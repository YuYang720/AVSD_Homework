`include "Defines.sv"
`timescale 1ns/10ps
module ImmGen(
    input logic [31:0] id_insn_i,

    output logic [31:0] id_immediate_gen_o
);
    logic [6:0] opcode;

    assign opcode = id_insn_i[6:0];

    always_comb begin
        case(opcode)
            `INST_TYPE_I     : id_immediate_gen_o = {{20{id_insn_i[31]}},id_insn_i[31:20]};
            `INST_TYPE_L     : id_immediate_gen_o = {{20{id_insn_i[31]}},id_insn_i[31:20]};
            `INST_TYPE_JALR  : id_immediate_gen_o = {{20{id_insn_i[31]}},id_insn_i[31:20]};
            `INST_TYPE_S     : id_immediate_gen_o = {{20{id_insn_i[31]}},id_insn_i[31:25],id_insn_i[11:7]};
            `INST_TYPE_B     : id_immediate_gen_o = {{19{id_insn_i[31]}},id_insn_i[31],id_insn_i[7],id_insn_i[30:25],id_insn_i[11:8],1'b0};
            `INST_TYPE_LUI   : id_immediate_gen_o = {id_insn_i[31:12],12'b0};
            `INST_TYPE_AUIPC : id_immediate_gen_o = {id_insn_i[31:12],12'b0};
            `INST_TYPE_JAL   : id_immediate_gen_o = {{11{id_insn_i[31]}},id_insn_i[31],id_insn_i[19:12],id_insn_i[20],id_insn_i[30:21],1'b0};
            default          : id_immediate_gen_o = 32'hxxxx_xxxx;
        endcase
    end

endmodule : ImmGen