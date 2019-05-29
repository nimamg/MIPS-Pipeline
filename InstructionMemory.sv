`timescale 1ns/1ns

module instructionMemory (input [31:0] instructionAddress, output [31:0] instruction);
    reg [7:0] insMem [0:4095];
    initial begin
        // {insMem[0],insMem[1],insMem[2],insMem[3]} = 32'b10001100000000010000000000000000 ; //lw on reg 1
        // {insMem[4],insMem[5],insMem[6],insMem[7]} = 32'b10001100000000100000000000000001 ; //lw on reg 2
        // {insMem[0],insMem[1],insMem[2],insMem[3]} = 32'b 00000000001000100001100000100001 ; //3 = 1 + 2 --> 5clk
        // {insMem[4],insMem[5],insMem[6],insMem[7]} = 32'b10101100001000100000000000000010; //sw reg 2 (15) on 12
        // {insMem[4],insMem[5],insMem[6],insMem[7]} = 32'b00010000001000110000000000011000; // dont beq --> clk 7
        // {insMem[8],insMem[9],insMem[10],insMem[11]} = 32'b00000000100000100010000000100001 ; //4 = 4 + 2 --> clk 8
        // {insMem[12],insMem[13],insMem[14],insMem[15]} = 32'b00010000001000100000000000000100 ; //beq to 32 -->clk 9
        // {insMem[32],insMem[33],insMem[34],insMem[35]} = 32'b00010100010000010010000000100011; // dont bneq --> clk 11
        // {insMem[36],insMem[37],insMem[38],insMem[39]} = 32'b00000000100000100010000000100001; // 4 = 4 + 2 --> clk 12
        // {insMem[40],insMem[41],insMem[42],insMem[43]} = 32'b00010100011000010000000000001000; // bneq to 52 --> clk13
        // {insMem[44],insMem[45],insMem[46],insMem[47]} = 32'b00000000100000100010000000100001; // 4 = 4 + 2 --> clk 15
        // {insMem[52],insMem[53],insMem[54],insMem[55]} = 32'b00000000001000100010100000100001; // 5 = 1 + 2 --> clk 16

        // {insMem[0],insMem[1],insMem[2],insMem[3]} = 32'b00000000001000100001100000100001 ; //3 = 1 + 2 --> 5clk
        // {insMem[4],insMem[5],insMem[6],insMem[7]} = 32'b00000000000000010010100000100001 ; //5 = 1 + 0 --> 6clk
        // {insMem[8],insMem[9],insMem[10],insMem[11]} = 32'b00000000001000110010000000100001 ; //4 = 1 + 3 --> 7clk


        // {insMem[0],insMem[1],insMem[2],insMem[3]} = 32'b10001100000000110000000000000000 ; //lw on reg 3
        // {insMem[4],insMem[5],insMem[6],insMem[7]} = 32'b00000000001000110010000000100001 ; //4 = 1 + 3 --> 7clk


        {insMem[0], insMem[1], insMem[2], insMem[3]} = 32'b10001100000000010000000000000000 ; //lw mem[0] on 1
        {insMem[4], insMem[5], insMem[6], insMem[7]} = 32'b10001100000000100000000000000001 ; //lw mem[1] on 2
        {insMem[8], insMem[9], insMem[10], insMem[11]} = 32'b00000000001000100001100000100001 ; //3 = 1 + 2
        {insMem[12], insMem[13], insMem[14], insMem[15]} = 32'b00000000001000100010000000100001 ; //4 = 1 + 2
        {insMem[16], insMem[17], insMem[18], insMem[19]} = 32'b00000000011001000010100000100001 ; //5 = 3 + 4
        {insMem[20], insMem[21], insMem[22], insMem[23]} = 32'b00000000000000000000000000000000 ; //nop
        {insMem[24], insMem[25], insMem[26], insMem[27]} = 32'b00000000000000000000000000000000 ; //nop
        {insMem[28], insMem[29], insMem[30], insMem[31]} = 32'b00000000000000000000000000000000 ; //nop
        {insMem[32], insMem[33], insMem[34], insMem[35]} = 32'b00010100101010000001100110100001 ; //bneq 5 8 wont branch
        {insMem[36], insMem[37], insMem[38], insMem[39]} = 32'b00010000101010000000000000000000 ; //beq 5 8 to 40
        {insMem[40], insMem[41], insMem[42], insMem[43]} = 32'b00000000001000100010100000100001 ; //add 5 = 1 + 2
        {insMem[44], insMem[45], insMem[46], insMem[47]} = 32'b00000000101010000011000000100001 ; //6 = 5 + 8
        {insMem[48], insMem[49], insMem[50], insMem[51]} = 32'b00000000001001010011000000101011 ; //slt 6 1 < 5
    end
    assign instruction = {insMem[instructionAddress],insMem[instructionAddress + 1],insMem[instructionAddress + 2],insMem[instructionAddress + 3]};
endmodule
