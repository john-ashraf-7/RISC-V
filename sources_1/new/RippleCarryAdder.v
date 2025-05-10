`timescale 1ns / 1ps


module RippleCarryAdder #(parameter N = 32)( // Change N to your desired bit width
    input [N-1:0] A,
    input [N-1:0] B,
    input cin,
    output [N-1:0] Sum,
    output cout
);
    wire [N:0] carry; // Internal carry wires, including carry-in and carry-out
    assign carry[0] = cin; // Assign carry-in to the first carry bit

    genvar i;
    generate
        for (i = 0; i < N; i = i + 1) begin : adder_loop
            FullAdder FA(
                .a(A[i]),
                .b(B[i]),
                .cin(carry[i]),
                .sum(Sum[i]),
                .cout(carry[i+1])
            );
        end
    endgenerate

    assign cout = carry[N]; // The final carry-out
endmodule
