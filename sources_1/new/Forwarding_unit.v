`timescale 1ns / 1ps


//module Forwarding_unit(
//    input [4:0] ID_EX_RegisterRs1,
//    input [4:0] ID_EX_RegisterRs2,
//    input [4:0] EX_MEM_RegisterRd,
//    input [4:0] MEM_WB_RegisterRd,
    
//    input EX_MEM_RegWrite,
//    input MEM_WB_RegWrite,
    
//    output reg [1:0] ForwardA,
//    output reg [1:0] ForwardB
//    );
    
//    always @(EX_MEM_RegWrite or EX_MEM_RegisterRd or ID_EX_RegisterRs1 or ID_EX_RegisterRs2 or
//             MEM_WB_RegWrite or MEM_WB_RegisterRd) begin
//        // Initialize ForwardA and ForwardB to zero
//        ForwardA <= 2'b00;
//        ForwardB <= 2'b00;
    
//        // Forwarding logic for ForwardA
//        if (EX_MEM_RegWrite && (EX_MEM_RegisterRd != 0) && (EX_MEM_RegisterRd == ID_EX_RegisterRs1)) begin
//            ForwardA = 2'b10;
//        end else if (MEM_WB_RegWrite && (MEM_WB_RegisterRd != 0) && 
//                     !(EX_MEM_RegWrite && (EX_MEM_RegisterRd != 0) && (EX_MEM_RegisterRd == ID_EX_RegisterRs1)) && 
//                     (MEM_WB_RegisterRd == ID_EX_RegisterRs1)) begin
//            ForwardA <= 2'b01;
//        end
    
//        // Forwarding logic for ForwardB
//        if (EX_MEM_RegWrite && (EX_MEM_RegisterRd != 0) && (EX_MEM_RegisterRd == ID_EX_RegisterRs2)) begin
//            ForwardB <= 2'b10;
//        end else if (MEM_WB_RegWrite && (MEM_WB_RegisterRd != 0) && 
//                     !(EX_MEM_RegWrite && (EX_MEM_RegisterRd != 0) && (EX_MEM_RegisterRd == ID_EX_RegisterRs2)) && 
//                     (MEM_WB_RegisterRd == ID_EX_RegisterRs2)) begin
//            ForwardB <= 2'b01;
//        end
//    end

//endmodule

module Forwarding_unit(
        input [4:0] ID_EX_RegisterRs1,
        input [4:0] ID_EX_RegisterRs2,
        input [4:0] EX_MEM_RegisterRd,
        input [4:0] MEM_WB_RegisterRd,
        input EX_MEM_RegWrite,
        input MEM_WB_RegWrite,
        output reg [1:0] ForwardA,
        output reg [1:0] ForwardB
    );
    
    always @(*) begin
        if((EX_MEM_RegWrite == 1'b1) && ( EX_MEM_RegisterRd != 0) && (ID_EX_RegisterRs1 == EX_MEM_RegisterRd))
            ForwardA = 2'b10;
        else if ((MEM_WB_RegWrite == 1'b1) && ( MEM_WB_RegisterRd != 0) && (ID_EX_RegisterRs1 == MEM_WB_RegisterRd))
            ForwardA = 2'b01;
        else ForwardA = 2'b00;
        
        if((EX_MEM_RegWrite == 1'b1) && ( EX_MEM_RegisterRd != 0) && (ID_EX_RegisterRs2 == EX_MEM_RegisterRd))
            ForwardB = 2'b10;
        else if ((MEM_WB_RegWrite == 1'b1) && ( MEM_WB_RegisterRd != 0) && (ID_EX_RegisterRs2 == MEM_WB_RegisterRd))
            ForwardB = 2'b01;
        else ForwardB = 2'b00;
    
    end
  
endmodule
