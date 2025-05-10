`timescale 1ns / 1ps


module FullAdder(
    input a,
    input b,
    input cin,
    output sum,
    output cout
);
    // Logic for sum and carry out
    assign sum = a ^ b ^ cin; // XOR for sum
    assign cout = (a & b) | (b & cin) | (cin & a); // OR for carry out
    
endmodule

