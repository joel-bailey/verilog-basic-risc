`timescale 1 ns / 100 ps

import STATES::*;

module PHASE_GENERATOR(CLK, RST_, EN, ADDR, OPCODE, ZF, OF, SF, CF, IF,
              IR_EN, A_EN, B_EN, PDR_EN, PORT_EN, PORT_RD, PC_EN,
              PC_LOAD, ALU_EN, ALU_OE, RAM_OE, RDR_EN, RAM_CS);

input [6:0] ADDR;
input [3:0] OPCODE;
input CLK, RST_, EN, ZF, OF, SF, CF, IF;
output reg IR_EN, A_EN, B_EN, PDR_EN, PORT_EN, PORT_RD, PC_EN,
       PC_LOAD, ALU_EN, ALU_OE, RAM_OE, RDR_EN, RAM_CS;

    PHASES PSIG;

    PHASER PGEN(
        .CLK(CLK),
        .RST_(RST_),
        .EN(EN),
        .PHASE(PSIG)
    );

    CONTROLLER CTRL(
        .ADDR(ADDR),
        .OPCODE(OPCODE),
        .PH(PSIG),
        .ZF(ZF),
        .OF(OF),
        .SF(SF),
        .CF(CF),
        .IF(IF),
        .IR_EN(IR_EN),
        .A_EN(A_EN),
        .B_EN(B_EN),
        .PDR_EN(PDR_EN),
        .PORT_EN(PORT_EN),
        .PORT_RD(PORT_RD),
        .PC_EN(PC_EN),
        .PC_LOAD(PC_LOAD),
        .ALU_EN(ALU_EN),
        .ALU_OE(ALU_OE),
        .RAM_OE(RAM_OE),
        .RAM_CS(RAM_CS),
        .RDR_EN(RDR_EN)
    );


endmodule