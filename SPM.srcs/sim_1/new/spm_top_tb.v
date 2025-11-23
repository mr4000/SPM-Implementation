`timescale 1ns / 1ps

module spm_top_bram_tb;

    parameter N = 8;
    parameter WIDTH = 8;
    parameter Q = 251;

    reg clk = 0;
    reg reset = 1;
    reg start = 0;
    reg write_enable = 0;
    reg [1:0] sel = 0;  // 00=a, 01=b, 10=c
    reg [$clog2(N)-1:0] addr = 0;
    reg [WIDTH-1:0] data_in = 0;
    wire [2*WIDTH-1:0] data_out;
    wire done;

    // Instantiate DUT
    spm_top_bram #(
        .N(N), .WIDTH(WIDTH), .Q(Q)
    ) dut (
        .clk(clk), .reset(reset), .start(start),
        .write_enable(write_enable), .sel(sel),
        .addr(addr), .data_in(data_in), .data_out(data_out), .done(done)
    );

    // Clock generation
    always #5 clk = ~clk;

    // Tasks
    task write_a(input integer i, input [WIDTH-1:0] val);
        begin
            @(posedge clk);
            sel = 2'b00;
            addr = i;
            data_in = val;
            write_enable = 1;
            @(posedge clk);
            write_enable = 0;
        end
    endtask

    task write_b(input integer i, input [WIDTH-1:0] val);
        begin
            @(posedge clk);
            sel = 2'b01;
            addr = i;
            data_in = val;
            write_enable = 1;
            @(posedge clk);
            write_enable = 0;
        end
    endtask

    task read_c(input integer i);
        begin
            @(posedge clk);
            sel = 2'b10;
            addr = i;
            @(posedge clk);
            $display("c[%0d] = %0d", i, data_out);
        end
    endtask

    integer i;

    initial begin
        // Reset
        #10 reset = 0;

        // Load input a[]
        for (i = 0; i < N; i = i + 1) begin
            write_a(i, i + 1);  // Example: a = [1,2,3,...,8]
        end

        // Load input b[]
        for (i = 0; i < N; i = i + 1) begin
            write_b(i, (i + 1) * 2);  // Example: b = [2,4,6,...,16]
        end

        // Start computation
        @(posedge clk);
        start = 1;
        @(posedge clk);
        start = 0;

        // Wait for done
        wait (done);
        @(posedge clk); // wait 1 cycle after done

        // Read output c[]
        for (i = 0; i < N; i = i + 1) begin
            read_c(i);
        end

        $finish;
    end

endmodule
