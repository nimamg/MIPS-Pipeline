`timescale 1ns / 1ns

module pcTB();
    reg clk = 0, rst, pcWrite;
    reg [31:0] pcIn;
    wire [31:0] pcOut;
    PC pc (clk, rst, pcWrite, pcIn, pcOut);
    always #10 clk = ~clk;
    initial begin
        #100;
        rst = 1;
        #100;
        rst = 0;
        #20;
        pcWrite = 1;
        pcIn = 1;
        #20;
        pcIn = 2;
        #10;
        pcWrite = 0;
        #10;
        pcIn = 1000;
        #20;
        pcIn = 500;
        #20;
        $stop;
    end
endmodule
