/***************************************************************************
ECE 526/L
Experiment 6: Sum of products
Developer: Joel Bailey
****************************************************************************
File Name: RESISTER.sv
Date Created: 20201019
Date Last Modified: 20201022

Module Purpose: 
D-FF NO RESET
***************************************************************************/
`timescale 1 ns / 100 ps

module REG(CLK, EN, D, Q);
parameter WIDTH = 4;

    input CLK, EN;
    input [WIDTH - 1 : 0] D;
    output reg [WIDTH - 1 : 0] Q;

    always @(posedge CLK) begin
        if (EN)
            Q <= D;
    end

endmodule