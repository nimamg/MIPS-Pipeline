`timescale 1ns/1ns

module instructionMemory (input [31:0] instructionAddress, output [31:0] instruction);
    reg [31:0] insMem [0:1023];
    assign instruction = insMem[address];
endmodule
