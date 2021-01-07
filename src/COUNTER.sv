/***************************************************************************
ECE 526/L
Experiment 4: Behavioral Modeling of a Counter
Developer: Joel Bailey
****************************************************************************
File Name: COUNTER.sv
Date Created: 20200925
Date Last Modified: 20201001

Module Purpose: 
Up counter with variable bit width. Features:
-Async Reset
-Sync Enable
    -Sync Load
***************************************************************************/
`timescale 1 ns / 100 ps

module COUNTER(CLK, RST_, EN, LD, DATA, COUNT);
parameter WIDTH = 2; //2-bit default

    input CLK, RST_, EN, LD;
    input [WIDTH - 1 : 0] DATA;
    output reg [WIDTH - 1 : 0] COUNT;

    always @(posedge CLK, negedge RST_) begin
        if(!RST_)                                     //Async reset
            COUNT <= 'b0;                              
        else                                          
            if (EN)                                   //Sync Enable
                if (LD)                               //Sync Load
                    COUNT <= DATA;
                else
                    COUNT <= (COUNT + 1) % 2 ** WIDTH; //Turn over at bit width
            else
                COUNT <= COUNT;                        //Hold
    end 
endmodule