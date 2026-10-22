`timescale 1ns / 1ps

module forwarding(
    input [3:0] ID_EX_Rs,
	input [3:0] ID_EX_Rt,
	input [3:0] EX_MEM_Rd,
	input [3:0] MEM_WB_Rd,
	input EX_MEM_RegWrite,
	input MEM_WB_RegWrite,
	output reg [1:0] ForwardA,
	output reg [1:0] ForwardB
    );
    
    always @(*) begin
    ForwardA=2'b00;
    ForwardB=2'b00;
    
    if((EX_MEM_RegWrite == 1'b1) && (EX_MEM_Rd != 4'b0000) && (EX_MEM_Rd == ID_EX_Rs)) begin
			ForwardA = 2'b10;
		end else if((MEM_WB_RegWrite == 1'b1) && (MEM_WB_Rd != 4'b0000) && (MEM_WB_Rd == ID_EX_Rs)) begin
			ForwardA = 2'b01;
		end
		
		if((EX_MEM_RegWrite == 1'b1) && (EX_MEM_Rd != 4'b0000) && (EX_MEM_Rd == ID_EX_Rt)) begin
			ForwardB = 2'b10;
		end else if((MEM_WB_RegWrite == 1'b1) && (MEM_WB_Rd != 4'b0000) && (MEM_WB_Rd == ID_EX_Rt)) begin
			ForwardB = 2'b01;
		end
    end
endmodule
