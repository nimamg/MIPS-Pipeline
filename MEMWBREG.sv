`timescale 1ns / 1ns

module memwbReg (input clk, rst, input [31:0] memwbMemDataIn, memwbAluDataIn, input [4:0] memwbRdIn,
    input memwbMemToRegIn, memwbRegWriteIn, output memwbMemToRegOut, memwbRegWriteOut
    output [31:0] memwbMemDataOut, memwbAluDataOut, output [4:0] memwbRdOut);
    always @(posedge clk, posedge rst) begin
        if (rst) begin
            memwbRegWriteOut = 0;
        end
        else begin
            memwbMemToRegOut = memwbMemToRegIn;
            memwbRegWriteOut = memwbRegWriteIn;
            memwbMemDataOut = memwbMemDataIn;
            memwbAluDataOut = memwbAluDataIn;
            memwbRdOut = memwbRdIn;
        end
    end
endmodule
