// tb_lut_mul.v
`timescale 1ns/1ps
module tb_lut_mul;
  parameter AW = 12;
  parameter BW = 5;
  reg  [AW-1:0] a;
  reg  [BW-1:0] b;
  wire [AW+BW-1:0] p;

  // instantiate
  lut_mul #(.A_WIDTH(AW), .B_WIDTH(BW)) dut (.a(a), .b(b), .p(p));

  integer i, j;
  initial begin
    // basic random test
    for (i = 0; i < 1000; i = i + 1) begin
      a = $urandom() & ((1<<AW)-1);
      b = $urandom() & ((1<<BW)-1);
      #1; // let combinational settle
      if (p !== (a * b)) begin
        $display("Mismatch: a=%0d b=%0d p=%0d expected=%0d", a, b, p, a*b);
        $stop;
      end
    end
    $display("All tests passed");
    $finish;
  end
endmodule
