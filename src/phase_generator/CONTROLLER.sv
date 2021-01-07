/***************************************************************************
ECE 526/L
Experiment 9: Modeling a Sequence Controller
Developer: Joel Bailey
****************************************************************************
File Name: CONTROLLER.sv
Date Created: 20201112
Date Last Modified: 20201203

Module Purpose: Control unit of phase generator. Combinational case statement
  decodes the phase and sets certain flags. 
  INPUT:
    Phases: FETCH, DECODE, EXECUTE, UPDATE
    Opcodes: LOAD, STORE, ADD, SUBTRACT, AND, OR, XOR, NOT, BRANCH UNCOND,
        BRANCH IF ZERO, BRANCH IF CARRY, BRANCH IF NEGATIVE, BRANCH IF OVERFLOW
    Addresses: RAM, REGA, REGB, PDR, IOPORT
    Flags: OF, CF, ZF, SF, IF
  OUTPUT:
    Flags: IR_EN, A_EN, B_EN, PDR_EN, PORT_EN, PORT_RD, PC_EN, PC_LOAD,
        ALU_EN, ALU_OE, RAM_OE, RDR_EN, RAM_CS
***************************************************************************/
`timescale 1 ns / 100 ps

import STATES::*;

module CONTROLLER(ADDR, OPCODE, PH, ZF, OF, SF, CF, IF,
              IR_EN, A_EN, B_EN, PDR_EN, PORT_EN, PORT_RD, PC_EN,
              PC_LOAD, ALU_EN, ALU_OE, RAM_OE, RDR_EN, RAM_CS);

input [6:0] ADDR;
input [3:0] OPCODE;
input [1:0] PH;
input ZF, OF, SF, CF, IF;
output reg IR_EN, A_EN, B_EN, PDR_EN, PORT_EN, PORT_RD, PC_EN,
       PC_LOAD, ALU_EN, ALU_OE, RAM_OE, RDR_EN, RAM_CS;

    always_comb begin
        case (PH) 
            FETCH: 
            begin
                //Enable Instruction Register
                IR_EN = 1;
                //Disable the program counter
                PC_EN = 0;
                PC_LOAD = 0;
            end
            DECODE: 
            begin
                //Disable the Instruction Register
                IR_EN = 0;
                //Decode function call
                DCODE(OPCODE, ADDR);
            end
            EXECUTE:
            begin
            end
            default:
            begin
                UD(OPCODE, ADDR);
            end
        endcase
    end

    //Begin Decode Function
    function automatic DCODE;
    input [3:0] CODE;
    input [6:0] ADR;
    begin
        if (OPCODE == 0)
            LD(ADR);
        else if (OPCODE == 1)
            STR(ADR);
        else if (OPCODE < 8)
            ALU_EN = 1;
    end
    endfunction

    //Begin Update Function
    function automatic UD;
    input [3:0] CODE;
    input [6:0] ADR;
    begin
        //Enable the program counter
        PC_EN = 1;

        //If statement for branch instructions
        if (OPCODE == 8) 
            PC_LOAD = 1;
        else if(OPCODE == 9 && ZF)
            PC_LOAD = 1;
        else if(OPCODE == 10 && SF)
            PC_LOAD = 1;
        else if(OPCODE == 11 && OF)
            PC_LOAD = 1;
        else if(OPCODE == 12 && CF)
            PC_LOAD = 1;
        else
            PC_LOAD = 0;

        //Reset all signals
        RDR_EN = 0;
        A_EN = 0;
        B_EN = 0;
        PDR_EN = 0;
        PORT_EN = 0;
        PORT_RD = 1;
        ALU_EN = 0;
        ALU_OE = 0;
        RAM_OE = 0;
        RAM_CS = 1;
    end
    endfunction

    //Begin Store function
    function automatic STR;
    input [6:0] ADR;
    //Enable RAM
    RAM_CS = 0;
    begin
        //We can store from IO or ALU
        //67 is IO else is ALU
        if (ADR == 67) begin
            PORT_RD = 1; 
            ALU_OE = 0;
        end
        else begin
            PORT_RD = 0; 
            ALU_OE = 1;
        end
    end
    endfunction

    //Begin Load function
    function automatic LD;
    input [6:0] ADR;
    begin
        //Decide what data to use
        //by checking the immediate flag
        if (IF == 1) 
        begin
            RAM_OE = 0;
            RAM_CS = 1;
            RDR_EN = 0;
            PORT_RD = 1; 
        end
        else 
        begin
            RAM_OE = 1;
            RAM_CS = 0;
            RDR_EN = 1;
            PORT_RD = 0; 
        end

        if (ADR == 64) //A
        begin
            A_EN = 1;
            B_EN = 0;
            PDR_EN = 0;
            PORT_EN = 0;
        end
        else if (ADR == 65) //B
        begin
            A_EN = 0;
            B_EN = 1;
            PDR_EN = 0;
            PORT_EN = 0;
        end
        else if (ADR == 66) //PDR
        begin
            A_EN = 0;
            B_EN = 0;
            PDR_EN = 1;
            PORT_EN = 0;
        end
        else if (ADR == 67) //PORT DATA
        begin
            A_EN = 0;
            B_EN = 0;
            PDR_EN = 0;
            PORT_EN = 1;
        end
        else
        begin
            A_EN = 0;
            B_EN = 0;
            PDR_EN = 0;
            PORT_EN = 0;
        end
    end
    endfunction

endmodule