module Controller(
    input logic       clk,
    input logic       rst,
    // ID Stage signals
    input logic [6:0] ID_op,
    input logic [4:0] ID_rd,
    input logic [4:0] ID_rs1,
    input logic [4:0] ID_rs2,
    
    // EX Stage signals
    input logic [6:0] EX_op,
    input logic [4:0] EX_rs1,
    input logic [4:0] EX_rs2,
    input logic [4:0] EX_rd,
    input logic [6:0] EX_func7,
    input logic       EX_alu_out_0,

    // MEM Stage signals
    input logic [6:0] MEM_op,
    input logic [4:0] MEM_rd,
    input logic [2:0] MEM_func3,
    input logic [31:0] MEM_cal_out,
    
    // WB Stage signals
    input logic [6:0] WB_op,
    input logic [4:0] WB_rd,

    // Branch  signal
    input logic IF_gbc_predict_taken,
    input logic EX_gbc_predict_taken,
    input logic IF_btb_hit,                   
    input logic EX_btb_hit,  

    output logic EX_actual_taken,        

    // Control outputs
    output logic [ 2:0] next_pc_sel,
    output logic        stall,
    output logic        IF_flush,
    output logic        ID_flush,
    output logic [ 1:0] ID_rs1_data_sel,
    output logic [ 1:0] ID_rs2_data_sel,
    output logic [ 1:0] EX_reg_src1_data_sel,
    output logic [ 1:0] EX_reg_src2_data_sel,
    output logic        EX_cal_out_sel, 
    output logic        alu_src1_sel,
    output logic        alu_src2_sel,
    output logic        MEM_dm_w_en,
    output logic        MEM_ceb,
    output logic [31:0] MEM_bweb,
    output logic        WB_wb_en,
    output logic        WB_fwb_en,
    output logic [ 1:0] WB_wb_data_sel
);

    // Condition checking signals,  stage requirements
    logic ID_inst_with_rs1, ID_inst_with_rs2, ID_inst_with_frs2;
    logic EX_inst_with_rs1, EX_inst_with_rs2, EX_inst_with_frs2;
    logic MEM_inst_with_rd, MEM_inst_with_frd;
    logic WB_inst_with_rd, WB_inst_with_frd;

    always_comb begin
        ID_inst_with_rs1 = (ID_op == `R_type) || (ID_op == `I_arth) || (ID_op == `I_load) || (ID_op == `JALR) || (ID_op == `S_type) || (ID_op == `B_type) || (ID_op == `F_FLW) || (ID_op == `F_FSW);
        ID_inst_with_rs2 = (ID_op == `R_type) || (ID_op == `S_type) || (ID_op == `B_type);
        ID_inst_with_frs2 = (ID_op == `F_arth) || (ID_op == `F_FSW);

        EX_inst_with_rs1 = (EX_op != `LUI) && (EX_op != `AUIPC) && (EX_op != `JAL) && (EX_op != `F_arth);
        EX_inst_with_rs2 = (EX_op == `R_type) || (EX_op == `S_type) || (EX_op == `B_type);
        EX_inst_with_frs2 = (EX_op == `F_arth) || (EX_op == `F_FSW);

        MEM_inst_with_rd = (MEM_op != `S_type) && (MEM_op != `B_type) && (MEM_op != `F_FSW) && (MEM_op != `F_arth) && (MEM_op != `F_FLW);
        MEM_inst_with_frd = (MEM_op == `F_arth) || (MEM_op == `F_FLW);
 
        WB_inst_with_rd = (WB_op != `S_type) && (WB_op != `B_type) && (WB_op != `F_FSW) && (WB_op != `F_arth) && (WB_op != `F_FLW);
        WB_inst_with_frd = (WB_op == `F_arth) || (WB_op == `F_FLW);
    end

    // stall control : Load-use data hazard
    assign stall = ((EX_op == `I_load) 
                 && ((ID_inst_with_rs1 && (ID_rs1 == EX_rd)) || (ID_inst_with_rs2 && (ID_rs2 == EX_rd))) 
                 && (EX_rd != 5'b0))
                || ((EX_op == `F_FLW) // load fp in fpreg
                 && ((ID_op == `F_arth && ID_rs1 == EX_rd) || (ID_inst_with_frs2 && (ID_rs2 == EX_rd))) 
                 && (EX_rd != 5'b0));

    // branch control
    logic EX_mispredict;
    logic EX_is_branch;
    assign EX_is_branch = (EX_op == `B_type);
    always_comb begin
        // ID_predict_taken = bp_predict_taken && (ID_op == `B_type) && !stall; // 加入 !stall 判斷當前是否為 load branch
        
        EX_actual_taken = (EX_op == `B_type) && EX_alu_out_0;
        EX_mispredict = (EX_op == `B_type) && ((EX_gbc_predict_taken && EX_btb_hit) != EX_actual_taken);
    end

    // flush control
    assign IF_flush = EX_mispredict || ID_op == `JAL || EX_op == `JALR;
    assign ID_flush = EX_mispredict || EX_op == `JALR;

    // next pc control
    always_comb begin
        if (EX_mispredict) begin
            next_pc_sel = (EX_actual_taken) ? 3'd1 : 3'd0; 
        end else if (EX_op == `JALR) begin 
            next_pc_sel = 3'd1;
        end else if (ID_op == `JAL) begin 
            next_pc_sel = 3'd3;
        end else if (IF_btb_hit && IF_gbc_predict_taken) begin
            next_pc_sel = 3'd2;
        end else begin
            next_pc_sel = 3'd4;
        end
    end

    // memory operation control
    assign MEM_ceb = ~(MEM_op == `S_type || MEM_op == `I_load || MEM_op == `F_FSW || MEM_op == `F_FLW);
    assign MEM_dm_w_en = (MEM_op == `I_load || MEM_op == `F_FLW); // read: active high, write: active low

    always_comb begin
        if(MEM_op == `S_type || MEM_op == `F_FSW) begin
            unique case(MEM_func3)
                3'b010: begin    // SW
                    MEM_bweb = 32'h00000000;  // 全部 byte 都寫入
                end
                3'b000: begin    // SB
                    case(MEM_cal_out[1:0])
                        2'b00: MEM_bweb = 32'hFFFFFF00;  // 寫入 byte 0
                        2'b01: MEM_bweb = 32'hFFFF00FF;  // 寫入 byte 1
                        2'b10: MEM_bweb = 32'hFF00FFFF;  // 寫入 byte 2
                        2'b11: MEM_bweb = 32'h00FFFFFF;  // 寫入 byte 3
                    endcase
                end
                3'b001: begin    // SH
                    case(MEM_cal_out[1:0])
                        2'b00: MEM_bweb = 32'hFFFF0000;  
                        2'b01: MEM_bweb = 32'hFF0000FF;
                        2'b10: MEM_bweb = 32'h0000FFFF;  
                        default: MEM_bweb = 32'hFFFFFFFF;
                    endcase
                end
                default: begin
                    MEM_bweb = 32'hFFFFFFFF;  // 不寫入任何 byte
                end
            endcase
        end else begin
            MEM_bweb = 32'hFFFFFFFF;  // 不寫入任何 byte
        end
    end
    
    // mux control & reg write back enable
    assign ID_rs1_data_sel = ((ID_inst_with_rs1 && WB_inst_with_rd && (ID_rs1 == WB_rd) && (WB_rd != 5'b0)) 
                           || (ID_op == `F_arth && WB_inst_with_frd && (ID_rs1 == WB_rd) && (WB_rd != 5'b0))) ? 2'd1 : ((ID_op == `F_arth) ? 2'd2 : 2'd0);

    assign ID_rs2_data_sel = (ID_inst_with_rs2  && WB_inst_with_rd && (ID_rs2 == WB_rd) && (WB_rd != 5'b0)) 
                          || (ID_inst_with_frs2 && WB_inst_with_frd && (ID_rs2 == WB_rd) && (WB_rd != 5'b0)) ? 2'd1 : (ID_inst_with_frs2 ? 2'd2 : 2'd0);

    assign EX_reg_src1_data_sel = ((EX_inst_with_rs1 && MEM_inst_with_rd && (EX_rs1 == MEM_rd) && (MEM_rd != 5'b0))
                                || ((EX_op == `F_arth) && MEM_inst_with_frd && (EX_rs1 == MEM_rd) && (MEM_rd != 5'b0))) ? 2'd1 :
                                  ((EX_inst_with_rs1 && WB_inst_with_rd && (EX_rs1 == WB_rd) && (WB_rd != 5'b0))
                                || ((EX_op == `F_arth) && WB_inst_with_frd && (EX_rs1 == WB_rd) && (WB_rd != 5'b0)) ? 2'd0 : 2'd2);

    assign EX_reg_src2_data_sel = ((EX_inst_with_rs2 && MEM_inst_with_rd && (EX_rs2 == MEM_rd) && (MEM_rd != 5'b0))
                                || (EX_inst_with_frs2 && MEM_inst_with_frd && (EX_rs2 == MEM_rd) && (MEM_rd != 5'b0))) ? 2'b1 : 
                                  ((EX_inst_with_rs2 && WB_inst_with_rd && (EX_rs2 == WB_rd) && (WB_rd != 5'b0))
                                || (EX_inst_with_frs2 && WB_inst_with_frd && (EX_rs2 == WB_rd) && (WB_rd != 5'b0)) ? 2'd0 : 2'd2);
    
    assign alu_src1_sel = (EX_op == `LUI || EX_op == `AUIPC || EX_op == `JAL || EX_op == `JALR);   

    assign alu_src2_sel = (EX_op == `R_type || EX_op ==`B_type || EX_op == `F_arth);  

    assign EX_cal_out_sel = (EX_op == `R_type && EX_func7 == `M_type); 

    assign WB_wb_en = WB_inst_with_rd;

    assign WB_fwb_en = WB_inst_with_frd;

    assign WB_wb_data_sel = (WB_op == `I_load || WB_op == `F_FLW) ? 2'd1 : ((WB_op == `CSR) ? 2'd2 : 2'd0);


endmodule
         




