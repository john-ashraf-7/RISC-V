`timescale 1ns / 1ps

//module MUX(
//    input a,//input 0
//    input b,//input 1
//    input s,//selection
//    output o //output
//    );
    
//    assign o = (s)? a: b;
//endmodule

//module RippleCarryAdder #(parameter N = 4)( // Change N to your desired bit width
//    input [N-1:0] A,
//    input [N-1:0] B,
//    input cin,
//    output [N-1:0] Sum,
//    output cout
//);

//module n_bit_2_x_1_MUX #(N = 4)(//TODO potential error
//    input [N-1:0] a,
//    input [N-1:0] b,
//    input s,
//    output [N-1:0] o
//    );
    
module N_bit_ALU #(parameter N = 32)( //refactor later to delete some wires
    input [N-1:0] A,
    input [N-1:0] B,
    input [4:0] sel,
    output reg [N-1:0] ALU_output,
    output ZeroFlag,
    output NegativeFlag,
    output OverflowFlag,
    output CarryFlag
    );
    
    wire [31:0] add, sub, not_B;
    assign not_B = (~B);
    assign {CarryFlag, add} = sel[0]? (A + not_B + 1'b1): (A + B); //when sel[2] = 1 then operation is subtraction

    assign ZeroFlag = (ALU_output == 0);
    assign NegativeFlag = add[31]; //determines whether the ALU ouptu is negative
    assign OverflowFlag = (A[31] ^ (not_B[31]) ^ add[31] ^ CarryFlag);
            

    wire [4:0] shift_amount = B[N-1:0] > N-1 ? N-1 : B[4:0];
              
   // MUX 16 * 1
   always @(*) begin
       case(sel)
           5'b00000: ALU_output = add;
           5'b00001: ALU_output = add;
           5'b00101: ALU_output = A & B;
           5'b00100: ALU_output = A | B;
           5'b00111: ALU_output = A ^ B;
           
           //mul
           `ALU_MUL   :ALU_output = $signed(A) * $signed(B); // MUL                                
           `ALU_MULH  :ALU_output = ($signed(A) * $signed(B)) >>> 32; // MULH                       
           `ALU_MULHSU:ALU_output = ($signed(A) * $unsigned(B)) >>> 32; // MULHSU                   
           `ALU_MULHU :ALU_output = ($unsigned(A) * $unsigned(B)) >>> 32; // MULHU                  
           `ALU_DIV   :ALU_output = (B != 0) ? $signed(A) / $signed(B) : 32'hFFFFFFFF; // DIV       
           `ALU_DIVU  :ALU_output = (B != 0) ? $unsigned(A) / $unsigned(B) : 32'hFFFFFFFF; // DIVU  
           `ALU_REM   :ALU_output = (B != 0) ? $signed(A) % $signed(B) : A; // REM                  
           `ALU_REMU  :ALU_output = (B != 0) ? $unsigned(A) % $unsigned(B) : A; // REMU             
           
           //LUI and AUIPC
            `ALU_LUI   :ALU_output = B; // Loads immediate value into upper 20 bits. (B << 12 is done outside of ALU) 
//            `ALU_AUIPC :ALU_output = ; !!!!!!!!!!!

           5'b01000: ALU_output = A >> shift_amount;
           5'b01001: ALU_output = A << shift_amount;
           5'b01010: ALU_output = ($signed(A) >>> shift_amount); 
            
           5'b01101: ALU_output = {31'b0,(NegativeFlag != OverflowFlag)}; //SLT: to be understood
           5'b01111: ALU_output = {31'b0,(~CarryFlag)};
             
           5'b01011: ALU_output = B;
           default: ALU_output = 0;//
       endcase
   end
     
endmodule
