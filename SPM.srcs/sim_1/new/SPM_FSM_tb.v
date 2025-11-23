`timescale 1ns / 1ps

module tb_poly_multiplier_2();

    // Parameters
    parameter N = 8;
    parameter Q = 251;
    parameter COEFF_WIDTH = 12;
    parameter B_WIDTH = 6;
    parameter CLK_PERIOD = 10; 
    parameter A_DEPTH = 4;     // Depth for transformed A (n/2)
    parameter B_DEPTH = 8;     // Depth for transformed B (3n/2 - 4)
    parameter ADDR_WIDTH = 3;  // 100 MHz clock

    // Signals
    reg clk;
    reg reset;
    reg start;
    wire done;
    wire [COEFF_WIDTH*N-1:0] c_packed;
    
    // Clock generation
    always #(CLK_PERIOD/2) clk = ~clk;
    
    // DUT Instantiation
    poly_multiplier_2 #(
        .N(N),
        .Q(Q),
        .COEFF_WIDTH(COEFF_WIDTH),
        .B_WIDTH(B_WIDTH)
    ) dut (
        .clk(clk),
        .reset(reset),
        .start(start),
        .done(done),
        .c_packed(c_packed)
    );
    
    // Unpack the output for easier viewing
    wire [COEFF_WIDTH-1:0] c [0:N-1];
    genvar i;
    generate
        for (i = 0; i < N; i = i + 1) begin : unpack
            assign c[i] = c_packed[i*COEFF_WIDTH +: COEFF_WIDTH];
        end
    endgenerate
    

    integer j;
    // Test sequence
    initial begin
        // Initialize signals
        clk = 0;
        reset = 1;
        start = 0;
        
        // Reset the design
        #(CLK_PERIOD*10) reset = 0;
        
        // Wait a bit then start
        #(CLK_PERIOD*5) start = 1;
        #(CLK_PERIOD) start = 0;
        
        // Wait for completion
        wait(done == 1);
        #(CLK_PERIOD*2);
        
        // Display results
        $display("Test completed. Results:");
        for ( j = 0; j < N; j = j + 1) begin
            $display("c[%0d] = %0d", j, c[j]);
        end
        
        // Simple check (for N=8, Q=3329)
        if (c[0] == ((1*1 + 2*0 + 3*4 + 4*0 + 5*3 + 6*0 + 7*2 + 8*0) % Q)) begin
            $display("Basic check passed for c[0]");
        end else begin
            $display("Basic check FAILED for c[0]");
        end
        
        // End simulation
        $finish;
    end
    

    
endmodule