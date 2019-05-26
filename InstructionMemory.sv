`timescale 1ns/1ns

module instructionMemory (input [31:0] instructionAddress, output [31:0] instruction);
    reg [7:0] insMem [0:4095];
    initial begin
        // {insMem[0],insMem[1],insMem[2],insMem[3]} = 32'b10001100000000010000000000000000 ; //lw on reg 1
        // {insMem[4],insMem[5],insMem[6],insMem[7]} = 32'b10001100000000100000000000000001 ; //lw on reg 2
        {insMem[8],insMem[9],insMem[10],insMem[11]} = 32'b00000000001000100001100000100001 ; //3 = 1 + 2
        {insMem[12],insMem[13],insMem[14],insMem[15]} = 32'b00000000010000110010000000100100 ; //4 = 2 & 3
        {insMem[16],insMem[17],insMem[18],insMem[19]} = 32'b00000000100000110100000000101011 ; //8 = 4 slt 3
    end
    assign instruction = {insMem[instructionAddress],insMem[instructionAddress + 1],insMem[instructionAddress + 2],insMem[instructionAddress + 3]};
endmodule
