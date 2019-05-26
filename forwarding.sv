`timescale 1ns/1ns

module forwarding(input[4:0] ExMemRd, MemWbRd, Rt, Rs, input regWrite1, regWrite2, output reg[1:0] ASel, BSel);
    always @* begin
        ASel = 0;
        BSel = 0;
        if (regWrite1 == 1) begin
            if (Rs == ExMemRd && ExMemRd != 5'b0)
                ASel <= 1;
            if (Rt == ExMemRd && ExMemRd != 5'b0)
                BSel <= 1;
        end
        else if (regWrite1 == 1) begin
            if (Rs == MemWbRd && MemWbRd != 5'b0)
                ASel <= 2;
            if (Rt == MemWbRd && MemWbRd != 5'b0)
                BSel <= 2;
        end
    end
endmodule
