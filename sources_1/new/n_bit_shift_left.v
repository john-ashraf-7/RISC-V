`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/20/2024 10:31:07 AM
// Design Name: 
// Module Name: n_bit_shift_left
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


//module  n_bit_shift_left #(parameter N = 4)(
//    input clk,
//    input rst,  //reset all to zero asynchronously
//    input load, //when 1 (and shift = 0) all stages load from input
//    input shift, //when 1 shift is enabled (second priority after rst)
//    input [7:0] D,
//    output reg [7:0] Q,
//    input A //input value to be shifted into first stage
//    );
    
//    always @(posedge clk) begin
    
//        if (rst)
//            Q <= 8'b00000000;
            
//        if (shift) begin
//            //shift mechanism
//            Q <= {D[6:0], A};
//        end else begin
//            if(load) begin
//                Q <= D;
//            end
//        end
        
//    end
//endmodule

module  n_bit_shift_left #(parameter N = 32)(
    input [N-1:0] D,
    output [N-1:0] Q
    );
    
    assign Q = {D[N-2: 0], 1'b0};
endmodule