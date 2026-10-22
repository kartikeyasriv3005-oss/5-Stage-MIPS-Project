`timescale 1ns / 1ps

module data_memory(
    input clk, reset,
    input MemWrite, MemRead,
    input [31:0] addr,
    input [31:0] write_data,
    output reg [31:0] read_data
);
    reg [31:0] data [1023:0];  // larger memory
    integer i;
    
    initial begin
        for (i = 0; i < 1024; i = i + 1)
            data[i] = 32'h0;
        // Pre-load values at LW addresses
        // LW reg7: addr = 1279, word index = 1279/4 = 319
        data[319] = 32'h000000AA;  // value for reg7
        // LW reg8: addr = 1283, word index = 1283/4 = 320
        data[320] = 32'h000000BB;  // value for reg8
    end

always @(posedge clk) begin
    if (reset) begin
        for (i = 0; i < 1024; i = i + 1)
            data[i] = 32'h0;
             data[319] = 32'h000000AA;
               data[320] = 32'h000000BB;
    end else if (MemWrite && !MemRead) begin
        data[addr[31:2]] <= write_data;
    end
end

// Separate combinational read:
always @(*) begin
    if (MemRead && !MemWrite)
        read_data = data[addr[31:2]];  // combinational - no clock
    else
        read_data = 32'h0;
end
endmodule
