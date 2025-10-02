module ID_EX_reg (
    input logic        clk,
    input logic        rst,
    input logic        stall,
    input logic        flush,
    input logic [31:0] ID_pc,
    input logic [ 6:0] ID_op,
    input logic [ 2:0] ID_func3,
    input logic [ 6:0] ID_func7,
    input logic [ 4:0] ID_rd,
    input logic [ 4:0] ID_rs1,
    input logic [ 4:0] ID_rs2,
    input logic [31:0] ID_rs1_data,
    input logic [31:0] ID_rs2_data,
    input logic [31:0] ID_imm_ext,

    input logic       ID_btb_hit,
    input logic       ID_gbc_predict_taken,
    input logic [3:0] ID_bhr,

    output logic       EX_btb_hit,
    output logic       EX_gbc_predict_taken,
    output logic [3:0] EX_bhr,
    
    output logic [31:0] EX_pc,
    output logic [ 6:0] EX_op,
    output logic [ 2:0] EX_func3,
    output logic [ 6:0] EX_func7,
    output logic [ 4:0] EX_rd,
    output logic [ 4:0] EX_rs1,
    output logic [ 4:0] EX_rs2,
    output logic [31:0] EX_rs1_data,
    output logic [31:0] EX_rs2_data,
    output logic [31:0] EX_imm_ext
);

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            EX_pc       <= 32'b0;
            EX_op       <= 7'b0;
            EX_func3    <= 3'b0;
            EX_rd       <= 5'b0;
            EX_rs1      <= 5'b0;
            EX_rs2      <= 5'b0;
            EX_func7    <= 7'b0;
            EX_rs1_data <= 32'b0;
            EX_rs2_data <= 32'b0;
            EX_imm_ext  <= 32'b0;
        end else if (stall || flush) begin
			EX_pc       <= 32'b0;
            EX_op       <= 7'b0010011;
            EX_func3    <= 3'b0;
            EX_rd       <= 5'b0;
            EX_rs1      <= 5'b0;
            EX_rs2      <= 5'b0;
            EX_func7    <= 7'b0;
            EX_rs1_data <= 32'b0;
            EX_rs2_data <= 32'b0;
            EX_imm_ext  <= 32'b0;
		end else begin
            EX_pc       <= ID_pc;
            EX_op       <= ID_op;
            EX_func3    <= ID_func3;
            EX_rd       <= ID_rd;
            EX_rs1      <= ID_rs1;
            EX_rs2      <= ID_rs2;
            EX_func7    <= ID_func7;
            EX_rs1_data <= ID_rs1_data;
            EX_rs2_data <= ID_rs2_data;
            EX_imm_ext  <= ID_imm_ext;
        end
    end

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            EX_btb_hit <= 1'b0;
            EX_gbc_predict_taken <= 1'b0;
            EX_bhr <= 4'b0;
        end else if (stall || flush) begin
            EX_btb_hit <= 1'b0;
            EX_gbc_predict_taken <= 1'b0;
            EX_bhr <= 4'b0;
        end else begin
            EX_btb_hit <= ID_btb_hit;
            EX_gbc_predict_taken <= ID_gbc_predict_taken;
            EX_bhr <= ID_bhr;
        end      
    end

endmodule
