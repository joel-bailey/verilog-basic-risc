/***************************************************************************
ECE 526/L
Experiment 8: Arithmetic-Logic Unit Modeling
Developer: Joel Bailey
****************************************************************************
File Name: ALU.sv
Date Created: 20201004
Date Last Modified: 20201005

Module Purpose: 
    ALU unit with following operations:
        - Add, Subtract, And, Or, Exclusive Or, Not
    Controls:
        - OE enables output
        - EN enables an operation
    Flags:
        - ZF: zero flag
        - CF: carry flag
        - SF: negative flag
        - OF: overflow flag
***************************************************************************/
`timescale 1 ns / 100 ps

module ALU(CLK, EN, OE, OPCODE, A, B, ALU_OUT, CF, OF, SF, ZF);
parameter WIDTH = 8;

localparam ADD = 4'b0010;
localparam SUB = 4'b0011;
localparam AAND = 4'b0100;
localparam OOR = 4'b0101;
localparam XOOR = 4'b0110;
localparam NNOT = 4'b0111; 


    input CLK, EN, OE;
    input [WIDTH - 1 : 0] A, B;
    input [3 : 0] OPCODE;
    output reg CF, OF, SF, ZF;
    output reg [WIDTH - 1 : 0] ALU_OUT;

    //seperate signals for arithmetic and logical
    //operation to keep flags seperated
    reg [WIDTH - 1 : 0] OP, AR, TMP;
    reg CARRY;

    //Begin Input Logic
    always @(posedge CLK) begin
        if (EN == 1)
            case(OPCODE)
                ADD    : {CARRY, AR} <= A + B;
                SUB    : {CARRY, AR} <= A + (~B + 1);
                AAND   : OP <= A & B;
                OOR    : OP <= A | B;
                XOOR   : OP <= A ^ B;
                NNOT   : OP <= ~A;
                default: begin
                            OP <= OP;
                            AR <= AR;
                         end
            endcase
    end

    
    always_comb begin
        if (EN == 1)
            if (OPCODE == ADD || OPCODE == SUB)
                TMP = AR;
            else
                TMP = OP;
    end

    //Begin Output Logic
    always_comb begin
        if (OE)
            ALU_OUT = TMP;
        else
            ALU_OUT = {WIDTH{1'bz}};
    end

    //Begin Flag Logic, seperated by
    //logical or arithmetic outputs
    always @(OP) begin
        SF = OP[WIDTH - 1];
        ZF = ~(|OP);
    end

    always @(AR, CARRY) begin
        CF = CARRY;
        OF = (A[WIDTH - 1] == B[WIDTH - 1] && AR[WIDTH - 1] != A[WIDTH - 1]);
        SF = AR[WIDTH - 1];
        ZF = ~(|AR);
    end

endmodule