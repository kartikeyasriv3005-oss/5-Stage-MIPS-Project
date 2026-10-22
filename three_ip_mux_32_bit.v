`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.04.2026 09:30:49
// Design Name: 
// Module Name: two_ip_mux_32_bit
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module three_ip_mux_32_bit(
input [31:0] a,b,c,
input [1:0] sel,
output reg [31:0] out
);
always @(*) begin
    case (sel)
    2'b00: out = a;
    2'b10: out = b;
    2'b01: out = c;
    default out = a;
    endcase
    end
endmodule