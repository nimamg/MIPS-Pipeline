`timescale 1ns/1ns

module aluTB();
    reg [31:0] a, b;
    reg [2:0] op;
    wire [31:0] aluResult;
    ALU alu (a, b, op, aluResult);
    initial begin
        #10;
        a = 15;
        b = 10;
        op = 0;
        #20;
        op = 1;
        #20;
        op = 2;
        #20;
        a = 13;
        b = 8;
        op = 3;
        #20;
        op = 4;
        #20;
        a = 8;
        b = 13;
        #20;
        $stop;
    end
endmodule
