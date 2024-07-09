module Reg_PC ( 
    input clk, 
    input rst, 
    input [31:0] next_pc, 
    output reg [31:0] current_pc 
);

    reg [31:0] reg_pc;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            //reset
            reg_pc <= 32'h0000_0000;
        end else begin
            //update current_pc
            reg_pc <= next_pc;
        end
    end
    
    assign current_pc = reg_pc;

endmodule