`timescale 1ns / 1ps

module n_bit_2_x_1_MUX #(N = 32)(//TODO potential error
    input [N-1:0] a,
    input [N-1:0] b,
    input s,
    output [N-1:0] o
    );
    
    genvar i;
    generate
        for(i = 0; i < N; i = i + 1) begin
            MUX mx(.a(a[i]), .b(b[i]), .s(s), .o(o[i]));
        end
    endgenerate
    
endmodule
