`timescale 1ns / 1ps

module pixel_pusher(
    input clk,               // Clock input
    input enable,            // Enable signal
    input vs,                // Vertical sync signal
    input [7:0] pixel,       // Input pixel data
    input [9:0] hcount,      // Horizontal counter
    input vid,               // Video enable signal
    output reg [7:0] R,      // Red channel output
    output reg [7:0] B,      // Blue channel output
    output reg [7:0] G,      // Green channel output
    output reg [17:0] addr   // Image address
);

    always @(posedge clk) begin
        if (vs == 0) begin
            addr <= 0; // Reset the address counter when vs is low
        end else if (enable && vid && hcount < 480) begin
            addr <= addr + 1; // Increment address when conditions are met
        end
    end

    always @(posedge clk) begin
        if (enable && vid && hcount < 480) begin
            R <= {pixel[7:5], 5'b00000};   // Extend and map pixel's Red channel
            G <= {pixel[4:2], 5'b00000};   // Extend and map pixel's Green channel
            B <= {pixel[1:0], 6'b000000};  // Extend and map pixel's Blue channel
        end else begin
            R <= 0; // Default to 0 when conditions aren't met
            G <= 0;
            B <= 0;
        end
    end
endmodule
