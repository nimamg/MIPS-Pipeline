`timescale 1ns/1ns

module instructionMemory (input [31:0] instructionAddress, output [31:0] instruction);
    reg [7:0] insMem [0:4095];
    initial begin
        // {insMem[0],insMem[1],insMem[2],insMem[3]} = 32'b10001100000000010000000000000000 ; //lw on reg 1
        // {insMem[4],insMem[5],insMem[6],insMem[7]} = 32'b10001100000000100000000000000001 ; //lw on reg 2
        {insMem[0],insMem[1],insMem[2],insMem[3]} = 32'b 00000000001000100001100000100001 ; //3 = 1 + 2 --> 5clk
        // {insMem[4],insMem[5],insMem[6],insMem[7]} = 32'b10101100001000100000000000000010; //sw reg 2 (15) on 12
        {insMem[4],insMem[5],insMem[6],insMem[7]} = 32'b00010000001000110000000000011000; // dont beq --> clk 7
        {insMem[8],insMem[9],insMem[10],insMem[11]} = 32'b00000000100000100010000000100001 ; //4 = 4 + 2 --> clk 8
        {insMem[12],insMem[13],insMem[14],insMem[15]} = 32'b00010000001000100000000000010000 ; //beq to 32 -->clk 9
        {insMem[32],insMem[33],insMem[34],insMem[35]} = 32'b00010100010000010010000000100011; // dont bneq --> clk 11
        {insMem[36],insMem[37],insMem[38],insMem[39]} = 32'b00000000100000100010000000100001; // 4 = 4 + 2 --> clk 12
        {insMem[40],insMem[41],insMem[42],insMem[43]} = 32'b00010100011000010000000000001000; // bneq to 52 --> clk13
        {insMem[44],insMem[45],insMem[46],insMem[47]} = 32'b00000000100000100010000000100001; // 4 = 4 + 2 --> clk 15
        {insMem[52],insMem[53],insMem[54],insMem[55]} = 32'b00000000001000100010100000100001; // 5 = 1 + 2 --> clk 16


    end
    assign instruction = {insMem[instructionAddress],insMem[instructionAddress + 1],insMem[instructionAddress + 2],insMem[instructionAddress + 3]};
endmodule
