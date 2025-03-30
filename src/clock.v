`timescale 1ns / 1ps

module topDisplay(
    input clk,                // Input base clock (125 MHz)
    input reset,              // Reset signal
    output TMDS_Clk_p,        // TMDS Clock (Positive HDMI)
    output TMDS_Clk_n,        // TMDS Clock (Negative HDMI)
    output [2:0] TMDS_Data_p, // TMDS Data Channels (Positive HDMI)
    output [2:0] TMDS_Data_n  // TMDS Data Channels (Negative HDMI)
);

    // Internal signals
    wire PixelClk;              // Pixel clock (25 MHz)
    wire [9:0] hcount, vcount;  // Horizontal and vertical counters
    wire vid;                   // Video enable signal
    wire hs, vs;                // Internal VGA sync signals
    wire [17:0] addr;           // Address for pixel fetching
    wire [7:0] R, G, B;         // Resized RGB signals
    wire [7:0] pixel = 8'b11111111; // Hardcoded pixel data for testing

    // Clock Divider: Generate Pixel Clock
    clock_div clk_div_inst (
        .clk_in(clk),
        .reset(reset),
        .clk_out_en(PixelClk) // Pixel Clock output (25 MHz)
    );

    // VGA Controller: Generates sync signals and video enable
    vga_ctrl vga_ctrl_inst (
        .clk(PixelClk),
        .reset(reset),
        .enable(1'b1),
        .hcount(hcount),
        .vcount(vcount),
        .vid(vid),
        .hs(hs),
        .vs(vs)
    );

    // Pixel Pusher: Processes pixel data to produce 8-bit RGB
    pixel_pusher pixel_pusher_inst (
        .clk(PixelClk),
        .enable(1'b1),
        .vs(vs),
        .pixel(pixel),
        .hcount(hcount),
        .vid(vid),
        .R(R),
        .G(G),
        .B(B),
        .addr(addr)
    );

    // HDMI Encoder: Converts VGA signals to HDMI TMDS
    rgb2dvi_0 rgb2dvi_inst (
        .PixelClk(PixelClk),
        .SerialClk(clk),
        .vid_pData({R, G, B}),
        .aRst(reset),
        .vid_pHSync(hs),
        .vid_pVSync(vs),
        .vid_pVDE(vid),
        .TMDS_Clk_p(TMDS_Clk_p),
        .TMDS_Clk_n(TMDS_Clk_n),
        .TMDS_Data_p(TMDS_Data_p),
        .TMDS_Data_n(TMDS_Data_n)
    );

endmodule
