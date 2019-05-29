`timescale 1ns/1ns

module regFile (input [4:0] adr1, adr2, writeAdr, input regWrite, clk, rst, input [31:0] writeData,
    output [31:0] readData1, readData2);

    reg [31:0] registers [0:31];
    assign readData1 = registers[adr1];
    assign readData2 = registers[adr2];
    initial begin
        #100;
        // registers[1] = 10;
        // registers[2] = 10;
        // registers[3] = 15;
        registers[8] = 80;
    end
    always @ (negedge clk, posedge rst) begin
        if (rst) begin
            integer i;
            for (i = 0 ; i < 32 ; i++) begin
              registers[i] = 0;
            end
        end
        else if (regWrite) begin
            registers[writeAdr] = writeData;
        end
    end
endmodule
