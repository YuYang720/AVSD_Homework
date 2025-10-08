`include "Defines.sv"
`include "WritebackStage.sv"
`include "RegisterFile.sv"
`include "NextPC.sv"
`include "MulPartResult.sv"
`include "MEM_WB.sv"
`include "ImmGen.sv"
`include "IF_ID.sv"
`include "ID_EX.sv"
`include "HazardDetection.sv"
`include "ForwardingUnit.sv"
`include "FetchPC.sv"
`include "ExecuteStage.sv"
`include "EX_MEM.sv"
`include "DecodeStage.sv"
`include "Control.sv"
`include "BranchUnit.sv"
`timescale 1ns/10ps
module CPU(
    input  logic        clk_i               ,
    input  logic        rst_i               ,
    input  logic        if_insn_axi_valid_i ,
    input  logic [31:0] if_insn_axi_addr_i  ,
    input  logic [31:0] if_insn_axi_i       ,
    input  logic [31:0] mem_mem_read_data_i ,
    input  logic [31:0] mem_axi_raddr_i     ,
    input  logic [31:0] mem_axi_waddr_i     ,
    input  logic [3:0]  mem_axi_web_i       ,
    input  logic [31:0] mem_axi_wdata_i     ,
    input  logic        mem_axi_wvalid_i    ,
    input  logic        mem_axi_rvalid_i    ,

    output logic        mem_mem_store_o     ,
    output logic        mem_mem_read_o      ,
    output logic [3:0]  mem_mem_web_o       , //active low
    output logic [31:0] if_pc_reg_o         ,
    output logic [31:0] mem_mem_addr_o      ,
    output logic [31:0] mem_mem_wdata_o
);

    // Control Signal
    logic stall_w;
    logic stall_axi_im_w;
    logic stall_axi_dm_w;

    // IF stage
    logic        if_valid_reg_w;
    logic        if_insn_axi_valid_w;
    logic [31:0] if_insn_axi_w;
    logic [31:0] if_pc_reg_w;
    logic [31:0] if_next_pc_w;
    logic [31:0] if_fetch_pc_w;
    logic [31:0] if_insn_axi_addr_w;

    // ID stage
    logic        id_valid_w;
    logic        id_flush_w;
    logic        id_mul_w;
    logic        id_branch_w;
    logic        id_mem_store_w;
    logic        id_mem_read_w;
    logic        id_reg_write_w;
    logic        id_op1_is_reg_w;
    logic        id_op2_is_reg_w;
    logic  [4:0] id_rd_w;
    logic  [4:0] id_rs1_w;
    logic  [4:0] id_rs2_w;
    logic  [6:0] id_insn_funct7_w;
    logic  [6:0] id_insn_opcode_w;
    logic [31:0] id_insn_w;
    logic [31:0] id_pc_w;
    logic [31:0] id_pc_add4_w;
    logic [31:0] id_rs1_data_w;
    logic [31:0] id_rs2_data_w;
    logic [31:0] id_pc_add_imm_w;
    logic [31:0] id_immediate_gen_w;
    logic [31:0] id_predict_jump_addr_w;

    // EX stage
    logic        ex_mul_w;
    logic        ex_flush_w;
    logic        ex_branch_w;
    logic        ex_mem_store_w;
    logic        ex_mem_read_w;
    logic        ex_reg_write_w;
    logic  [1:0] ex_forwardA_w;
    logic  [1:0] ex_forwardB_w;
    logic  [1:0] ex_rs1_rs2_sign_w;
    logic  [1:0] ex_mem_raddr_index_w;
    logic  [2:0] ex_insn_funct3_w;
    logic  [3:0] ex_mem_web_w;
    logic  [4:0] ex_rs1_w;
    logic  [4:0] ex_rs2_w;
    logic  [4:0] ex_rd_w;
    logic [31:0] ex_rs1_data_w;
    logic [31:0] ex_rs2_data_w;
    logic [31:0] ex_pc_w;
    logic [31:0] ex_insn_w;
    logic [31:0] ex_mul_op1_w;
    logic [31:0] ex_mul_op2_w;
    logic [31:0] ex_pc_add4_w;
    logic [31:0] ex_mem_wdata_w;
    logic [31:0] ex_jump_addr_w;
    logic [31:0] ex_alu_result_w;
    logic [31:0] ex_pc_add_imm_w;
    logic [31:0] ex_immediate_gen_w;
    logic [63:0] ex_cycle_w;
    logic [63:0] ex_instret_w;

    // MEM stage
    logic        mem_mul_w;
    logic        mem_mem_store_w;
    logic        mem_mem_read_w;
    logic        mem_reg_write_w;
    logic        mem_axi_wvalid_w;
    logic        mem_axi_rvalid_w;
    logic  [1:0] mem_rs1_rs2_sign_w;
    logic  [2:0] mem_insn_funct3_w;
    logic  [3:0] mem_mem_web_w;
    logic  [4:0] mem_rd_w;
    logic [31:0] mem_axi_raddr_w;
    logic [31:0] mem_axi_waddr_w;
    logic [3:0]  mem_axi_web_w;
    logic [31:0] mem_axi_wdata_w;
    logic [31:0] mem_pc_w;
    logic [31:0] mem_insn_w;
    logic [31:0] mem_mul_op1_w;
    logic [31:0] mem_mul_op2_w;
    logic [31:0] mem_mem_wdata_w;
    logic [31:0] mem_alu_result_w;
    logic [31:0] mem_mem_read_data_w;
    logic [31:0] mem_mul_temp_part1_w;
    logic [31:0] mem_mul_temp_part2_w;
    logic [31:0] mem_mul_temp_part3_w;
    logic [31:0] mem_mul_temp_part4_w;

    // WB stage
    logic        wb_mul_w;
    logic        wb_mem_read_w;
    logic        wb_reg_write_w;
    logic  [1:0] wb_rs1_rs2_sign_w;
    logic  [2:0] wb_insn_funct3_w;
    logic  [4:0] wb_rd_w;
    logic [31:0] wb_pc_w;
    logic [31:0] wb_insn_w;
    logic [31:0] wb_alu_result_w;
    logic [31:0] wb_mem_read_data_w;
    logic [31:0] wb_reg_write_data_w;
    logic [31:0] wb_mul_temp_part1_w;
    logic [31:0] wb_mul_temp_part2_w;
    logic [31:0] wb_mul_temp_part3_w;
    logic [31:0] wb_mul_temp_part4_w;

    // assign
    assign if_insn_axi_w       = if_insn_axi_i       ;
    assign if_insn_axi_addr_w  = if_insn_axi_addr_i  ;
    assign if_insn_axi_valid_w = if_insn_axi_valid_i ;
    assign if_pc_reg_o         = if_pc_reg_w         ;
    assign mem_mem_store_o     = mem_mem_store_w     ;
    assign mem_mem_read_o      = mem_mem_read_w      ;
    assign mem_mem_web_o       = mem_mem_web_w       ;
    assign mem_mem_addr_o      = mem_alu_result_w    ;
    assign mem_mem_wdata_o     = mem_mem_wdata_w     ;
    assign mem_axi_raddr_w     = mem_axi_raddr_i     ;
    assign mem_axi_waddr_w     = mem_axi_waddr_i     ;
    assign mem_axi_web_w       = mem_axi_web_i       ;
    assign mem_axi_wdata_w     = mem_axi_wdata_i     ;
    assign mem_axi_wvalid_w    = mem_axi_wvalid_i    ;
    assign mem_axi_rvalid_w    = mem_axi_rvalid_i    ;
    assign mem_mem_read_data_w = mem_mem_read_data_i ;

    FetchPC fetch(
        .id_predict_jump_addr_i (id_predict_jump_addr_w) ,
        .id_flush_i             (id_flush_w)             ,
        .ex_flush_i             (ex_flush_w)             ,
        .ex_jump_addr_i         (ex_jump_addr_w)         ,
        .stall_i                (stall_w)                ,
        .stall_axi_im_i         (stall_axi_im_w)         ,
        .stall_axi_dm_i         (stall_axi_dm_w)         ,
        .if_pc_reg_i            (if_pc_reg_w)            ,
        .if_next_pc_i           (if_next_pc_w)           ,
        .if_fetch_pc_o          (if_fetch_pc_w)
    );

    NextPC nextpc(
        .clk_i                  (clk_i)                  ,
        .rst_i                  (rst_i)                  ,
        .stall_i                (stall_w)                ,
        .stall_axi_im_i         (stall_axi_im_w)         ,
        .stall_axi_dm_i         (stall_axi_dm_w)         ,
        .if_fetch_pc_i          (if_fetch_pc_w)          ,
        .if_next_pc_o           (if_next_pc_w)
    );

    IF_ID ifid(
        .clk_i                  (clk_i)                  ,
        .rst_i                  (rst_i)                  ,
        .stall_i                (stall_w)                ,
        .stall_axi_im_i         (stall_axi_im_w)         ,
        .stall_axi_dm_i         (stall_axi_dm_w)         ,
        .id_flush_i             (id_flush_w)             ,
        .ex_flush_i             (ex_flush_w)             ,
        .if_insn_axi_i          (if_insn_axi_w)          ,
        .if_fetch_pc_i          (if_fetch_pc_w)          ,
        .if_valid_reg_o         (if_valid_reg_w)         ,
        .id_valid_o             (id_valid_w)             ,
        .id_pc_o                (id_pc_w)                ,
        .if_pc_reg_o            (if_pc_reg_w)            ,
        .id_insn_o              (id_insn_w)
    );

    Control control(
        .id_insn_funct7_i       (id_insn_funct7_w)       ,
        .id_insn_opcode_i       (id_insn_opcode_w)       ,
        .id_mul_o               (id_mul_w)               ,
        .id_branch_o            (id_branch_w)            ,
        .id_mem_store_o         (id_mem_store_w)         ,
        .id_mem_read_o          (id_mem_read_w)          ,
        .id_reg_write_o         (id_reg_write_w)         ,
        .id_op1_is_reg_o        (id_op1_is_reg_w)        ,
        .id_op2_is_reg_o        (id_op2_is_reg_w)
    );

    HazardDetection hazarddetection(
        .if_insn_axi_valid_i    (if_insn_axi_valid_w)    ,
        .if_insn_axi_addr_i     (if_insn_axi_addr_w)     ,
        .if_pc_reg_i            (if_pc_reg_w)            ,
        .mem_mem_store_i        (mem_mem_store_w)        ,
        .mem_axi_wvalid_i       (mem_axi_wvalid_w)       ,
        .mem_axi_rvalid_i       (mem_axi_rvalid_w)       ,
        .mem_axi_raddr_i        (mem_axi_raddr_w)        ,
        .mem_axi_waddr_i        (mem_axi_waddr_w)        ,
        .mem_mem_web_i          (mem_mem_web_w)          ,
        .mem_axi_web_i          (mem_axi_web_w)          ,
        .mem_axi_wdata_i        (mem_axi_wdata_w)        ,
        .mem_alu_result_i       (mem_alu_result_w)       ,
        .mem_mem_wdata_i        (mem_mem_wdata_w)        ,
        .ex_rd_i                (ex_rd_w)                ,
        .mem_rd_i               (mem_rd_w)               ,
        .wb_rd_i                (wb_rd_w)                ,
        .ex_reg_write_i         (ex_reg_write_w)         ,
        .mem_reg_write_i        (mem_reg_write_w)        ,
        .wb_reg_write_i         (wb_reg_write_w)         ,
        .ex_mul_i               (ex_mul_w)               ,
        .mem_mul_i              (mem_mul_w)              ,
        .wb_mul_i               (wb_mul_w)               ,
        .ex_mem_read_i          (ex_mem_read_w)          ,
        .mem_mem_read_i         (mem_mem_read_w)         ,
        .wb_mem_read_i          (wb_mem_read_w)          ,
        .id_rs1_i               (id_rs1_w)               ,
        .id_rs2_i               (id_rs2_w)               ,
        .id_op1_is_reg_i        (id_op1_is_reg_w)        ,
        .id_op2_is_reg_i        (id_op2_is_reg_w)        ,
        .stall_o                (stall_w)                ,
        .stall_axi_im_o         (stall_axi_im_w)         ,
        .stall_axi_dm_o         (stall_axi_dm_w)
    );

    ImmGen immgen(
        .id_insn_i              (id_insn_w)              ,
        .id_immediate_gen_o     (id_immediate_gen_w)
    );

    DecodeStage decodestage(
        .id_insn_i              (id_insn_w)              ,
        .id_insn_funct7_o       (id_insn_funct7_w)       ,
        .id_insn_opcode_o       (id_insn_opcode_w)       ,
        .id_rd_o                (id_rd_w)                ,
        .id_rs1_o               (id_rs1_w)               ,
        .id_rs2_o               (id_rs2_w)
    );

    RegisterFile registerfile(
        .clk_i                  (clk_i)                  ,
        .rst_i                  (rst_i)                  ,
        .id_rs1_i               (id_rs1_w)               ,
        .id_rs2_i               (id_rs2_w)               ,
        .wb_reg_write_i         (wb_reg_write_w)         ,
        .wb_mul_i               (wb_mul_w)               ,
        .wb_mem_read_i          (wb_mem_read_w)          ,
        .wb_alu_result_i        (wb_alu_result_w)        ,
        .wb_reg_write_data_i    (wb_reg_write_data_w)    ,
        .wb_rd_i                (wb_rd_w)                ,
        .id_rs1_data_o          (id_rs1_data_w)          ,
        .id_rs2_data_o          (id_rs2_data_w)
    );

    BranchUnit branchunit(
        .clk_i                  (clk_i)                  ,
        .rst_i                  (rst_i)                  ,
        .ex_branch_i            (ex_branch_w)            ,
        .ex_flush_i             (ex_flush_w)             ,
        .stall_axi_im_i         (stall_axi_im_w)         ,
        .stall_axi_dm_i         (stall_axi_dm_w)         ,
        .if_pc_reg_i            (if_pc_reg_w)            ,
        .id_pc_i                (id_pc_w)                ,
        .id_immediate_gen_i     (id_immediate_gen_w)     ,
        .id_insn_opcode_i       (id_insn_opcode_w)       ,
        .id_flush_o             (id_flush_w)             ,
        .id_pc_add4_o           (id_pc_add4_w)           ,
        .id_pc_add_imm_o        (id_pc_add_imm_w)        ,
        .id_predict_jump_addr_o (id_predict_jump_addr_w)
    );

    ID_EX idex(
        .clk_i                  (clk_i)                  ,
        .rst_i                  (rst_i)                  ,
        .stall_i                (stall_w)                ,
        .stall_axi_im_i         (stall_axi_im_w)         ,
        .stall_axi_dm_i         (stall_axi_dm_w)         ,
        .id_valid_i             (id_valid_w)             ,
        .id_mul_i               (id_mul_w)               ,
        .id_branch_i            (id_branch_w)            ,
        .id_mem_store_i         (id_mem_store_w)         ,
        .id_mem_read_i          (id_mem_read_w)          ,
        .id_reg_write_i         (id_reg_write_w)         ,
        .id_flush_i             (id_flush_w)             ,
        .ex_flush_i             (ex_flush_w)             ,
        .id_rd_i                (id_rd_w)                ,
        .id_rs1_i               (id_rs1_w)               ,
        .id_rs2_i               (id_rs2_w)               ,
        .id_insn_i              (id_insn_w)              ,
        .id_rs1_data_i          (id_rs1_data_w)          ,
        .id_rs2_data_i          (id_rs2_data_w)          ,
        .id_immediate_gen_i     (id_immediate_gen_w)     ,
        .id_pc_i                (id_pc_w)                ,
        .id_pc_add4_i           (id_pc_add4_w)           ,
        .id_pc_add_imm_i        (id_pc_add_imm_w)        ,

        .ex_mul_o               (ex_mul_w)               ,
        .ex_branch_o            (ex_branch_w)            ,
        .ex_mem_store_o         (ex_mem_store_w)         ,
        .ex_mem_read_o          (ex_mem_read_w)          ,
        .ex_reg_write_o         (ex_reg_write_w)         ,
        .ex_rd_o                (ex_rd_w)                ,
        .ex_rs1_o               (ex_rs1_w)               ,
        .ex_rs2_o               (ex_rs2_w)               ,
        .ex_insn_o              (ex_insn_w)              ,
        .ex_rs1_data_o          (ex_rs1_data_w)          ,
        .ex_rs2_data_o          (ex_rs2_data_w)          ,
        .ex_immediate_gen_o     (ex_immediate_gen_w)     ,
        .ex_pc_o                (ex_pc_w)                ,
        .ex_pc_add4_o           (ex_pc_add4_w)           ,
        .ex_pc_add_imm_o        (ex_pc_add_imm_w)        ,
        .ex_instret_o           (ex_instret_w)           ,
        .ex_cycle_o             (ex_cycle_w)
    );

    ExecuteStage executestage(
        .ex_forwardA_i          (ex_forwardA_w)          ,
        .ex_forwardB_i          (ex_forwardB_w)          ,
        .ex_insn_i              (ex_insn_w)              ,
        .ex_rs1_data_i          (ex_rs1_data_w)          ,
        .ex_rs2_data_i          (ex_rs2_data_w)          ,
        .mem_alu_result_i       (mem_alu_result_w)       ,
        .wb_alu_result_i        (wb_alu_result_w)        ,
        .ex_immediate_gen_i     (ex_immediate_gen_w)     ,
        .id_pc_i                (id_pc_w)                ,
        .ex_pc_add4_i           (ex_pc_add4_w)           ,
        .ex_pc_add_imm_i        (ex_pc_add_imm_w)        ,
        .ex_instret_i           (ex_instret_w)           ,
        .ex_cycle_i             (ex_cycle_w)             ,

        .ex_flush_o             (ex_flush_w)             ,
        .ex_rs1_rs2_sign_o      (ex_rs1_rs2_sign_w)      ,
        .ex_insn_funct3_o       (ex_insn_funct3_w)       ,
        .ex_mem_web_o           (ex_mem_web_w)           ,
        .ex_jump_addr_o         (ex_jump_addr_w)         ,
        .ex_mem_wdata_o         (ex_mem_wdata_w)         ,
        .ex_alu_result_o        (ex_alu_result_w)        ,
        .ex_mul_op1_o           (ex_mul_op1_w)           ,
        .ex_mul_op2_o           (ex_mul_op2_w)
    );

    ForwardingUnit forwardingunit(
        .ex_rs1_i               (ex_rs1_w)               ,
        .ex_rs2_i               (ex_rs2_w)               ,
        .mem_rd_i               (mem_rd_w)               ,
        .wb_rd_i                (wb_rd_w)                ,
        .mem_reg_write_i        (mem_reg_write_w)        ,
        .wb_reg_write_i         (wb_reg_write_w)         ,
        .wb_mul_i               (wb_mul_w)               ,
        .wb_mem_read_i          (wb_mem_read_w)          ,

        .ex_forwardA_o          (ex_forwardA_w)          ,
        .ex_forwardB_o          (ex_forwardB_w)
    );

    EX_MEM exmem(
        .clk_i                  (clk_i)                  ,
        .rst_i                  (rst_i)                  ,
        .ex_mul_i               (ex_mul_w)               ,
        .stall_axi_im_i         (stall_axi_im_w)         ,
        .stall_axi_dm_i         (stall_axi_dm_w)         ,
        .ex_mem_store_i         (ex_mem_store_w)         ,
        .ex_mem_read_i          (ex_mem_read_w)          ,
        .ex_reg_write_i         (ex_reg_write_w)         ,
        .ex_rs1_rs2_sign_i      (ex_rs1_rs2_sign_w)      ,
        .ex_insn_funct3_i       (ex_insn_funct3_w)       ,
        .ex_mem_web_i           (ex_mem_web_w)           ,
        .ex_rd_i                (ex_rd_w)                ,
        .ex_pc_i                (ex_pc_w)                ,
        .ex_insn_i              (ex_insn_w)              ,
        .ex_mul_op1_i           (ex_mul_op1_w)           ,
        .ex_mul_op2_i           (ex_mul_op2_w)           ,
        .ex_mem_wdata_i         (ex_mem_wdata_w)         ,
        .ex_alu_result_i        (ex_alu_result_w)        ,

        .mem_mul_o              (mem_mul_w)              ,
        .mem_mem_store_o        (mem_mem_store_w)        ,
        .mem_mem_read_o         (mem_mem_read_w)         ,
        .mem_reg_write_o        (mem_reg_write_w)        ,
        .mem_rs1_rs2_sign_o     (mem_rs1_rs2_sign_w)     ,
        .mem_insn_funct3_o      (mem_insn_funct3_w)      ,
        .mem_mem_web_o          (mem_mem_web_w)          ,
        .mem_rd_o               (mem_rd_w)               ,
        .mem_pc_o               (mem_pc_w)               ,
        .mem_insn_o             (mem_insn_w)             ,
        .mem_mul_op1_o          (mem_mul_op1_w)          ,
        .mem_mul_op2_o          (mem_mul_op2_w)          ,
        .mem_mem_wdata_o        (mem_mem_wdata_w)        ,
        .mem_alu_result_o       (mem_alu_result_w)
    );

    MulPartResult mulpartresult(
        .mem_mul_op1_i          (mem_mul_op1_w)          ,
        .mem_mul_op2_i          (mem_mul_op2_w)          ,

        .mem_mul_temp_part1_o   (mem_mul_temp_part1_w)   ,
        .mem_mul_temp_part2_o   (mem_mul_temp_part2_w)   ,
        .mem_mul_temp_part3_o   (mem_mul_temp_part3_w)   ,
        .mem_mul_temp_part4_o   (mem_mul_temp_part4_w)
    );

    MEM_WB memwb(
        .clk_i                  (clk_i)                  ,
        .rst_i                  (rst_i)                  ,
        .mem_mul_i              (mem_mul_w)              ,
        .stall_axi_im_i         (stall_axi_im_w)         ,
        .stall_axi_dm_i         (stall_axi_dm_w)         ,
        .mem_mem_read_i         (mem_mem_read_w)         ,
        .mem_reg_write_i        (mem_reg_write_w)        ,
        .mem_rs1_rs2_sign_i     (mem_rs1_rs2_sign_w)     ,
        .mem_insn_funct3_i      (mem_insn_funct3_w)      ,
        .mem_rd_i               (mem_rd_w)               ,
        .mem_pc_i               (mem_pc_w)               ,
        .mem_insn_i             (mem_insn_w)             ,
        .mem_alu_result_i       (mem_alu_result_w)       ,
        .mem_mem_read_data_i    (mem_mem_read_data_w)    ,
        .mem_mul_temp_part1_i   (mem_mul_temp_part1_w)   ,
        .mem_mul_temp_part2_i   (mem_mul_temp_part2_w)   ,
        .mem_mul_temp_part3_i   (mem_mul_temp_part3_w)   ,
        .mem_mul_temp_part4_i   (mem_mul_temp_part4_w)   ,

        .wb_mul_o               (wb_mul_w)               ,
        .wb_mem_read_o          (wb_mem_read_w)          ,
        .wb_reg_write_o         (wb_reg_write_w)         ,
        .wb_rs1_rs2_sign_o      (wb_rs1_rs2_sign_w)      ,
        .wb_insn_funct3_o       (wb_insn_funct3_w)       ,
        .wb_rd_o                (wb_rd_w)                ,
        .wb_pc_o                (wb_pc_w)                ,
        .wb_insn_o              (wb_insn_w)              ,
        .wb_alu_result_o        (wb_alu_result_w)        ,
        .wb_mem_read_data_o     (wb_mem_read_data_w)     ,
        .wb_mul_temp_part1_o    (wb_mul_temp_part1_w)    ,
        .wb_mul_temp_part2_o    (wb_mul_temp_part2_w)    ,
        .wb_mul_temp_part3_o    (wb_mul_temp_part3_w)    ,
        .wb_mul_temp_part4_o    (wb_mul_temp_part4_w)
    );

    WritebackStage writebackstage(
        .wb_mul_i               (wb_mul_w)               ,
        .wb_mem_read_i          (wb_mem_read_w)          ,
        .wb_rs1_rs2_sign_i      (wb_rs1_rs2_sign_w)      ,
        .wb_insn_funct3_i       (wb_insn_funct3_w)       ,
        .wb_alu_result_i        (wb_alu_result_w)        ,
        .wb_mem_read_data_i     (wb_mem_read_data_w)     ,
        .wb_mul_temp_part1_i    (wb_mul_temp_part1_w)    ,
        .wb_mul_temp_part2_i    (wb_mul_temp_part2_w)    ,
        .wb_mul_temp_part3_i    (wb_mul_temp_part3_w)    ,
        .wb_mul_temp_part4_i    (wb_mul_temp_part4_w)    ,

        .wb_reg_write_data_o    (wb_reg_write_data_w)
    );

endmodule : CPU