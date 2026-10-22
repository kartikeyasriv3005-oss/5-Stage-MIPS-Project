`timescale 1ns / 1ps



module top(input clk, input rst);
wire stall, RegRead, RegWrite, ALUSrc, RegDst,MemRead, MemWrite,zero,MemtoReg;
wire MemRead_out_1, MemWrite_out_1,MemtoReg_out_1,RegWrite_out_1, RegDst_out_1;
wire MemRead_out_2, MemWrite_out_2, RegWrite_out_2, zero_out_1,MemtoReg_out_2, reset, MemtoReg_out_3;
wire RegWrite_out_3, ALUSrc_out_1;   
wire [31:0] pc_in, pc_out, pc_plus_four, instr, write_data_in, rd1, rd2;
wire [31:0] im_sign_extend, pc_plus_four_out, pc_plus_four_out_2;
wire [31:0] rd1_out, rd2_out, im_sign_extend_out, ALUA,ALUB, result, result_out_1, ALUB_int;
wire [31:0] write_data, data_out, data_out_1, result_out_2, write_data_reg, write_data_mem;
wire [63:0] pr1_out;
wire [147:0] pr2_out;
wire [3:0] rs, rt, rd,rd_out_1, rd_out_2, rs_out_1, rt_out_1, rd_out_int, rd_out_3;
wire [1:0] ALUOp, ALUOp_out_1, ForwardA, ForwardB;
wire [3:0] opcode;
wire [72:0] pr3_out;
wire [69:0] pr4_out;
wire [15:0] im_value;

assign rs = pr1_out [23:20];
assign rt = pr1_out [19:16];
assign rd = pr1_out [27:24];
assign opcode = pr1_out [31:28];
assign im_value = pr1_out[15:0];
assign pc_plus_four_out = pr1_out[63:32];

assign RegWrite_out_1    = pr2_out[147];
assign rs_out_1          = pr2_out[146:143];
assign rt_out_1          = pr2_out[142:139];
assign rd_out_int        = pr2_out[138:135];
assign pc_plus_four_out_2= pr2_out[134:103];
assign rd1_out           = pr2_out[102:71];
assign rd2_out           = pr2_out[70:39];
assign im_sign_extend_out= pr2_out[38:7];
assign MemtoReg_out_1    = pr2_out[6];
assign MemRead_out_1     = pr2_out[5];
assign MemWrite_out_1    = pr2_out[4];
assign ALUOp_out_1       = pr2_out[3:2];
assign RegDst_out_1      = pr2_out[1];
assign ALUSrc_out_1      = pr2_out[0];  // new

assign result_out_1  = pr3_out[72:41];   // alu_out
assign write_data_mem= pr3_out[40:9];    // write_data (rt value for SW)
assign zero_out_1    = pr3_out[8];
assign MemRead_out_2 = pr3_out[7];
assign MemWrite_out_2= pr3_out[6];
assign RegWrite_out_2= pr3_out[5];
assign MemtoReg_out_2= pr3_out[4];
assign rd_out_2      = pr3_out[3:0];

assign RegWrite_out_3 = pr4_out[69];
assign rd_out_3 = pr4_out[68:65];
assign data_out_1 = pr4_out[64:33];
assign result_out_2 = pr4_out[32:1];
assign MemtoReg_out_3 = pr4_out[0];

reg stall_d;
always @(posedge clk) stall_d <= stall;


control_unit c1(opcode,ALUOp,RegWrite,ALUSrc,RegDst,MemRead,MemWrite, MemtoReg);
PC pc1 (clk, rst, stall, pc_plus_four, pc_out);
hazard h1(rs, rt, rd_out_int, MemRead_out_1, stall);
adder a1(pc_out, 32'd4, 1'd0, pc_plus_four,);
instr_mem i1 (clk, pc_out, instr);
if_id pr1 (stall, clk, rst, pc_plus_four, instr, pr1_out);
reg_file r1(clk, RegRead, RegWrite_out_3, rs, rt, rd_out_3, write_data_reg, rd1, rd2);
id_ex pr2 (stall, 1'b0, clk, pc_plus_four_out, rd1, rd2,
           {{16{im_value[15]}}, im_value},
           MemtoReg, MemRead, MemWrite, RegDst, RegWrite,ALUSrc,
           ALUOp, rs, rt, rd, pr2_out);
three_ip_mux_32_bit m1 (rd1_out, result_out_1, write_data_reg, ForwardA, ALUA);
three_ip_mux_32_bit m2 (rd2_out, result_out_1 ,write_data_reg,ForwardB,ALUB_int);
two_ip_mux m4(ALUB_int, im_sign_extend_out, ALUSrc_out_1, ALUB);
alu a2(ALUA,ALUB,ALUOp_out_1,result,zero);
ex_mem pr3(clk, result, ALUB_int,          // ? pass ALUB_int as write_data
           zero, MemRead_out_1, MemWrite_out_1,
           RegWrite_out_1, MemtoReg_out_1, rd_out_int, pr3_out);
data_memory d1(clk, rst, MemWrite_out_2, MemRead_out_2,
                          result_out_1, write_data_mem,   // ? was ALUB_int
                          data_out); 
mem_wb pr4 (clk, 1'b0, data_out, result_out_1,rd_out_2, MemtoReg_out_2, RegWrite_out_2,pr4_out);
two_ip_mux m3(result_out_2, data_out_1, MemtoReg_out_3, write_data_reg);
forwarding f1(rs_out_1, rt_out_1, rd_out_2, rd_out_3, RegWrite_out_2, RegWrite_out_3, ForwardA, ForwardB);

     
endmodule
