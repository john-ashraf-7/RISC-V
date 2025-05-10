`timescale 1ns / 1ps

//module RISC_V(
//    input  clk, //connected to a push button
//    input rst,  //connected to a push button (initialize pc and RF to zeros)
//    input [1:0] ledSel,// Select infomration displayed on leds (instructions, control signals)
//    input [3:0] ssdSel,// Select info displayed on SSD (PC, rs1, rs2, imm, etc..)
//    input ssd_clk, //connected to pin E3
//    output reg [15:0] LEDs,
//    output reg [12:0] ssd
//    );
    
//module Four_Digit_Seven_Segment_Driver_Optimized(
//    input clk,
//    input [12:0] num, 
//    output reg [3:0] Anode, 
//    output reg [6:0] LED_out
//    );

module RISCV_SSD_Top(
    input clk_push_button,
    input rst,
    input ssd_clk,
    input [1:0] ledSel,
    input [3:0] ssdSel,
    output [3:0] Anode,
    output [15:0] LEDs,
    output [6:0] LED_out
    );
    //Declaring some wires
    wire [12:0] number;
    
    RISC_V_pipelined risc_v(.clk(clk_push_button),
                  .rst(rst),
                  .ledSel(ledSel),
                  .ssdSel(ssdSel),
                   //why even passing ssd_clk to RISC_V
                  .LEDs(LEDs),
                  .ssd(number)
                  );
    Four_Digit_Seven_Segment_Driver_Optimized ssd(.clk(ssd_clk),
                                                  .num(number),
                                                  .Anode(Anode),
                                                  .LED_out(LED_out));
endmodule
