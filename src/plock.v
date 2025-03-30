`timescale 1ns / 1ps

module topDisplay_tb; // Testbench for the topDisplay module

    // Testbench signals
    reg clk;                        // Clock signal
    reg reset;                      // Reset signal
    wire TMDS_Clk_p;                // TMDS Clock (Positive HDMI)
    wire TMDS_Clk_n;                // TMDS Clock (Negative HDMI)
    wire [2:0] TMDS_Data_p;         // TMDS data positive differential signals
    wire [2:0] TMDS_Data_n;         // TMDS data negative differential signals

    // Instantiate the Device Under Test (DUT)
    topDisplay dut (
        .clk(clk),
        .reset(reset),
        .TMDS_Clk_p(TMDS_Clk_p),
        .TMDS_Clk_n(TMDS_Clk_n),
        .TMDS_Data_p(TMDS_Data_p),
        .TMDS_Data_n(TMDS_Data_n)
    );

    // Clock generation (125 MHz -> 8 ns period)
    initial begin
        clk = 0;
        forever #4 clk = ~clk; // Toggle clock every 4 ns
    end

    // Testbench logic
    initial begin
        // Apply Reset
        reset = 1;        // Assert reset
        #20 reset = 0;    // Deassert reset after 20 ns
        
        // Run simulation for some time
        #100000;          // Simulate for 100 µs

        // End simulation
        $stop;
    end

    // Monitor Outputs
    initial begin
        $monitor("Time: %0dns, TMDS_Clk_p: %b, TMDS_Clk_n: %b, TMDS_Data_p: %b, TMDS_Data_n: %b",
                 $time, TMDS_Clk_p, TMDS_Clk_n, TMDS_Data_p, TMDS_Data_n);
    end

endmodule
