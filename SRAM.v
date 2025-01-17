module SRAM ( 
    input clk, 
    input [3:0] w_en,   //write_enable
    input [15:0] address, 
    input [31:0] write_data, 
    output [31:0] read_data 
);

    reg [7:0] mem [0:65535];

    always @(posedge clk) begin
        // Write operation
        if (w_en[0]) begin
            mem[address] <= write_data[7:0];
        end
        if (w_en[1]) begin
            mem[address] <= write_data[15:8];
        end
        if (w_en[2]) begin
            mem[address+2] <= write_data[23:16];
        end
        if (w_en[3]) begin
            mem[address+3] <= write_data[31:24];
        end

        // Read operation
        read_data <= {mem[address+3], mem[address+2], mem[address+1], mem[address]};
    end

endmodule
