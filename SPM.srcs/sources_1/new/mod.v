module barrett_mod_fixed #(
    parameter WIDTH_IN = 16,
    parameter WIDTH_OUT = 12,
    parameter Q = 251,
    parameter K = 8,                      // ?log2(Q)?
    parameter MU = (1 << (2*K)) / Q,       // Floor(2^(2K) / Q)
    parameter SIGNED_INPUT = 1
)(
    input clk,
    input reset,
    input start,
    input [WIDTH_IN-1:0] x,
    output reg [WIDTH_OUT-1:0] result,
    output reg done
);

    localparam MU_WIDTH = 2*K;  // Width of MU and intermediate multiplication
    localparam T_WIDTH = WIDTH_IN + MU_WIDTH; // To hold full intermediate product

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
                    // Compute t = floor(x * MU >> 2K)
                    if (SIGNED_INPUT)
                        t <= ($signed(sx) * MU) >> (2*K);
                    else
                        t <= (ux * MU) >> (2*K);
                    state <= FINAL;
                end

                FINAL: begin
                    // r = x - t * Q
                    if (SIGNED_INPUT)
                        r = sx - t * Q;
                    else
                        r = ux - t * Q;

                    // Correct r into [0, Q-1]
                    if ($signed(r) < 0)
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





//module mod_q #(
//    parameter COEFF_WIDTH = 12,
//    parameter B_WIDTH = 5,
//    parameter Q = 23
//)(
//    input  signed [COEFF_WIDTH+B_WIDTH:0] value_in,
//    output reg signed [$clog2(Q)-1:0] value_out
//);

//    reg signed [$clog2(Q)-1:0] residue;

//    always @(*) begin
//        residue = value_in % Q;  // Compute residue once
//        value_out = (residue < 0) ? residue + Q : residue;  // Adjust if negative
//    end

//endmodule