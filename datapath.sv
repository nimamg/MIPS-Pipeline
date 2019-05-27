`timescale 1ns / 1ns

module dataPath (input clk, rst, input [1:0] pcSrcFromCtrl, aSel, bSel, input pcWrite, ifFlush, ifidWrite,
    controlSel, regWrite, regDst, memWrite, memRead, aluSel, memToReg,
    input [2:0] aluOp, output equalToControl, output [4:0] idRsToHazard, idRtToHazard,
    exRtToFrwrd_Hazard, exRsToFrwrd, memRdToFrwrd, wbRdToFrwrd, output exMemReadToHazard,
    memRegWriteToFrwrd, wbRegWriteToFrwrd, output [31:0] instToCtrl);

    // IF wires
    wire [31:0] pcOut, pcIn, IncPcOut, jmpAdr, branchAdr, instruction;

    // ID wires
   wire [31:0] regWriteData, regData1, regData2, idPCin, idInstructionIn;
   wire [4:0] Rs, Rt, Rd;
   wire [15:0] MemoryOffset;
   wire [17:0] branchOffset;
        // wires used in ID stage, coming from WB stage
   wire [4:0] wbRdIn;
   wire wbRegWriteIn;
   // ID wires -- finished

   // EX wires
   wire [31:0] exDataIn1, exDataIn2, aluInA, aluInB, aluBetweenB, aluResult;
   wire [4:0] exRsIn, exRtIn, exRdIn, exRdOut;
   wire [15:0] exOffsetIn;
   wire [2:0] exAluOpIn;
   wire [1:0] pcSrc;
   wire exRegWriteIn, exRegDstIn, exMemWriteIn, exMemReadIn, exAluSelIn, exMemToRegIn;
   // EX wires -- finished

   // MEM wires
   wire [31:0] memAluResIn, memDataIn, memDataOut;
   wire [4:0] memRdIn;
   wire memRegWriteIn, memMemWriteIn, memMemReadIn, memMemToRegIn;
   // MEM wires -- finished

   // WB wires
   wire wbMemToRegIn;
   wire [31:0] wbMemDataIn, wbAluResIn;

   // WB wires -- finished
    ifidReg stage1Reg (IncPcOut, instruction, ifFlush, ifidWrite, clk, rst, idPCin, idInstructionIn); // IF/ID Reg

    wire regWriteInternal, regDstInternal, memWriteInternal, memReadInternal, aluSelInternal, memToRegInternal;
    wire [2:0] aluOpInternal;

    // IF stage
    assign IncPcOut = pcOut + 4; // PC incrementer
    assign pcIn = (pcSrc == 0) ? IncPcOut : (pcSrc == 1) ? branchAdr : (pcSrc == 2) ? jmpAdr : IncPcOut; // PC source Mux
    PC pc (clk, rst, pcWrite, pcIn, pcOut);
    instructionMemory instructionMem (pcOut, instruction);
    // IF stage -- finished

    // ID stage
    assign jmpAdr = {idPCin[31:28], idInstructionIn[25:0], 2'b0}; // Jump address
    // assign branchOffset = {14'b0,idInstructionIn[15:0],2'b0}; // branch offset
    assign branchAdr = {14'b0,idInstructionIn[15:0],2'b0} + idPCin; // branch address
    assign Rs = idInstructionIn[25:21];
    assign Rt = idInstructionIn[20:16];
    assign Rd = idInstructionIn[15:11];
    assign MemoryOffset = idInstructionIn[15:0];
    regFile registerFile (Rs, Rt, wbRdIn, wbRegWriteIn, clk, rst, regWriteData, regData1, regData2);
    assign {regWriteInternal, regDstInternal, memWriteInternal, memReadInternal,
    aluSelInternal, memToRegInternal,aluOpInternal} = (controlSel == 0) ? 9'b0
     : {regWrite, regDst, memWrite, memRead, aluSel, memToReg, aluOp}; // Control Signal mux
     assign equalToControl = (regData1 == regData2) ? 1'b1 : 1'b0; // branch comparator
     // ID stage -- finished

     idexReg stage2Reg (clk, rst, regData1, regData2, Rs, Rt, Rd, MemoryOffset,
        regWrite, regDst, memWrite, memRead, aluSel, memToReg, aluOp, pcSrcFromCtrl,
        exDataIn1, exDataIn2, exRsIn, exRtIn, exRdIn, exOffsetIn, exAluOpIn,
        exRegWriteIn, exRegDstIn, exMemWriteIn, exMemReadIn, exAluSelIn,
        exMemToRegIn, pcSrc); // ID/EX Reg

    // EX stage
    assign exRdOut = (exRegDstIn == 1) ? exRdIn : exRtIn; // Rd output of ex stage
    assign aluInA = (aSel == 0) ? exDataIn1 : (aSel == 1) ? aluResult : (aSel == 2) ? regWriteData : exDataIn1; // ALU A input / Forward selector
    assign aluBetweenB = (bSel == 0) ? exDataIn2 : (bSel == 1) ? aluResult : (bSel == 2) ? regWriteData : exDataIn2; // ALU B / forward selector
    assign aluInB = (exAluSelIn == 0) ? aluBetweenB : (exAluSelIn == 1) ? exOffsetIn : aluBetweenB; // ALU B input / Data and offset selector
    ALU alu (aluInA, aluInB, exAluOpIn, aluResult);
    // EX stage -- finished

    exmemReg stage3Reg (clk, rst, aluResult, aluBetweenB, exRdOut, exRegWriteIn,
    exMemWriteIn, exMemReadIn, exMemToRegIn, memRegWriteIn, memMemWriteIn, memMemReadIn,
    memMemToRegIn, memAluResIn, memDataIn, memRdIn); // EX/MEM reg

    // MEM stage
    DataMemory datamem (clk, rst, memMemWriteIn, memMemReadIn,memDataIn, memAluResIn, memDataOut);
    // MEM stage -- finished

    memwbReg stage4Reg (clk, rst, memDataOut, memAluResIn, memRdIn,
        memMemToRegIn, memRegWriteIn, wbMemToRegIn, wbRegWriteIn,
        wbMemDataIn, wbAluResIn, wbRdIn); // MEM/WB reg

    // WB stage
    assign regWriteData = (wbMemToRegIn == 0) ? wbAluResIn : wbMemDataIn; // Register write data selector
    //WB stage -- finished

    // output control signals
    assign idRsToHazard = Rs; // ID stage Rs register -> hazard unit
    assign idRtToHazard = Rt; // ID stage Rt register -> hazard unit
    assign exRtToFrwrd_Hazard = exRtIn; // EX stage Rt register -> hazard unit - forwarding unit
    assign exRsToFrwrd = exRsIn; // EX stage Rs register -> forwarding unit
    assign memRdToFrwrd = memRdIn; // MEM stage Rd (destination) register -> forwarding unit
    assign wbRdToFrwrd = wbRdIn; // WB stage Rd (destination) register -> forwarding unit
    assign exMemReadToHazard = exMemReadIn; // EX stage MemRead signal -> hazard unit
    assign memRegWriteToFrwrd = memRegWriteIn; // MEM stage RegWrite signal -> forwarding unit
    assign wbRegWriteToFrwrd = wbRegWriteIn; // WB stage RegWrite signal -> forwarding unit
    assign instToCtrl = idInstructionIn; // ID stage Instruction input -> controller
    // output control signals --finished

endmodule
