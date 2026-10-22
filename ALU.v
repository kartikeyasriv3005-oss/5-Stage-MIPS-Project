module ALU (
    input wire [31:0] a,
    input wire [31:0] b,
    input wire [1:0] alu_op,
    output reg [31:0] result,
    output reg zero
);

always @(*) begin
    case (alu_op)
        2'b00: result = a + b;       // ADD
        2'b10: result = a - b;       // SUBTRACT
        2'b11: result = ~(a | b);    // NOR
        default: result = 32'h0;
    endcase
    zero = (result == 32'b0);
end

endmodule
