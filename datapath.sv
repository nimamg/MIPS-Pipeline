`timescale 1ns / 1ns

module dataPath (input clk, rst, pcSrc, pcWrite, ifFlush, ifidWrite, stall,
    regWrite);
    // IF wires
    wire [31:0] pcOut, pcIn, IncPcOut, jmpAdr, branchAdr,instruction;

    // IF stage
    assign IncPcOut = pcOut + 4; // PC incrementer
    assign pcIn = (pcSrc == 0) ? IncPcOut : (pcSrc == 1) ? branchAdr : (pcSrc == 2) jmpAdr; // PC source Mux
    PC pc (clk, rst, pcWrite, pcIn, pcOut);
    instructionMemory instructionMem (pcOut, instruction);
    // IF stage

    ifidReg (IncPcOut, instruction, ifFlush, ifidWrite, clk, rst, idPCin, idInstructionIn); // IF/ID Reg

     // ID wires
    wire [31:0] idPCin, idInstructionIn, regWriteData, regData1, regData2;
    wire [4:0] Rs, Rt, Rd, writeAdr;
    wire [15:0] MemoryOffset;
    wire [17:0] branchOffset;

    //ID stage
    assign jmpAdr = {idPCin[31:28], idInstructionIn[25:0], 2'b0}; // Jump address
    assign branchOffset = {idInstructionIn[15:0],2'b0}; // branch offset
    assign branchAdr = branchOffset + idPCin; // branch address
    assign Rs = idInstructionIn[25:21];
    assign Rt = idInstructionIn[20:16];
    assign Rd = idInstructionIn[15:11];
    assign MemoryOffset = idInstructionIn[15:0];
    regFile registerFile (Rs, Rt, writeAdr, regWrite, clk, rst, regWriteData, regData1, regData2);
    //ID stage
    
endmodule
