
// ---------------------------------------------------------------------
// poly_multiplier (modified: high-impact LUT/FF reduction changes)
// - Uses lut_mul instances (assumed available in project)
// - Removes wide second-stage accumulators and second bmod_q stage
// - Stores C coefficients at COEFF_BITS and performs per-add modular add
// ---------------------------------------------------------------------
module poly_multiplier #(
    parameter N = 8,
    parameter Q = 4096,
    parameter COEFF_BITS = clog2(Q),
    parameter A_WIDTH = 12,
    parameter B_WIDTH = 6,
    parameter A_DEPTH = 2,
    parameter B_DEPTH = 3,
    parameter ADDR_WIDTH = 3
)(
    input clk,
    input reset,
    input start,
    output reg done,
    output [COEFF_BITS-1:0] c_data,  // Multiplexed coefficient data
    output [2:0] c_index,            // Coefficient index (0-7)
    output reg c_valid               // Valid signal for data/index
);

function integer clog2;
    input integer value;
    integer i;
    begin
        value = value - 1;
        for (i = 0; value > 0; i = i + 1)
            value = value >> 1;
        clog2 = i;
    end
endfunction

    // Precomputed bit widths based on Q
  //  localparam COEFF_BITS = clog2(Q);        // Bits needed for coefficients
    localparam MULT_WIDTH = A_WIDTH + B_WIDTH;
    localparam mem_Size = MULT_WIDTH + clog2(N);

    // State machine parameters
    localparam [3:0]
        IDLE         = 4'b0000,
        READ         = 4'b0001,
        WAIT_BRAM    = 4'b0010,
        COMPUTE      = 4'b0011,
        MULTIPLY     = 4'b0100,
        MODULO_STAGE = 4'b0101,
        UPDATE       = 4'b0110,
        ACCUMULATE   = 4'b0111,
        FINISH       = 4'b1010,
        OUTPUT_COEFFS = 4'b1011;

    reg [3:0] current_state, next_state;

    // BRAM interface (external block RAM cores)
    wire [23:0] a_data_out, b_data_out;
    reg [A_DEPTH-1:0] a_addr;
    reg [B_DEPTH-1:0] b_addr;
    reg a_en, b_en;

    // Counters
    reg [ADDR_WIDTH:0] i_cnt, j_cnt;
    reg [2:0] output_counter;

    // -----------------------
    // *** CHANGED: narrow C memory to COEFF_BITS to reduce LUT/FF
    //        perform per-add modular addition into this small memory
    // -----------------------
    reg [COEFF_BITS-1:0] c_mem [0:N-1]; // *** CHANGED: was wide mem_Size

    // Removed c_mem1/c_mem2 wide arrays to save area (no second mod stage)

    // Intermediate values
    reg  [A_WIDTH-1:0] a0;
    reg  [A_WIDTH-1:0] a1;
    reg  [B_WIDTH-1:0] b0, b1, b2, b3;

    reg [$clog2(N)-1:0] index_reg[0:7];

    // mult_stage1 registers: store registered outputs from lut_mul
    reg  [MULT_WIDTH-1:0] mult_stage1 [1:8]; // keep 1..8 indexing like your code

    // temp_c now holds reduced products (COEFF_BITS)
    reg  [COEFF_BITS-1:0] temp_c [1:8]; // *** CHANGED: was smaller/wrong earlier

    // wires for combinational lut_mul outputs
    wire [MULT_WIDTH-1:0] mult_out [1:8];

    // instantiate 8 lut_mul instances (unsigned shift-and-add)
    // (Assumes lut_mul module exists in project)
    lut_mul #(.A_WIDTH(A_WIDTH), .B_WIDTH(B_WIDTH)) lutmul1 (.a(a0), .b(b0), .p(mult_out[1]));
    lut_mul #(.A_WIDTH(A_WIDTH), .B_WIDTH(B_WIDTH)) lutmul2 (.a(a0), .b(b1), .p(mult_out[2]));
    lut_mul #(.A_WIDTH(A_WIDTH), .B_WIDTH(B_WIDTH)) lutmul3 (.a(a0), .b(b2), .p(mult_out[3]));
    lut_mul #(.A_WIDTH(A_WIDTH), .B_WIDTH(B_WIDTH)) lutmul4 (.a(a0), .b(b3), .p(mult_out[4]));
    lut_mul #(.A_WIDTH(A_WIDTH), .B_WIDTH(B_WIDTH)) lutmul5 (.a(a1), .b(b0), .p(mult_out[5]));
    lut_mul #(.A_WIDTH(A_WIDTH), .B_WIDTH(B_WIDTH)) lutmul6 (.a(a1), .b(b1), .p(mult_out[6]));
    lut_mul #(.A_WIDTH(A_WIDTH), .B_WIDTH(B_WIDTH)) lutmul7 (.a(a1), .b(b2), .p(mult_out[7]));
    lut_mul #(.A_WIDTH(A_WIDTH), .B_WIDTH(B_WIDTH)) lutmul8 (.a(a1), .b(b3), .p(mult_out[8]));

    // ------------------------
    // Modulo unit signals (first-stage only)
    // ------------------------
    wire [COEFF_BITS-1:0] mod1_out [1:8];
    wire [1:8] done1;
    wire done1_all = &done1;

    // *** CHANGED: first stage receives unsigned products from lut_mul
    // so set SIGNED_INPUT = 0
    wire start1 = (current_state == MODULO_STAGE);

    (* keep = "true" *) reg [COEFF_BITS-1:0] c_data_reg;
    (* keep = "true" *) reg [2:0] output_counter_reg;

    // Output signals
    assign c_data = c_data_reg;
    assign c_index = output_counter_reg;

    // First set of modulo units using generate (product -> mod)
    genvar i;
    generate
        for (i = 1; i <= 8; i = i + 1) begin : gen_mod1
            bmod_q #(
                .WIDTH_IN(MULT_WIDTH),
                .Q(Q),
                .WIDTH_OUT(COEFF_BITS),
                .SIGNED_INPUT(0)  // *** CHANGED: unsigned input (from lut_mul)
            ) mod1_inst (
                .clk(clk),
                .reset(reset),
                .start(start1),
                .x(mult_stage1[i]),
                .result(mod1_out[i]),
                .done(done1[i])
            );
        end
    endgenerate

    // *** REMOVED second-stage bmod_q blocks to save LUTs/FFs
    // (we do per-add modular adds into c_mem instead)

    // Modified output logic
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            c_data_reg <= 0;
            output_counter_reg <= 0;
            c_valid <= 0;
        end else begin
            if (current_state == OUTPUT_COEFFS) begin
                c_data_reg <= c_mem[output_counter];
                output_counter_reg <= output_counter;
                c_valid <= 1;
            end else begin
               c_valid <= 0;
            end
        end
    end

    // State register
    always @(posedge clk or posedge reset)
        if (reset) current_state <= IDLE;
        else current_state <= next_state;

    // Next state logic (Acc1/Acc2 removed; merged into ACCUMULATE)
    always @(*) begin
        next_state = current_state;
        case (current_state)
            IDLE:        if (start) next_state = READ;
            READ:        next_state = WAIT_BRAM;
            WAIT_BRAM:   next_state = COMPUTE;
            COMPUTE:     next_state = MULTIPLY;
            MULTIPLY:    next_state = MODULO_STAGE;
            MODULO_STAGE: if (done1_all) next_state = UPDATE;
            UPDATE:      next_state = ACCUMULATE;
            ACCUMULATE: begin
                if (j_cnt == N-1) begin
                    if (i_cnt >= (N/2 - 4))
                        next_state = FINISH;
                    else
                        next_state = READ;
                end else begin
                    next_state = READ;
                end
            end
            FINISH:      next_state = OUTPUT_COEFFS;
            OUTPUT_COEFFS:
                if (start) next_state = IDLE;
                else next_state = OUTPUT_COEFFS;
            default:     next_state = IDLE;
        endcase
    end

    // Done output
    always @(*) begin
        done = (current_state == FINISH) || (current_state == OUTPUT_COEFFS);
    end

    // Datapath logic
    integer k;
    reg [COEFF_BITS:0] sum_tmp; // one extra bit for carry during modular add
    always @(posedge clk) begin
        if (reset) begin
            i_cnt <= 0;
            j_cnt <= 0;
            output_counter <= 0;
            a_en <= 0;
            b_en <= 0;
            a_addr <= 0;
            b_addr <= 0;
            done <= 0;

            a0 <= 0; a1 <= 0;
            b0 <= 0; b1 <= 0; b2 <= 0; b3 <= 0;

            // initialize narrow c_mem to zero
            for (k = 0; k < N; k = k + 1) begin
                c_mem[k] <= 0;
            end

            for (k = 0; k < 8; k = k + 1) begin
                index_reg[k] <= 0;
            end

            for (k = 1; k <= 8; k = k + 1) begin
                mult_stage1[k] <= 0;
                temp_c[k] <= 0;
            end
        end else begin
            case (current_state)
                IDLE: begin
                    if (start) begin
                        i_cnt <= 0;
                        j_cnt <= 0;
                        a_en <= 1;
                        b_en <= 1;
                        a_addr <= 0;
                        b_addr <= 0;
                        // clear c_mem (robustness)
                        for (k = 0; k < N; k = k + 1) c_mem[k] <= 0;
                    end
                end

                READ: begin
                    // keep addrs safe and small: avoid costly % operator in synthesis
                    if (j_cnt[ADDR_WIDTH-1:0] >= (N/2)) begin
                        a_addr <= j_cnt[ADDR_WIDTH-1:0] - (N/2);
                    end else begin
                        a_addr <= j_cnt[ADDR_WIDTH-1:0];
                    end
                    b_addr <= j_cnt[ADDR_WIDTH-1:0];
                end

                WAIT_BRAM: begin
                    a_en <= 1;
                    b_en <= 1;
                end

                COMPUTE: begin
                    // implement A0_mod = (j < N/2) ? a[j] : (Q - a[j])
                    a0 <= (j_cnt < N/2) ? a_data_out[23:12] : (Q - a_data_out[11:0]);
                    a1 <= (j_cnt < N/2) ? a_data_out[11:0] : a_data_out[23:12];
                    // unpack B packed word (adjust if your BRAM width is different)
                    b0 <= b_data_out[23:18];
                    b1 <= b_data_out[17:12];
                    b2 <= b_data_out[11:6];
                    b3 <= b_data_out[5:0];
                    a_en <= 0;
                    b_en <= 0;
                end

                MULTIPLY: begin
                    // capture combinational LUT mul outputs into registered stage
                    mult_stage1[1] <= mult_out[1];
                    mult_stage1[2] <= mult_out[2];
                    mult_stage1[3] <= mult_out[3];
                    mult_stage1[4] <= mult_out[4];
                    mult_stage1[5] <= mult_out[5];
                    mult_stage1[6] <= mult_out[6];
                    mult_stage1[7] <= mult_out[7];
                    mult_stage1[8] <= mult_out[8];
                end

                MODULO_STAGE: begin
                    // bmod_q (first-stage) runs on mult_stage1; results appear when done1 asserts
                end

                UPDATE: begin
                    // collect the reduced temps from mod1_out (COEFF_BITS wide)
                    for (k = 1; k <= 8; k = k + 1) begin
                        temp_c[k] <= mod1_out[k];
                    end

                    // Update coefficient target indices
                    index_reg[0] <= i_cnt;
                    index_reg[1] <= (i_cnt + 1) % N;
                    index_reg[2] <= (i_cnt + 2) % N;
                    index_reg[3] <= (i_cnt + 3) % N;
                    index_reg[4] <= (i_cnt + N/2) % N;
                    index_reg[5] <= (i_cnt + N/2 + 1) % N;
                    index_reg[6] <= (i_cnt + N/2 + 2) % N;
                    index_reg[7] <= (i_cnt + N/2 + 3) % N;
                end

                ACCUMULATE: begin
                    // PER-ADD modular addition into narrow c_mem (COEFF_BITS)
                    for (k = 0; k < 8; k = k + 1) begin
                        sum_tmp = c_mem[index_reg[k]] + temp_c[k+1];
                        if (sum_tmp >= Q) sum_tmp = sum_tmp - Q;
                        c_mem[index_reg[k]] <= sum_tmp[COEFF_BITS-1:0];
                    end

                    // advance j_cnt / i_cnt and addresses
                    if (j_cnt == N-1) begin
                        j_cnt <= 0;
                        i_cnt <= i_cnt + 4;
                        a_en <= 1;
                        b_en <= 1;
                        a_addr <= 0;
                        b_addr <= 0;
                    end else begin
                        j_cnt <= j_cnt + 1;
                        a_en <= 1;
                        b_en <= 1;
                        if (j_cnt + 1 >= (N/2)) begin
                            a_addr <= j_cnt + 1 - (N/2);
                        end else begin
                            a_addr <= j_cnt + 1;
                        end
                        b_addr <= j_cnt + 1;
                    end
                end

                FINISH: begin
                    output_counter <= 0;
                    a_en <= 0;
                    b_en <= 0;
                end

                OUTPUT_COEFFS: begin
                    if (output_counter == 3'd7)
                        output_counter <= 3'd0;
                    else
                        output_counter <= output_counter + 1;
                end

            endcase
        end
    end

    // BRAM Instantiation (unchanged)
    blk_mem_gen_0 a_bram (
        .clka(clk), .ena(a_en), .wea(1'b0),
        .addra(a_addr), .dina(24'b0), .douta(a_data_out)
    );

    blk_mem_gen_1 b_bram (
        .clka(clk), .ena(b_en), .wea(1'b0),
        .addra(b_addr), .dina(24'b0), .douta(b_data_out)
    );

endmodule




module bmod_q #(
    parameter WIDTH_IN = 18,
    parameter Q = 4096,
    parameter WIDTH_OUT = 8,
    parameter SIGNED_INPUT = 1
)(
    input clk,
    input reset,
    input start,
    input [WIDTH_IN-1:0] x,
    output reg [WIDTH_OUT-1:0] result,
    output reg done
);

    // Helper function for clog2
    function integer clog2;
        input integer value;
        begin
            value = value - 1;
            for (clog2 = 0; value > 0; clog2 = clog2 + 1)
                value = value >> 1;
        end
    endfunction

    // Dynamically compute Barrett parameters
    localparam integer K = clog2(Q);
    localparam integer MU = (1 << (2*K)) / Q;
    localparam integer MU_WIDTH = 2*K;
    localparam integer T_WIDTH = WIDTH_IN + MU_WIDTH;

    reg [1:0] state;
    localparam IDLE = 0, MUL = 1, FINAL = 2;

    reg signed [WIDTH_IN-1:0] sx;
    reg [WIDTH_IN-1:0] ux;
    reg [T_WIDTH-1:0] t;
    reg [WIDTH_OUT:0] r;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            done <= 0;
            result <= 0;
        end else begin
            case (state)
                IDLE: begin
                    done <= 0;
                    if (start) begin
                        if (SIGNED_INPUT)
                            sx <= $signed(x);
                        else
                            ux <= x;
                        state <= MUL;
                    end
                end

                MUL: begin
                    if (SIGNED_INPUT)
                        t <= ($signed(sx) * MU) >>> MU_WIDTH;
                    else
                        t <= (ux * MU) >> MU_WIDTH;
                    state <= FINAL;
                end

                FINAL: begin
                    if (SIGNED_INPUT)
                        r = sx - t * Q;
                    else
                        r = ux - t * Q;

                    if (r < 0)
                        r = r + Q;
                    else if (r >= Q)
                        r = r - Q;

                    result <= r[WIDTH_OUT-1:0];
                    done <= 1;
                    state <= IDLE;
                end
            endcase
        end
    end
endmodule