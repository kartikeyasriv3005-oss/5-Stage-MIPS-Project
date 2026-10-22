module hazard #(parameter WIDTH = 4) (
    input [WIDTH-1:0] IF_ID_Rs,   // rs of instruction in ID stage
    input [WIDTH-1:0] IF_ID_Rt,   // rt of instruction in ID stage
    input [WIDTH-1:0] ID_EX_Rd,   // destination of instruction in ID/EX
    input ID_EX_MemRead,           // is ID/EX instruction a load?
    output reg stall
);
    always @(*) begin
        if (ID_EX_MemRead &&
           ((ID_EX_Rd == IF_ID_Rs) || (ID_EX_Rd == IF_ID_Rt))) begin
            stall = 1'b1;
        end else begin
            stall = 1'b0;
        end
    end
endmodule
