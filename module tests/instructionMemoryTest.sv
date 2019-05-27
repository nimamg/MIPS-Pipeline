`timescale 1ns / 1ns

module imTB();
    reg [31:0] instructionAddress;
    wire [31:0] instruction;
    instructionMemory im (instructionAddress, instruction);
    initial begin
        instructionAddress = 0;
        #20;
        $stop;
    end
endmodule
