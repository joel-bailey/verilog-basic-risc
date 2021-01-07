/***************************************************************************
ECE 526/L
Experiment 6: Sum of products
Developer: Joel Bailey
****************************************************************************
File Name: RESISTER.sv
Date Created: 20201019
Date Last Modified: 20201022

Module Purpose: 
AASD D-FF
***************************************************************************/
`timescale 1 ns / 100 ps

module RESET_REG(CLK, RST_, EN, D, Q);
parameter WIDTH = 4;

    input CLK, EN, RST_;
    input [WIDTH - 1 : 0] D;
    output reg [WIDTH - 1 : 0] Q;

    always @(posedge CLK, negedge RST_) begin
        if (!RST_) 
            Q <= 0;
        else
            if (EN)
                Q <= D;
    end

endmodule