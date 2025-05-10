`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/05/2024 09:17:58 AM
// Design Name: 
// Module Name: DataMem
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

`include "defines.v" 

module DataMem(
    input clk, 
    input MemRead, 
    input MemWrite,
    input [7:0] addr, //address of byte
    input [31:0] data_in,
    input [2:0] funct3, 
    output reg [31:0] data_out);
    
    reg [7:0] mem [0:255];//Memory is consistent of 256 byte
    
    //initialize the data memory
    initial begin
//initialization from lab 7
//        mem[0] = 32'd17;
//        mem[1] = 32'd9;
//        mem[2] = 32'd25;
        {mem[3], mem[2], mem[1], mem[0]} = 32'd17;
        {mem[7], mem[6], mem[5], mem[4]} = 32'd9;
        {mem[11], mem[10], mem[9], mem[8]} = 32'd25;


//          {mem[3], mem[2], mem[1], mem[0]} = 32'h12345678;
//          {mem[7], mem[6], mem[5], mem[4]} = 32'h87654321;
//          {mem[11], mem[10], mem[9], mem[8]} = 32'hFFFFFFFF;
//          {mem[15], mem[14], mem[13], mem[12]} = 32'h0000007F;
//          {mem[19], mem[18], mem[17], mem[16]} = 32'h00007FFF;

//        mem[0] = 32'd3;
//        mem[1] = 32'd4;
//        mem[2] = 32'd3; //value of loop iterator at the beginning
//        mem[3] = -1; //to be added to loop iterator each iteration till equal zero
    end
    
    always @(posedge clk) begin
        if (MemWrite) begin
            // Write data to memory at the specified address
            case(funct3) 
              `F3_SB: mem[addr] = data_in[7:0];
              `F3_SH: 
                  begin 
                    mem[addr] = data_in[7:0];
                    mem[addr+1] = data_in[15:8];
                  end
              `F3_SW:
                   begin 
                    mem[addr] = data_in[7:0];
                    mem[addr+1] = data_in[15:8];
                    mem[addr+2] = data_in[23:15];
                    mem[addr+3] = data_in[31:24];
                   end
            endcase
        end
    end
    
    always @(*) begin
         if (MemRead) begin
        // Read data from memory at the specified byte according to funct 3
        begin
            case(funct3)
//              3'b011://ld; 
//              3'b110://lwu;
                `F3_LB: data_out <= {{24{mem[addr][7]}},mem[addr]};                 //lb
                `F3_LH: data_out <= {{16{mem[addr+1][7]}},mem[addr+1],mem[addr]};   //lh       Not working - visited, it seems to work just fin 4-10-2024
                `F3_LW: data_out <= {mem[addr+3],mem[addr+2],mem[addr+1],mem[addr]};//lw         
                `F3_LBU: data_out <= {24'd0,mem[addr]};                              //lbu
                `F3_LHU: data_out <= {16'd0,mem[addr+1],mem[addr]};                //lhu
                default: data_out <= 0;
            endcase 
        end
    end
    
    end
    
endmodule 
