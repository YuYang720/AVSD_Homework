module JB_target_gen (
    input [31:0] EX_reg_src1_data,
    input [31:0] EX_pc,
    input [31:0] EX_imm_ext,
    input [ 6:0] EX_op,
    output [31:0] jb_target
);
    logic [31:0] temp;

    // JAL 提前到 ID stage 處理
    // JALR 在 EX stage : Ex_reg_src1 _data + EX_imm_ext 再 mask
    // Branch : EX_pc + EX_imm_ext
    assign temp = (EX_op == `JALR) ? EX_reg_src1_data : EX_pc;

    assign jb_target = (temp + EX_imm_ext) & 32'hFFFFFFFE;

endmodule
