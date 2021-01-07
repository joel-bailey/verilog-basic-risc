/***************************************************************************
ECE 526/L
Experiment 10: RISC-Y
Developer: Joel Bailey
****************************************************************************
File Name: RISCY.sv
Date Created: 20201130
Date Last Modified: 20201203

Module Purpose: Top level of a reduced instruction set computer (RISC).
This top level instantiates the following modules:
    - AASD Reset
    - Phase Generator, with phaser
    - Program Counter
    - Instruction Register
    - Port Direction Register
    - Read-only Memory
    - Random Access Memory
    - (2) Tri-state Buffers
    - Port Data Register
    - A Register
    - B Register
    - 2 to 1 Multiplexer
    - Arithmetic Unit (ALU)
    - Ram Data Register
***************************************************************************/

`timescale 1 ns / 100 ps
module RISCY (CLK, RST_, IO);
input CLK, RST_; 
inout [7:0] IO;

    reg EN, CF, OF, SF, ZF;
    reg [31:0] ROM_OUT, CMD;
    reg [7:0] RDR_OUT, DATA, AOUT, BOUT, PORT_OUT;
    wire [7:0] BUS;
    reg [6:0] ADDR;
    reg [4:0] ROM_ADDR;
    reg AASD_RESET_;
    reg IR_EN, A_EN, B_EN, PDR_EN, PORT_EN, PORT_RD, PC_EN,
       PC_LOAD, ALU_EN, ALU_OE, RAM_OE, RDR_EN, RAM_CS, DIR;

    AASD RESETTER(
        .CLK(CLK),
        .RST_(RST_),
        .AASD_OUT_(AASD_RESET_)
    );

    PHASE_GENERATOR PHASEGEN(
        .CLK(CLK),
        .RST_(AASD_RESET_),
        .EN(1'b1),
        .ADDR(CMD[26:20]),
        .OPCODE(CMD[31:28]),
        .ZF(ZF),
        .OF(OF),
        .SF(SF),
        .CF(CF),
        .IF(CMD[27]),
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

    COUNTER #(.WIDTH(5)) PC (
        .CLK(CLK),
        .RST_(AASD_RESET_),
        .EN(PC_EN),
        .LD(PC_LOAD),
        .DATA(CMD[24:20]),
        .COUNT(ROM_ADDR)
    );

    ROM #(.WIDTH(32), .DEPTH(32)) ROM0 (
        .CS_(1'b0), 
        .OE(1'b1),
        .ADDR(ROM_ADDR),
        .DOUT(ROM_OUT)
    );

    REG #(.WIDTH(32)) IR (
        .CLK(CLK),
        .EN(IR_EN),
        .D(ROM_OUT),
        .Q(CMD)
    );

    RAM #(.WIDTH(8), .DEPTH(32)) RAM0 (
        .CLK(CLK),
        .WS(CLK),
        .OE(RAM_OE),
        .CS_(RAM_CS),
        .ADDR(CMD[4:0]),
        .DATA(BUS)
    );

    REG #(.WIDTH(8)) RDR (
        .CLK(CLK),
        .EN(RDR_EN),
        .D(BUS),
        .Q(RDR_OUT)
    );

    MUX2_1 #(.WIDTH(8)) DATAMUX (
        .A(CMD[7:0]),
        .B(RDR_OUT),
        .SEL(RAM_OE),
        .OUT(DATA)
    );

    RESET_REG #(.WIDTH(8)) AREG (
        .CLK(CLK),
        .RST_(AASD_RESET_),
        .EN(A_EN),
        .D(DATA),
        .Q(AOUT)
    );

    RESET_REG #(.WIDTH(8)) BREG (
        .CLK(CLK),
        .RST_(AASD_RESET_),
        .EN(B_EN),
        .D(DATA),
        .Q(BOUT)
    );

    ALU #(.WIDTH(8)) ALUNIT (
        .CLK(CLK),
        .EN(ALU_EN),
        .OE(ALU_OE),
        .OPCODE(CMD[31:28]),
        .A(AOUT),
        .B(BOUT),
        .ALU_OUT(BUS),
        .CF(CF),
        .OF(OF),
        .SF(SF),
        .ZF(ZF)
    );

    RESET_REG #(.WIDTH(1)) PDR ( //RESETS TO 0, READ IO
        .CLK(CLK),
        .RST_(AASD_RESET_),
        .EN(PDR_EN),
        .D(DATA[0]),
        .Q(DIR)
    );

    REG #(.WIDTH(8)) PORTDATA (
        .CLK(CLK),
        .EN(PORT_EN),
        .D(DATA),
        .Q(PORT_OUT)
    );

    TRISTATE #(.WIDTH(8)) INNOUT (
        .DIN(PORT_OUT),
        .CTRL(DIR),
        .DOUT(IO)
    );

    TRISTATE #(.WIDTH(8)) IO_BUS (
        .DIN(IO),
        .CTRL(PORT_RD),
        .DOUT(BUS)
    );

endmodule