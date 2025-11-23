//module SPM_FSM #(
//    parameter N = 8,           // Polynomial degree
//    parameter Q = 3329,         // Modulus
//    parameter COEFF_WIDTH = 12, // a coefficients width
//    parameter B_WIDTH = 6,// b coefficients width
//    parameter A_DEPTH = 4,      // Depth for transformed A (n/2)
//    parameter B_DEPTH = 8,      // Depth for transformed B (3n/2 - 4)
//    parameter ADDR_WIDTH = 3    // ceil(log2(max(A_DEPTH, B_DEPTH)))
//)(
//    input clk,
//    input reset,
//    input start,
//    output done,
//    output [COEFF_WIDTH*N-1:0] c_packed  // Packed array output
//);

//    // =============================================
//    // State Encoding
//    // =============================================
//    localparam [2:0] 
//        IDLE       = 3'b000,
//        READ       = 3'b001,
//        WAIT_BRAM  = 3'b010,
//        COMPUTE    = 3'b011,
//        ACCUMULATE = 3'b100,
//        UPDATE     = 3'b101,
//        FINISH     = 3'b110;

//    reg [2:0] current_state, next_state;

//    // =============================================
//    // BRAM Interface Signals
//    // =============================================
//    wire [23:0] a_data_out;
//    reg [ADDR_WIDTH-1:0] a_addr;
//    reg a_en;
    
//    wire [23:0] b_data_out;
//    reg [ADDR_WIDTH-1:0] b_addr;
//    reg b_en;
    
//    // Internal unpacked accumulation array
//    reg [COEFF_WIDTH-1:0] c_mem [0:N-1];
    
//    // Algorithm Control Signals
//    reg [ADDR_WIDTH:0] i_cnt, j_cnt;
    
//    // Data Path Registers
//    reg [COEFF_WIDTH-1:0] a0, a1;
//    reg [B_WIDTH-1:0] b0, b1, b2, b3;
//    reg [COEFF_WIDTH+B_WIDTH-1:0] temp_c [1:8];
    
//    // =============================================
//    // BRAM Instantiations
//    // =============================================
//    blk_mem_gen_0 a_bram (
//        .clka(clk),
//        .ena(a_en),
//        .wea(1'b0),
//        .addra(a_addr),
//        .dina(24'b0),
//        .douta(a_data_out)
//    );
    
//    blk_mem_gen_1 b_bram (
//        .clka(clk),
//        .ena(b_en),
//        .wea(1'b0),
//        .addra(b_addr),
//        .dina(24'b0),
//        .douta(b_data_out)
//    );

//    // =============================================
//    // Combinational Outputs
//    // =============================================
//    // Packed array output assignment
//    genvar i;
//    generate
//        for (i = 0; i < N; i = i + 1) begin : pack_output
//            assign c_packed[i*COEFF_WIDTH +: COEFF_WIDTH] = c_mem[i];
//        end
//    endgenerate
    
//    // Done signal assignment
//    assign done = (current_state == FINISH);

//    // =============================================
//    // Sequential Current State Logic
//    // =============================================
//    always @(posedge clk or posedge reset) begin
//        if (reset) begin
//            current_state <= IDLE;
//        end else begin
//            current_state <= next_state;
//        end
//    end

//    // =============================================
//    // Combinational Next State Logic
//    // =============================================
//    always @(*) begin
//        case (current_state)
//            IDLE:       next_state = start ? READ : IDLE;
//            READ:       next_state = WAIT_BRAM;
//            WAIT_BRAM:  next_state = COMPUTE;
//            COMPUTE:    next_state = ACCUMULATE;
//            ACCUMULATE: next_state = UPDATE;
//            UPDATE:     next_state = (j_cnt == N-1 && i_cnt >= N/2-4) ? FINISH : READ;
//            FINISH:     next_state = IDLE;
//            default:    next_state = IDLE;
//        endcase
//    end

//    // =============================================
//    // Sequential Datapath and Control Logic
//    // =============================================
//    always @(posedge clk or posedge reset) begin
//        if (reset) begin
//            // Reset all registers
//            i_cnt <= 0;
//            j_cnt <= 0;
//            a_en <= 0;
//            b_en <= 0;
//            a_addr <= 0;
//            b_addr <= 0;
//            a0 <= 0;
//            a1 <= 0;
//            b0 <= 0;
//            b1 <= 0;
//            b2 <= 0;
//            b3 <= 0;
            
//            // Initialize output memory
//            begin : init_c_mem
//                integer k;
//                for (k = 0; k < N; k = k + 1) begin
//                    c_mem[k] <= 0;
//                end
//            end
            
//            // Initialize temp products
//            begin : init_temp_c
//                integer m;
//                for (m = 1; m <= 8; m = m + 1) begin
//                    temp_c[m] <= 0;
//                end
//            end
//        end else begin
//            case (current_state)
//                IDLE: begin
//                    if (start) begin
//                        i_cnt <= 0;
//                        j_cnt <= 0;
//                        a_en <= 1;
//                        b_en <= 1;
//                        a_addr <= 0;
//                        b_addr <= 0;
//                    end
//                end
                
//                READ: begin
//                    // Set up next addresses
//                    a_addr <= j_cnt[ADDR_WIDTH-1:0] % (N/2);
//                    b_addr <= j_cnt[ADDR_WIDTH-1:0];
//                end
                
//                WAIT_BRAM: begin
//                    // Keep enables active during wait state
//                    a_en <= 1;
//                    b_en <= 1;
//                end
                
//                COMPUTE: begin
//                    // Capture BRAM outputs
//                    a0 <= (j_cnt < N/2) ? a_data_out[23:12] : (Q - a_data_out[23:12]);
//                    a1 <= a_data_out[11:0];
                    
                 
                    
//                    b0 <= b_data_out[4*COEFF_WIDTH-1:3*B_WIDTH];
//                    b1 <= b_data_out[3*B_WIDTH-1:2*B_WIDTH];
//                    b2 <= b_data_out[2*B_WIDTH-1:B_WIDTH];
//                    b3 <= b_data_out[B_WIDTH-1:0];
                    
//                    // Turn off BRAM enables after capture
//                    a_en <= 0;
//                    b_en <= 0;
//                end
                
//                ACCUMULATE: begin
//                    // Perform parallel multiplications
//                    temp_c[1] <= (a0 * b0) % Q;
//                    temp_c[2] <= (a0 * b1) % Q;
//                    temp_c[3] <= (a0 * b2) % Q;
//                    temp_c[4] <= (a0 * b3) % Q;
//                    temp_c[5] <= (a1 * b0) % Q;
//                    temp_c[6] <= (a1 * b1) % Q;
//                    temp_c[7] <= (a1 * b2) % Q;
//                    temp_c[8] <= (a1 * b3) % Q;
//                end
                
//                UPDATE: begin
//                    // Accumulate results
//                    c_mem[i_cnt]             <= (c_mem[i_cnt] + temp_c[1]) % Q;
//                    c_mem[(i_cnt + 1) % N]   <= (c_mem[(i_cnt + 1) % N] + temp_c[2]) % Q;
//                    c_mem[(i_cnt + 2) % N]   <= (c_mem[(i_cnt + 2) % N] + temp_c[3]) % Q;
//                    c_mem[(i_cnt + 3) % N]   <= (c_mem[(i_cnt + 3) % N] + temp_c[4]) % Q;
//                    c_mem[(i_cnt + N/2) % N] <= (c_mem[(i_cnt + N/2) % N] + temp_c[5]) % Q;
//                    c_mem[(i_cnt + N/2 + 1) % N] <= (c_mem[(i_cnt + N/2 + 1) % N] + temp_c[6]) % Q;
//                    c_mem[(i_cnt + N/2 + 2) % N] <= (c_mem[(i_cnt + N/2 + 2) % N] + temp_c[7]) % Q;
//                    c_mem[(i_cnt + N/2 + 3) % N] <= (c_mem[(i_cnt + N/2 + 3) % N] + temp_c[8]) % Q;
                    
//                    // Update indices and prepare for next read
//                    if (j_cnt == N - 1) begin
//                        if (i_cnt >= N/2 - 4) begin
//                            // Last iteration, no more reads
//                            a_en <= 0;
//                            b_en <= 0;
//                        end else begin
//                            i_cnt <= i_cnt + 4;
//                            j_cnt <= 0;
//                            a_en <= 1;
//                            b_en <= 1;
//                            a_addr <= 0;
//                            b_addr <= 0;
//                        end
//                    end else begin
//                        j_cnt <= j_cnt + 1;
//                        a_en <= 1;
//                        b_en <= 1;
//                        a_addr <= (j_cnt + 1) % (N/2);
//                        b_addr <= j_cnt + 1;
//                    end
//                end
                
//                FINISH: begin
//                    // Reset for next operation
//                    a_en <= 0;
//                    b_en <= 0;
//                end
//            endcase
//        end
//    end

//endmodule
//module poly_multiplier #(
//    parameter N = 8,
//    parameter Q = 4096,
//    parameter A_WIDTH = 12,
//    parameter B_WIDTH = 6,
//    parameter A_DEPTH = 2,
//    parameter B_DEPTH = 3,
//    parameter ADDR_WIDTH = 3
//)(
//    input clk,
//    input reset,
//    input start,
//    output reg done,
//    output [COEFF_BITS-1:0] c_data,  // Multiplexed coefficient data
//    output [2:0] c_index,             // Coefficient index (0-7)
//    output reg c_valid                    // Valid signal for data/index
//);

//function integer clog2;
//    input integer value;
//    integer i;
//    begin
//        value = value - 1;
//        for (i = 0; value > 0; i = i + 1)
//            value = value >> 1;
//        clog2 = i;
//    end
//endfunction




//    // Precomputed bit widths based on Q
//    localparam COEFF_BITS = clog2(Q);  // Bits needed for coefficients
//    localparam MULT_WIDTH = A_WIDTH + B_WIDTH;
//   // localparam mem_Size=2*$clog2(Q-1);  // Accumulation width
//    localparam mem_Size=  MULT_WIDTH +  clog2(N);
//    // State machine parameters
//    localparam [3:0]
//        IDLE         = 4'b0000,
//        READ         = 4'b0001,
//        WAIT_BRAM    = 4'b0010,
//        COMPUTE      = 4'b0011,
//        MULTIPLY     = 4'b0100,
//        MODULO_STAGE = 4'b0101,
//        UPDATE       = 4'b0110,
//        ACCUMULATE   = 4'b0111,
//        Acc1         = 4'b1000,
//        Acc2         = 4'b1001,
//        FINISH       = 4'b1010,
//        OUTPUT_COEFFS = 4'b1011;

//    reg [3:0] current_state, next_state;

//    // BRAM interface
//    wire [23:0] a_data_out, b_data_out;
//    reg [A_DEPTH-1:0] a_addr;
//    reg [B_DEPTH-1:0] b_addr;
//    reg a_en, b_en;

//    // Counters
//    reg [ADDR_WIDTH:0] i_cnt, j_cnt;
//    reg [2:0] output_counter;

//    // Output memories
//    reg [mem_Size-1:0] c_mem [0:N-1];
//    reg [mem_Size-1:0] c_mem1 [0:N-1];
//    reg [mem_Size-1:0] c_mem2 [0:N-1];
    
//    // Intermediate values
//    reg  [A_WIDTH-1:0] a0;
//    reg [A_WIDTH-1:0] a1;
//    reg [B_WIDTH-1:0] b0, b1, b2, b3;
   
//    reg [$clog2(N)-1:0] index_reg[0:7];

//     reg  [MULT_WIDTH:0] mult_stage1 [1:8];
// //   reg signed [COEFF_BITS-1:0] mult_stage2 [1:8];
//    reg  [$clog2(Q-1)-1:0] temp_c [1:8];
    
      
//    wire [MULT_WIDTH-1:0] mult_out [1:8];

   
//    lut_mul #(.A_WIDTH(A_WIDTH), .B_WIDTH(B_WIDTH)) lutmul1 (.a(a0), .b(b0), .p(mult_out[1]));
//    lut_mul #(.A_WIDTH(A_WIDTH), .B_WIDTH(B_WIDTH)) lutmul2 (.a(a0), .b(b1), .p(mult_out[2]));
//    lut_mul #(.A_WIDTH(A_WIDTH), .B_WIDTH(B_WIDTH)) lutmul3 (.a(a0), .b(b2), .p(mult_out[3]));
//    lut_mul #(.A_WIDTH(A_WIDTH), .B_WIDTH(B_WIDTH)) lutmul4 (.a(a0), .b(b3), .p(mult_out[4]));
//    lut_mul #(.A_WIDTH(A_WIDTH), .B_WIDTH(B_WIDTH)) lutmul5 (.a(a1),.b(b0), .p(mult_out[5]));
//    lut_mul #(.A_WIDTH(A_WIDTH), .B_WIDTH(B_WIDTH)) lutmul6 (.a(a1),.b(b1), .p(mult_out[6]));
//    lut_mul #(.A_WIDTH(A_WIDTH), .B_WIDTH(B_WIDTH)) lutmul7 (.a(a1),.b(b2), .p(mult_out[7]));
//    lut_mul #(.A_WIDTH(A_WIDTH), .B_WIDTH(B_WIDTH)) lutmul8 (.a(a1),.b(b3), .p(mult_out[8]));
//    // --- END ADD ---

    
    
    

 
    
//  //  assign c_valid = (current_state == OUTPUT_COEFFS);

//    // Modulo unit signals
//    wire [COEFF_BITS-1:0] mod1_out [1:8];
//    wire [1:8] done1;
//    wire done1_all = &done1;
    
//    wire [COEFF_BITS-1:0] mod2_out [1:8];
//    wire [1:8] done2;
//    wire done2_all = &done2;
    
//    wire start1 = (current_state == MODULO_STAGE);
//    wire start2 = (current_state == Acc1);
    
//    (* keep = "true" *) reg [COEFF_BITS-1:0] c_data_reg;
//    (* keep = "true" *) reg [2:0] output_counter_reg;
    
//       // Output signals
//    assign c_data = c_data_reg;
//    assign c_index = output_counter_reg;
    

//      // First set of modulo units using generate
//    genvar i;
//    generate
//        for (i = 1; i <= 8; i = i + 1) begin : gen_mod1
//            bmod_q #(
//                .WIDTH_IN(MULT_WIDTH),
//                .Q(Q),
//                .WIDTH_OUT(COEFF_BITS),
//                .SIGNED_INPUT(1)
//            ) mod1_inst (
//                .clk(clk),
//                .reset(reset),
//                .start(start1),
//                .x(mult_stage1[i]),
//                .result(mod1_out[i]),
//                .done(done1[i])
//            );
//        end
//    endgenerate

//    // Second set of modulo units using generate
//    genvar j;
//    generate
//        for (j = 1; j <= 8; j = j + 1) begin : gen_mod2
//            bmod_q #(
//                .WIDTH_IN(mem_Size),
//                .Q(Q),
//                .WIDTH_OUT(COEFF_BITS),
//                .SIGNED_INPUT(0)
//            ) mod2_inst (
//                .clk(clk),
//                .reset(reset),
//                .start(start2),
//                .x(c_mem1[index_reg[j-1]]),
//                .result(mod2_out[j]),
//                .done(done2[j])
//            );
//        end
//    endgenerate
//// Modified output logic
//    always @(posedge clk or posedge reset) begin
//        if (reset) begin
//            c_data_reg <= 0;
//            output_counter_reg <= 0;
//         //   c_valid <= 0;
//        end else begin
//            if (current_state == OUTPUT_COEFFS) begin
//                c_data_reg <= c_mem[output_counter];
//                output_counter_reg <= output_counter;
//                c_valid <= 1;
//            end else begin
//               c_valid <= 0;
//            end
//        end
//    end
//    // State register
//    always @(posedge clk or posedge reset)
//        if (reset) current_state <= IDLE;
//        else current_state <= next_state;

//    // Next state logic
//    always @(*) begin
//        next_state = current_state;
//        case (current_state)
//            IDLE:        if (start) next_state = READ;
//            READ:        next_state = WAIT_BRAM;
//            WAIT_BRAM:   next_state = COMPUTE;
//            COMPUTE:     next_state = MULTIPLY;
//            MULTIPLY:    next_state = MODULO_STAGE;
//            MODULO_STAGE: if (done1_all) next_state = UPDATE;
//            UPDATE:      next_state = ACCUMULATE;
//            ACCUMULATE:  next_state = Acc1;
//            Acc1:        if (done2_all) next_state = Acc2;
//          //  Acc2:        if (j_cnt == N-1) next_state = FINISH;
//           //              else next_state = READ;
//            Acc2:if (current_state == Acc2) begin
//                   if (j_cnt == N-1) begin
//                      if (i_cnt >= (N/2 - 4)) 
//                          next_state = FINISH;
//                      else 
//                          next_state = READ; // start next i block
//                     end 
//                  else
//                       next_state = READ;
                   
//                   end 

//            FINISH:      next_state = OUTPUT_COEFFS;
//            OUTPUT_COEFFS: 
//                if (start) next_state = IDLE;
//                else next_state = OUTPUT_COEFFS;
//            default:     next_state = IDLE;
//        endcase
//    end

//    // Done output
//    always @(*) begin
//        done = (current_state == FINISH) || (current_state == OUTPUT_COEFFS);
//    end

//    // Datapath logic
//    integer k;
//    always @(posedge clk) begin
//        if (reset) begin
//            i_cnt <= 0;
//            j_cnt <= 0;
//            output_counter <= 0;
//            a_en <= 0;
//            b_en <= 0;
//            a_addr <= 0;
//            b_addr <= 0;
//            done <= 0;
            
//            a0 <= 0; a1 <= 0;
//            b0 <= 0; b1 <= 0; b2 <= 0; b3 <= 0;
            
//            for (k = 0; k < N; k = k + 1) begin
//                c_mem[k] <= 0;
//                c_mem1[k] <= 0;
//                c_mem2[k] <= 0;
//            end
            
//            for (k = 0; k < 8; k = k + 1) begin
//                index_reg[k] <= 0;
//            end
            
//            for (k = 1; k <= 8; k = k + 1) begin
//                mult_stage1[k] <= 0;
//               // mult_stage2[k] <= 0;
//                temp_c[k] <= 0;
//            end
//        end else begin
//            case (current_state)
//                IDLE: begin
//                    if (start) begin
//                        i_cnt <= 0;
//                        j_cnt <= 0;
//                        a_en <= 1;
//                        b_en <= 1;
//                        a_addr <= 0;
//                        b_addr <= 0;
                        
//                        for (k = 0; k < N; k = k + 1) begin
//                            c_mem1[k] <= 0;
//                        end
//                    end
//                end

//                READ: begin
//                //    a_addr <= j_cnt[ADDR_WIDTH-1:0] % (N/2);
                
//                        if (j_cnt[ADDR_WIDTH-1:0] >= (N/2)) begin
//                        a_addr <= j_cnt[ADDR_WIDTH-1:0] - (N/2);end
//                        else 
//                        begin
//                        a_addr <= j_cnt[ADDR_WIDTH-1:0] + 1;
//                        end
                
//                    b_addr <= j_cnt[ADDR_WIDTH-1:0];
//                end

//                WAIT_BRAM: begin
//                    a_en <= 1;
//                    b_en <= 1;
//                end

//                COMPUTE: begin
//                  //  a0 <= (j_cnt < N/2) ? $signed(a_data_out[23:12]) :-$signed({1'b0, a_data_out[11:0]});
//                    a0 <= (j_cnt < N/2) ? a_data_out[23:12] :(Q - a_data_out[11:0]);
//                    a1 <= (j_cnt < N/2) ? a_data_out[11:0] : a_data_out[23:12];
//                    b0 <= b_data_out[23:18];
//                    b1 <= b_data_out[17:12];
//                    b2 <= b_data_out[11:6];
//                    b3 <= b_data_out[5:0];
//                    a_en <= 0;
//                    b_en <= 0;
//                end

//                MULTIPLY: begin
////                    mult_stage1[1] <= a0 * $signed({1'b0, b0});
////                    mult_stage1[2] <= a0 * $signed({1'b0, b1});
////                    mult_stage1[3] <= a0 * $signed({1'b0, b2});
////                    mult_stage1[4] <= a0 * $signed({1'b0, b3});
////                    mult_stage1[5] <= $signed({1'b0, a1}) * $signed({1'b0, b0});
////                    mult_stage1[6] <= $signed({1'b0, a1}) * $signed({1'b0, b1});
////                    mult_stage1[7] <= $signed({1'b0, a1}) * $signed({1'b0, b2});
////                    mult_stage1[8] <= $signed({1'b0, a1}) * $signed({1'b0, b3});
                    
////                    mult_stage1[1] <= a0 * b0;
////                    mult_stage1[2] <= a0 * b1;
////                    mult_stage1[3] <= a0 * b2;
////                    mult_stage1[4] <= a0 * b3;
////                    mult_stage1[5] <= a1 * b0;
////                    mult_stage1[6] <= a1 * b1;
////                    mult_stage1[7] <= a1 * b2;
////                    mult_stage1[8] <= a1 * b3;
                    
//                    mult_stage1[1] <= mult_out[1];
//                    mult_stage1[2] <= mult_out[2];
//                    mult_stage1[3] <= mult_out[3];
//                    mult_stage1[4] <= mult_out[4];
//                    mult_stage1[5] <= mult_out[5];
//                    mult_stage1[6] <= mult_out[6];
//                    mult_stage1[7] <= mult_out[7];
//                    mult_stage1[8] <= mult_out[8];
                
                    
                    
//                end

//                MODULO_STAGE: begin
//                    // Results captured in UPDATE state
//                end

//                UPDATE: begin
//                    // Store modulo results using array notation
//                    for (k = 1; k <= 8; k = k + 1) begin
//                        temp_c[k] <= mod1_out[k];
//                    end
                    
//                    // Update coefficient indices
//                    index_reg[0] <= i_cnt;
//                    index_reg[1] <= (i_cnt + 1) % N;
//                    index_reg[2] <= (i_cnt + 2) % N;
//                    index_reg[3] <= (i_cnt + 3) % N;
//                    index_reg[4] <= (i_cnt + N/2) % N;
//                    index_reg[5] <= (i_cnt + N/2 + 1) % N;
//                    index_reg[6] <= (i_cnt + N/2 + 2) % N;
//                    index_reg[7] <= (i_cnt + N/2 + 3) % N;
//                end

//                ACCUMULATE: begin
//                    for (k = 0; k < 8; k = k + 1) begin
//                        c_mem1[index_reg[k]] <= c_mem1[index_reg[k]] + temp_c[k+1];
//                    end
//                end
                
//                Acc1: begin
//                    for (k = 0; k < 8; k = k + 1) begin
//                        c_mem2[index_reg[k]] <= mod2_out[k+1];
//                    end
//                end
                       
//                Acc2: begin
//                    for (k = 0; k < 8; k = k + 1) begin
//                        c_mem[index_reg[k]] <= c_mem2[index_reg[k]];
//                    end
                    
//                    if (j_cnt == N-1) begin
//                        j_cnt <= 0;
//                        i_cnt <= i_cnt + 4;
//                        a_en <= 1;
//                        b_en <= 1;
//                        a_addr <= 0;
//                        b_addr <= 0;
//                    end else begin
//                        j_cnt <= j_cnt + 1;
//                        a_en <= 1;
//                        b_en <= 1;
//                        //a_addr <= (j_cnt + 1) % (N/2);
//                        if (j_cnt + 1 >= (N/2)) begin
//                        a_addr <= j_cnt + 1 - (N/2);end
//                        else 
//                        begin
//                        a_addr <= j_cnt + 1;
//                        end
//                        b_addr <= j_cnt + 1;
//                    end
//                end
                
//                FINISH: begin
//                    output_counter <= 0;
//                    a_en <= 0;
//                    b_en <= 0;
//                end
                
//                OUTPUT_COEFFS: begin
//                    if (output_counter == 3'd7) 
//                        output_counter <= 3'd0;
//                    else 
//                        output_counter <= output_counter + 1;
//                end
//            endcase
//        end
//    end

//    // BRAM Instantiation
//    blk_mem_gen_0 a_bram (
//        .clka(clk), .ena(a_en), .wea(1'b0),
//        .addra(a_addr), .dina(24'b0), .douta(a_data_out)
//    );

//    blk_mem_gen_1 b_bram (
//        .clka(clk), .ena(b_en), .wea(1'b0),
//        .addra(b_addr), .dina(24'b0), .douta(b_data_out)
//    );



//endmodule

module poly_multiplier_2 #(




    parameter N = 8,           // Polynomial degree
    parameter Q = 3329,        // Modulus
    parameter COEFF_WIDTH = 12, // a coefficients width
    parameter B_WIDTH = 5,// b coefficients width
    parameter A_DEPTH = 4,      // Depth for transformed A (n/2)
    parameter B_DEPTH = 8,      // Depth for transformed B (3n/2 - 4)
    parameter ADDR_WIDTH = 3    // ceil(log2(max(A_DEPTH, B_DEPTH)))
)(
    input clk,
    input reset,
    input start,
    output reg done,
    output reg [COEFF_WIDTH*N-1:0] c_packed  // Packed array output
);

    // =============================================
    // State Encoding with Meaningful Names
    // =============================================
   localparam [2:0] 
        STATE_IDLE       = 3'b000,
        STATE_READ       = 3'b001,
        STATE_WAIT_BRAM = 3'b010,
        STATE_MULTIPLY=   3'B011,
        STATE_MODULO  =   3'b100,
        STATE_ACCUMULATE = 3'b101,
        STATE_FINAL_MOD =3'b110,
        STATE_FINISH    =3'b111;
   
    
   reg [2:0]  current_state, next_state;

    // =============================================
    // BRAM Interface Signals
    // =============================================
    wire [23:0] a_data_out;
    reg [ADDR_WIDTH-1:0] a_addr_reg;
    reg a_en;
    
    wire [23:0] b_data_out;
    reg [ADDR_WIDTH-1:0] b_addr_reg;
    reg b_en;
    
    // Internal unpacked accumulation array
    reg [COEFF_WIDTH+B_WIDTH:0] c_mem [0:N-1];
    reg [COEFF_WIDTH+B_WIDTH:0] accum_stage [0:N-1];
    
    // Algorithm Control Signals
    reg [ADDR_WIDTH:0] i_cnt, j_cnt;
    
    // Data Path Registers with Pipeline Stages
    reg signed [COEFF_WIDTH:0] a0;
    reg [COEFF_WIDTH-1:0] a1;
    reg [B_WIDTH-1:0] b0, b1, b2, b3;
    
    // Multiplier Pipeline
    reg signed [COEFF_WIDTH+B_WIDTH:0] mult_stage1 [1:8];
    reg signed [COEFF_WIDTH+B_WIDTH:0] mult_stage2 [1:8];
    reg signed [COEFF_WIDTH+B_WIDTH:0] temp_c [1:8];
    

    // =============================================
    // BRAM Instantiations
    // =============================================
    blk_mem_gen_0 a_bram (
        .clka(clk),
        .ena(a_en),
        .wea(1'b0),
        .addra(a_addr_reg),
        .dina(24'b0),
        .douta(a_data_out)
    );
    
    blk_mem_gen_1 b_bram (
        .clka(clk),
        .ena(b_en),
        .wea(1'b0),
        .addra(b_addr_reg),
        .dina(24'b0),
        .douta(b_data_out)
    );

  integer i,k,m,l,s;
    // =============================================
    // Sequential Current State Logic
    // =============================================
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= STATE_IDLE;
            done <= 0;
            c_packed <= 0;
        end else begin
            current_state <= next_state;
            
            // Output registration
            if (current_state == STATE_FINISH) begin
                for ( i = 0; i < N; i=i+1) begin
                    c_packed[i*COEFF_WIDTH +: COEFF_WIDTH] <= c_mem[i];
                end
                done <= 1;
            end else begin
                done <= 0;
            end
        end
    end

    // =============================================
    // Combinational Next State Logic
    // =============================================
    always @(*) begin
        case (current_state)
            STATE_IDLE:       next_state = start ? STATE_READ : STATE_IDLE;
            STATE_READ:       next_state = STATE_WAIT_BRAM;
            STATE_WAIT_BRAM:  next_state = STATE_MULTIPLY;
            STATE_MULTIPLY:   next_state = STATE_MODULO;
            STATE_MODULO:     next_state = STATE_ACCUMULATE;
            STATE_ACCUMULATE: next_state = STATE_FINAL_MOD ;
            STATE_FINAL_MOD:  next_state = (j_cnt == N-1 && i_cnt >= N/2-4) ? STATE_FINISH : STATE_READ;
            STATE_FINISH:     next_state = STATE_IDLE;
            default:          next_state = STATE_IDLE;
        endcase
    end

    // =============================================
    // Sequential Datapath and Control Logic
    // =============================================
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Reset all registers
            i_cnt <= 0;
            j_cnt <= 0;
            a_en <= 0;
            b_en <= 0;
            a_addr_reg <= 0;
            b_addr_reg <= 0;
            a0 <= 0;
            a1 <= 0;
            b0 <= 0;
            b1 <= 0;
            b2 <= 0;
            b3 <= 0;
            
            // Initialize memories
            for  (k = 0; k < N; k=k+1) begin
                c_mem[k] <= 0;
                accum_stage[k] <= 0;
            end
            
            for ( m = 1; m <= 8; m=m+1) begin
                mult_stage1[m] <= 0;
                mult_stage2[m] <= 0;
                temp_c[m] <= 0;
            end
            
        end else begin
            case (current_state)
                STATE_IDLE: begin
                    if (start) begin
                        i_cnt <= 0;
                        j_cnt <= 0;
                        a_en <= 1;
                        b_en <= 1;
                        a_addr_reg <= 0;
                        b_addr_reg <= 0;
                    end
                end
                
                STATE_READ: begin
                    // Set up next addresses
                    a_addr_reg <= j_cnt[ADDR_WIDTH-1:0] % (N/2);
                    b_addr_reg <= j_cnt[ADDR_WIDTH-1:0];
                end
                
                STATE_WAIT_BRAM: begin
                    // Keep enables active during wait state
                    a_en <= 1;
                    b_en <= 1;
                end
                
                STATE_MULTIPLY: begin
                    // Capture BRAM outputs with proper signed handling
                    a0 <= (j_cnt < N/2) ? $signed(a_data_out[23:12]) : -$signed({1'b0, a_data_out[11:0]});
                    a1 <= (j_cnt < N/2) ? a_data_out[11:0] : a_data_out[23:12];
                    
                    b0 <= b_data_out[23:18];
                    b1 <= b_data_out[17:12];
                    b2 <= b_data_out[11:6];
                    b3 <= b_data_out[5:0];
                    
                    // First pipeline stage - raw multiplications
                    mult_stage1[1] <= a0 * $signed({1'b0, b0});
                    mult_stage1[2] <= a0 * $signed({1'b0, b1});
                    mult_stage1[3] <= a0 * $signed({1'b0, b2});
                    mult_stage1[4] <= a0 * $signed({1'b0, b3});
                    mult_stage1[5] <= $signed({1'b0, a1}) * $signed({1'b0, b0});
                    mult_stage1[6] <= $signed({1'b0, a1}) * $signed({1'b0, b1});
                    mult_stage1[7] <= $signed({1'b0, a1}) * $signed({1'b0, b2});
                    mult_stage1[8] <= $signed({1'b0, a1}) * $signed({1'b0, b3});
                    
                    a_en <= 0;
                    b_en <= 0;
                end
                
                STATE_MODULO: begin
                    // Second pipeline stage - modulo operations
                    for ( l = 1; l <= 8; l=l+1) begin
                        mult_stage2[l] <= ((mult_stage1[l] % Q) + Q) % Q;
                    end
                end
                
                STATE_ACCUMULATE: begin
                    // Use pipelined results
                    for (s = 1; s <= 8; s=s+1) begin
                        temp_c[s] <= mult_stage2[s];
                    end
                    
            
                end
                
                STATE_FINAL_MOD: begin
                    // Final modulo stage
                    
                            // Pipeline stage for accumulation
                    accum_stage[i_cnt]             <=  (accum_stage[i_cnt] + temp_c[1])%Q;
                    accum_stage[(i_cnt + 1) % N]   <=  (accum_stage[(i_cnt + 1) % N] + temp_c[2])%Q;
                    accum_stage[(i_cnt + 2) % N]   <= (accum_stage[(i_cnt + 2) % N] + temp_c[3])%Q;
                    accum_stage[(i_cnt + 3) % N]   <= (accum_stage[(i_cnt + 3) % N] + temp_c[4])%Q;
                    accum_stage[(i_cnt + N/2) % N] <= (accum_stage[(i_cnt + N/2) % N] + temp_c[5])%Q;
                    accum_stage[(i_cnt + N/2 + 1) % N] <= (accum_stage[(i_cnt + N/2 + 1) % N] + temp_c[6])%Q;
                    accum_stage[(i_cnt + N/2 + 2) % N] <= (accum_stage[(i_cnt + N/2 + 2) % N] + temp_c[7])%Q;
                    accum_stage[(i_cnt + N/2 + 3) % N] <= (accum_stage[(i_cnt + N/2 + 3) % N] + temp_c[8])%Q;
                    
                    // Update indices
                    if (j_cnt == N - 1) begin
                        if (i_cnt >= N/2 - 4) begin
                            // Last iteration
                            a_en <= 0;
                            b_en <= 0;
                        end else begin
                            i_cnt <= i_cnt + 4;
                            j_cnt <= 0;
                            a_en <= 1;
                            b_en <= 1;
                            a_addr_reg <= 0;
                            b_addr_reg <= 0;
                        end
                    end else begin
                        j_cnt <= j_cnt + 1;
                        a_en <= 1;
                        b_en <= 1;
                        a_addr_reg <= (j_cnt + 1) % (N/2);
                        b_addr_reg <= j_cnt + 1;
                    end
                   
                end
                
                STATE_FINISH: begin
                    // Reset for next operation
                     for (i = 0; i < N; i=i+1) begin
                        c_mem[i] <= accum_stage[i] ;
                    end
                    a_en <= 0;
                    b_en <= 0;
                end
            endcase
        end
    end
endmodule