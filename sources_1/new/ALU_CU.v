`timescale 1ns / 1ps

`include "defines.v"

    
module ALU_CU(input [3:0] ALUOp, 
                        input [2:0] funct3, 
                        input bit_30, 
                        output reg [4:0] ALU_selection);
    always @(*) begin
    if(ALUOp == 4'b0000) //R-Format instructions.
      begin
        case(funct3)
          `F3_OR: ALU_selection = `ALU_OR;
          `F3_AND: ALU_selection = `ALU_AND;
          `F3_XOR: ALU_selection = `ALU_XOR;
          `F3_ADD: 
            begin
              if(bit_30 == 0)
                ALU_selection = `ALU_ADD;
              else
                ALU_selection = `ALU_SUB;
            end
          `F3_SLT: ALU_selection = `ALU_SLT;
          `F3_SLL: ALU_selection = `ALU_SLL;
          `F3_SLTU: ALU_selection = `ALU_SLTU;
          `F3_SRL: 
            begin
              if(bit_30 == 0)
                ALU_selection = `ALU_SRL;
              else
                ALU_selection = `ALU_SRA;
            end
        endcase
      end
    else if(ALUOp == 4'b0001) //I-Format Instructions
      begin
        case(funct3)
          `F3_ADD: ALU_selection = `ALU_ADD;
          `F3_OR: ALU_selection = `ALU_OR;
          `F3_AND: ALU_selection = `ALU_AND;
          `F3_XOR: ALU_selection = `ALU_XOR;
          `F3_SLT: ALU_selection = `ALU_SLT;
          `F3_SLTU: ALU_selection = `ALU_SLTU;
          `F3_SLL: ALU_selection = `ALU_SLL;
          `F3_SRL: 
            begin
              if(bit_30 == 0)
                ALU_selection = `ALU_SRL;
              else
                ALU_selection = `ALU_SRA;
            end
        endcase
      end
    else if (ALUOp==4'b1001)
      begin
      $display("encountered an m instruction"); //for debugging
        case(funct3)
          `F3_MUL: ALU_selection = `ALU_MUL;
          `F3_MULH: ALU_selection = `ALU_MULH;
          `F3_MULHSU: ALU_selection = `ALU_MULHSU;
          `F3_MULHU: ALU_selection = `ALU_MULHU;
          `F3_DIV: ALU_selection = `ALU_DIV;
          `F3_DIVU: ALU_selection = `ALU_DIVU;
          `F3_REM: ALU_selection = `ALU_REM;
          `F3_REMU: ALU_selection = `ALU_REMU;
          endcase
      end
    else if(ALUOp == 4'b0010) //Branching
      ALU_selection = `ALU_SUB;
    else if(ALUOp == 4'b0011) //Load
      ALU_selection = `ALU_ADD;
    else if(ALUOp == 4'b0100) //Store
      ALU_selection = `ALU_ADD;
  
    else if(ALUOp == 4'b0111) //AUIPC
      ALU_selection = `ALU_AUIPC;
    else if(ALUOp == 4'b1000) //LUI
      ALU_selection = `ALU_LUI;
    else if(ALUOp == 4'b0101) //JALR
      ALU_selection = `ALU_ADD;
    else if(ALUOp == 4'b0110) //JAL
      ALU_selection = `ALU_ADD;
    end
endmodule