`timescale 1ns / 1ps

module HazardDetectionUnit(
        wire [4:0] IF_ID_Rs1,
        wire [4:0] IF_ID_Rs2,
        wire [4:0] ID_EX_Rd,
        wire ID_EX_MemRead,
        output reg stall
    );
    
    always @(*) begin 
        if((IF_ID_Rs1 == ID_EX_Rd || IF_ID_Rs2 == ID_EX_Rd) && ID_EX_MemRead && ID_EX_Rd != 0) 
            stall = 0;
        else 
            stall = 1;
    end
endmodule
