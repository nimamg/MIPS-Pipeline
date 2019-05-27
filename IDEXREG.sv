`timescale 1ns / 1ns

module idexReg (input clk, rst, input [31:0] idexRegData1, idexRegData2,
    input [4:0] idexRs, idexRt, idexRd, input [15:0] idexOffset,
    input idexRegWrite, idexRegDst, idexMemWrite, idexMemRead, idexAluSel,
    idexMemToReg, input [2:0] idexAluOp, input [1:0] idexPcSrcIn,
    output reg [31:0] idexDataOut1, idexDataOut2, output reg [4:0] idexRsOut,
    idexRtOut, idexRdOut, output reg [15:0] idexOffsetOut,
    output reg [2:0] idexAluOpOut, output reg idexRegWriteOut, idexRegDstOut,
    idexMemWriteOut, idexMemReadOut, idexAluSelOut, idexMemToRegOut,
    output reg [1:0] idexPcSrcOut);
    always @ (posedge clk, posedge rst) begin
        if (rst) begin
            idexRegWriteOut = 0;
            idexMemWriteOut = 0;
        end
        else begin
            idexDataOut1 = idexRegData1;
            idexDataOut2 = idexRegData2;
            idexRsOut = idexRs;
            idexRtOut = idexRt;
            idexRdOut = idexRd;
            idexOffsetOut = idexOffset;
            idexRegWriteOut = idexRegWrite;
            idexRegDstOut = idexRegDst;
            idexMemWriteOut = idexMemWrite;
            idexMemReadOut = idexMemRead;
            idexAluSelOut = idexAluSel;
            idexMemToRegOut = idexMemToReg;
            idexAluOpOut = idexAluOp;
            idexPcSrcOut = idexPcSrcIn;
        end
    end
endmodule
