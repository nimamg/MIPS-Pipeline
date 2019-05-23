`timescale 1ns/1ns

module hazard(input[4:0] Rs, Rt, IdExRt, input IdExMemRead, output reg controlSel, IfIdWrite, PCWrite);
    always @* begin
        PCWrite = 1;
        IfIdWrite = 1;
        controlSel = 1;
        if (IdExMemRead) begin
            if (Rs == IdExRt || Rt == IdExRt) begin
                PCWrite = 0;
                IfIdWrite = 0;
                controlSel = 0;
            end
        end
    end
endmodule