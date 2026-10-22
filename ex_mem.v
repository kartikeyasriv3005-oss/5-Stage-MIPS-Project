`timescale 1ns / 1ps

module ex_mem(
    input clk,
    input [31:0] alu_out,
    input [31:0] write_data,      // ? add rt value for SW
    input zero, MemRead, MemWrite, RegWrite, MemtoReg,
    input [3:0] rd,
    output reg [72:0] reg_out     // ? 41 + 32 = 73 bits
);
    always @(posedge clk) begin
        // no stall gating here — EX/MEM always advances
        reg_out <= {alu_out, write_data, zero, MemRead, MemWrite, RegWrite, MemtoReg, rd};
        //          32       32          1     1        1         1         1         4 = 73
    end
endmodule
