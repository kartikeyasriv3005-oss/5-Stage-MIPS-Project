`timescale 1ns / 1ps

module adder(input [31:0] a,b, input cin, output [31:0] sum, output cout);
    wire [32:0] temp;
    assign temp = {1'b0, a} + {1'b0, b} + {1'b0, cin};
    assign sum = temp[31:0];
    assign cout = temp[32];
endmodule
