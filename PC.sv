`timescale 1ns/1ns

module PC (input clk, rst, pcWrite input [31:0] pcIn, output reg [31:0] pcOut);
    always @(posedge clk, posedge rst) begin
        if (rst)
            pcOut <= 0;
        else if (pcWrite)
            pcOut <= pcIn;
        else
            pcOut <= pcOut;
    end
endmodule
