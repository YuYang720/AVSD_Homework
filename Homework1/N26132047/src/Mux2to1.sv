module Mux2to1 (
    input logic [31:0] in_0,
    input logic [31:0] in_1,
    input logic        sel,
    
    output logic [31:0] mux_out
);

    always_comb begin 
        case (sel)
            1'b0: mux_out = in_0;
            1'b1: mux_out = in_1; 
        endcase
    end
    
endmodule