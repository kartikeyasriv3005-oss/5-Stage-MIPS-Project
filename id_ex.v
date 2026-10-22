`timescale 1ns / 1ps

module id_ex(
    input stall,
    input flush,
    input clk,
    input [31:0] pc_plus_four,
    input [31:0] rd1, rd2,
    input [31:0] im_sign_extend,
    input MemtoReg, MemRead, MemWrite, RegDst, RegWrite,
    input ALUSrc,
    input [1:0] ALUOp,
    input [3:0] rs, rt, rd,
    output reg [147:0] reg_out
);
    always @(posedge clk) begin
        if (stall || flush) begin
            reg_out <= 148'b0;
        end else begin
            reg_out <= {
                RegWrite, rs, rt, rd,
                pc_plus_four, rd1, rd2, im_sign_extend,
                MemtoReg, MemRead, MemWrite, ALUOp, RegDst, ALUSrc
            };
        end
    end
endmodule
