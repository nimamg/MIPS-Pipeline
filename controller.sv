`timescale 1ns / 1ns

module controller(input equal, input [31:0] instruction, output reg [1:0] pcSrc, output reg regDst, regWrite, memWrite, memRead, aluSel, memToReg, IFFlush, output reg [2:0] aluOp);
  wire[5:0] opcode, func;
  assign func = instruction[5:0];
  assign opcode = instruction[31:26];
  always @ (instruction) begin
    {pcSrc, regDst, regWrite, memWrite, memRead, aluSel, memToReg , aluOp, IFFlush} = 12'b0;
    case (opcode)
      6'b100011: begin //lw
        memToReg = 1;
        regWrite = 1;
        memRead = 1;
        aluSel = 1;
      end
      6'b101011: begin //sw
        memWrite = 1;
        aluSel = 1;
      end
      6'b000010: begin // jump
        pcSrc = 2;
        IFFlush = 1;
      end
      6'b000100: begin // branchEq
        if (equal) begin
          pcSrc = 1;
          IFFlush = 1;
        end
        else begin
          pcSrc = 0;
        end
      end
      6'b000101: begin // branchNotEq
        if (~equal) begin
            pcSrc = 1;
            IFFlush = 1;
        end
        else begin
          pcSrc = 0;
        end
      end
      6'b000000: begin //Rtype
        regDst = 1;
        regWrite = 1;
        if (func == 6'b100001) begin // add
            aluOp = 0;
        end
        else if (func == 6'b100011) begin //sub
            aluOp = 1;
        end
        else if (func == 6'b100100) begin //and
            aluOp = 2;
        end
        else if (func == 6'b100101) begin // or
            aluOp = 3;
        end
        else if (func == 6'b101011) begin // slt
            aluOp = 4;
        end
        else if (func == 6'b000000) begin //nop
            regWrite = 0;
        end
      end
    endcase
  end
endmodule
