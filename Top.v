`include "SRAM.v" 
`include "RegFile.v"  
`include "Reg_PC.v"  
`include "Mux.v"  
`include "LD_Fliter.v"  
`include "JB_Unit.v"  
`include "Imm_Ext.v"    
`include "Decoder.v"
`include "Controller.v"
`include "ALU.v"  

module Top (
input sysclk, 
input sysrst
);

wire [31:0] inst_wire, rs1_data_wire, rs2_data_wire, pc_wire, next_pc_wire, alu_out_wire, ld_data_wire, ld_data_f_wire, wb_data_wire, jb_pc_wire, sext_imme_wire;
wire [4:0] opcode_wire, rs1_index_wire, rs2_index_wire, rd_index_wire;
wire [2:0] func3_wire;
wire func7_wire, next_pc_sel_wire, wb_en_wire, jb_op1_sel_wire, alu_op1_sel_wire, alu_op2_sel_wire, wb_sel_wire;
wire [3:0] im_w_en_wire, dm_w_en_wire;
wire [31:0] mux1_wire, mux2_wire, mux3_wire;

SRAM im(
    .clk(sysclk), 
    .w_en1(im_w_en_wire),   //write_enable(always 0)
    .address1(pc_wire[15:0]), 
    .write_data1(), //nothing 
    .read_data1(inst_wire)
);

Decoder decoder (
    .inst(inst_wire),
    .dc_out_opcode(opcode_wire),
    .dc_out_func3(func3_wire),
    .dc_out_func7(func7_wire),
    .dc_out_rs1_index(rs1_wire),
    .dc_out_rs2_index(rs2_wire),
    .dc_out_rd_index(rd_wire)
);

SRAM dm(
    .clk(sysclk), 
    .w_en0(dm_w_en_wire),   //write_enable
    .address0(alu_out_wire[15:0]), 
    .write_data0(rs2_data_wire), 
    .read_data0(ld_data_wire) 
);

RegFile regfile (
    .clk(sysclk), 
    .wb_en_r(wb_en_wire), 
    .wb_data_r(wb_data_wire), 
    .rd_index_r(rd_index_wire), 
    .rs1_index_r(rs1_index_wire), 
    .rs2_index_r(rs2_index_wire), 
    .rs1_data_out_r(rs1_data_wire), 
    .rs2_data_out_r(rs2_data_wire) 
);

Controller controller(
    .opcode(opcode_wire), 
    .func3(func3_wire), 
    .func7(func7_wire),
    .next_pc_sel(next_pc_sel_wire),
    .im_w_en(im_w_en_wire),
    .wb_en(wb_data_wire),
    .jb_op1_sel(jb_op1_sel_wire),
    .alu_op1_sel(alu_op1_sel_wire),
    .alu_op2_sel(alu_op2_sel_wire),
    .opcode_alu(opcode_wire), 
    .func3_alu(func3_wire), 
    .func7_alu(func7_wire),
    .wb_sel(wb_sel_wire),
    .dm_w_en(dm_w_en_wire),
);

Imm_Ext imm_ext (
    .inst(inst_wire),
    .imm_ext_out(sext_imme_wire)
);

JB_Unit jb_unit (
    .operand1(mux3_wire),
    .operand2(sext_imme_wire),
    .jb_out(jb_pc_wire)
);

LD_Filter ld_filter (
    .func3(func3_wire),
    .ld_data(ld_data_wire),
    .ld_data_f(ld_data_f_wire)
);

Reg_PC reg_pc (
    .clk(sysclk),
    .rst(sysrst),
    .next_pc(next_pc_wire),
    .current_pc(pc_wire)
);

ALU alu (
    .opcode(opcode_wire),
    .func3(func3_wire),
    .func7(func7_wire),
    .operand1(mux1_wire),
    .operand2(mux2_wire),
    .alu_out(alu_out_wire)
);

Mux mux_pc (
    .sel_p(next_pc_sel_wire),
    .data0_p(pc_wire),
    .data1_p(jb_pc_wire),
    .result_p(next_pc_wire)
);

Mux mux_alu1 (
    .sel_1(alu_op1_sel_wire),
    .data0_1(rs1_data_wire),
    .data1_1(pc_wire),
    .result_1(mux1_wire)
);

Mux mux_alu2 (
    .sel_2(alu_op2_sel_wire),
    .data0_2(rs2_data_wire),
    .data1_2(sext_imme_wire),
    .result_2(mux2_wire)
);

Mux mux_jb (
    .sel_j(jb_op1_sel_wire),
    .data0_j(rs1_data_wire),
    .data1_j(pc_wire),
    .result_j(mux3_wire)
);

Mux mux_data (
    .sel_d(wb_sel_wire),
    .data0_d(alu_out_wire),
    .data1_d(ld_data_f_wire),
    .result_d(wb_data_wire)
);
  
endmodule

