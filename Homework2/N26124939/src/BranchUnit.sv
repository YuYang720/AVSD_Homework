`include "Defines.sv"
`timescale 1ns/10ps
module BranchUnit(
    input logic clk_i,
    input logic rst_i,
    input logic ex_branch_i,
    input logic ex_flush_i,
    input logic stall_axi_im_i,
    input logic stall_axi_dm_i,
    input logic [6:0] id_insn_opcode_i,
    input logic [31:0] if_pc_reg_i,
    input logic [31:0] id_pc_i,
    input logic [31:0] id_immediate_gen_i,

    output logic id_flush_o,
    output logic [31:0] id_pc_add4_o,
    output logic [31:0] id_pc_add_imm_o,
    output logic [31:0] id_predict_jump_addr_o
);

    logic id_predict_w;
    logic [31:0] id_pc_add4_w;
    logic [31:0] id_pc_add_imm_w;
    logic [31:0] id_predict_jump_addr_w;

    assign id_pc_add4_w    = id_pc_i + 3'd4;
    assign id_pc_add_imm_w = id_pc_i + id_immediate_gen_i;

    assign id_pc_add4_o    = id_pc_add4_w;
    assign id_pc_add_imm_o = id_pc_add_imm_w;
    assign id_predict_jump_addr_o = id_predict_jump_addr_w;

    always_comb begin
        if (id_insn_opcode_i == `INST_TYPE_JAL) begin
            id_flush_o             = 1'b1;
            id_predict_jump_addr_w = id_pc_add_imm_w;
        end
        else if (id_insn_opcode_i == `INST_TYPE_B) begin
            id_predict_jump_addr_w = id_predict_w ? id_pc_add_imm_w : id_pc_add4_w;
            id_flush_o             = (id_predict_jump_addr_w !=  if_pc_reg_i);
        end else begin
            id_flush_o             = 1'b0;
            id_predict_jump_addr_w = 32'b0;
        end
    end

    logic [1:0] branchPredictState, branchPredictNextState;
    logic branchPredict;  //1 taken , 0 not taken

    //2 bits branch prediction
    localparam STRONGLY_NOT_TAKEN = 2'b00;
    localparam WEAKLY_NOT_TAKEN   = 2'b01;
    localparam WEAKLY_TAKEN       = 2'b10;
    localparam STRONGLY_TAKNE     = 2'b11;

    always_comb begin
        if (branchPredictState == STRONGLY_NOT_TAKEN) begin
            id_predict_w = 1'b0;
        end else if (branchPredictState == WEAKLY_NOT_TAKEN) begin
            id_predict_w = 1'b0;
        end else if (branchPredictState == WEAKLY_TAKEN) begin
            id_predict_w = 1'b1;
        end else if (branchPredictState == STRONGLY_TAKNE) begin
            id_predict_w = 1'b1;
        end else begin
            id_predict_w = 1'b0;
        end
    end

    always_comb begin
        if (ex_branch_i && ~stall_axi_im_i && ~stall_axi_dm_i) begin
            if (branchPredictState == STRONGLY_NOT_TAKEN && ex_flush_i == 1'b0) begin
                branchPredictNextState = STRONGLY_NOT_TAKEN;
            end else if (branchPredictState == STRONGLY_NOT_TAKEN && ex_flush_i == 1'b1) begin
                branchPredictNextState = WEAKLY_NOT_TAKEN;
            end else if (branchPredictState == WEAKLY_NOT_TAKEN && ex_flush_i == 1'b0) begin
                branchPredictNextState = STRONGLY_NOT_TAKEN;
            end else if (branchPredictState == WEAKLY_NOT_TAKEN && ex_flush_i == 1'b1) begin
                branchPredictNextState = WEAKLY_TAKEN;
            end else if (branchPredictState == WEAKLY_TAKEN && ex_flush_i == 1'b0) begin
                branchPredictNextState = STRONGLY_TAKNE;
            end else if (branchPredictState == WEAKLY_TAKEN && ex_flush_i == 1'b1) begin
                branchPredictNextState = WEAKLY_NOT_TAKEN;
            end else if (branchPredictState == STRONGLY_TAKNE && ex_flush_i == 1'b0) begin
                branchPredictNextState = STRONGLY_TAKNE;
            end else if (branchPredictState == STRONGLY_TAKNE && ex_flush_i == 1'b1) begin
                branchPredictNextState = WEAKLY_TAKEN;
            end else begin
                branchPredictNextState = WEAKLY_NOT_TAKEN;
            end
        end else begin
            branchPredictNextState = branchPredictState;
        end
    end

    always_ff @(posedge clk_i or posedge rst_i) begin
        if (rst_i) begin
            branchPredictState <= WEAKLY_NOT_TAKEN;
        end else begin
            branchPredictState <= branchPredictNextState;
        end
    end

endmodule : BranchUnit