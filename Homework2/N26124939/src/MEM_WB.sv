`timescale 1ns/10ps
module MEM_WB(
    input logic clk_i,
    input logic rst_i,
    input logic mem_mul_i,
    input logic stall_axi_im_i,
    input logic stall_axi_dm_i,
    input logic mem_mem_read_i,
    input logic mem_reg_write_i,
    input logic [ 1:0] mem_rs1_rs2_sign_i,
    input logic [ 2:0] mem_insn_funct3_i,
    input logic [ 4:0] mem_rd_i,
    input logic [31:0] mem_pc_i,
    input logic [31:0] mem_insn_i,
    input logic [31:0] mem_alu_result_i,
    input logic [31:0] mem_mem_read_data_i,
    input logic [31:0] mem_mul_temp_part1_i,
    input logic [31:0] mem_mul_temp_part2_i,
    input logic [31:0] mem_mul_temp_part3_i,
    input logic [31:0] mem_mul_temp_part4_i,

    output logic wb_mul_o,
    output logic wb_mem_read_o,
    output logic wb_reg_write_o,
    output logic [ 1:0] wb_rs1_rs2_sign_o,
    output logic [ 2:0] wb_insn_funct3_o,
    output logic [ 4:0] wb_rd_o,
    output logic [31:0] wb_pc_o,
    output logic [31:0] wb_insn_o,
    output logic [31:0] wb_alu_result_o,
    output logic [31:0] wb_mem_read_data_o,
    output logic [31:0] wb_mul_temp_part1_o,
    output logic [31:0] wb_mul_temp_part2_o,
    output logic [31:0] wb_mul_temp_part3_o,
    output logic [31:0] wb_mul_temp_part4_o
);

    always_ff @(posedge clk_i or posedge rst_i) begin
        if (rst_i) begin
            wb_mul_o             <= 1'b0;
            wb_mem_read_o        <= 1'b0;
            wb_reg_write_o       <= 1'b0;
            wb_rs1_rs2_sign_o    <= 2'b0;
            wb_insn_funct3_o     <= 3'b0;
            wb_rd_o              <= 5'b0;
            wb_pc_o              <= 32'b0;
            wb_insn_o            <= `INST_NOP;
            wb_alu_result_o      <= 32'b0;
            wb_mem_read_data_o   <= 32'b0;
            wb_mul_temp_part1_o  <= 32'b0;
            wb_mul_temp_part2_o  <= 32'b0;
            wb_mul_temp_part3_o  <= 32'b0;
            wb_mul_temp_part4_o  <= 32'b0;
        end else if (stall_axi_im_i || stall_axi_dm_i) begin
            ;
        end else begin
            wb_mul_o             <= mem_mul_i;
            wb_mem_read_o        <= mem_mem_read_i;
            wb_reg_write_o       <= mem_reg_write_i;
            wb_rs1_rs2_sign_o    <= mem_rs1_rs2_sign_i;
            wb_insn_funct3_o     <= mem_insn_funct3_i;
            wb_rd_o              <= mem_rd_i;
            wb_pc_o              <= mem_pc_i;
            wb_insn_o            <= mem_insn_i;
            wb_alu_result_o      <= mem_alu_result_i;
            wb_mem_read_data_o   <= mem_mem_read_data_i;
            wb_mul_temp_part1_o  <= mem_mul_temp_part1_i;
            wb_mul_temp_part2_o  <= mem_mul_temp_part2_i;
            wb_mul_temp_part3_o  <= mem_mul_temp_part3_i;
            wb_mul_temp_part4_o  <= mem_mul_temp_part4_i;
        end
    end

endmodule : MEM_WB