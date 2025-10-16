`include "instruction_pkg.sv"
`include "Controller.sv"
`include "CSR_Unit.sv"
`include "Decoder.sv"
`include "Imm_Extension.sv"
`include "JB_target_gen.sv"
`include "LD_Filter.sv"
`include "MUL.sv"
`include "Mux2to1.sv"
`include "Mux3to1.sv"
`include "Mux4to1.sv"
`include "Program_Counter_reg.sv"
`include "Register_File.sv"
`include "ALU.sv"
`include "IF_ID_reg.sv"
`include "ID_EX_reg.sv"
`include "EX_MEM_reg.sv"
`include "MEM_WB_reg.sv"
`include "BTB.sv"
`include "BHR_PHT.sv"

module CPU (
    input  logic        clk,
    input  logic        rst,

    // Instruction Memory Interface
    output logic        im_request_o,
    output logic [31:0] im_pc_o,
    input  logic        im_wait_i,
    input  logic [31:0] im_addr_i, // input pc from wrapper
    input  logic [31:0] im_dout_i,

    // Data Memory Interface
    output logic        dm_request_o,
    output logic [ 3:0] dm_bit_write_o,
    input  logic        dm_wait_i,
    output logic [31:0] dm_addr_o, 
    output logic [31:0] dm_din_o,
    input  logic [31:0] dm_dout_i

    // output logic        dm_ceb,
    // output logic        dm_w_en,
    // output logic [31:0] dm_bweb,
);
    
    logic [ 3:0] dm_bweb;

    logic [31:0] next_pc, IF_pc_plus_4;
    logic [31:0] IF_pc, IF_inst;
    logic [31:0] jb_target;
    logic [31:0] ID_pc, ID_inst;
    logic [ 2:0] ID_func3;
    logic [ 6:0] ID_op, ID_func7;
    logic [ 4:0] ID_rs1_index, ID_rs2_index, ID_rd_index;
    logic [31:0] imm_ext_out;
    logic [31:0] wb_data;
    logic [31:0] regOut_rs1_data, regOut_rs2_data;
    logic [31:0] regOut_frs1_data, regOut_frs2_data;
    logic [31:0] ID_rs1_data, ID_rs2_data;
    logic [31:0] EX_pc, EX_pc_plus_4;
    logic [31:0] EX_rs1_data, EX_rs2_data;
    logic [31:0] EX_imm_ext;
    logic [31:0] EX_reg_src1_data, EX_reg_src2_data;
    logic [31:0] alu_src1_data, alu_src2_data, alu_out, mul_out;
    logic [31:0] EXE_cal_out;
    logic [31:0] MEM_rs2_data;
    logic [31:0] MEM_cal_out;
    logic [31:0] MEM_ld_data;
    logic [11:0] MEM_CSR_imm;
    logic [31:0] WB_cal_out;
    logic [31:0] WB_ld_data;
    logic [11:0] WB_CSR_imm;
    logic [31:0] ld_f_data;
    logic [31:0] CSR_dout;

    logic [ 1:0] next_pc_sel;
    logic        stall;
    logic        load_use_stall;
    // load-use stall : 2 clock
    // stall & !mem_wait : 1 clock
    logic        IF_flush, ID_flush;
    logic [ 1:0] ID_rs1_data_sel, ID_rs2_data_sel;
 
    logic [ 1:0] EX_reg_src1_data_sel, EX_reg_src2_data_sel;
    logic        alu_src1_sel, alu_src2_sel;
    logic        EX_cal_out_sel;
    logic [ 6:0] EX_op, EX_func7;
    logic [ 4:0] EX_rs1, EX_rs2, EX_rd;
    logic [ 2:0] EX_func3;

    logic [31:0] MEM_pc;
    logic [ 6:0] MEM_op;
    logic [ 4:0] MEM_rd;
    logic [ 2:0] MEM_func3;
    logic        MEM_dm_w_en;
    logic        WB_wb_en;
    logic        WB_fwb_en;
    logic [ 6:0] WB_op;
    logic [ 4:0] WB_rd;
    logic [ 2:0] WB_func3;
    logic [ 1:0] WB_wb_data_sel;
    
    logic        IF_btb_b_hit;
    logic        IF_btb_j_hit;
    logic [31:0] IF_btb_target;
    logic        IF_gbc_predict_taken;
    logic [ 3:0] IF_bhr_out;
    logic        ID_btb_b_hit;
    logic        ID_btb_j_hit;
    logic        ID_gbc_predict_taken;
    logic [ 3:0] ID_bhr;
    logic        EX_btb_b_hit;
    logic        EX_btb_j_hit;
    logic        EX_gbc_predict_taken;
    logic [ 3:0] EX_bhr;
    logic        EX_actual_taken;

    Controller controller (
        .clk          (clk),
      	.rst          (rst),
      	.ID_op        (ID_op),
      	.ID_rd        (ID_rd_index),
      	.ID_rs1       (ID_rs1_index),
      	.ID_rs2       (ID_rs2_index),
        .EX_op        (EX_op),
        .EX_rd        (EX_rd),
      	.EX_rs1       (EX_rs1),
      	.EX_rs2       (EX_rs2),
      	.EX_func7     (EX_func7),
      	.EX_alu_out_0 (alu_out[0]),
        .MEM_op       (MEM_op),
        .MEM_rd       (MEM_rd),
        .MEM_func3    (MEM_func3),
        .MEM_cal_out  (MEM_cal_out),
        .WB_op        (WB_op),
        .WB_rd        (WB_rd),

        .IF_gbc_predict_taken (IF_gbc_predict_taken),
        .EX_gbc_predict_taken (EX_gbc_predict_taken),
        .IF_btb_b_hit         (IF_btb_b_hit),
        .IF_btb_j_hit         (IF_btb_j_hit),
        .EX_btb_b_hit         (EX_btb_b_hit),
        .EX_btb_j_hit         (EX_btb_j_hit),
        .mem_wait             (im_wait_i | dm_wait_i),

        .EX_actual_taken      (EX_actual_taken),
      	.next_pc_sel          (next_pc_sel),
      	.stall                (stall),
        .load_use_stall       (load_use_stall),
        .IF_flush             (IF_flush),
        .ID_flush             (ID_flush),
      	.ID_rs1_data_sel      (ID_rs1_data_sel),
      	.ID_rs2_data_sel      (ID_rs2_data_sel),
      	.EX_reg_src1_data_sel (EX_reg_src1_data_sel),
      	.EX_reg_src2_data_sel (EX_reg_src2_data_sel),
        .EX_cal_out_sel       (EX_cal_out_sel),
      	.alu_src1_sel         (alu_src1_sel),
      	.alu_src2_sel         (alu_src2_sel),

      	.MEM_dm_w_en    (MEM_dm_w_en),
        .MEM_ceb        (dm_request_o),
        .MEM_bweb       (dm_bweb),
      	
        .WB_wb_en       (WB_wb_en),
        .WB_fwb_en      (WB_fwb_en),
        .WB_wb_data_sel (WB_wb_data_sel)
    );
 
    assign im_request_o = 1'b1;
    assign im_pc_o = (load_use_stall) ? ID_pc : IF_pc;  // Word aligned
    assign IF_inst = im_dout_i;
    assign IF_pc_plus_4 = IF_pc + 32'd4;
    assign EX_pc_plus_4 = EX_pc + 32'd4;


    // assign dm_w_en = MEM_dm_w_en;
    assign dm_addr_o = MEM_cal_out;
    assign dm_din_o  = MEM_rs2_data;
    assign MEM_ld_data = dm_dout_i;
    assign dm_bit_write_o = ~dm_bweb;


    Mux4to1 next_pc_m (
        .in_0     (EX_pc_plus_4),
        .in_1     (jb_target),
        .in_2     (IF_btb_target),
        .in_3     (IF_pc_plus_4),
        .sel      (next_pc_sel),
        .mux_out  (next_pc)
    );

    BTB btb_unit (
        .clk           (clk),
        .rst           (rst),
        .IF_pc         (IF_pc),
        .EX_op         (EX_op),
        .EX_pc         (EX_pc),
        .EX_target     (jb_target),

        .IF_btb_b_hit  (IF_btb_b_hit),
        .IF_btb_j_hit  (IF_btb_j_hit),
        .IF_btb_target (IF_btb_target)
    );

    BHR_PHT bhr_pht_unit (
        .clk                  (clk),
        .rst                  (rst),

        .EX_op                (EX_op),
        .EX_actual_taken      (EX_actual_taken),
        .EX_bhr               (EX_bhr),
        .IF_gbc_predict_taken (IF_gbc_predict_taken),
        .IF_bhr_out           (IF_bhr_out)
    );

    Program_Counter_reg PC(
        .clk        (clk),
        .rst        (rst),
        .stall      (stall),
        .mem_wait   (im_wait_i | dm_wait_i),

        .next_pc    (next_pc),
        .current_pc (IF_pc)
    );

    IF_ID_reg Reg_IF_ID (
        .clk                  (clk),
        .rst                  (rst),
        .mem_wait             (im_wait_i | dm_wait_i),
        .stall                (stall),
        .flush                (IF_flush),
        

        .IF_pc                (IF_pc),
        .IF_inst              (IF_inst),
        .IF_btb_b_hit         (IF_btb_b_hit),
        .IF_btb_j_hit         (IF_btb_j_hit),
        .IF_gbc_predict_taken (IF_gbc_predict_taken),
        .IF_bhr               (IF_bhr_out),

        .ID_btb_b_hit         (ID_btb_b_hit),
        .ID_btb_j_hit         (ID_btb_j_hit),
        .ID_gbc_predict_taken (ID_gbc_predict_taken),
        .ID_bhr               (ID_bhr),
        .ID_pc                (ID_pc),
        .ID_inst              (ID_inst)
    );

    Decoder DEC (
    	.ID_inst      (ID_inst),

        .ID_op        (ID_op),
        .ID_func3     (ID_func3),
        .ID_func7     (ID_func7),
        .ID_rs1_index (ID_rs1_index),
        .ID_rs2_index (ID_rs2_index),
        .ID_rd_index  (ID_rd_index)
    );

    Imm_Extension IMM_EXT (
        .ID_inst     (ID_inst),
        .imm_ext_out (imm_ext_out)
    );

    Register_File GPR (
        .clk       (clk),
        .rst       (rst),
        .w_en      (WB_wb_en),
        .w_data    (wb_data),
        .rs1_index (ID_rs1_index),
        .rs2_index (ID_rs2_index),
        .rd_index  (WB_rd),

        .rs1_data  (regOut_rs1_data),
        .rs2_data  (regOut_rs2_data)
    );

    Register_File FPR (
        .clk       (clk),
        .rst       (rst),
        .w_en      (WB_fwb_en),
        .w_data    (wb_data),
        .rs1_index (ID_rs1_index),
        .rs2_index (ID_rs2_index),
        .rd_index  (WB_rd),

        .rs1_data  (regOut_frs1_data),
        .rs2_data  (regOut_frs2_data)
    );

    Mux3to1 ID_rs1_data_m (
        .in_0    (regOut_rs1_data),
        .in_1    (wb_data),
        .in_2    (regOut_frs1_data),
        .sel     (ID_rs1_data_sel),
        .mux_out (ID_rs1_data)
    );
    
    Mux3to1 ID_rs2_data_m (
        .in_0    (regOut_rs2_data),
        .in_1    (wb_data),
        .in_2    (regOut_frs2_data),
        .sel     (ID_rs2_data_sel),
        .mux_out (ID_rs2_data)
    ); 

    ID_EX_reg Reg_ID_EX (
        .clk                  (clk),
        .rst                  (rst),
        .stall                (stall),
        .mem_wait             (im_wait_i | dm_wait_i),
        .flush                (ID_flush),

        .ID_pc                (ID_pc),
        .ID_op                (ID_op),
      	.ID_func3             (ID_func3),
      	.ID_func7             (ID_func7),
      	.ID_rd                (ID_rd_index),
      	.ID_rs1               (ID_rs1_index),
      	.ID_rs2               (ID_rs2_index),
        .ID_rs1_data          (ID_rs1_data),
        .ID_rs2_data          (ID_rs2_data),
        .ID_imm_ext           (imm_ext_out),

        .ID_btb_b_hit         (ID_btb_b_hit),
        .ID_btb_j_hit         (ID_btb_j_hit),
        .ID_gbc_predict_taken (ID_gbc_predict_taken),
        .ID_bhr               (ID_bhr),
        .EX_btb_b_hit         (EX_btb_b_hit),
        .EX_btb_j_hit         (EX_btb_j_hit),
        .EX_gbc_predict_taken (EX_gbc_predict_taken),
        .EX_bhr               (EX_bhr),
        .EX_pc                (EX_pc),
        .EX_op                (EX_op),
      	.EX_func3             (EX_func3),
      	.EX_func7             (EX_func7),
      	.EX_rd                (EX_rd),
      	.EX_rs1               (EX_rs1),
      	.EX_rs2               (EX_rs2),
        .EX_rs1_data          (EX_rs1_data),
        .EX_rs2_data          (EX_rs2_data),
        .EX_imm_ext           (EX_imm_ext)
    );

    Mux3to1  EX_reg_src1_m (
        .in_0    (wb_data),
        .in_1    (MEM_cal_out),
        .in_2    (EX_rs1_data),
        .sel     (EX_reg_src1_data_sel),
        .mux_out (EX_reg_src1_data)
    );
    
    Mux3to1 EX_reg_src2_m (
        .in_0    (wb_data),
        .in_1    (MEM_cal_out),
        .in_2    (EX_rs2_data),
        .sel     (EX_reg_src2_data_sel),
        .mux_out (EX_reg_src2_data)
    );
    
    Mux2to1 alu_src1_m (
        .in_0    (EX_reg_src1_data),
        .in_1    (EX_pc),
        .sel     (alu_src1_sel),
        .mux_out (alu_src1_data)
    );

    JB_target_gen JB (
        .EX_reg_src1_data (EX_reg_src1_data),
        .EX_pc            (EX_pc),
        .EX_imm_ext       (EX_imm_ext),
        .EX_op            (EX_op),
        .jb_target        (jb_target)
    );
    
    Mux2to1 alu_src2_m (
        .in_0    (EX_imm_ext),
        .in_1    (EX_reg_src2_data),
        .sel     (alu_src2_sel),
        .mux_out (alu_src2_data)
    );

    ALU alu (
        .op       (EX_op),
        .func3    (EX_func3),
        .func7    (EX_func7),
        .operand1 (alu_src1_data),
        .operand2 (alu_src2_data),
        .alu_out  (alu_out)
    );

    MUL mul (
        .EX_func3 (EX_func3),
        .src1     (alu_src1_data),
        .src2     (alu_src2_data),
        .mul_out  (mul_out)                 
    );

    Mux2to1 mul_alu_m (
        .in_0    (alu_out),
        .in_1    (mul_out),
        .sel     (EX_cal_out_sel),
        .mux_out (EXE_cal_out)
    );

    EX_MEM_reg Reg_EX_MEM (
        .clk          (clk),
        .rst          (rst),
        .stall        (stall),
        .mem_wait     (im_wait_i | dm_wait_i),

        .EX_pc        (EX_pc),
        .EX_op        (EX_op),
        .EX_rd        (EX_rd),
        .EX_func3     (EX_func3),
        .EX_cal_out   (EXE_cal_out),
        .EX_rs2_data  (EX_reg_src2_data),
        .EX_imm_ext   (EX_imm_ext),        
        
        .MEM_pc       (MEM_pc),
        .MEM_op       (MEM_op),
        .MEM_rd       (MEM_rd),
        .MEM_func3    (MEM_func3),
        .MEM_cal_out  (MEM_cal_out),
        .MEM_rs2_data (MEM_rs2_data),
        .MEM_CSR_imm  (MEM_CSR_imm)
    );

    MEM_WB_reg Reg_MEM_WB (
        .clk         (clk),
        .rst         (rst),
        .mem_wait    (im_wait_i | dm_wait_i),
        .dm_wait     (dm_wait_i),

        .MEM_op      (MEM_op),
        .MEM_rd      (MEM_rd),
        .MEM_func3   (MEM_func3),
        .MEM_cal_out (MEM_cal_out),
        .MEM_ld_data (MEM_ld_data),
        .MEM_CSR_imm (MEM_CSR_imm),

        .WB_op       (WB_op),
        .WB_rd       (WB_rd),
      	.WB_func3    (WB_func3),
        .WB_cal_out  (WB_cal_out),
        .WB_ld_data  (WB_ld_data),
        .WB_CSR_imm  (WB_CSR_imm)
    );

    CSR_Unit csr (
        .clk        (clk),
        .rst        (rst),
        .mem_wait   (im_wait_i | dm_wait_i),
        .WB_op      (WB_op),
        .WB_rd      (WB_rd),
        .WB_CSR_imm (WB_CSR_imm),

        .CSR_dout   (CSR_dout)
    );

    LD_Filter LDF (
        .func3     (WB_func3),
        .cal_out   (WB_cal_out),
        .ld_data   (WB_ld_data),

        .ld_f_data (ld_f_data)
    );

    Mux3to1  wb(
        .in_0    (WB_cal_out),
        .in_1    (ld_f_data),
        .in_2    (CSR_dout),
        .sel     (WB_wb_data_sel),
        .mux_out (wb_data)
    );

endmodule