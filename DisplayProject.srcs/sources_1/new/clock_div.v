`timescale 1ns / 1ps

module clock_div (
    input wire clk_in,      // Input clock (125 MHz)
    input wire reset,       // Reset signal
    output reg clk_out_en   // Output clock enable (25 MHz)
);

    reg [2:0] counter = 3'b000; // 3-bit counter to divide by 5

    always @(posedge clk_in or posedge reset) begin
        if (reset) begin
            counter <= 3'b000;
            clk_out_en <= 0;
        end else begin
            if (counter == 4) begin
                counter <= 3'b000;
                clk_out_en <= 1;  // Generate a pulse every 5 cycles
            end else begin
                counter <= counter + 1;
                clk_out_en <= 0;
            end
        end
    end
endmodule
