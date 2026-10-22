`timescale 1ns / 1ps

module control_unit(input [3:0] opcode,
output reg [1:0] ALUOp,
output reg RegWrite,
output reg ALUSrc,
output reg RegDst,
output reg MemRead,
output reg MemWrite,
output reg MemtoReg
);
    always @(*) begin
    RegWrite = 0;
    RegDst   = 0;
    MemtoReg = 0;
    MemWrite = 0;
    MemRead  = 0;
    ALUSrc   = 0;
    ALUOp    = 2'b00;
    case(opcode)
4'b0000: begin // SUBI  
        ALUOp   = 2'b10;
        RegWrite = 1'b1;
        ALUSrc  = 1'b1;
        RegDst  = 1'b0;
        MemRead  = 1'b0;
        MemWrite = 1'b0;
        MemtoReg = 1'b0;  // ? fixed: ALU result, not memory
    end
    4'b0100: begin // LW
        ALUOp   = 2'b00;
        ALUSrc  = 1'b1;
        RegWrite = 1'b1;
        RegDst  = 1'b0;
        MemRead  = 1'b1;  // ? fixed
        MemWrite = 1'b0;
        MemtoReg = 1'b1;
    end
    4'b0010: begin // LW
        ALUOp   = 2'b00;
        RegWrite = 1'b1;
        ALUSrc  = 1'b1;
        RegDst  = 1'b0;
        MemRead  = 1'b1;  // ? fixed
        MemWrite = 1'b0;  // ? fixed
        MemtoReg = 1'b1;
    end
    4'b0001: begin // NOR
        ALUSrc  = 1'b0;
        RegDst  = 1'b1;   // ? fixed
        MemRead  = 1'b0;
        MemWrite = 1'b0;
        ALUOp   = 2'b11;
        RegWrite = 1'b1;
        MemtoReg = 1'b0;
    end
    4'b1111: begin // SW
        ALUOp   = 2'b00;  // ? fixed: SW needs ADD for address calculation
        RegWrite = 1'b0;
        ALUSrc  = 1'b1;
        RegDst  = 1'b0;
        MemRead  = 1'b0;
        MemWrite = 1'b1;
        MemtoReg = 1'b0;
    end
    
    endcase
    end
endmodule
