`timescale 1ns/1ns

module PC (input clk, rst, pcWrite input [9:0] in, output [9:0] out);
    always @(posedge clk, posedge rst) begin
        if (rst)
            out <= 0;
        else if (pcWrite)
            out <= in;
        else
            out <= out;
    end
endmodule
