module MUL (
    input logic [31:0] src1,
    input logic [31:0] src2,
    input logic [ 2:0] EX_func3,
    
    output logic [31:0] mul_out
);


wire signed [63:0] product;
wire signed [32:0] operand1, operand2;

assign operand1 = (EX_func3 == `MULHU) ? {1'b0, src1} : {src1[31], src1};
assign operand2 = (EX_func3 == `MULHU || EX_func3 == `MULHSU) ? {1'b0, src2} : {src2[31], src2};

assign product = operand1 * operand2;
assign mul_out = (EX_func3 == `MUL)? product[31:0] : product[63:32];

endmodule
