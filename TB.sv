`timescale 1ns/1ns

module TB();
    reg clk = 1, rst = 1;
    reg [4:0] counter = 0;
    pipeLine UUT(clk, rst);
    always #10 begin
        clk = ~clk;
        if (rst) counter = 0;
        else if (clk) counter = counter + 1;
    end
    initial begin
        rst = 1;
        #100;
        rst = 0;
        #1000
        $stop;
    end
endmodule
