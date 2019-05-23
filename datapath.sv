`timescale 1ns / 1ns

module dataPath (input clk, rst, input [1:0] pcSrc, pcWrite, ifFlush, ifidWrite, stall,
    controlSel, regWrite, regDst, memWrite, memRead, aluSel, memToReg,
    input [2:0] aluOp, output equal);
    // IF wires
    wire [31:0] pcOut, pcIn, IncPcOut, jmpAdr, branchAdr,instruction;

    // IF stage
    assign IncPcOut = pcOut + 4; // PC incrementer
    assign pcIn = (pcSrc == 0) ? IncPcOut : (pcSrc == 1) ? branchAdr : (pcSrc == 2) jmpAdr; // PC source Mux
    PC pc (clk, rst, pcWrite, pcIn, pcOut);
    instructionMemory instructionMem (pcOut, instruction);
    // IF stage

    ifidReg stage1Reg (IncPcOut, instruction, ifFlush, ifidWrite, clk, rst, idPCin, idInstructionIn); // IF/ID Reg

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
    regFile registerFile (Rs, Rt, writeAdr, regWriteFromWB, clk, rst, regWriteData, regData1, regData2);
    assign {regWrite, regDst, memWrite, memRead, aluSel, memToReg, aluOp} = (controlSel == 0) ? 8'b0
     : {regWrite, regDst, memWrite, memRead, aluSel, memToReg, aluOp}; // Control Signal mux
     assign equal = (regData1 == regData2) ? 1'b1 : 1'b0; // branch comparator
    //ID stage

    idexReg stage2Reg (clk, rst, regData1, regData2, Rs, Rt, Rd, MemoryOffset,
        regWrite, regDst, memWrite, memRead, aluSel, memToReg, aluOp, exDataIn1,
        exDataIn2, exRsIn, exRtIn, exRdIn, exOffsetIn, exAluOpIn, exRegWriteIn, exRegDstIn,
        exMemWriteIn, exMemReadIn, exAluSelIn, exMemToRegIn);

    //EX wires
    wire [31:0] exDataIn1, exDataIn2;
    wire [4:0] exRsIn, exRtIn, exRdIn,;
    wire [15:0] exOffsetIn;
    wire [2:0] exAluOpIn;
    wire exRegWriteIn, exRegDstIn, exMemWriteIn, exMemReadIn, exAluSelIn, exMemToRegIn;
endmodule
