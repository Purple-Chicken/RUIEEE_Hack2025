`timescale 1ns / 1ps

module Display2_tb;

    // Testbench signals
    reg clk;
    reg reset;
    reg enable;
    wire [9:0] hcount;
    wire [9:0] vcount;
    wire vid;
    wire hs;
    wire vs;

    // Instantiate the Display2 module
    Display2 uut (
        .clk(clk),
        .reset(reset),
        .enable(enable),
        .hcount(hcount),
        .vcount(vcount),
        .vid(vid),
        .hs(hs),
        .vs(vs)
    );

    // Generate a clock signal (50 MHz, period = 20 ns)
    initial begin
        clk = 0;
        forever #10 clk = ~clk; // Toggle clock every 10 ns
    end

    // Test sequence
    initial begin
        // Initialize signals
        reset = 1; // Assert reset
        enable = 0;

        #100 reset = 0; // Deassert reset
        enable = 1; // Enable the counters

        // Simulate for a sufficient duration to observe the behavior
        #1000000;

        // Disable the counters
        enable = 0;

        // Finish simulation
        #1000;
        $stop;
    end
endmodule
