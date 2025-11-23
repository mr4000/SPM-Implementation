// Code your testbench here
// or browse Examples
//`timescale 1ns / 1ps

//module spm_parallel_tb;

//    parameter N = 8;
//    parameter WIDTH = 8;
//    parameter Q = 251;

//    reg clk = 0, reset = 1, start = 0;
//    reg [N*WIDTH-1:0] a, b;
//    wire [N*2*WIDTH-1:0] c;
//    wire done;

//    // Instantiate the DUT
//    spm_parallel #(
//        .N(N),
//        .WIDTH(WIDTH),
//        .Q(Q)
//    ) uut (
//        .clk(clk),
//        .reset(reset),
//        .start(start),
//        .a(a),
//        .b(b),
//        .c(c),
//        .done(done)
//    );

//    // Clock generation
//    always #10 clk = ~clk;

//    integer i;

//    initial begin
//        // Monitor internal states (if exposed)
//        $dumpfile("spm_parallel_tb.vcd");
//        $dumpvars(0, spm_parallel_tb);
        
//        // Initialization
//        a = {8'd8, 8'd7, 8'd6, 8'd5, 8'd4, 8'd3, 8'd2, 8'd1};  // a = [1,2,...,8]
//        b = {8'd1, 8'd2, 8'd3, 8'd4, 8'd5, 8'd6, 8'd7, 8'd8};  // b = [8,7,...,1]
//        reset = 1;
//        #100 reset = 0;

//        // Start computation
//        #10 start = 1;
//        #10 start = 0;

//        $display("\n=== SPM Parallel Testbench ===");
//        $display("Input Polynomial A(x):");
//        for (i = 0; i < N; i = i + 1)
//            $display("a[%0d] = %0d", i, a[(N-1-i)*WIDTH +: WIDTH]);

//        $display("Input Polynomial B(x):");
//        for (i = 0; i < N; i = i + 1)
//            $display("b[%0d] = %0d", i, b[(N-1-i)*WIDTH +: WIDTH]);

//        // Wait for completion
//        wait(done);

       
//       $display("\n=== Result C(x) ===");
//         for (i = 0; i < N; i = i + 1)
//    $display("c[%0d] = %0d", i, c[i*2*WIDTH +: 2*WIDTH]);

//        $finish;
//    end

//endmodule


`timescale 1ns / 1ps

module tb_spm_parallel();

    // Parameters
    parameter N = 8;          // Polynomial degree
    parameter WIDTH_A = 12;   // Width of a coefficients
    parameter WIDTH_B = 6;    // Width of b coefficients
    parameter Q = 251;        // Modulus
    parameter CLK_PERIOD = 10; // 100 MHz clock

    // Signals
    reg clk;
    reg reset;
    reg start;
    wire [N*(WIDTH_A+WIDTH_B)-1:0] c;
    wire done;

    // Clock generation
    always #(CLK_PERIOD/2) clk = ~clk;

    // DUT instantiation (contains BRAMs internally)
    spm_parallel #(
        .N(N),
        .WIDTH_A(WIDTH_A),
        .WIDTH_B(WIDTH_B),
        .Q(Q)
    ) dut (
        .clk(clk),
        .reset(reset),
        .start(start),
        .c(c),
        .done(done)
        // BRAM ports are internal to spm_parallel
    );

    integer i;
    // Main test sequence
    initial begin
        // Initialize signals
        clk = 0;
        reset = 1;
        start = 0;

        // Reset sequence
        #(CLK_PERIOD*10);
        reset = 0;
        #(CLK_PERIOD*2);

        // Start computation
        $display("[%0t] Starting computation", $time);
        start = 1;
        #(CLK_PERIOD);
        start = 0;

        // Wait for completion
        wait(done);
        $display("[%0t] Computation completed", $time);
        #(CLK_PERIOD*2);

        // Display results
        $display("\nPolynomial Multiplication Results (mod %0d):", Q);
        $display("Index | Decimal | Hex");
        $display("---------------------");
        for ( i = 0; i < N; i=i+1) begin
            $display("%3d   | %7d | 0x%04h", 
                    i, 
                    c[i*(WIDTH_A+WIDTH_B) +: WIDTH_A+WIDTH_B],
                    c[i*(WIDTH_A+WIDTH_B) +: WIDTH_A+WIDTH_B]);
        end

        $display("\nTestbench finished");
        $finish;
    end

    // Waveform dumping
    initial begin
        $dumpfile("tb_spm_parallel.vcd");
        $dumpvars(0, tb_spm_parallel);
        $dumpvars(1, dut); // Add all DUT signals
    end

endmodule
