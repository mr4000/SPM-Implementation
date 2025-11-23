module spm_parallel #(
    parameter N = 8,
    parameter WIDTH = 8,
    parameter Q = 251
)(
    input wire clk,
    input wire reset,
    input wire start,
    input wire [N*WIDTH-1:0] a,
    input wire [N*WIDTH-1:0] b,
    output reg [N*2*WIDTH-1:0] c,
    output reg done
);
    localparam IDLE = 0, LOAD = 1, COMPUTE = 2, COMPUTE_UPDATE = 3, DONE = 4;
    reg [2:0] state;

    reg [$clog2(N):0] i, j;
    reg [WIDTH-1:0] A0, A1;
    reg [WIDTH-1:0] B0, B1, B2, B3;
    reg [2*WIDTH-1:0] temp_c [0:7];
    reg [2*WIDTH-1:0] c_array [0:N-1];

    wire [WIDTH-1:0] a_array [0:N-1];
    wire [WIDTH-1:0] b_array [0:N-1];

    genvar idx;
    generate
        for (idx = 0; idx < N; idx = idx + 1) begin
            assign a_array[idx] = a[idx*WIDTH +: WIDTH];
            assign b_array[idx] = b[idx*WIDTH +: WIDTH];
        end
    endgenerate

    // Output assignment
    integer k;
    always @(*) begin
        for (k = 0; k < N; k = k + 1)
            c[k*2*WIDTH +: 2*WIDTH] = c_array[k];
    end



    function [2*WIDTH-1:0] mod_q;
    input [2*WIDTH-1:0] value;
    begin
        mod_q = value % Q;  // Synthesis-safe for constant Q
    end
endfunction


    // Modulo N function (for index wrapping)
function [$clog2(N):0] mod_n;
    input [$clog2(N):0] value;
    begin
        mod_n = value % N;
    end
endfunction


    integer m;
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            i <= 0;
            j <= 0;
            done <= 0;
            for (m = 0; m < N; m = m + 1)
                c_array[m] <= 0;
            for (m = 0; m < 8; m = m + 1)
                temp_c[m] <= 0;
            A0 <= 0; A1 <= 0;
            B0 <= 0; B1 <= 0; B2 <= 0; B3 <= 0;
        end else begin
            case (state)
                IDLE: begin
                    if (start) begin
                        i <= 0;
                        j <= 0;
                        done <= 0;
                        for (m = 0; m < N; m = m + 1)
                            c_array[m] <= 0;
                        state <= LOAD;
                    end
                end

                LOAD: begin
                    if (i < N/2) begin
                        if (j < N) begin
                            if (j < N/2) begin
                                A0 <= a_array[j];
                                A1 <= a_array[mod_n(j + N/2)];
                            end else begin
                                A0 <= mod_q(Q - a_array[j]);
                                A1 <= a_array[mod_n(j + N/2)];
                            end

                            B0 <= b_array[mod_n(i - j + 0 + N)];
                            B1 <= b_array[mod_n(i - j + 1 + N)];
                            B2 <= b_array[mod_n(i - j + 2 + N)];
                            B3 <= b_array[mod_n(i - j + 3 + N)];
                            state <= COMPUTE;
                        end else begin
                            j <= 0;
                            i <= i + 4;
                            if (i + 4 >= N/2)
                                state <= DONE;
                            else
                                state <= LOAD;
                        end
                    end else begin
                        state <= DONE;
                    end
                end

                COMPUTE: begin
                    temp_c[0] <= mod_q(A0 * B0);
                    temp_c[1] <= mod_q(A0 * B1);
                    temp_c[2] <= mod_q(A0 * B2);
                    temp_c[3] <= mod_q(A0 * B3);
                    temp_c[4] <= mod_q(A1 * B0);
                    temp_c[5] <= mod_q(A1 * B1);
                    temp_c[6] <= mod_q(A1 * B2);
                    temp_c[7] <= mod_q(A1 * B3);
                    state <= COMPUTE_UPDATE;
                end

                COMPUTE_UPDATE: begin
                    c_array[i+0] <= mod_q(c_array[i+0] + temp_c[0]);
                    c_array[i+1] <= mod_q(c_array[i+1] + temp_c[1]);
                    c_array[i+2] <= mod_q(c_array[i+2] + temp_c[2]);
                    c_array[i+3] <= mod_q(c_array[i+3] + temp_c[3]);

                    c_array[mod_n(i+N/2+0)] <= mod_q(c_array[mod_n(i+N/2+0)] + temp_c[4]);
                    c_array[mod_n(i+N/2+1)] <= mod_q(c_array[mod_n(i+N/2+1)] + temp_c[5]);
                    c_array[mod_n(i+N/2+2)] <= mod_q(c_array[mod_n(i+N/2+2)] + temp_c[6]);
                    c_array[mod_n(i+N/2+3)] <= mod_q(c_array[mod_n(i+N/2+3)] + temp_c[7]);

                    j <= j + 1;
                    state <= LOAD;

                    // Debug
                  ///  $display("i=%0d j=%0d state=COMPUTE_UPDATE", i, j);
                end

                DONE: begin
                    done <= 1;
                    state <= IDLE;
                    //$display("DONE at time %t", $time);
                end

                default: state <= IDLE;
            endcase
        end
    end
endmodule




//Two always block fsm
    
//module spm_parallel #(
//    parameter N = 8,
//    parameter WIDTH = 8,
//    parameter Q = 251
//)(
//    input wire clk,
//    input wire reset,
//    input wire start,
//    input wire [N*WIDTH-1:0] a,
//    input wire [N*WIDTH-1:0] b,
//    output wire [N*2*WIDTH-1:0] c,
//    output reg done
//);

//    // State encoding with safe one-hot encoding for synthesis
//    localparam [4:0]
//        IDLE         = 5'b00001,
//        LOAD         = 5'b00010,
//        COMPUTE      = 5'b00100,
//        COMPUTE_STG2 = 5'b01000,
//        COMPUTE_UPD  = 5'b10000;
    
//    reg [4:0] current_state, next_state;

//    // Datapath registers with explicit reset values
//    reg [$clog2(N):0] i, j;
//    reg [WIDTH-1:0] A0, A1;
//    reg [WIDTH-1:0] B0, B1, B2, B3;
    
//    // Pipeline registers with synchronous reset
//    reg [WIDTH-1:0] A0_reg, A1_reg;
//    reg [WIDTH-1:0] B0_reg, B1_reg, B2_reg, B3_reg;
//    reg [$clog2(N):0] i_reg, j_reg;
//    reg [2*WIDTH-1:0] mult_results [0:7];
    
//    // Memory with synchronous reset
//    reg [2*WIDTH-1:0] c_array [0:N-1];
//    integer k;

//    // ==============================================
//    // Combinational next-state logic
//    // ==============================================
//    always @(*) begin
//        next_state = current_state;
//        case (current_state)
//            IDLE:       next_state = start ? LOAD : IDLE;
            
//            LOAD:       if (i < N/2) begin
//                            next_state = (j < N) ? COMPUTE : 
//                                        ((i + 4 >= N/2) ? IDLE : LOAD);
//                        end else begin
//                            next_state = IDLE;
//                        end
                        
//            COMPUTE:    next_state = COMPUTE_STG2;
//            COMPUTE_STG2: next_state = COMPUTE_UPD;
//            COMPUTE_UPD: next_state = (j < N-1) ? LOAD : 
//                                     (i + 4 >= N/2) ? IDLE : LOAD;
//            default:    next_state = IDLE;
//        endcase
//    end

//    // ==============================================
//    // Sequential logic with proper reset
//    // ==============================================
//    always @(posedge clk) begin
//        if (reset) begin
//            current_state <= IDLE;
//            done <= 1'b0;
//            i <= 0;
//            j <= 0;
//            for (k = 0; k < N; k = k + 1) c_array[k] <= 0;
//            A0 <= 0; A1 <= 0;
//            B0 <= 0; B1 <= 0; B2 <= 0; B3 <= 0;
//            A0_reg <= 0; A1_reg <= 0;
//            B0_reg <= 0; B1_reg <= 0; B2_reg <= 0; B3_reg <= 0;
//            i_reg <= 0; j_reg <= 0;
//            for (k = 0; k < 8; k = k + 1) mult_results[k] <= 0;
//        end else begin
//            current_state <= next_state;
            
//            // Default assignments
//            done <= 1'b0;
            
//            case (current_state)
//                IDLE: begin
//                    if (start) begin
//                        i <= 0;
//                        j <= 0;
//                        for (k = 0; k < N; k = k + 1) c_array[k] <= 0;
//                    end
//                end
                
//                LOAD: begin
//                    if (i < N/2 && j < N) begin
//                        // Use blocking assignments for immediate updates
//                        A0 <= (j < N/2) ? a[j*WIDTH +: WIDTH] : 
//                              (Q - a[j*WIDTH +: WIDTH]);
//                        A1 <= a[((j + N/2) % N)*WIDTH +: WIDTH];
                        
//                        B0 <= b[((i - j + 0 + 2*N) % N)*WIDTH +: WIDTH];
//                        B1 <= b[((i - j + 1 + 2*N) % N)*WIDTH +: WIDTH];
//                        B2 <= b[((i - j + 2 + 2*N) % N)*WIDTH +: WIDTH];
//                        B3 <= b[((i - j + 3 + 2*N) % N)*WIDTH +: WIDTH];
                        
//                        i_reg <= i;
//                        j_reg <= j;
//                    end else if (i < N/2) begin
//                        j <= 0;
//                        i <= i + 4;
//                    end
//                end
                
//                COMPUTE: begin
//                    A0_reg <= A0;
//                    A1_reg <= A1;
//                    B0_reg <= B0;
//                    B1_reg <= B1;
//                    B2_reg <= B2;
//                    B3_reg <= B3;
//                end
                
//                COMPUTE_STG2: begin
//                    // Use explicit multiplication with registered inputs
//                    mult_results[0] <= A0_reg * B0_reg;
//                    mult_results[1] <= A0_reg * B1_reg;
//                    mult_results[2] <= A0_reg * B2_reg;
//                    mult_results[3] <= A0_reg * B3_reg;
//                    mult_results[4] <= A1_reg * B0_reg;
//                    mult_results[5] <= A1_reg * B1_reg;
//                    mult_results[6] <= A1_reg * B2_reg;
//                    mult_results[7] <= A1_reg * B3_reg;
//                end
                
//                COMPUTE_UPD: begin
//                    // Use non-blocking assignments for all register updates
//                    c_array[(i_reg+0)%N] <= mod_q(c_array[(i_reg+0)%N] + mult_results[0]);
//                    c_array[(i_reg+1)%N] <= mod_q(c_array[(i_reg+1)%N] + mult_results[1]);
//                    c_array[(i_reg+2)%N] <= mod_q(c_array[(i_reg+2)%N] + mult_results[2]);
//                    c_array[(i_reg+3)%N] <= mod_q(c_array[(i_reg+3)%N] + mult_results[3]);
                    
//                    c_array[(i_reg+N/2+0)%N] <= mod_q(c_array[(i_reg+N/2+0)%N] + mult_results[4]);
//                    c_array[(i_reg+N/2+1)%N] <= mod_q(c_array[(i_reg+N/2+1)%N] + mult_results[5]);
//                    c_array[(i_reg+N/2+2)%N] <= mod_q(c_array[(i_reg+N/2+2)%N] + mult_results[6]);
//                    c_array[(i_reg+N/2+3)%N] <= mod_q(c_array[(i_reg+N/2+3)%N] + mult_results[7]);
                    
//                    j <= j_reg + 1;
                    
//                    // Set done flag when returning to IDLE
//                    if (next_state == IDLE) done <= 1'b1;
//                end
//            endcase
//        end
//    end

//    // ==============================================
//    // Output assignments and functions
//    // ==============================================
//    generate
//        for (genvar idx = 0; idx < N; idx = idx + 1) begin
//            assign c[idx*2*WIDTH +: 2*WIDTH] = c_array[idx];
//        end
//    endgenerate

//    // Synthesis-friendly modulo function
//    function [2*WIDTH-1:0] mod_q;
//    input [2*WIDTH-1:0] value;
//    begin
//        mod_q = value % Q;  // Synthesis-safe for constant Q
//    end
//endfunction

//endmodule

//module spm_parallel #(
//    parameter N = 8,          // Polynomial degree (must be power of 2)
//    parameter WIDTH_A = 24,   // Width of a coefficients (12-bit)
//    parameter WIDTH_B = 24,    // Width of b coefficients (5-bit)
//    parameter Q = 251         // Modulus
//)(
//    input wire clk,
//    input wire reset,
//    input wire start,
//    output wire [N*(WIDTH_A+WIDTH_B)-1:0] c,  // Output polynomial
//    output reg done
//);

//    // State encoding with safe one-hot encoding for synthesis
//    localparam [5:0]
//        IDLE         = 5'b00001,
//        LOAD         = 5'b00010,
//        COMPUTE      = 5'b00100,
//        COMPUTE_STG2 = 5'b01000,
//        COMPUTE_UPD  = 5'b10000;
    
//    reg [4:0] current_state, next_state;

//    // BRAM interface signals
//    reg [3:0] a_addr, b_addr;  // 4-bit address for N=8 (2^3)
//    reg a_ena, b_ena;
//    wire [23:0] a_dout, b_dout;
    
//    // BRAM instances (Vivado BRAM IP)
//    blk_mem_gen_0 bram_a (
//        .clka(clk),
//        .ena(a_ena),
//        .wea(1'b0),      // Read-only
//        .addra(a_addr),
//        .dina(16'b0),    // Not used for reads
//        .douta(a_dout)
//    );
    
//    blk_mem_gen_1 bram_b (
//        .clka(clk),
//        .ena(b_ena),
//        .wea(1'b0),      // Read-only
//        .addra(b_addr),
//        .dina(16'b0),    // Not used for reads
//        .douta(b_dout)
//    );

//    // Datapath registers
//    reg [$clog2(N):0] i, j;
//    reg [WIDTH_A-1:0] A0, A1;
//    reg [WIDTH_B-1:0] B0, B1, B2, B3;
    
//    // Pipeline registers
//    reg [WIDTH_A-1:0] A0_reg, A1_reg;
//    reg [WIDTH_B-1:0] B0_reg, B1_reg, B2_reg, B3_reg;
//    reg [$clog2(N):0] i_reg, j_reg;
//    reg [WIDTH_A+WIDTH_B-1:0] mult_results [0:7];
    
//    // Accumulation memory
//    reg [WIDTH_A+WIDTH_B-1:0] c_array [0:N-1];
//    integer k;

//    // ==============================================
//    // Combinational next-state logic
//    // ==============================================
//    always @(*) begin
//        next_state = current_state;
//        case (current_state)
//            IDLE:       next_state = start ? LOAD : IDLE;
            
//            LOAD:       if (i < N/2) begin
//                            next_state = (j < N) ? COMPUTE : 
//                                        ((i + 4 >= N/2) ? IDLE : LOAD);
//                        end else begin
//                            next_state = IDLE;
//                        end
                        
//            COMPUTE:    next_state = COMPUTE_STG2;
//            COMPUTE_STG2: next_state = COMPUTE_UPD;
//            COMPUTE_UPD: next_state = (j < N-1) ? LOAD : 
//                                     (i + 4 >= N/2) ? IDLE : LOAD;
//            default:    next_state = IDLE;
//        endcase
//    end

//    // ==============================================
//    // Sequential logic
//    // ==============================================
//    always @(posedge clk) begin
//        if (reset) begin
//            current_state <= IDLE;
//            done <= 1'b0;
//            i <= 0;
//            j <= 0;
//            for (k = 0; k < N; k = k + 1) c_array[k] <= 0;
//            A0 <= 0; A1 <= 0;
//            B0 <= 0; B1 <= 0; B2 <= 0; B3 <= 0;
//            A0_reg <= 0; A1_reg <= 0;
//            B0_reg <= 0; B1_reg <= 0; B2_reg <= 0; B3_reg <= 0;
//            i_reg <= 0; j_reg <= 0;
//            for (k = 0; k < 8; k = k + 1) mult_results[k] <= 0;
//            a_addr <= 0;
//            b_addr <= 0;
//            a_ena <= 0;
//            b_ena <= 0;
//        end else begin
//            current_state <= next_state;
//            done <= 1'b0;
            
//            case (current_state)
//                IDLE: begin
//                    if (start) begin
//                        i <= 0;
//                        j <= 0;
//                        for (k = 0; k < N; k = k + 1) c_array[k] <= 0;
//                        a_ena <= 1'b1;
//                        b_ena <= 1'b1;
//                    end else begin
//                        a_ena <= 1'b0;
//                        b_ena <= 1'b0;
//                    end
//                end
                
//                LOAD: begin
//                    if (i < N/2 && j < N) begin
//                        // Read a[j] and a[(j+N/2)%N] from BRAM
//                        a_addr <= j;
//                        A0 <= (j <= N/2) ? a_dout[WIDTH_A-1:0]:(-$signed( a_dout[WIDTH_A-1:0]));
                        
//                       // a_addr <= (j + N/2) % N;
//                        A1 <= a_dout[2*WIDTH_A-1:WIDTH_A];
                        
//                        // Read b[(i-j)modN] to b[(i-j+3)modN] from BRAM
//                        b_addr <= (i - j + 0 + N) % N;
//                        B0 <= b_dout[WIDTH_B-1:0];
                        
//                       // b_addr <= (i - j + 1 + N) % N;
//                        B1 <= b_dout[WIDTH_B-1:0];
                        
//                       // b_addr <= (i - j + 2 + N) % N;
//                        B2 <= b_dout[WIDTH_B-1:0];
                        
//                       // b_addr <= (i - j + 3 + N) % N;
//                        B3 <= b_dout[WIDTH_B-1:0];
                        
//                        i_reg <= i;
//                        j_reg <= j;
//                        //j<=j+1;
//                    end else if (i < N/2) begin
//                        j <= 0;
//                        i <= i + 4;
//                    end
//                end
                
//                COMPUTE: begin
//                    A0_reg <= A0;
//                    A1_reg <= A1;
//                    B0_reg <= B0;
//                    B1_reg <= B1;
//                    B2_reg <= B2;
//                    B3_reg <= B3;
//                  //   j <= j_reg + 1;
//                end
                
//                COMPUTE_STG2: begin
//                    // Perform 8 parallel multiplications
//                    mult_results[0] <= A0_reg * B0_reg;
//                    mult_results[1] <= A0_reg * B1_reg;
//                    mult_results[2] <= A0_reg * B2_reg;
//                    mult_results[3] <= A0_reg * B3_reg;
//                    mult_results[4] <= A1_reg * B0_reg;
//                    mult_results[5] <= A1_reg * B1_reg;
//                    mult_results[6] <= A1_reg * B2_reg;
//                    mult_results[7] <= A1_reg * B3_reg;
//                end
                
//                COMPUTE_UPD: begin
//                    // Accumulate results with modulo
//                    c_array[(i_reg+0)%N] <= mod_q(c_array[(i_reg+0)%N] + mult_results[0]);
//                    c_array[(i_reg+1)%N] <= mod_q(c_array[(i_reg+1)%N] + mult_results[1]);
//                    c_array[(i_reg+2)%N] <= mod_q(c_array[(i_reg+2)%N] + mult_results[2]);
//                    c_array[(i_reg+3)%N] <= mod_q(c_array[(i_reg+3)%N] + mult_results[3]);
                    
//                    c_array[(i_reg+N/2+0)%N] <= mod_q(c_array[(i_reg+N/2+0)%N] + mult_results[4]);
//                    c_array[(i_reg+N/2+1)%N] <= mod_q(c_array[(i_reg+N/2+1)%N] + mult_results[5]);
//                    c_array[(i_reg+N/2+2)%N] <= mod_q(c_array[(i_reg+N/2+2)%N] + mult_results[6]);
//                    c_array[(i_reg+N/2+3)%N] <= mod_q(c_array[(i_reg+N/2+3)%N] + mult_results[7]);
                    
//                  j <= j_reg + 1;
                    
//                    if (next_state == IDLE) begin
//                        done <= 1'b1;
//                        a_ena <= 1'b0;
//                        b_ena <= 1'b0;
//                    end
//                end
//            endcase
//        end
//    end

//    // ==============================================
//    // Output assignments and functions
//    // ==============================================
//    generate
//        for (genvar idx = 0; idx < N; idx = idx + 1) begin
//            assign c[idx*(WIDTH_A+WIDTH_B) +: (WIDTH_A+WIDTH_B)] = c_array[idx];
//        end
//    endgenerate

//    // Modulo function
//    function [WIDTH_A+WIDTH_B-1:0] mod_q;
//    input [WIDTH_A+WIDTH_B-1:0] value;
//    begin
//        mod_q = value % Q;
//    end
//    endfunction

//endmodule