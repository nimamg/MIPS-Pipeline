`timescale 1ns/1ns

module TB();
    reg clk = 1, rst = 1;
    pipeLine UUT(clk, rst);
    always #10 clk = ~clk;
    initial begin
        rst = 1;
        #200
        rst = 0;
        #100000
        $stop;  
    end
endmodule