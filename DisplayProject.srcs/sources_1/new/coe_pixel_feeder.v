`timescale 1ns / 1ps

module coe_pixel_feeder(
    input wire clk,             // Clock input
    input wire reset,           // Reset input
    input wire enable,          // Enable signal
    input wire [17:0] addr_in,  // Address input from pixel_pusher
    output reg [7:0] pixel_out  // Pixel data output
);
    // BRAM: Memory to hold COE data (512x8 for this example)
    blk_mem_gen_0 bram (
      .clka(clk),    // input wire clka
      .addra(addr_in),  // input wire [17 : 0] addra
      .douta(pixel_out)  // output wire [7 : 0] douta
    );
    // Initialize BRAM with COE data
    initial begin
        $readmemb("pixel_data.coe", bram); // Reads data from COE file
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            pixel_out <= 8'b0;  // Reset output pixel data
        end else if (enable) begin
            pixel_out <= bram[addr_in]; // Read pixel data from BRAM
        end
    end
endmodule
