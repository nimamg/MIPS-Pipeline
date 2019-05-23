`timescale 1ns / 1ns

module dataPath (input clk, rst, input [1:0] pcSrc, aSel, bSel, input pcWrite, ifFlush, ifidWrite, stall,
    controlSel, regWrite, regDst, memWrite, memRead, aluSel, memToReg,
    input [2:0] aluOp, output equal);
    // IF wires
    wire [31:0] pcOut, pcIn, IncPcOut, jmpAdr, branchAdr, instruction;

    // IF stage
    assign IncPcOut = pcOut + 4; // PC incrementer
    assign pcIn = (pcSrc == 0) ? IncPcOut : (pcSrc == 1) ? branchAdr : (pcSrc == 2) jmpAdr; // PC source Mux
    PC pc (clk, rst, pcWrite, pcIn, pcOut);
    instructionMemory instructionMem (pcOut, instruction);
    // IF stage -- finished

    ifidReg stage1Reg (IncPcOut, instruction, ifFlush, ifidWrite, clk, rst, idPCin, idInstructionIn); // IF/ID Reg

     // ID wires
    wire [31:0] idPCin, idInstructionIn, regWriteData, regData1, regData2;
    wire [4:0] Rs, Rt, Rd;
    wire [15:0] MemoryOffset;
    wire [17:0] branchOffset;
    // ID wires -- finished

    // ID stage
    assign jmpAdr = {idPCin[31:28], idInstructionIn[25:0], 2'b0}; // Jump address
    assign branchOffset = {idInstructionIn[15:0],2'b0}; // branch offset
    assign branchAdr = branchOffset + idPCin; // branch address
    assign Rs = idInstructionIn[25:21];
    assign Rt = idInstructionIn[20:16];
    assign Rd = idInstructionIn[15:11];
    assign MemoryOffset = idInstructionIn[15:0];
    regFile registerFile (Rs, Rt, wbRdIn, wbRegWriteIn, clk, rst, regWriteData, regData1, regData2);
    assign {regWrite, regDst, memWrite, memRead, aluSel, memToReg, aluOp} = (controlSel == 0) ? 8'b0
     : {regWrite, regDst, memWrite, memRead, aluSel, memToReg, aluOp}; // Control Signal mux
     assign equal = (regData1 == regData2) ? 1'b1 : 1'b0; // branch comparator
     // ID stage -- finished


     idexReg stage2Reg (clk, rst, regData1, regData2, Rs, Rt, Rd, MemoryOffset,
        regWrite, regDst, memWrite, memRead, aluSel, memToReg, aluOp, exDataIn1,
        exDataIn2, exRsIn, exRtIn, exRdIn, exOffsetIn, exAluOpIn, exRegWriteIn, exRegDstIn,
        exMemWriteIn, exMemReadIn, exAluSelIn, exMemToRegIn);

    // EX wires
    wire [31:0] exDataIn1, exDataIn2, forwardedFromMem, forwardedFromWb, aluInA, aluInB, aluBetweenB, aluResult;
    wire [4:0] exRsIn, exRtIn, exRdIn, exRdOut;
    wire [15:0] exOffsetIn;
    wire [2:0] exAluOpIn;
    wire exRegWriteIn, exRegDstIn, exMemWriteIn, exMemReadIn, exAluSelIn, exMemToRegIn;
    // EX wires -- finished

    // EX stage
    assign exRdOut = (exRegDstIn == 1) ? exRdIn : exRtIn;
    assign aluInA = (aSel == 0) ? exDataIn1 : (aSel == 1) ? forwardedFromMem : (aSel == 2) ? forwardedFromWb;
    assign aluBetweenB = (bSel == 0) ? exDataIn2 : (bSel == 1) ? forwardedFromMem : (bSel == 2) ? forwardedFromWb;
    assign aluInB = (aluSel == 0) ? aluBetweenB : (aluSel == 1) ? exOffsetIn;
    ALU alu (aluInA, aluInB, exAluOpIn, aluResult);
    // EX stage -- finished

    exmemReg stage3Reg (clk, rst, aluResult, aluBetweenB, exRdOut, exRegWriteIn,
    exMemWriteIn, exMemReadIn, exMemToRegIn, memRegWriteIn, memMemWriteIn, memMemReadIn,
    memMemToRegIn, memAluResIn, memDataIn, memRdIn);

    // MEM wires
    wire [31:0] memAluResIn, memDataIn, memDataOut;
    wire [4:0] memRdIn;
    wire memRegWriteIn, memMemWriteIn, memMemReadIn, memMemToRegIn;
    // MEM wires

    // MEM stage
    DataMemory datamem (clk, rst, memMemWriteIn, memMemReadIn,memDataIn, memAluResIn, memDataOut);
    // MEM stage -- finished

    memwbReg stage4Reg (clk, rst, memDataOut, memAluResIn, memRdIn,
        memMemToRegIn, memRegWriteIn, wbMemToRegIn, wbRegWriteIn,
        wbMemDataIn, wbAluResIn, wbRdIn);

    // WB wires
    wire wbMemToRegIn, wbRegWriteIn;
    wire [31:0] wbMemDataIn, wbAluResIn;
    wire [4:0] wbRdIn;
    // WB wires -- finished

    // WB stage
    assign regWriteData = (wbMemToRegIn == 0) ? wbAluResIn : wbMemDataIn;
    //WB stage -- finished

endmodule
