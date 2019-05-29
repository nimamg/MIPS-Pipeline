`timescale 1ns/1ns

module DataMemory (input clk, rst, memWrite, memRead, input [31:0] writeData, address, output [31:0] readData);
    reg [31:0] memory [0:1023];
    always @(posedge clk, posedge rst) begin
        if (rst) begin
            integer i;
            for (i = 0 ; i < 1023 ; i++) begin
                memory[i] = 0;
            end
        end
        else if (memWrite) begin
            memory[address] = writeData;
        end
    end
    assign readData = (memRead == 1) ? memory[address] : readData;
    initial begin
        #100;
        memory[0] = 15;
        memory[1] = 25;
        memory[2] = 25;
        memory[3] = 80;
    end
endmodule
