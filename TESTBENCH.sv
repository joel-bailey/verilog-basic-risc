`timescale 1 ns / 100 ps

module TESTBENCH;

    reg CLK, RST_;
    wire [7:0] IO;
    reg [7:0] INPUT;

    RISCY RISC (
        .CLK(CLK),
        .RST_(RST_),
        .IO(IO)
    );

    initial
    $monitorb ("\nTIME = %0d\n", $time,
               "CONTROL:   CLK=%0b\tRST_=%0b\n", CLK, RST_,
               "OPERATION: INSTRUCTION=[%b][%b][%b][%b][%b]\n", RISC.CMD[31:28], RISC.CMD[27], RISC.CMD[26:20], RISC.CMD[19:8], RISC.CMD[7:0],
               "           PHASE=%s\tOPCODE=%b\tADDR=[%h]%b\tI_DATA=[%0d]%b\n",  RISC.PHASEGEN.PSIG, RISC.CMD[31:28], RISC.ROM_ADDR, RISC.ROM_ADDR, RISC.DATA, RISC.DATA,
               "STORAGE:   MEM[0]=%0d\tMEM[1]=%0d\tMEM[2]=%0d\n", RISC.RAM0.MEM[0], RISC.RAM0.MEM[1], RISC.RAM0.MEM[2],
               "REGISTERS: A_REG=%0d\tB_REG=%0d  \tRDR_REG=%0d\tDIR_REG=%0d\tPORT_REG=%0d\n", RISC.AREG.Q, RISC.BREG.Q, RISC.RDR.Q, RISC.PDR.Q, RISC.PORTDATA.Q,
               "SIGNALS:   RAMDATA=%0d\tALUOUT=[%0d]%b\tBUS=%b\n", RISC.RAM0.DATA, RISC.ALUNIT.TMP ,RISC.ALUNIT.TMP, RISC.BUS,
               "FLAGS:     CF=%b\tZF=%b\tSF=%b\tOF=%b\tIF=%b\n", RISC.CF, RISC.ZF, RISC.SF, RISC.OF, RISC.CMD[27],               
               "CONTROLS:  IR_EN=%b\tA_EN=%b\tB_EN=%b\tPDR_EN=%b\tPORT_EN=%b\tPORT_RD=%b\n", RISC.IR_EN, RISC.A_EN, RISC.B_EN, RISC.PDR_EN, RISC.PORT_EN, RISC.PORT_RD,
               "           PC_EN=%b\tPC_LOAD=%b\tALU_EN=%b\tALU_OE=%b\tRAM_OE=%b\tRDR_EN=%b\tRAM_CS=%b\n", RISC.PC_EN, RISC.PC_LOAD, RISC.ALU_EN, RISC.ALU_OE, RISC.RAM_OE, RISC.RDR_EN, RISC.RAM_CS,
               "I/O:       IO=[%0d]%b\n", RISC.IO, RISC.IO,
                ); 

    //begin clock
    initial begin
        CLK <= 0;
        forever begin
        #50 CLK <= ~CLK;
        end
    end 
    
    assign IO = (RISC.PDR.Q == 1'b0) ? INPUT : {8{1'bz}};

    //reset
    initial begin
        RST_ <= 0; INPUT = 8'b00000001;
        #100;
        RST_ <= 1;
        #400;
        INPUT = 8'b10000000;
        #10000;
        $finish;
    end

endmodule