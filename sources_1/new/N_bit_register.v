`timescale 1ns / 1ps

module N_bit_register #(parameter N = 32)(
    input load,
    input clk,
    input rst,
    input [N-1:0] D,
    output [N-1:0] Q
    );
    


    genvar i;
    generate
        for(i = 0; i < N; i = i + 1) begin
            wire a;
            //assign a = (load)?D[i] :Q[i];
            MUX mx(.a(D[i]), .b(Q[i]), .s(load), .o(a));
            DFlipFlop DFF(.clk(clk), .rst(rst), .D(a), .Q(Q[i]));
        end
    endgenerate
    
endmodule
