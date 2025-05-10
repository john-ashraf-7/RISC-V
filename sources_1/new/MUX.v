`timescale 1ns / 1ps

module MUX(
    input a,
    input b,
    input s,//selection
    output o //output
    );
    
    assign o = (s)? a: b;
endmodule
