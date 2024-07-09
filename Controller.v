module Controller ( 
    input [4:0]  opcode, 
    input [2:0]  func3, 
    input        func7,
    output       next_pc_sel,
    output [3:0] im_w_en,
    output       wb_en,
    output       jb_op1_sel,
    output       alu_op1_sel,
    output       alu_op2_sel,
    output [4:0]  opcode_alu, 
    output [2:0]  func3_alu, 
    output        func7_alu,
    output       wb_sel,
    output [3:0] dm_w_en,
);

endmodule