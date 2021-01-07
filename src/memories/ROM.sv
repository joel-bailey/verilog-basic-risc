/***************************************************************************
ECE 526/L
Experiment 7: Register File Modules
Developer: Joel Bailey
****************************************************************************
File Name: ROM.sv
Date Created: 20201023
Date Last Modified: 20201029

Module Purpose: Read-only memory. Initialized via files ram0.mem -> ram2.mem.
Features:
CS_ - Chip select, active low
OE  - Output enable, active high
***************************************************************************/
`timescale 1 ns / 100 ps

module ROM(OE, CS_, ADDR, DOUT);
parameter WIDTH = 32;
parameter DEPTH = 32;

    input OE, CS_;
    input [$clog2(DEPTH) - 1 : 0] ADDR;
    output reg [WIDTH - 1 : 0] DOUT;

    reg [WIDTH - 1 : 0] MEM [ 0 : DEPTH - 1];
    initial begin
        $readmemh("prog1.mem", MEM, 5'h00, 5'h06);
        $readmemh("prog2.mem", MEM, 5'h08, 5'h0B);
        $readmemh("prog3.mem", MEM, 5'h0F, 5'h14);
        $readmemh("prog4.mem", MEM, 5'h16, 5'h1E);
    end

    always_comb begin
        if (!CS_)
            if (OE)
                DOUT <= MEM[ADDR];
    end
endmodule