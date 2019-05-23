`timescale 1ns/1ns

module regFile (input [4:0] adr1, adr2, writeAdr, input regWrite, input [31:0] writeData,
    output reg [31:0] readData1, readData2);

    reg [31:0] registers [0:31];
    assign readData1 = registers[adr1];
    assign readData2 = registers[adr2];

    always @ (posedge clk, posedge rst) begin
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
