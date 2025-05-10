`timescale 1ns / 1ps

module RISC_V_pipelined_tb;

// Inputs
reg clk;
reg rst;


// Clock generation
always #50 clk = ~clk; // 50MHz Clock

// Instantiate the Unit Under Test (UUT)
RISC_V_pipelined uut (
    .clk(clk), 
    .rst(rst) 
);

//block for testing using scopes and objects only
initial begin
        // Initialize Inputs
    clk = 1;
    rst = 1;
    #100
    rst = 0;
end


endmodule


