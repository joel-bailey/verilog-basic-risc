#!/bin/bash
FILES=$(find ./src -type f \( -iname \*.v -o -iname \*.sv \))
vcs -debug -sverilog -full64 APKG.sv RISCY.sv TESTBENCH.sv $FILES && simv | tee log.log