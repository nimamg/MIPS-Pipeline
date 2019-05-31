`timescale 1ns/1ns

module hazard(input[4:0] Rs, Rt, IdExRt, input IdExMemRead, output reg controlSel, IfIdWrite, PCWrite);
    assign PCWrite = (IdExMemRead && ((Rs == IdExRt && Rs != 0) || (Rt == IdExRt && Rt != 0))) ? 0 : 1;
    assign IfIdWrite = (IdExMemRead && ((Rs == IdExRt && Rs != 0) || (Rt == IdExRt && Rt != 0))) ? 0 : 1;
    assign controlSel = (IdExMemRead && ((Rs == IdExRt && Rs != 0) || (Rt == IdExRt && Rt != 0))) ? 0 : 1;
    // always @* begin
    //     PCWrite = 1;
    //     IfIdWrite = 1;
    //     controlSel = 1;
    //     if (IdExMemRead) begin
    //         if (Rs == IdExRt || Rt == IdExRt) begin
    //             PCWrite = 0;
    //             IfIdWrite = 0;
    //             controlSel = 0;
    //         end
    //     end
    // end
endmodule
