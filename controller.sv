`timescale 1ns / 1ns

module controller(input clk, equal, input [31:0] instruction, output reg [1:0] pcSrc, output reg regDst, regWrite, memWrite, memRead, aluSel, memToReg, IFFlush, output reg [2:0] aluOP);
  wire[5:0] opcode;
  assign opcode = instruction[31:26];
  always @ (instruction) begin
    {pcSrc, regDst, regWrite, memWrite, memRead, aluSel, memToReg , aluOP} = 11'b0;
    case (opcode)
      6'b100011: begin //lw
        datasel = 1;
        regWriteEn = 1;
      end
      6'b101011: begin //sw
        memWriteEn = 1;
      end
      6'b0010: begin // jump
        pcsel = 2;
      end
      6'b0100: begin // branchz
        if (zero) begin
        pcsel = 1;
        end
        else begin
          pcsel = 0;
        end
        alusel = 0;
        aluop = 6;
      end
      6'b1100: begin //addi
        regWriteEn = 1;
        alusel = 2;
        aluop = 3;
      end
      6'b1101: begin //subi
        regWriteEn = 1;
        alusel = 2;
        aluop = 5;
      end
      6'b1110: begin //andi
        alusel = 2;
        aluop = 0;
        regWriteEn = 1;
      end
      6'b1111: begin // ori
        aluop = 1;
        regWriteEn = 1;
        alusel = 2;
      end
      6'b1000: begin //rtype
        $display("rtype, %b, %b", opcode, func);
        if (func[7] == 0) begin //calc
          regWriteEn = 1;
          alusel = 0;
          if (func == 1) begin // move
            alusel = 1;
            aluop = 3;
          end
          else if (func == 2) begin // add
            aluop = 3;
          end
          else if (func == 4) begin //sub
            aluop = 4;
          end
          else if (func == 8) begin //and
            aluop = 0;
          end
          else if (func == 16) begin // or
            aluop = 1;
          end
          else if (func == 32) begin // not
            aluop = 2;
          end
          else if (func == 64) begin //nop
            regWriteEn = 0;
          end
        end
        else begin // window
          $display("wnd");
          changewnd = 1;
        end
      end
    endcase
  end
endmodule