/***************************************************************************
ECE 526/L
Experiment 6: Sum of products
Developer: Joel Bailey
****************************************************************************
File Name: AASD.sv
Date Created: 20201019
Date Last Modified: 20201022

Module Purpose: 
Asynchronous Assert, Synchronous De-assert - Active Low RESET
***************************************************************************/
`timescale 1 ns / 100 ps

module AASD(CLK, RST_, AASD_OUT_);
    input CLK, RST_;
    output reg AASD_OUT_;

    reg HOLD;

    always @(posedge CLK, negedge RST_) 
    begin
        if(!RST_) begin        //Async Assert
            HOLD <= !RST_;
            AASD_OUT_ <= 1'b0;
        end else               //Syncronous De-assert
            AASD_OUT_ <= HOLD;
    end
endmodule