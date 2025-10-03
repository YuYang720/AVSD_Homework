module Mux4to1 (
    input logic [31:0] in_0,
    input logic [31:0] in_1,
    input logic [31:0] in_2,
    input logic [31:0] in_3,
    // input logic [31:0] in_4,
    input logic [ 1:0] sel,
    output logic [31:0] mux_out
);

    always_comb begin
        case (sel)
            2'd0: mux_out = in_0; 
            2'd1: mux_out = in_1; 
            2'd2: mux_out = in_2; 
            2'd3: mux_out = in_3; 
            // 3'd4: mux_out = in_4;
            default: mux_out = in_3;
        endcase
    end
    
endmodule