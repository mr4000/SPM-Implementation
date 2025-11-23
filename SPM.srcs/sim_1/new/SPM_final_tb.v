`timescale 1ns / 1ps

module tb_poly_multiplier();

    // Parameters
    parameter Q = 4096;  // Test with your modulus value
    parameter COEFF_BITS = $clog2(Q);

    // Clock and reset
    reg clk = 0;
    reg reset = 1;
    
    // Testbench control
    reg start = 0;
    wire done;
    
    // Device outputs
    wire [COEFF_BITS-1:0] c_data;
    wire [2:0] c_index;
    wire c_valid;
    
    // Captured coefficients
    reg [COEFF_BITS-1:0] c0, c1, c2, c3, c4, c5, c6, c7;
    
    // Clock generation
    always #5 clk = ~clk;
    
    // Instantiate DUT
    poly_multiplier #(
        .Q(Q)
    ) dut (
        .clk(clk),
        .reset(reset),
        .start(start),
        .done(done),
        .c_data(c_data),
        .c_index(c_index),
        .c_valid(c_valid)
    );
    
    // Capture coefficients
    always @(posedge clk) begin
        if (c_valid) begin
            case (c_index)
                0: c0 <= c_data;
                1: c1 <= c_data;
                2: c2 <= c_data;
                3: c3 <= c_data;
                4: c4 <= c_data;
                5: c5 <= c_data;
                6: c6 <= c_data;
                7: c7 <= c_data;
            endcase
        end
    end
    
    // Test sequence
    initial begin
        // Initialize
        reset = 1;
        #100;
        reset = 0;
        #100;
        
        // Start computation
        start = 1;
        #10;
        start = 0;
        
        // Wait for computation to complete
        wait(done);
        $display("Computation completed at time %0t", $time);
        
        // Monitor output coefficients
        $display("Waiting for coefficients...");
        
        // Wait for all coefficients to be output at least once
        wait(c_valid && c_index == 7);
        #100;
        
        // Display results
        $display("Final Coefficients:");
        $display("c0 = %d", c0);
        $display("c1 = %d", c1);
        $display("c2 = %d", c2);
        $display("c3 = %d", c3);
        $display("c4 = %d", c4);
        $display("c5 = %d", c5);
        $display("c6 = %d", c6);
        $display("c7 = %d", c7);
        
        // Verify coefficients are within modulus
        if (c0 < Q && c1 < Q && c2 < Q && c3 < Q && 
            c4 < Q && c5 < Q && c6 < Q && c7 < Q) begin
            $display("All coefficients are valid (0 <= c < Q)");
        end else begin
            $display("Error: Some coefficients exceed modulus Q");
        end
        
        // End simulation
        #100;
        $finish;
    end
    
    // Monitor outputs
    always @(posedge clk) begin
        if (c_valid) begin
            $display("Time %0t: Output c%d = %d", $time, c_index, c_data);
        end
    end

endmodule