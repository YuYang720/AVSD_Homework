`timescale 1ns/10ps
`include "Defines.sv"

module Control(
    input logic [6:0] id_insn_funct7_i,
    input logic [6:0] id_insn_opcode_i,

    output logic id_mul_o,
    output logic id_branch_o,
    output logic id_mem_store_o,
    output logic id_mem_read_o,
    output logic id_reg_write_o,
    output logic id_op1_is_reg_o,
    output logic id_op2_is_reg_o
);

    assign id_mul_o        = (id_insn_opcode_i == `INST_TYPE_R_M   && id_insn_funct7_i == 7'b0000001);
    assign id_branch_o     = (id_insn_opcode_i == `INST_TYPE_B);
    assign id_mem_store_o  = (id_insn_opcode_i == `INST_TYPE_S);
    assign id_mem_read_o   = (id_insn_opcode_i == `INST_TYPE_L);

    assign id_reg_write_o  = (id_insn_opcode_i == `INST_TYPE_L     || id_insn_opcode_i == `INST_TYPE_R_M  || id_insn_opcode_i == `INST_TYPE_I   ||
                              id_insn_opcode_i == `INST_TYPE_JAL   || id_insn_opcode_i == `INST_TYPE_JALR || id_insn_opcode_i == `INST_TYPE_LUI ||
                              id_insn_opcode_i == `INST_TYPE_AUIPC || id_insn_opcode_i == `INST_TYPE_CSR);
    assign id_op1_is_reg_o = (id_insn_opcode_i == `INST_TYPE_R_M   || id_insn_opcode_i == `INST_TYPE_I    || id_insn_opcode_i == `INST_TYPE_S   ||
                              id_insn_opcode_i == `INST_TYPE_L     || id_insn_opcode_i == `INST_TYPE_JALR || id_insn_opcode_i == `INST_TYPE_B   );
    assign id_op2_is_reg_o = (id_insn_opcode_i == `INST_TYPE_R_M   || id_insn_opcode_i == `INST_TYPE_S    || id_insn_opcode_i == `INST_TYPE_B   );

endmodule : Control