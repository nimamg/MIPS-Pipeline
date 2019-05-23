`timescale 1ns / 1ns

module dataPath (input clk, rst, pcSrc, pcWrite);

    wire [31:0] pcOut, pcIn, IncPcOut, jmpAdr, branchAdr,instruction;

    assign IncPcOut = pcOut + 4;
    assign pcIn = (pcSrc == 0) ? IncPcOut : (pcSrc == 1) ? branchAdr : (pcSrc == 2) jmpAdr;
    PC pc (clk, rst, pcWrite, pcIn, pcOut);
    instructionMemory instructionMem (pcOut, instruction);

endmodule
