`timescale 1ns / 1ps

module if_id(
    input stall, clk, rst,
    input [31:0] pc_plus_four, instr,
    output reg [63:0] reg_out
);
    always @(posedge clk) begin
        if (rst)
            reg_out <= 64'b0;
        else if (~stall)
            reg_out <= {pc_plus_four, instr};
    end
endmodule
