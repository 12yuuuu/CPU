module Mux (
    input wire sel,
    input wire [31:0] data0,
    input wire [31:0] data1,
    output reg [31:0] result
);

    always @(*) begin
    if (sel)
            result = data1;
    else 
            result = data0;
    end

endmodule