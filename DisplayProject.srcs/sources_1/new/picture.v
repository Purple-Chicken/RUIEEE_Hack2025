// Picture Memory Interface Module
module picture(
    input clk,                // Clock input
    input [17:0] addr,        // Address input
    output [7:0] pixel         // Data output
);
    blk_mem_gen_0 inst (
        .clka(clk),    // Connect the clock
        .addra(addr),  // Connect the address
        .douta(dout)   // Connect the data output
    );
endmodule