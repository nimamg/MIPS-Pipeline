`timescale 1ns/1ns

module ifidReg (input [31:0] ifidPCin, ifidInstructionIn, input ifFlush, ifidWrite, clk, rst
    output reg [31:0] ifidPCout, ifidInstructionOut);
    always @(posedge clk, posedge rst) begin
        if (rst) begin
            ifidPCout = 0;
            ifidInstructionOut = 0;
        end
        else if (ifFlush) begin
            ifidInstructionOut = 0;
        end
        else if (ifidWrite) begin
            ifidPCout = ifidPCin;
            ifidInstructionOut = ifidInstructionIn;
        end
        else begin
            ifidPCout = ifidPCout;
            ifidInstructionOut = ifidInstructionOut;
        end
    end
endmodule
