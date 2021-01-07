/***************************************************************************
ECE 526/L
Experiment 5: Scalable Multiplexer
Developer: Joel Bailey
****************************************************************************
File Name: MUX2_1.sv
Date Created: 20201005
Date Last Modified: 20201015

Module Purpose: 
Scalable 2:1 Multiplexer 
INPUTS: A (parameterized), B (parameterized), SEL (1-bit)
OUTPUT: OUT (parameterized)

Note: When select is not a 1 or 0, OUT resolves equal bits as 1 and unequal
bits as unknown (X)
***************************************************************************/
`timescale 1 ns / 100 ps

module MUX2_1(A, B, SEL, OUT);
parameter WIDTH = 1; //1-bit default

    input SEL;
    input [WIDTH - 1 : 0] A, B;
    output reg [WIDTH - 1 : 0] OUT;

    reg [WIDTH - 1 : 0] INDEX;

    always @(A, B, SEL) begin
        if (SEL == 0)                                     
            OUT = A;                              
        else if (SEL == 1)                                         
            OUT = B;
        else begin
            for(INDEX = 0; INDEX < WIDTH; INDEX = INDEX + 1) begin
                OUT[INDEX] = (A[INDEX] == B[INDEX]) ? A[INDEX] : 1'bx;
            end
        end
    end 
endmodule