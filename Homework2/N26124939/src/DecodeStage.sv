`include "Defines.sv"
`timescale 1ns/10ps
module DecodeStage(
    input logic [31:0] id_insn_i,

    output logic [ 6:0] id_insn_funct7_o,
    output logic [ 6:0] id_insn_opcode_o,
    output logic [ 4:0] id_rd_o,
    output logic [ 4:0] id_rs1_o,
    output logic [ 4:0] id_rs2_o
);

    assign id_insn_funct7_o = id_insn_i[31:25];
    assign id_insn_opcode_o = id_insn_i[6:0];
    assign id_rd_o          = id_insn_i[11:7];
    assign id_rs1_o         = id_insn_i[19:15];
    assign id_rs2_o         = id_insn_i[24:20];

endmodule : DecodeStage