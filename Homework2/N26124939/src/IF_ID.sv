`include "Defines.sv"

module IF_ID(
    input logic clk_i,
    input logic rst_i,
    input logic stall_i,
    input logic stall_axi_im_i,
    input logic stall_axi_dm_i,
    input logic id_flush_i,
    input logic ex_flush_i,
    input logic [31:0] if_insn_axi_i,
    input logic [31:0] if_fetch_pc_i,

    output logic        if_valid_reg_o,
    output logic        id_valid_o,
    output logic [31:0] id_pc_o,
    output logic [31:0] if_pc_reg_o,
    output logic [31:0] id_insn_o
);
    logic        if_valid_reg;
    logic [31:0] if_pc_reg;
    assign if_pc_reg_o = if_pc_reg;
    assign if_valid_reg_o = if_valid_reg;

    always_ff @(posedge clk_i or posedge rst_i) begin
        if (rst_i) begin
            if_valid_reg <= 1'b0;
            if_pc_reg    <= 32'b0;
            id_valid_o   <= 1'b0;
            id_pc_o      <= 32'b0;
            id_insn_o    <= `INST_NOP;
        end else if ( stall_axi_im_i || stall_axi_dm_i) begin
            ;
        end
        else if (ex_flush_i == 1'b1) begin
            if_pc_reg    <= if_fetch_pc_i;
            if_valid_reg <= 1'b1;
            id_insn_o    <= `INST_NOP;
            id_valid_o   <= 1'b0;
            id_pc_o      <= 32'b0;
        end else if (stall_i == 1'b1) begin
            ;
        end else if (id_flush_i == 1'b1) begin
            if_valid_reg <= 1'b1;
            if_pc_reg    <= if_fetch_pc_i;
            id_valid_o   <= 1'b0;
            id_pc_o      <= 32'b0;
            id_insn_o    <= `INST_NOP;
        end else begin
            if_valid_reg <= 1'b1;
            if_pc_reg    <= if_fetch_pc_i;
            id_pc_o      <= if_pc_reg;
            id_insn_o    <= if_insn_axi_i;
            id_valid_o   <= if_valid_reg;
        end
    end
endmodule : IF_ID