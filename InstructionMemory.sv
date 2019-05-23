`timescale 1ns/1ns

module instructionMemory (input [9:0] address, output [31:0] instruction);
    reg [31:0] insMem [0:1023];
    assign instruction = insMem[address];
endmodule
