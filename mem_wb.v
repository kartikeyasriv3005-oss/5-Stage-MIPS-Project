`timescale 1ns / 1ps

module mem_wb(
input clk, stall,
input [31:0] data_out, result,
input [3:0] rd,
input MemtoReg,RegWrite,
output reg [69:0] reg_out
);
always @(posedge clk) begin
    if (~stall) begin
        reg_out <= {RegWrite,rd,data_out, result, MemtoReg};
        end
        end 

endmodule
