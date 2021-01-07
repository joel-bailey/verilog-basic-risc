/***************************************************************************
ECE 526/L
Experiment 7: Register File Modules
Developer: Joel Bailey
****************************************************************************
File Name: RAM.sv
Date Created: 20201023
Date Last Modified: 20201029

Module Purpose: Random Access Memory modeled with bi-directional data bus.
Features:
CS_ - Chip select, active low
WS  - Write strobe, active high
OE  - Output enable, active high
***************************************************************************/
`timescale 1 ns / 100 ps

module RAM(CLK, WS, OE, CS_, ADDR, DATA);
parameter WIDTH = 8;
parameter DEPTH = 32;

    input CLK, WS, OE, CS_;
    input [$clog2(DEPTH) - 1 : 0] ADDR;
    inout wire [WIDTH - 1 : 0] DATA;

    reg [WIDTH - 1 : 0] MEM [ 0 : DEPTH - 1];
    reg [WIDTH - 1 : 0] WIREOUT;

    assign DATA = (OE) ? WIREOUT : {WIDTH{1'bz}};

    //WRITE process
    always_comb begin
        if (!CS_ && OE) 
            WIREOUT = MEM[ADDR];
        else
            WIREOUT = {WIDTH{1'bz}};
    end

    //READ process
    always @(posedge CLK) begin
        if (!CS_ && !OE && WS)
            MEM[ADDR] <= DATA;
    end
    
endmodule
