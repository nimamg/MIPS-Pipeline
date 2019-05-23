`timescale 1ns / 1ns

module dataPath (input clk, rst, pcSrc, pcWrite, ifFlush, ifidWrite);

    wire [31:0] pcOut, pcIn, IncPcOut, jmpAdr, branchAdr,instruction; // IF wires

    // IF stage
    assign IncPcOut = pcOut + 4;
    assign pcIn = (pcSrc == 0) ? IncPcOut : (pcSrc == 1) ? branchAdr : (pcSrc == 2) jmpAdr;
    PC pc (clk, rst, pcWrite, pcIn, pcOut);
    instructionMemory instructionMem (pcOut, instruction);
    // IF stage

    ifidReg (IncPcOut, instruction, ifFlush, ifidWrite, clk, rst, idPCin, idInstructionIn); // IF/ID Reg

    wire [31:0] idPCin, idInstructionIn; // ID wires

endmodule
