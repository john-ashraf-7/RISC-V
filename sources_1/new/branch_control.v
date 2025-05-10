`timescale 1ns / 1ps

`include "defines.v"


module branch_control(input [1:0] branchOp, 
                        input [2:0] funct3, 
                        input zf, 
                        input cf, 
                        input sf, 
                        input vf, 
                        output reg [1:0] PCSrc);
always@(*) begin
  case(branchOp)
    2'b00: PCSrc = 2'b00; //No branching
    2'b01: begin //If branch: PC = PC + Imm , Else: PC = PC + 4
      case(funct3)
        `BR_BEQ:PCSrc = (zf == 1) ? 2'b01 : 2'b00;
        `BR_BNE:PCSrc = (zf == 0) ? 2'b01 : 2'b00;
        `BR_BLT:PCSrc = (sf != vf) ? 2'b01 : 2'b00;
        `BR_BGE:PCSrc = (sf == vf) ? 2'b01 : 2'b00;
        `BR_BLTU:PCSrc = (cf == 0) ? 2'b01 : 2'b00;
        `BR_BGEU:PCSrc = (cf == 1) ? 2'b01 : 2'b00;
      endcase
    end
    2'b10: PCSrc = 2'b01; //JAL (PC = PC + Imm) //to be understood TODO I the control unit is not yet cabable of producing 10 in branchOp
    2'b11: PCSrc = 2'b10; //JALR (PC = ALU_Result) //to be understood TODO
  
  endcase
end
endmodule
