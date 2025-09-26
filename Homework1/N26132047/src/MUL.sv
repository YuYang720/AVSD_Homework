module MUL (
    input logic [31:0] src1,
    input logic [31:0] src2,
    input logic [ 2:0] EX_func3,
    
    output logic [31:0] mul_out
);

    logic signed [63:0] product;
    logic signed [32:0] operand1, operand2;

    always_comb begin
        case (EX_func3)
            `MUL: begin
                operand1 = {src1[31], src1};
                operand2 = {src2[31], src2};
            end
            `MULH: begin
                operand1 = {src1[31], src1};
                operand2 = {src2[31], src2};
            end
            `MULHSU: begin
                operand1 = {src1[31], src1};
                operand2 = {1'b0, src2};
            end
            `MULHU:  begin
                operand1 = {1'b0, src1};
                operand2 = {1'b0, src2};
            end
            default: begin
                operand1 = {src1[31], src1};
                operand2 = {src2[31], src2};
            end
        endcase
    end

    assign product = operand1 * operand2;

    always_comb begin
        if (EX_func3 == `MUL) begin
            mul_out = product[31:0];
        end else begin
            mul_out = product[63:32];
        end
    end

endmodule
