/***************************************************************************
ECE 526/L
Experiment 10: RISC-Y
Developer: Joel Bailey
****************************************************************************
File Name: TRISTATE.sv
Date Created: 20201130
Date Last Modified: 20201203
 
Module Purpose: Scalable Tristate Buffer
***************************************************************************/

`timescale 1 ns / 100 ps

module TRISTATE(DIN, CTRL, DOUT);
parameter WIDTH = 8;

input [WIDTH - 1 : 0] DIN;
input CTRL;
output reg [WIDTH - 1 : 0] DOUT;

    always_comb begin
        if (CTRL)
            DOUT = DIN;
        else
            DOUT = {WIDTH{1'bz}}; 
    end

endmodule
