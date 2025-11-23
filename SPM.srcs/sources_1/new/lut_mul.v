// lut_mul.v
// Parameterized LUT-based multiplier using shift-and-add
// Default: A_WIDTH = 12, B_WIDTH = 5 -> product width = 17

module lut_mul #(
  parameter integer A_WIDTH = 12,
  parameter integer B_WIDTH = 5
)(
  input  wire [A_WIDTH-1:0] a,
  input  wire [B_WIDTH-1:0] b,
  output reg  [A_WIDTH+B_WIDTH-1:0] p
);

  // Partial products (each shifted version of `a` masked by b[i])
  wire [A_WIDTH+B_WIDTH-1:0] partial [0:B_WIDTH-1];

  genvar i;
  generate
    for (i = 0; i < B_WIDTH; i = i + 1) begin : PARTIALS
      // extend `a` to full product width then shift left by i
      wire [A_WIDTH+B_WIDTH-1:0] a_ext = { {B_WIDTH{1'b0}}, a } << i;
      assign partial[i] = b[i] ? a_ext : { (A_WIDTH+B_WIDTH){1'b0} };
    end
  endgenerate

  integer j;
  always @(*) begin
    // simple accumulation (adder chain)
    p = { (A_WIDTH+B_WIDTH){1'b0} };
    for (j = 0; j < B_WIDTH; j = j + 1) begin
      p = p + partial[j];
    end
  end

endmodule
