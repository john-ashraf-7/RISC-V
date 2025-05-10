`timescale 1ns / 1ps

module Single_memory(input clk, input MemRead,input [2:0]func3, input MemWrite,input [7:0] addr,input [31:0] data_in, output reg [31:0] data_out);

     reg [7:0] mem [0:4*1024-1]; //256 for instructions and the rest for data
     localparam [8:0] pointer = 256; // 100000000    //  points to the first row reserved for data
     wire [8:0] data_address;
     assign data_address = addr + pointer;    // 8 bits + 9 bits = 9 bits
     
     // for reading
     always @(*)begin 
         if(clk == 1)  // there is no need to test whtether MemRead == 1 as we will not write instructions and we are always reading instructions to the memory
             data_out = {mem[addr+3],mem[addr+2],mem[addr+1],mem[addr]};  // read instriction
         else begin
            if(MemRead == 1) 
                    begin 
                      case(func3) 
                          3'b000: data_out <= {{24{mem[data_address][7]}},mem[data_address]};//lb
                          3'b001: data_out <= {{16{mem[data_address+1][7]}},mem[data_address+1],mem[data_address]};//lh       
                          3'b010: data_out <= {mem[data_address+3],mem[data_address+2],mem[data_address+1],mem[data_address]};//lw         
                          3'b100: data_out <= {24'd0,mem[data_address]};//lbu
                          3'b101: data_out <= {16'd0,mem[data_address+1],mem[data_address]};//lhu
                          default: data_out <= 0;
                      endcase
                    end
                  else data_out <= 0 ;
         end
     end
     
     // for data writing
     always @(posedge clk)begin 
         if(MemWrite==1)
             case(func3) 
                   3'b000: mem[data_address] = data_in[7:0]; //sb
                   3'b001: 
                       begin 
                       {mem[data_address+1],mem[data_address]} = {data_in[15:8],data_in[7:0]};
                       end
                   3'b010:
                        begin 
                         {mem[data_address+3],mem[data_address+2],mem[data_address+1],mem[data_address]} = {data_in[31:24],data_in[23:15],data_in[15:8],data_in[7:0]};
                        end
             endcase
     end
     
     initial begin
     //instructions block
// Initialize instructions in memory for a RISC-V processor
     // {mem[high], mem[high-1], mem[low+1], mem[low]} = 32-bit Instruction
//    {mem[3],mem[2],mem[1],mem[0]} = 32'b0000000_00000_00000_000_00000_0110011; // add x0, x0, x0          0  
//     {mem[7], mem[6], mem[5], mem[4]} = 32'b00000000000000011111000010110111; // lui x1, 31
//     {mem[11], mem[10], mem[9], mem[8]} = 32'b00000000000000010000000100010111; // auipc x2, 16
//     {mem[15], mem[14], mem[13], mem[12]} = 32'b00000001000000000000000111101111; // jal x3, 16
//     {mem[19], mem[18], mem[17], mem[16]} = 32'b00000000011000101000001010110011; // add x5, x5, x6
//     {mem[23], mem[22], mem[21], mem[20]} = 32'b01000000010000101000001010110011; // sub x5, x5, x4
//     {mem[27], mem[26], mem[25], mem[24]} = 32'b00000000000000011000001101100111; // jalr x6, x3, 0
//     {mem[31], mem[30], mem[29], mem[28]} = 32'b00000010001000001000001000110011; // mul x4, x1, x2
//     {mem[35], mem[34], mem[33], mem[32]} = 32'b00000010000100100100001010110011; // div x5, x4, x1
//     {mem[39], mem[38], mem[37], mem[36]} = 32'b00000010000100100110001100110011; // rem x6, x4, x1
//     {mem[43], mem[42], mem[41], mem[40]} = 32'b00000010000100100110001100110011; // jalr x7, x3, 0

 //Instructions block
         //initializations
         {mem[3],mem[2],mem[1],mem[0]}    =32'b00000000010100000000000010010011; //addi x1, x0, 5 (shouldnt be shown cuz of reset)          
         {mem[7],mem[6],mem[5],mem[4]}    =32'b00000000010100000000000110010011; //addi x3, x0, 5                                           
         {mem[11],mem[10],mem[9],mem[8]}  =32'b11111111000000000000001000010011; //addi x4, x0, -16                                  
         {mem[15],mem[14],mem[13],mem[12]}=32'b00000010000000000000001010010011; //addi x5, x0, 32                                   
         {mem[19],mem[18],mem[17],mem[16]}=32'b00000000001000000000001100010011; //addi x6, x0, 2
          
         //arithmetics
//         {mem[23],mem[22],mem[21],mem[20]}=32'b00000000000000000010001100000011; //lw x6, 0(x0)
                  
//         {mem[23],mem[22],mem[21],mem[20]}=32'b00000000010100011000000100110011; //add x2, x3, x5 
         {mem[27],mem[26],mem[25],mem[24]}=32'b01000000011000011000001110110011; //sub x7, x3, x6  
         {mem[31],mem[30],mem[29],mem[28]}=32'b00000000011000011111000010110011; //and x8, x3, x6  
         {mem[35],mem[34],mem[33],mem[32]}=32'b00000000001100011111010010010011; //andi x9, x3, 3  
         {mem[39],mem[38],mem[37],mem[36]}=32'b00000000011000011110010100110011; //or x10, x3, x6  
         {mem[43],mem[42],mem[41],mem[40]}=32'b00000000001100011110010110010011; //ori x11, x3, 3 
         {mem[47],mem[46],mem[45],mem[44]}=32'b00000000011000011100011000110011; //xor x12, x3, x6
         {mem[51],mem[50],mem[49],mem[48]}=32'b00000000001100011100011010010011; //xori x13, x3, 3
         
         //shifting
         {mem[55],mem[54],mem[53],mem[52]}=32'b00000000001100110001011100110011; // sll x14, x6, x3     
         {mem[59],mem[58],mem[57],mem[56]}=32'b00000000010100110001011110010011; // slli x15, x6, 5     
         {mem[63],mem[62],mem[61],mem[60]}=32'b00000000011000101101100000110011; // srl x16, x5, x6     
         {mem[67],mem[66],mem[65],mem[64]}=32'b00000000001000101101100010010011; // srli x17, x5, 2              
         {mem[71],mem[70],mem[69],mem[68]}=32'b01000000011000100101100100110011; // sra x18, x4, x6     
//         {mem[75],mem[74],mem[73],mem[72]}=32'b01000000001000101101100110010011; // srai x19, x5, 2   
         {mem[75],mem[74],mem[73],mem[72]}=32'b01000000000100100101100110010011; // srai x19, x4, 1  //!!!!!!!!!!!!!!!!!!   
  
         
         //memory
         {mem[79],mem[78],mem[77],mem[76]}=32'b00000001100000000001010100000011; //lh x10, 24(x0) 
         {mem[83],mem[82],mem[81],mem[80]}=32'b00000000000000000000001110000011; //lb x7, 0(x0)  
         {mem[87],mem[86],mem[85],mem[84]}=32'b00000000000000000100101100000011; //lbu x22,0(x0) 
         {mem[91],mem[90],mem[89],mem[88]}=32'b00000000001100000010001000100011; //sw x3, 4(x0)  
         {mem[95],mem[94],mem[93],mem[92]}=32'b00000000001100000000100000100011; //sb x3, 16(x0) 
         {mem[99],mem[98],mem[97],mem[96]}=32'b00000000001100000001100000100011; //sh x3, 16(x0) 
         {mem[103],mem[102],mem[101],mem[100]}=32'b00000000010000000001100000100011; //sh x4, 16(x0) 

         //branching
         {mem[107],mem[106],mem[105],mem[104]}=32'b00000000010000000000000011101111; //jal x1, 4     !!!!!                                     
         {mem[111],mem[110],mem[109],mem[108]}=32'b00000011001000000000111110010011; //addi x31, x0, 50 //instruction to be skipped       
         {mem[115],mem[114],mem[113],mem[112]}=32'b00001001001000001000001011100111; //jalr x5, 146(x1) //loop testing                    

         //setting
//         {mem[115],mem[114],mem[113],mem[112]}=32'b00000000001100101010101000110011; //slt x20, x5, x3        
         {mem[119],mem[118],mem[117],mem[116]}=32'b00000001010000111010101010010011; //slti x21, x7, 20       
         {mem[123],mem[122],mem[121],mem[120]}=32'b00000000010000100011101000110011; //sltu x20, x4, x4       
         {mem[127],mem[126],mem[125],mem[124]}=32'b00000000001100100011101010010011; //sltiu x21, x4, 3       
         {mem[127],mem[126],mem[125],mem[124]}=32'b00000000001100100011101010010011; //sltiu x21, x4, 3       
//         {mem[131],mem[130],mem[129],mem[128]}=32'b00000000000000000100001010010111; //auipc x5, 4   //!!!!!!!!!!!!!       
                  
         //more cases
//         {mem[131],mem[130],mem[129],mem[128]}=32'b00000000010000000010001110000011; //lw x7, 4(x0)               
//         {mem[135],mem[134],mem[133],mem[132]}=32'b00000000010000011000010001100011; //beq x3, x4, 8    
//         {mem[139],mem[138],mem[137],mem[136]}=32'b00000010010000011100000001100011; //blt x3, x4, 32         
//         {mem[139],mem[138],mem[137],mem[136]}=32'b00000010010000011001000001100011; //bne x3, x4, 32             
//         {mem[143],mem[142],mem[141],mem[140]}=32'b00000000010000011100010001100011; //blt x3, x4, 8              
//         {mem[147],mem[146],mem[145],mem[144]}=32'b00000000010000011101010001100011; //bge x3, x4, 8              
//         {mem[151],mem[150],mem[149],mem[148]}=32'b00000000010000011110010001100011; //bltu x3, x4, 8             
//         {mem[155],mem[154],mem[153],mem[152]}=32'b00000000010000011111010001100011; //bgeu x3, x4, 8   
                   
                   
         //hazards testing
         {mem[131],mem[130],mem[129],mem[128]}=32'b00000000010000110000111100110011; //add x30, x6, x4 --> 1
         {mem[135],mem[134],mem[133],mem[132]}=32'b01000000001100110000111100110011; //sub x30, x6, x3 --> 12
         {mem[139],mem[138],mem[137],mem[136]}=32'b00000000001111110000111110110011; //add x31, x30, x3  --> 17
         
         //mul, div
         {mem[143],mem[142],mem[141],mem[140]}=32'b00000010001100110000010100110011; //mul x10, x6, x3   --> 85
         {mem[147],mem[146],mem[145],mem[144]}=32'b00000010001100101001010110110011; //mulh x11, x5, x3  --> -80 upper = -1
         {mem[151],mem[150],mem[149],mem[148]}=32'b00000010001100101010011000110011; //mulhsu x12, x5, x3  --> -80 upper = -1
         {mem[155],mem[154],mem[153],mem[152]}=32'b00000010011000011011011010110011; //mulhu x13, x3, x6  --> 85 upper = 0
         {mem[159],mem[158],mem[157],mem[156]}=32'b00000010001100110100011100110011; //div x14, x6, x3   --> 3
         {mem[163],mem[162],mem[161],mem[160]}=32'b00000010001100101101011110110011; //divu x15, x5, x3  --> 4294967280 / 5 = 858993456
         {mem[167],mem[166],mem[165],mem[164]}=32'b00000010001100110110100000110011; //rem x16, x6, x3   --> 2
         {mem[171],mem[170],mem[169],mem[168]}=32'b00000010001100101111100010110011; //remu x17, x5, x3  --> 4294967280 % 5 = 0
         {mem[175],mem[174],mem[173],mem[172]}=32'b00000000000000000111110010110111; //lui x25, 7


    
//         {mem[3],mem[2],mem[1],mem[0]}    =32'b0000000_00000_00000_000_00000_0110011 ; //add x0, x0, x0          0                   
//         {mem[7],mem[6],mem[5],mem[4]}    =32'b000000000000_00000_010_00001_0000011 ; //lw x1, 0(x0)             17                  
//         {mem[11],mem[10],mem[9],mem[8]}  =32'b000000000100_00000_010_00010_0000011 ; //lw x2, 4(x0)             9 
//         {mem[15],mem[14],mem[13],mem[12]}=32'b000000001000_00000_010_00011_0000011 ; //lw x3, 8(x0)             25
//         {mem[19],mem[18],mem[17],mem[16]}=32'b0000000_00010_00001_110_00100_0110011 ; //or x4, x1, x2           25
//         {mem[23],mem[22],mem[21],mem[20]}=32'b00000000001100100000010001100011; //beq x4, x3, 8
//         {mem[27],mem[26],mem[25],mem[24]}=32'b0000000_00010_00001_000_00011_0110011 ; //add x3, x1, x2          *
//         {mem[31],mem[30],mem[29],mem[28]}=32'b0000000_00010_00011_000_00101_0110011 ; //add x5, x3, x2    34 <--*
//         {mem[35],mem[34],mem[33],mem[32]}=32'b0000000_00101_00000_010_01100_0100011; //sw x5, 12(x0) 0          *
//         {mem[39],mem[38],mem[37],mem[36]}=32'b000000001100_00000_010_00110_0000011 ; //lw x6, 12(x0)  34        *
//         {mem[43],mem[42],mem[41],mem[40]}=32'b0000000_00001_00110_111_00111_0110011 ; //and x7, x6, x1 0    
//         {mem[47],mem[46],mem[45],mem[44]}=32'b0100000_00010_00001_000_01000_0110011 ; //sub x8, x1, x2  8       8
//         {mem[51],mem[50],mem[49],mem[48]}=32'b0000000_00010_00001_000_00000_0110011 ; //add x0, x1, x2  26      26
//         {mem[55],mem[54],mem[53],mem[52]}=32'b0000000_00001_00000_000_01001_0110011 ; //add x9, x0, x1 17       17

//Data block
        {mem[259],mem[258],mem[257],mem[256]}=32'd17; 
        {mem[263],mem[262],mem[261],mem[260]}=32'd9; 
        {mem[267],mem[266],mem[265],mem[264]}=32'd25;
        {mem[283],mem[282],mem[281],mem[280]}=32'd33519191;

    end
    
    
    
endmodule
