`timescale 1ns / 1ns

module regFileTB(); // 0 1 20 21 30
    reg clk = 0, rst, regWrite;
    reg [4:0] adr1, adr2, writeAdr;
    reg [31:0] writeData;
    wire [31:0] readData1, readData2;
    regFile file (adr1, adr2, writeAdr, regWrite, clk, rst, writeData, readData1, readData2);
    always #10 clk = ~clk;
    initial begin
        rst = 1;
        #99;
        rst = 0;
        #1;
        regWrite = 0;
        writeAdr = 20;
        writeData = 9898;
        adr1 = 0;
        adr2 = 1;
        #20;
        adr1 = 20;
        adr2 = 21;
        writeAdr = 30;
        #20;
        adr1 = 30;
        adr2 = 0;
        writeAdr = 20;
        regWrite = 1;
        #20;
        adr1 = 21;
        writeAdr = 21;
        writeData = 6764;
        #100;
        $stop;
    end
endmodule
