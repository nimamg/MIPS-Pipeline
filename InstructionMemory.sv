`timescale 1ns/1ns

module instructionMemory (input [31:0] instructionAddress, output [31:0] instruction);
    reg [7:0] insMem [0:4095];
    initial begin
        insMem[0] = 8'b10101010;
        insMem[1] = 8'b00001111;
        insMem[2] = 8'b01010101;
        insMem[3] = 8'b00110011;
    end
    assign instruction = {insMem[instructionAddress],insMem[instructionAddress + 1],insMem[instructionAddress + 2],insMem[instructionAddress + 3]};
endmodule
