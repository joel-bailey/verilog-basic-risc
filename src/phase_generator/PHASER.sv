/***************************************************************************
ECE 526/L
Experiment 9: Modeling a Sequence Controller
Developer: Joel Bailey
****************************************************************************
File Name: PHASER.sv
Date Created: 20201112
Date Last Modified: 20201203

Module Purpose: Clocked phase generator that cycles through 4 states. 
  States: FETCH, DECODE, EXECUTE, UPDATE
***************************************************************************/
`timescale 1 ns / 100 ps

import STATES::*;

module PHASER(CLK, RST_, EN, PHASE);
input CLK, RST_;
output EN;
output PHASES PHASE;

PHASES CURRENTSTATE;
PHASES NEXTSTATE;

    //Nextstate logic
    always_comb begin
        case(CURRENTSTATE)
            FETCH: NEXTSTATE = DECODE;
            DECODE: NEXTSTATE = EXECUTE;
            EXECUTE: NEXTSTATE = UPDATE;
            default: NEXTSTATE = FETCH;
        endcase
    end

    //Current state logic
    always @(posedge CLK, negedge RST_) begin
        if (!RST_)
            CURRENTSTATE <= FETCH;
        else
            if (EN)
                CURRENTSTATE <= NEXTSTATE;
    end
    
    //Output logic
    always_comb begin
        PHASE = CURRENTSTATE;
    end

endmodule