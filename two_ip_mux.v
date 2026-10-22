`timescale 1ns / 1ps

module two_ip_mux(
input [31:0] a,b,
input sel,
output reg [31:0] out
);
always @(*) begin
    out = sel ? b : a;
    end
endmodule
