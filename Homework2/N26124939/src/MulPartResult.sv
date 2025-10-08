module MulPartResult(
    input logic [31:0] mem_mul_op1_i,
    input logic [31:0] mem_mul_op2_i,

    output logic [31:0] mem_mul_temp_part1_o,
    output logic [31:0] mem_mul_temp_part2_o,
    output logic [31:0] mem_mul_temp_part3_o,
    output logic [31:0] mem_mul_temp_part4_o
);

    assign mem_mul_temp_part1_o = mem_mul_op1_i[ 15:0] * mem_mul_op2_i[ 15:0];
    assign mem_mul_temp_part2_o = mem_mul_op1_i[ 15:0] * mem_mul_op2_i[31:16];
    assign mem_mul_temp_part3_o = mem_mul_op1_i[31:16] * mem_mul_op2_i[ 15:0];
    assign mem_mul_temp_part4_o = mem_mul_op1_i[31:16] * mem_mul_op2_i[31:16];

endmodule : MulPartResult