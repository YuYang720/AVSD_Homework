`include "Defines.sv"
`timescale 1ns/10ps
module ID_EX(
    input logic clk_i,
    input logic rst_i,
    input logic stall_i,
    input logic stall_axi_im_i,
    input logic stall_axi_dm_i,
    input logic id_valid_i,
    input logic id_mul_i,
    input logic id_branch_i,
    input logic id_mem_store_i,
    input logic id_mem_read_i,
    input logic id_reg_write_i,
    input logic id_flush_i,
    input logic ex_flush_i,
    input logic [ 4:0] id_rd_i,
    input logic [ 4:0] id_rs1_i,
    input logic [ 4:0] id_rs2_i,
    input logic [31:0] id_insn_i,
    input logic [31:0] id_rs1_data_i,
    input logic [31:0] id_rs2_data_i,
    input logic [31:0] id_immediate_gen_i,
    input logic [31:0] id_pc_i,
    input logic [31:0] id_pc_add4_i,
    input logic [31:0] id_pc_add_imm_i,

    output logic ex_mul_o,
    output logic ex_branch_o,
    output logic ex_mem_store_o,
    output logic ex_mem_read_o,
    output logic ex_reg_write_o,
    output logic [ 4:0] ex_rd_o,
    output logic [ 4:0] ex_rs1_o,
    output logic [ 4:0] ex_rs2_o,
    output logic [31:0] ex_insn_o,
    output logic [31:0] ex_rs1_data_o,
    output logic [31:0] ex_rs2_data_o,
    output logic [31:0] ex_immediate_gen_o,
    output logic [31:0] ex_pc_o,
    output logic [31:0] ex_pc_add4_o,
    output logic [31:0] ex_pc_add_imm_o,
    output logic [63:0] ex_instret_o,
    output logic [63:0] ex_cycle_o
);
    logic [63:0] instret, cycle;
    assign ex_instret_o  = instret;
    assign ex_cycle_o    = cycle;

    always_ff @(posedge clk_i or posedge rst_i) begin
        if (rst_i) begin
            instret            <= 64'hffffffffffffffff;
            cycle              <= 64'hffffffffffffffff;
            ex_mul_o           <= 1'b0;
            ex_branch_o        <= 1'b0;
            ex_mem_store_o     <= 1'b0;
            ex_mem_read_o      <= 1'b0;
            ex_reg_write_o     <= 1'b0;
            ex_rd_o            <= 5'd0;
            ex_rs1_o           <= 5'd0;
            ex_rs2_o           <= 5'd0;
            ex_insn_o          <= `INST_NOP;
            ex_rs1_data_o      <= 32'b0;
            ex_rs2_data_o      <= 32'b0;
            ex_immediate_gen_o <= 32'b0;
            ex_pc_o            <= 32'b0;
            ex_pc_add4_o       <= 32'b0;
            ex_pc_add_imm_o    <= 32'b0;
        end else if (stall_axi_im_i || stall_axi_dm_i) begin
            ;
        end else if (ex_flush_i == 1'b1) begin
            cycle              <= cycle + 1'b1;
            instret            <= instret;
            ex_insn_o          <= `INST_NOP;
            ex_mul_o           <= 1'b0;
            ex_branch_o        <= 1'b0;
            ex_mem_store_o     <= 1'b0;
            ex_mem_read_o      <= 1'b0;
            ex_reg_write_o     <= 1'b0;
        end else if (stall_i == 1'b1) begin
            cycle              <= cycle + 1'b1;
            instret            <= instret;
            ex_insn_o          <= `INST_NOP;
            ex_mul_o           <= 1'b0;
            ex_branch_o        <= 1'b0;
            ex_mem_store_o     <= 1'b0;
            ex_mem_read_o      <= 1'b0;
            ex_reg_write_o     <= 1'b0;
        end else if (id_valid_i == 1'b1) begin
            instret            <= instret + 1'b1;
            cycle              <= cycle   + 1'b1;
            ex_mul_o           <= id_mul_i;
            ex_branch_o        <= id_branch_i;
            ex_mem_store_o     <= id_mem_store_i;
            ex_mem_read_o      <= id_mem_read_i;
            ex_reg_write_o     <= id_reg_write_i;
            ex_rd_o            <= id_rd_i;
            ex_rs1_o           <= id_rs1_i;
            ex_rs2_o           <= id_rs2_i;
            ex_insn_o          <= id_insn_i;
            ex_rs1_data_o      <= id_rs1_data_i;
            ex_rs2_data_o      <= id_rs2_data_i;
            ex_immediate_gen_o <= id_immediate_gen_i;
            ex_pc_o            <= id_pc_i;
            ex_pc_add4_o       <= id_pc_add4_i;
            ex_pc_add_imm_o    <= id_pc_add_imm_i;
        end else begin
            instret            <= instret;
            cycle              <= cycle + 1'b1;
            ex_mul_o           <= 1'b0;
            ex_branch_o        <= 1'b0;
            ex_mem_store_o     <= 1'b0;
            ex_mem_read_o      <= 1'b0;
            ex_reg_write_o     <= 1'b0;
        end
    end

endmodule : ID_EX
