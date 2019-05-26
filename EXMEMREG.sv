`timescale 1ns/1ns

module exmemReg (input clk, rst, input [31:0] exmemAluResultIn, exmemMemoryDataIn,
    input [4:0] exmemRdIn, input exmemRegWriteIn, exmemMemWriteIn,
    exmemMemReadIn, exmemMemToRegIn, output reg exmemRegWriteOut, exmemMemWriteOut,
    exmemMemReadOut, exmemMemToRegOut, output reg [31:0] exmemAluResultOut,
    exmemMemoryDataOut, output reg [4:0] exmemRdOut);
    always @ (posedge clk, posedge rst) begin
        if (rst) begin
            exmemRegWriteOut = 0;
            exmemMemWriteOut = 0;
        end
        else begin
            exmemRegWriteOut = exmemRegWriteIn;
            exmemMemWriteOut = exmemMemWriteIn;
            exmemMemReadOut = exmemMemReadIn;
            exmemMemToRegOut = exmemMemToRegIn;
            exmemAluResultOut = exmemAluResultIn;
            exmemMemoryDataOut = exmemMemoryDataIn;
            exmemRdOut = exmemRdIn;
        end
    end
endmodule
