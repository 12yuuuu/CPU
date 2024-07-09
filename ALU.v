module ALU ( 
    input [4:0] opcode, 
    input [2:0] func3, 
    input       func7, 
    input [31:0] operand1, 
    input [31:0] operand2, 
    output [31:0] alu_out 
);

    always @(*) begin
        case(opcode)
            // U-type operations
            5'b01101: alu_out = operand2 << 12; // LUI
            5'b00101: alu_out = operand1 + operand2; // AUIPC

            // J-type operations
            5'b11011: alu_out = operand1 + operand2; // JAL

            // I-type operations
            5'b11001: alu_out = operand1 + operand2; // JALR
            5'b11000: // Branch operations
                case(func3)
                    3'b000: alu_out = (operand1 == operand2) ? (operand1 + func7) : alu_out; // BEQ
                    3'b001: alu_out = (operand1 != operand2) ? (operand1 + func7) : alu_out; // BNE
                    3'b100: alu_out = (operand1 < operand2) ? (operand1 + func7) : alu_out; // BLT
                    3'b101: alu_out = (operand1 >= operand2) ? (operand1 + func7) : alu_out; // BGE
                    3'b110: alu_out = (operand1 < operand2) ? (operand1 + func7) : alu_out; // BLTU
                    3'b111: alu_out = (operand1 >= operand2) ? (operand1 + func7) : alu_out; // BGEU
                endcase

            // Load instructions
            5'b00000:
                case(func3)
                    3'b000: alu_out = operand1 + operand2; // LB
                    3'b001: alu_out = operand1 + operand2; // LH
                    3'b010: alu_out = operand1 + operand2; // LW
                    3'b100: alu_out = operand1 + operand2; // LBU
                    3'b101: alu_out = operand1 + operand2; // LHU
                endcase

            // Store instructions
            5'b01000:
                case(func3)
                    3'b000: alu_out = operand1 + operand2; // SB
                    3'b001: alu_out = operand1 + operand2; // SH
                    3'b010: alu_out = operand1 + operand2; // SW
                endcase

            // I-type operations
            5'b00100:
                case(func3)
                    3'b000: alu_out = operand1 + operand2; // ADDI
                    3'b010: alu_out = (signed(operand1) < signed(operand2)) ? 1 : 0; // SLTI
                    3'b011: alu_out = (operand1 < operand2) ? 1 : 0; // SLTIU
                    3'b100: alu_out = operand1 ^ operand2; // XORI
                    3'b110: alu_out = operand1 | operand2; // ORI
                    3'b111: alu_out = operand1 & operand2; // ANDI
                endcase

            // R-type operations
            5'b01100:
                case(func3)
                    3'b000:
                        case(func7)
                            7'b0000000: alu_out = operand1 + operand2; // ADD
                            7'b0100000: alu_out = operand1 - operand2; // SUB
                            7'b0000001: alu_out = operand1 << operand2; // SLL
                            7'b0100001: alu_out = (signed(operand1) < signed(operand2)) ? 1 : 0; // SLT
                            7'b0100010: alu_out = (operand1 < operand2) ? 1 : 0; // SLTU
                            7'b0000010: alu_out = operand1 ^ operand2; // XOR
                            7'b0000100: alu_out = operand1 >> operand2; // SRL
                            7'b0100100: alu_out = ((operand1 >> operand2) & (operand1[31] == 1)) ? (32'b1 << (32 - operand2) - 1) : (operand1 >> operand2); // SRA
                            7'b0001001: alu_out = operand1 << (operand2[4:0]); // SLLI
                            7'b0000000: alu_out = operand1 | operand2; // OR
                            7'b0000101: alu_out = operand1 & operand2; // AND
                        endcase
                endcase
        endcase
    end

endmodule