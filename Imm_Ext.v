module Imm_Ext ( 
    input [31:0] inst, 
    output reg [31:0] imm_ext_out 
);

always @(*) begin
    // R-type
    if (inst[6:2] == 5'b01100) begin
        imm_ext_out = inst;
    end

    // I-type
    else if (inst[6:2] == 5'b11001 || inst[6:2] == 5'b00000 || inst[6:2] == 5'b00100) begin
        imm_ext_out = {{20{inst[31]}}, inst[31:20]};
    end

    // S-type
    else if (inst[6:2] == 5'b01000) begin
        imm_ext_out = {{20{inst[31]}}, inst[31:25], inst[11:7]};
    end

    // B-type
    else if (inst[6:2] == 5'b11000) begin
        imm_ext_out = {{20{inst[31]}}, inst[7], inst[30:25], inst[11:8], 1'b0};
    end

    // U-type
    else if (inst[6:2] == 5'b01101 || inst[6:2] == 5'b00101) begin
        imm_ext_out = {inst[31:12], 12'b0};
    end

    // J-type
    else if (inst[6:2] == 5'b11011) begin
        imm_ext_out = {{12{inst[31]}}, inst[19:12], inst[20], inst[30:21], 1'b0};
    end
end
    

endmodule