`timescale 1ns / 1ps

module barrett_mod_fixed_tb;

    // Parameters
    parameter WIDTH_IN = 16;
    parameter WIDTH_OUT = 12;
    parameter Q = 251;
    parameter K = 13;
    parameter MU = (1 << (2*K)) / Q;

    // Inputs
    reg clk = 0;
    reg reset = 1;
    reg start = 0;
    reg signed [WIDTH_IN-1:0] x;

    // Outputs
    wire [WIDTH_OUT-1:0] result;
    wire done;

    // Instantiate the module
    barrett_mod_fixed #(
        .WIDTH_IN(WIDTH_IN),
        .WIDTH_OUT(WIDTH_OUT),
        .Q(Q),
        .K(K),
        .MU(MU),
        .SIGNED_INPUT(1)
    ) uut (
        .clk(clk),
        .reset(reset),
        .start(start),
        .x(x),
        .result(result),
        .done(done)
    );

    // Clock generation
    always #5 clk = ~clk;

    // Test sequence
    initial begin
        $display("Time\tInput x\tMod %0d Result", Q);
        #100 reset = 0;

        test_input(0);
        test_input(1);
        test_input(-25);    // Q-1
        test_input(-36);    // Q
        test_input(-42);    // Q+1
        test_input(8191);    // 2*Q - 1
        test_input(-1);
        test_input(-4093);
        test_input(-8192);

        #100 $finish;
    end

    task test_input(input signed [WIDTH_IN-1:0] val);
    begin
        @(negedge clk);
        x <= val;
        start <= 1;
        @(negedge clk);
        start <= 0;

        wait(done);
        @(posedge clk);
        $display("%0t\t%d\t%d", $time, val, result);
    end
    endtask

endmodule
