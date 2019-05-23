`timescale 1ns / 1ns

module ALU (input [31:0] aluInA, aluInB, input [2:0] aluOp, output [31:0] aluResult);
    assign aluResult = (aluOp == 3'b000) ? aluInA + aluInB : // add
    (aluOp == 3'b001) ? aluInA - aluInB : // sub
    (aluOp == 3'b010) ? aluInA & aluInB : // and
    (aluOp == 3'b011) ? aluInA | aluInB : // or
    (aluOp == 3'b100) ? ((aluInA < aluInB) ? {30'b0,1'b1} : 31'b0);
endmodule 
