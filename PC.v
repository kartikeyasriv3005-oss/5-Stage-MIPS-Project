`timescale 1ns / 1ps

module PC(
input clk,
input rst,
input  stall,
input [31:0] pc_in,
output reg [31:0] pc_out
);

always @(posedge clk) begin
    if (rst) begin
        pc_out <= 32'b0;
        end
    else begin
        if (stall == 1'b0) begin
        pc_out <= pc_in;
        end
    end
end

endmodule
