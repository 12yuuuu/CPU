module LD_Filter ( 
    input [2:0] func3, 
    input [31:0] ld_data, 
    output [31:0] ld_data_f 
);

    always @(*) begin
        case(func3)
            3'b000: ld_data_f = ld_data; // b
            3'b001: ld_data_f = ld_data & 32'h0000FFFF; // h
            3'b010: ld_data_f = ld_data >> 16; // w
            default: ld_data_f = 32'b0;
        endcase
    end

endmodule