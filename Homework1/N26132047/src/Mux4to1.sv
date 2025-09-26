module Mux4to1 (
    input logic [31:0] in_0,
    input logic [31:0] in_1,
    input logic [31:0] in_2,
    input logic [31:0] in_3,
    input logic [ 1:0] sel,
    output logic [31:0] mux_out
);

    always_comb begin
        case (sel)
            2'b00: mux_out = in_0; 
            2'b01: mux_out = in_1; 
            2'b10: mux_out = in_2; 
            2'b11: mux_out = in_3; 
            default: mux_out = in_3;
        endcase
    end
    
endmodule