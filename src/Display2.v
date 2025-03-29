`timescale 1ns / 1ps

module Display2(
    input clk,
    input reset,
    input enable,
    output reg [9:0] hcount,
    output reg [9:0] vcount,
    output reg vid,
    output reg hs,
    output reg vs
    );
   
    parameter H_MAX = 799;
    parameter V_MAX = 524;
    parameter H_DISPLAY = 639;
    parameter V_DISPLAY = 479;
    parameter HS_START = 656;
    parameter HS_END = 751;
    parameter VS_START = 490;
    parameter VS_END = 491;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Reset all signals
            hcount <= 0;
            vcount <= 0;
            vid <= 0;
            hs <= 1;
            vs <= 1;
        end else if (enable) begin
            // Horizontal Counter
            if (hcount == H_MAX) begin
                hcount <= 0; // Reset horizontal counter
                // Vertical Counter
                if (vcount == V_MAX) begin
                    vcount <= 0; // Reset vertical counter
                end else begin
                    vcount <= vcount + 1; // Increment vertical counter
                end
            end else begin
                hcount <= hcount + 1; // Increment horizontal counter
            end

            // Video Signal (Display ON/OFF)
            vid <= (hcount <= H_DISPLAY && vcount <= V_DISPLAY) ? 1 : 0;

            // Horizontal Sync Signal
            hs <= (hcount >= HS_START && hcount <= HS_END) ? 0 : 1;

            // Vertical Sync Signal
            vs <= (vcount >= VS_START && vcount <= VS_END) ? 0 : 1;
        end
    end
endmodule
