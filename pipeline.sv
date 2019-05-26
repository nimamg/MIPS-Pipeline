`timescale 1ns/1ns

module pipeLine(input clk, rst);
    wire equalToControl, regDst, regWrite, memWrite, memRead, aluSel, memToReg, IFFlush,
    exMemReadToHazard, controlSel, ifidWrite, pcWrite, memRegWriteToFrwrd, wbRegWriteToFrwrd;
    wire[1:0] pcSrc, aSel, bSel;
    wire[2:0] aluOP;
    wire[4:0] idRsToHazard, idRtToHazard, exRtToFrwrd_Hazard, memRdToFrwrd, wbRdToFrwrd, exRsToFrwrd;
    wire[31:0] instruction;


    dataPath dp(clk, rst, pcSrc, aSel, bSel, pcWrite, IFFlush, ifidWrite,
    controlSel, regWrite, regDst, memWrite, memRead, aluSel, memToReg,
    aluOP, equalToControl, idRsToHazard, idRtToHazard,
    exRtToFrwrd_Hazard, exRsToFrwrd, memRdToFrwrd, wbRdToFrwrd, exMemReadToHazard,
    memRegWriteToFrwrd, wbRegWriteToFrwrd, instruction);

    hazard hazardUnit(idRsToHazard, idRtToHazard, exRtToFrwrd_Hazard, exMemReadToHazard,
    controlSel, ifidWrite, pcWrite);

    forwarding forwardingUnit(memRdToFrwrd, wbRdToFrwrd, exRtToFrwrd_Hazard, exRsToFrwrd, memRegWriteToFrwrd, wbRegWriteToFrwrd,
    aSel, bSel);

    controller cntrlr(equalToControl, instruction, pcSrc,
    regDst, regWrite, memWrite, memRead, aluSel, memToReg, IFFlush, aluOP);
endmodule
