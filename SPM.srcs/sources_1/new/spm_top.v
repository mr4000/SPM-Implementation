module poly_multiplier_3 #(
    parameter N = 256,              // Updated to Kyber standard
    parameter Q = 3329,
    parameter COEFF_WIDTH = 12,
    parameter B_WIDTH = 5,
    parameter A_DEPTH = 4,
    parameter B_DEPTH = 8,
    parameter ADDR_WIDTH = 8         // log2(N)
)(
    input clk,
    input reset,
    input start,
    output done,
    output [COEFF_WIDTH*N-1:0] c_packed
);

    localparam [3:0]
        IDLE        = 4'b0000,
        READ        = 4'b0001,
        WAIT_BRAM   = 4'b0010,
        COMPUTE     = 4'b0011,
        MULTIPLY    = 4'b0100,
        MODULO_STAGE= 4'b0101,
        UPDATE      = 4'b0110,
        ACCUMULATE  = 4'b0111,
        FINISH      = 4'b1000;

    reg [3:0] current_state, next_state;

    // BRAM interface
    wire [23:0] a_data_out, b_data_out;
    reg [ADDR_WIDTH-1:0] a_addr, b_addr;
    reg a_en, b_en;

    // Counters
    reg [ADDR_WIDTH:0] i_cnt, j_cnt;
    reg [2:0] update_cnt;  // Sequential accumulation counter

    // Output memory (reduced to 12 bits)
    reg [COEFF_WIDTH-1:0] c_mem [0:N-1];

    // Intermediate values
    reg signed [COEFF_WIDTH:0] a0;
    reg [COEFF_WIDTH-1:0] a1;
    reg [B_WIDTH-1:0] b0, b1, b2, b3;

    // DSP-pipelined multipliers
    (* use_dsp = "yes" *) reg signed [COEFF_WIDTH+B_WIDTH:0] mult_stage1 [1:8];
    reg [COEFF_WIDTH-1:0] temp_c [1:8];  // Reduced width storage

    // Done output
    assign done = (current_state == FINISH);

    // Output packing
    genvar i;
    generate
        for (i = 0; i < N; i = i + 1) begin : pack_out
            assign c_packed[i*COEFF_WIDTH +: COEFF_WIDTH] = c_mem[i];
        end
    endgenerate

    // Optimized modulo functions
    function [COEFF_WIDTH-1:0] mod_q_product;
        input signed [COEFF_WIDTH+B_WIDTH:0] value;
        reg signed [COEFF_WIDTH+B_WIDTH:0] mod_result;
        begin
            mod_result = value % Q;
            mod_q_product = (mod_result < 0) ? mod_result + Q : mod_result;
        end
    endfunction

    function [COEFF_WIDTH-1:0] mod_q_accum;
        input [12:0] value;  // 13-bit input (max 6656)
        begin
            mod_q_accum = (value < Q) ? value : value - Q;
        end
    endfunction

    // State register
    always @(posedge clk or posedge reset)
        if (reset) current_state <= IDLE;
        else current_state <= next_state;

    // Next state logic
    always @(*) begin
        case (current_state)
            IDLE:         next_state = start ? READ : IDLE;
            READ:         next_state = WAIT_BRAM;
            WAIT_BRAM:    next_state = COMPUTE;
            COMPUTE:      next_state = MULTIPLY;
            MULTIPLY:     next_state = MODULO_STAGE;
            MODULO_STAGE: next_state = UPDATE;
            UPDATE:       next_state = ACCUMULATE;
            ACCUMULATE:   next_state = (update_cnt == 7) ? 
                                      ((j_cnt == N-1 && i_cnt >= N/2-4) ? FINISH : READ) : 
                                      ACCUMULATE;
            FINISH:       next_state = IDLE;
            default:      next_state = IDLE;
        endcase
    end

    // Datapath logic
    integer k;
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            i_cnt <= 0;
            j_cnt <= 0;
            update_cnt <= 0;
            a_en <= 0;
            b_en <= 0;
            a_addr <= 0;
            b_addr <= 0;
            a0 <= 0; a1 <= 0;
            b0 <= 0; b1 <= 0; b2 <= 0; b3 <= 0;
            for (k = 0; k < N; k = k + 1)
                c_mem[k] <= 0;
            for (k = 1; k <= 8; k = k + 1)
                mult_stage1[k] <= 0;
        end else begin
            case (current_state)
                IDLE: begin
                    if (start) begin
                        i_cnt <= 0;
                        j_cnt <= 0;
                        update_cnt <= 0;
                        a_en <= 1;
                        b_en <= 1;
                        a_addr <= 0;
                        b_addr <= 0;
                    end
                end

                READ: begin
                    a_addr <= j_cnt[ADDR_WIDTH-1:0] % (N/2);
                    b_addr <= j_cnt[ADDR_WIDTH-1:0];
                end

                WAIT_BRAM: begin
                    // BRAM latency handling
                end

                COMPUTE: begin
                    a0 <= (j_cnt < N/2) ? $signed(a_data_out[23:12]) : -$signed({1'b0, a_data_out[11:0]});
                    a1 <= (j_cnt < N/2) ? a_data_out[11:0] : a_data_out[23:12];
                    b0 <= b_data_out[23:18];
                    b1 <= b_data_out[17:12];
                    b2 <= b_data_out[11:6];
                    b3 <= b_data_out[5:0];
                end

                MULTIPLY: begin
                    mult_stage1[1] <= a0 * $signed({1'b0, b0});
                    mult_stage1[2] <= a0 * $signed({1'b0, b1});
                    mult_stage1[3] <= a0 * $signed({1'b0, b2});
                    mult_stage1[4] <= a0 * $signed({1'b0, b3});
                    mult_stage1[5] <= $signed({1'b0, a1}) * $signed({1'b0, b0});
                    mult_stage1[6] <= $signed({1'b0, a1}) * $signed({1'b0, b1});
                    mult_stage1[7] <= $signed({1'b0, a1}) * $signed({1'b0, b2});
                    mult_stage1[8] <= $signed({1'b0, a1}) * $signed({1'b0, b3});
                end
                
                MODULO_STAGE: begin
                    for (k = 1; k <= 8; k = k + 1)
                        temp_c[k] <= mod_q_product(mult_stage1[k]);
                end

                UPDATE: begin
                    // Prepare for accumulation
                end

                ACCUMULATE: begin
                    // Sequential accumulation (1 per cycle)
                    case (update_cnt)
                        0: c_mem[i_cnt] <= mod_q_accum(c_mem[i_cnt] + temp_c[1]);
                        1: c_mem[(i_cnt + 1) % N] <= mod_q_accum(c_mem[(i_cnt + 1) % N] + temp_c[2]);
                        2: c_mem[(i_cnt + 2) % N] <= mod_q_accum(c_mem[(i_cnt + 2) % N] + temp_c[3]);
                        3: c_mem[(i_cnt + 3) % N] <= mod_q_accum(c_mem[(i_cnt + 3) % N] + temp_c[4]);
                        4: c_mem[(i_cnt + N/2) % N] <= mod_q_accum(c_mem[(i_cnt + N/2) % N] + temp_c[5]);
                        5: c_mem[(i_cnt + N/2 + 1) % N] <= mod_q_accum(c_mem[(i_cnt + N/2 + 1) % N] + temp_c[6]);
                        6: c_mem[(i_cnt + N/2 + 2) % N] <= mod_q_accum(c_mem[(i_cnt + N/2 + 2) % N] + temp_c[7]);
                        7: begin
                            c_mem[(i_cnt + N/2 + 3) % N] <= mod_q_accum(c_mem[(i_cnt + N/2 + 3) % N] + temp_c[8]);
                            
                            // Update counters after last accumulation
                            if (j_cnt == N - 1) begin
                                if (i_cnt < N/2 - 4) begin
                                    i_cnt <= i_cnt + 4;
                                    j_cnt <= 0;
                                end
                            end else begin
                                j_cnt <= j_cnt + 1;
                            end
                        end
                    endcase
                    
                    // Advance accumulation counter
                    update_cnt <= (update_cnt == 7) ? 0 : update_cnt + 1;
                    
                    // Enable BRAM for next read when needed
                    if (update_cnt == 6) begin  // Prepare 1 cycle early
                        a_en <= 1;
                        b_en <= 1;
                        a_addr <= (j_cnt + 1) % (N/2);
                        b_addr <= j_cnt + 1;
                    end else if (update_cnt == 7 && j_cnt != N-1) begin
                        a_en <= 1;
                        b_en <= 1;
                        a_addr <= (j_cnt + 2) % (N/2);
                        b_addr <= j_cnt + 2;
                    end else begin
                        a_en <= 0;
                        b_en <= 0;
                    end
                end

                FINISH: begin
                    a_en <= 0;
                    b_en <= 0;
                end
            endcase
        end
    end

    // BRAM Instantiation
    blk_mem_gen_0 a_bram (
        .clka(clk), .ena(a_en), .wea(1'b0),
        .addra(a_addr), .dina(24'b0), .douta(a_data_out)
    );

    blk_mem_gen_1 b_bram (
        .clka(clk), .ena(b_en), .wea(1'b0),
        .addra(b_addr), .dina(24'b0), .douta(b_data_out)
    );

endmodule