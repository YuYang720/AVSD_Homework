wvSetPosition -win $_nWave1 {("G1" 0)}
wvOpenFile -win $_nWave1 \
           {/home/user1/avsd25/avsd2541/AVSD_Homework/Homework1/N26132047/build/top.fsdb}
verdiSetActWin -win $_nWave1
wvGetSignalOpen -win $_nWave1
wvGetSignalSetScope -win $_nWave1 "/top_tb"
wvGetSignalSetScope -win $_nWave1 "/top_tb/TOP"
wvSetPosition -win $_nWave1 {("G1" 10)}
wvSetPosition -win $_nWave1 {("G1" 10)}
wvAddSignal -win $_nWave1 -clear
wvAddSignal -win $_nWave1 -group {"G1" \
{/top_tb/TOP/clk} \
{/top_tb/TOP/dm_addr\[13:0\]} \
{/top_tb/TOP/dm_bweb\[31:0\]} \
{/top_tb/TOP/dm_ceb} \
{/top_tb/TOP/dm_din\[31:0\]} \
{/top_tb/TOP/dm_dout\[31:0\]} \
{/top_tb/TOP/dm_w_en} \
{/top_tb/TOP/im_addr\[13:0\]} \
{/top_tb/TOP/im_dout\[31:0\]} \
{/BLANK} \
}
wvAddSignal -win $_nWave1 -group {"G2" \
}
wvSelectSignal -win $_nWave1 {( "G1" 1 2 3 4 5 6 7 8 9 10 )} 
wvSetPosition -win $_nWave1 {("G1" 10)}
wvSetPosition -win $_nWave1 {("G1" 10)}
wvSetPosition -win $_nWave1 {("G1" 10)}
wvAddSignal -win $_nWave1 -clear
wvAddSignal -win $_nWave1 -group {"G1" \
{/top_tb/TOP/clk} \
{/top_tb/TOP/dm_addr\[13:0\]} \
{/top_tb/TOP/dm_bweb\[31:0\]} \
{/top_tb/TOP/dm_ceb} \
{/top_tb/TOP/dm_din\[31:0\]} \
{/top_tb/TOP/dm_dout\[31:0\]} \
{/top_tb/TOP/dm_w_en} \
{/top_tb/TOP/im_addr\[13:0\]} \
{/top_tb/TOP/im_dout\[31:0\]} \
{/BLANK} \
}
wvAddSignal -win $_nWave1 -group {"G2" \
}
wvSelectSignal -win $_nWave1 {( "G1" 1 2 3 4 5 6 7 8 9 10 )} 
wvSetPosition -win $_nWave1 {("G1" 10)}
wvGetSignalClose -win $_nWave1
wvSetCursor -win $_nWave1 85706.539413 -snap {("G1" 5)}
wvZoomIn -win $_nWave1
wvZoomIn -win $_nWave1
wvZoomIn -win $_nWave1
wvZoomIn -win $_nWave1
wvSelectSignal -win $_nWave1 {( "G1" 6 )} 
wvGetSignalOpen -win $_nWave1
wvGetSignalSetScope -win $_nWave1 "/top_tb"
wvGetSignalSetScope -win $_nWave1 "/top_tb/TOP"
wvGetSignalSetScope -win $_nWave1 "/top_tb/TOP/cpu"
wvSetPosition -win $_nWave1 {("G1" 16)}
wvSetPosition -win $_nWave1 {("G1" 16)}
wvAddSignal -win $_nWave1 -clear
wvAddSignal -win $_nWave1 -group {"G1" \
{/top_tb/TOP/clk} \
{/top_tb/TOP/dm_addr\[13:0\]} \
{/top_tb/TOP/dm_bweb\[31:0\]} \
{/top_tb/TOP/dm_ceb} \
{/top_tb/TOP/dm_din\[31:0\]} \
{/top_tb/TOP/dm_dout\[31:0\]} \
{/top_tb/TOP/dm_w_en} \
{/top_tb/TOP/im_addr\[13:0\]} \
{/top_tb/TOP/im_dout\[31:0\]} \
{/BLANK} \
{/top_tb/TOP/cpu/IF_flush} \
{/top_tb/TOP/cpu/IF_inst\[31:0\]} \
{/top_tb/TOP/cpu/IF_pc\[31:0\]} \
{/top_tb/TOP/cpu/next_pc_sel\[1:0\]} \
{/top_tb/TOP/cpu/stall} \
{/BLANK} \
}
wvAddSignal -win $_nWave1 -group {"G2" \
}
wvSelectSignal -win $_nWave1 {( "G1" 11 12 13 14 15 16 )} 
wvSetPosition -win $_nWave1 {("G1" 16)}
wvSetPosition -win $_nWave1 {("G1" 25)}
wvSetPosition -win $_nWave1 {("G1" 25)}
wvAddSignal -win $_nWave1 -clear
wvAddSignal -win $_nWave1 -group {"G1" \
{/top_tb/TOP/clk} \
{/top_tb/TOP/dm_addr\[13:0\]} \
{/top_tb/TOP/dm_bweb\[31:0\]} \
{/top_tb/TOP/dm_ceb} \
{/top_tb/TOP/dm_din\[31:0\]} \
{/top_tb/TOP/dm_dout\[31:0\]} \
{/top_tb/TOP/dm_w_en} \
{/top_tb/TOP/im_addr\[13:0\]} \
{/top_tb/TOP/im_dout\[31:0\]} \
{/BLANK} \
{/top_tb/TOP/cpu/IF_flush} \
{/top_tb/TOP/cpu/IF_inst\[31:0\]} \
{/top_tb/TOP/cpu/IF_pc\[31:0\]} \
{/top_tb/TOP/cpu/next_pc_sel\[1:0\]} \
{/top_tb/TOP/cpu/stall} \
{/BLANK} \
{/top_tb/TOP/cpu/ID_branch_target\[31:0\]} \
{/top_tb/TOP/cpu/ID_flush} \
{/top_tb/TOP/cpu/ID_inst\[31:0\]} \
{/top_tb/TOP/cpu/ID_op\[6:0\]} \
{/top_tb/TOP/cpu/ID_pc\[31:0\]} \
{/top_tb/TOP/cpu/ID_predict_taken} \
{/top_tb/TOP/cpu/ID_rs1_data_sel\[1:0\]} \
{/top_tb/TOP/cpu/ID_rs2_data_sel\[1:0\]} \
{/BLANK} \
}
wvAddSignal -win $_nWave1 -group {"G2" \
}
wvSelectSignal -win $_nWave1 {( "G1" 17 18 19 20 21 22 23 24 25 )} 
wvSetPosition -win $_nWave1 {("G1" 25)}
wvSetPosition -win $_nWave1 {("G1" 34)}
wvSetPosition -win $_nWave1 {("G1" 34)}
wvAddSignal -win $_nWave1 -clear
wvAddSignal -win $_nWave1 -group {"G1" \
{/top_tb/TOP/clk} \
{/top_tb/TOP/dm_addr\[13:0\]} \
{/top_tb/TOP/dm_bweb\[31:0\]} \
{/top_tb/TOP/dm_ceb} \
{/top_tb/TOP/dm_din\[31:0\]} \
{/top_tb/TOP/dm_dout\[31:0\]} \
{/top_tb/TOP/dm_w_en} \
{/top_tb/TOP/im_addr\[13:0\]} \
{/top_tb/TOP/im_dout\[31:0\]} \
{/BLANK} \
{/top_tb/TOP/cpu/IF_flush} \
{/top_tb/TOP/cpu/IF_inst\[31:0\]} \
{/top_tb/TOP/cpu/IF_pc\[31:0\]} \
{/top_tb/TOP/cpu/next_pc_sel\[1:0\]} \
{/top_tb/TOP/cpu/stall} \
{/BLANK} \
{/top_tb/TOP/cpu/ID_branch_target\[31:0\]} \
{/top_tb/TOP/cpu/ID_flush} \
{/top_tb/TOP/cpu/ID_inst\[31:0\]} \
{/top_tb/TOP/cpu/ID_op\[6:0\]} \
{/top_tb/TOP/cpu/ID_pc\[31:0\]} \
{/top_tb/TOP/cpu/ID_predict_taken} \
{/top_tb/TOP/cpu/ID_rs1_data_sel\[1:0\]} \
{/top_tb/TOP/cpu/ID_rs2_data_sel\[1:0\]} \
{/BLANK} \
{/top_tb/TOP/cpu/EX_actual_taken} \
{/top_tb/TOP/cpu/EX_imm_ext\[31:0\]} \
{/top_tb/TOP/cpu/EX_op\[6:0\]} \
{/top_tb/TOP/cpu/EX_pc\[31:0\]} \
{/top_tb/TOP/cpu/EX_predict_taken} \
{/top_tb/TOP/cpu/EX_reg_src1_data_sel\[1:0\]} \
{/top_tb/TOP/cpu/EX_reg_src2_data_sel\[1:0\]} \
{/top_tb/TOP/cpu/history_reg_1} \
{/BLANK} \
}
wvAddSignal -win $_nWave1 -group {"G2" \
}
wvSelectSignal -win $_nWave1 {( "G1" 26 27 28 29 30 31 32 33 34 )} 
wvSetPosition -win $_nWave1 {("G1" 34)}
wvSetPosition -win $_nWave1 {("G1" 34)}
wvSetPosition -win $_nWave1 {("G1" 34)}
wvAddSignal -win $_nWave1 -clear
wvAddSignal -win $_nWave1 -group {"G1" \
{/top_tb/TOP/clk} \
{/top_tb/TOP/dm_addr\[13:0\]} \
{/top_tb/TOP/dm_bweb\[31:0\]} \
{/top_tb/TOP/dm_ceb} \
{/top_tb/TOP/dm_din\[31:0\]} \
{/top_tb/TOP/dm_dout\[31:0\]} \
{/top_tb/TOP/dm_w_en} \
{/top_tb/TOP/im_addr\[13:0\]} \
{/top_tb/TOP/im_dout\[31:0\]} \
{/BLANK} \
{/top_tb/TOP/cpu/IF_flush} \
{/top_tb/TOP/cpu/IF_inst\[31:0\]} \
{/top_tb/TOP/cpu/IF_pc\[31:0\]} \
{/top_tb/TOP/cpu/next_pc_sel\[1:0\]} \
{/top_tb/TOP/cpu/stall} \
{/BLANK} \
{/top_tb/TOP/cpu/ID_branch_target\[31:0\]} \
{/top_tb/TOP/cpu/ID_flush} \
{/top_tb/TOP/cpu/ID_inst\[31:0\]} \
{/top_tb/TOP/cpu/ID_op\[6:0\]} \
{/top_tb/TOP/cpu/ID_pc\[31:0\]} \
{/top_tb/TOP/cpu/ID_predict_taken} \
{/top_tb/TOP/cpu/ID_rs1_data_sel\[1:0\]} \
{/top_tb/TOP/cpu/ID_rs2_data_sel\[1:0\]} \
{/BLANK} \
{/top_tb/TOP/cpu/EX_actual_taken} \
{/top_tb/TOP/cpu/EX_imm_ext\[31:0\]} \
{/top_tb/TOP/cpu/EX_op\[6:0\]} \
{/top_tb/TOP/cpu/EX_pc\[31:0\]} \
{/top_tb/TOP/cpu/EX_predict_taken} \
{/top_tb/TOP/cpu/EX_reg_src1_data_sel\[1:0\]} \
{/top_tb/TOP/cpu/EX_reg_src2_data_sel\[1:0\]} \
{/top_tb/TOP/cpu/history_reg_1} \
{/BLANK} \
}
wvAddSignal -win $_nWave1 -group {"G2" \
}
wvSelectSignal -win $_nWave1 {( "G1" 26 27 28 29 30 31 32 33 34 )} 
wvSetPosition -win $_nWave1 {("G1" 34)}
wvGetSignalClose -win $_nWave1
wvSelectSignal -win $_nWave1 {( "G1" 11 )} 
wvSelectSignal -win $_nWave1 {( "G1" 12 )} 
wvSelectSignal -win $_nWave1 {( "G1" 13 )} 
wvSetCursor -win $_nWave1 45237.636085 -snap {("G1" 13)}
wvSelectSignal -win $_nWave1 {( "G1" 26 )} 
wvSelectSignal -win $_nWave1 {( "G1" 8 )} 
wvSelectSignal -win $_nWave1 {( "G1" 13 )} 
wvSelectSignal -win $_nWave1 {( "G1" 4 )} 
wvSelectSignal -win $_nWave1 {( "G1" 5 )} 
wvSelectSignal -win $_nWave1 {( "G1" 33 )} 
wvGetSignalOpen -win $_nWave1
wvGetSignalSetScope -win $_nWave1 "/top_tb"
wvGetSignalSetScope -win $_nWave1 "/top_tb/TOP"
wvGetSignalSetScope -win $_nWave1 "/top_tb/TOP/cpu"
wvGetSignalSetScope -win $_nWave1 "/top_tb/TOP/cpu/BHB"
wvSetPosition -win $_nWave1 {("G1" 35)}
wvSetPosition -win $_nWave1 {("G1" 35)}
wvAddSignal -win $_nWave1 -clear
wvAddSignal -win $_nWave1 -group {"G1" \
{/top_tb/TOP/clk} \
{/top_tb/TOP/dm_addr\[13:0\]} \
{/top_tb/TOP/dm_bweb\[31:0\]} \
{/top_tb/TOP/dm_ceb} \
{/top_tb/TOP/dm_din\[31:0\]} \
{/top_tb/TOP/dm_dout\[31:0\]} \
{/top_tb/TOP/dm_w_en} \
{/top_tb/TOP/im_addr\[13:0\]} \
{/top_tb/TOP/im_dout\[31:0\]} \
{/BLANK} \
{/top_tb/TOP/cpu/IF_flush} \
{/top_tb/TOP/cpu/IF_inst\[31:0\]} \
{/top_tb/TOP/cpu/IF_pc\[31:0\]} \
{/top_tb/TOP/cpu/next_pc_sel\[1:0\]} \
{/top_tb/TOP/cpu/stall} \
{/BLANK} \
{/top_tb/TOP/cpu/ID_branch_target\[31:0\]} \
{/top_tb/TOP/cpu/ID_flush} \
{/top_tb/TOP/cpu/ID_inst\[31:0\]} \
{/top_tb/TOP/cpu/ID_op\[6:0\]} \
{/top_tb/TOP/cpu/ID_pc\[31:0\]} \
{/top_tb/TOP/cpu/ID_predict_taken} \
{/top_tb/TOP/cpu/ID_rs1_data_sel\[1:0\]} \
{/top_tb/TOP/cpu/ID_rs2_data_sel\[1:0\]} \
{/BLANK} \
{/top_tb/TOP/cpu/EX_actual_taken} \
{/top_tb/TOP/cpu/EX_imm_ext\[31:0\]} \
{/top_tb/TOP/cpu/EX_op\[6:0\]} \
{/top_tb/TOP/cpu/EX_pc\[31:0\]} \
{/top_tb/TOP/cpu/EX_predict_taken} \
{/top_tb/TOP/cpu/EX_reg_src1_data_sel\[1:0\]} \
{/top_tb/TOP/cpu/EX_reg_src2_data_sel\[1:0\]} \
{/top_tb/TOP/cpu/history_reg_1} \
{/BLANK} \
{/top_tb/TOP/cpu/BHB/history_reg\[1:0\]} \
}
wvAddSignal -win $_nWave1 -group {"G2" \
}
wvSelectSignal -win $_nWave1 {( "G1" 35 )} 
wvSetPosition -win $_nWave1 {("G1" 35)}
wvSetPosition -win $_nWave1 {("G1" 35)}
wvSetPosition -win $_nWave1 {("G1" 35)}
wvAddSignal -win $_nWave1 -clear
wvAddSignal -win $_nWave1 -group {"G1" \
{/top_tb/TOP/clk} \
{/top_tb/TOP/dm_addr\[13:0\]} \
{/top_tb/TOP/dm_bweb\[31:0\]} \
{/top_tb/TOP/dm_ceb} \
{/top_tb/TOP/dm_din\[31:0\]} \
{/top_tb/TOP/dm_dout\[31:0\]} \
{/top_tb/TOP/dm_w_en} \
{/top_tb/TOP/im_addr\[13:0\]} \
{/top_tb/TOP/im_dout\[31:0\]} \
{/BLANK} \
{/top_tb/TOP/cpu/IF_flush} \
{/top_tb/TOP/cpu/IF_inst\[31:0\]} \
{/top_tb/TOP/cpu/IF_pc\[31:0\]} \
{/top_tb/TOP/cpu/next_pc_sel\[1:0\]} \
{/top_tb/TOP/cpu/stall} \
{/BLANK} \
{/top_tb/TOP/cpu/ID_branch_target\[31:0\]} \
{/top_tb/TOP/cpu/ID_flush} \
{/top_tb/TOP/cpu/ID_inst\[31:0\]} \
{/top_tb/TOP/cpu/ID_op\[6:0\]} \
{/top_tb/TOP/cpu/ID_pc\[31:0\]} \
{/top_tb/TOP/cpu/ID_predict_taken} \
{/top_tb/TOP/cpu/ID_rs1_data_sel\[1:0\]} \
{/top_tb/TOP/cpu/ID_rs2_data_sel\[1:0\]} \
{/BLANK} \
{/top_tb/TOP/cpu/EX_actual_taken} \
{/top_tb/TOP/cpu/EX_imm_ext\[31:0\]} \
{/top_tb/TOP/cpu/EX_op\[6:0\]} \
{/top_tb/TOP/cpu/EX_pc\[31:0\]} \
{/top_tb/TOP/cpu/EX_predict_taken} \
{/top_tb/TOP/cpu/EX_reg_src1_data_sel\[1:0\]} \
{/top_tb/TOP/cpu/EX_reg_src2_data_sel\[1:0\]} \
{/top_tb/TOP/cpu/history_reg_1} \
{/BLANK} \
{/top_tb/TOP/cpu/BHB/history_reg\[1:0\]} \
}
wvAddSignal -win $_nWave1 -group {"G2" \
}
wvSelectSignal -win $_nWave1 {( "G1" 35 )} 
wvSetPosition -win $_nWave1 {("G1" 35)}
wvGetSignalClose -win $_nWave1
wvSetCursor -win $_nWave1 44626.811112 -snap {("G1" 4)}
wvSetCursor -win $_nWave1 44561.486006 -snap {("G1" 35)}
wvGetSignalOpen -win $_nWave1
wvGetSignalSetScope -win $_nWave1 "/top_tb"
wvGetSignalSetScope -win $_nWave1 "/top_tb/TOP"
wvGetSignalSetScope -win $_nWave1 "/top_tb/TOP/cpu"
wvGetSignalSetScope -win $_nWave1 "/top_tb/TOP/cpu/BHB"
wvGetSignalSetScope -win $_nWave1 "/top_tb/TOP/cpu/csr"
wvGetSignalSetScope -win $_nWave1 "/top_tb/TOP/cpu/controller"
wvSetPosition -win $_nWave1 {("G1" 37)}
wvSetPosition -win $_nWave1 {("G1" 37)}
wvAddSignal -win $_nWave1 -clear
wvAddSignal -win $_nWave1 -group {"G1" \
{/top_tb/TOP/clk} \
{/top_tb/TOP/dm_addr\[13:0\]} \
{/top_tb/TOP/dm_bweb\[31:0\]} \
{/top_tb/TOP/dm_ceb} \
{/top_tb/TOP/dm_din\[31:0\]} \
{/top_tb/TOP/dm_dout\[31:0\]} \
{/top_tb/TOP/dm_w_en} \
{/top_tb/TOP/im_addr\[13:0\]} \
{/top_tb/TOP/im_dout\[31:0\]} \
{/BLANK} \
{/top_tb/TOP/cpu/IF_flush} \
{/top_tb/TOP/cpu/IF_inst\[31:0\]} \
{/top_tb/TOP/cpu/IF_pc\[31:0\]} \
{/top_tb/TOP/cpu/next_pc_sel\[1:0\]} \
{/top_tb/TOP/cpu/stall} \
{/BLANK} \
{/top_tb/TOP/cpu/ID_branch_target\[31:0\]} \
{/top_tb/TOP/cpu/ID_flush} \
{/top_tb/TOP/cpu/ID_inst\[31:0\]} \
{/top_tb/TOP/cpu/ID_op\[6:0\]} \
{/top_tb/TOP/cpu/ID_pc\[31:0\]} \
{/top_tb/TOP/cpu/ID_predict_taken} \
{/top_tb/TOP/cpu/ID_rs1_data_sel\[1:0\]} \
{/top_tb/TOP/cpu/ID_rs2_data_sel\[1:0\]} \
{/BLANK} \
{/top_tb/TOP/cpu/EX_actual_taken} \
{/top_tb/TOP/cpu/EX_imm_ext\[31:0\]} \
{/top_tb/TOP/cpu/EX_op\[6:0\]} \
{/top_tb/TOP/cpu/EX_pc\[31:0\]} \
{/top_tb/TOP/cpu/EX_predict_taken} \
{/top_tb/TOP/cpu/EX_reg_src1_data_sel\[1:0\]} \
{/top_tb/TOP/cpu/EX_reg_src2_data_sel\[1:0\]} \
{/top_tb/TOP/cpu/history_reg_1} \
{/BLANK} \
{/top_tb/TOP/cpu/BHB/history_reg\[1:0\]} \
{/top_tb/TOP/cpu/controller/ex_is_branch} \
{/top_tb/TOP/cpu/controller/id_is_branch} \
}
wvAddSignal -win $_nWave1 -group {"G2" \
}
wvSelectSignal -win $_nWave1 {( "G1" 36 37 )} 
wvSetPosition -win $_nWave1 {("G1" 37)}
wvSetPosition -win $_nWave1 {("G1" 37)}
wvSetPosition -win $_nWave1 {("G1" 37)}
wvAddSignal -win $_nWave1 -clear
wvAddSignal -win $_nWave1 -group {"G1" \
{/top_tb/TOP/clk} \
{/top_tb/TOP/dm_addr\[13:0\]} \
{/top_tb/TOP/dm_bweb\[31:0\]} \
{/top_tb/TOP/dm_ceb} \
{/top_tb/TOP/dm_din\[31:0\]} \
{/top_tb/TOP/dm_dout\[31:0\]} \
{/top_tb/TOP/dm_w_en} \
{/top_tb/TOP/im_addr\[13:0\]} \
{/top_tb/TOP/im_dout\[31:0\]} \
{/BLANK} \
{/top_tb/TOP/cpu/IF_flush} \
{/top_tb/TOP/cpu/IF_inst\[31:0\]} \
{/top_tb/TOP/cpu/IF_pc\[31:0\]} \
{/top_tb/TOP/cpu/next_pc_sel\[1:0\]} \
{/top_tb/TOP/cpu/stall} \
{/BLANK} \
{/top_tb/TOP/cpu/ID_branch_target\[31:0\]} \
{/top_tb/TOP/cpu/ID_flush} \
{/top_tb/TOP/cpu/ID_inst\[31:0\]} \
{/top_tb/TOP/cpu/ID_op\[6:0\]} \
{/top_tb/TOP/cpu/ID_pc\[31:0\]} \
{/top_tb/TOP/cpu/ID_predict_taken} \
{/top_tb/TOP/cpu/ID_rs1_data_sel\[1:0\]} \
{/top_tb/TOP/cpu/ID_rs2_data_sel\[1:0\]} \
{/BLANK} \
{/top_tb/TOP/cpu/EX_actual_taken} \
{/top_tb/TOP/cpu/EX_imm_ext\[31:0\]} \
{/top_tb/TOP/cpu/EX_op\[6:0\]} \
{/top_tb/TOP/cpu/EX_pc\[31:0\]} \
{/top_tb/TOP/cpu/EX_predict_taken} \
{/top_tb/TOP/cpu/EX_reg_src1_data_sel\[1:0\]} \
{/top_tb/TOP/cpu/EX_reg_src2_data_sel\[1:0\]} \
{/top_tb/TOP/cpu/history_reg_1} \
{/BLANK} \
{/top_tb/TOP/cpu/BHB/history_reg\[1:0\]} \
{/top_tb/TOP/cpu/controller/ex_is_branch} \
{/top_tb/TOP/cpu/controller/id_is_branch} \
}
wvAddSignal -win $_nWave1 -group {"G2" \
}
wvSelectSignal -win $_nWave1 {( "G1" 36 37 )} 
wvSetPosition -win $_nWave1 {("G1" 37)}
wvGetSignalClose -win $_nWave1
wvSetCursor -win $_nWave1 43548.946859 -snap {("G1" 37)}
wvSelectSignal -win $_nWave1 {( "G1" 26 )} 
wvSelectSignal -win $_nWave1 {( "G1" 33 )} 
wvCut -win $_nWave1
wvSetPosition -win $_nWave1 {("G2" 0)}
wvSetPosition -win $_nWave1 {("G1" 36)}
wvSetCursor -win $_nWave1 57453.395726 -snap {("G1" 26)}
wvSetCursor -win $_nWave1 71465.631019 -snap {("G1" 30)}
wvSetCursor -win $_nWave1 80431.501853 -snap {("G1" 5)}
wvZoomIn -win $_nWave1
wvSetCursor -win $_nWave1 119414.259013 -snap {("G1" 2)}
wvDisplayGridCount -win $_nWave1 -off
wvGetSignalClose -win $_nWave1
wvReloadFile -win $_nWave1
wvSelectSignal -win $_nWave1 {( "G1" 30 )} 
wvSelectSignal -win $_nWave1 {( "G1" 26 )} 
wvSelectSignal -win $_nWave1 {( "G1" 27 )} 
wvSelectSignal -win $_nWave1 {( "G1" 28 )} 
wvSelectSignal -win $_nWave1 {( "G1" 29 )} 
wvSelectSignal -win $_nWave1 {( "G1" 32 )} 
wvSelectSignal -win $_nWave1 {( "G1" 27 )} 
wvGetSignalOpen -win $_nWave1
wvGetSignalSetScope -win $_nWave1 "/top_tb/TOP/cpu"
wvGetSignalSetScope -win $_nWave1 "/top_tb/TOP/cpu/controller"
wvSetPosition -win $_nWave1 {("G1" 37)}
wvSetPosition -win $_nWave1 {("G1" 37)}
wvAddSignal -win $_nWave1 -clear
wvAddSignal -win $_nWave1 -group {"G1" \
{/top_tb/TOP/clk} \
{/top_tb/TOP/dm_addr\[13:0\]} \
{/top_tb/TOP/dm_bweb\[31:0\]} \
{/top_tb/TOP/dm_ceb} \
{/top_tb/TOP/dm_din\[31:0\]} \
{/top_tb/TOP/dm_dout\[31:0\]} \
{/top_tb/TOP/dm_w_en} \
{/top_tb/TOP/im_addr\[13:0\]} \
{/top_tb/TOP/im_dout\[31:0\]} \
{/BLANK} \
{/top_tb/TOP/cpu/IF_flush} \
{/top_tb/TOP/cpu/IF_inst\[31:0\]} \
{/top_tb/TOP/cpu/IF_pc\[31:0\]} \
{/top_tb/TOP/cpu/next_pc_sel\[1:0\]} \
{/top_tb/TOP/cpu/stall} \
{/BLANK} \
{/top_tb/TOP/cpu/ID_branch_target\[31:0\]} \
{/top_tb/TOP/cpu/ID_flush} \
{/top_tb/TOP/cpu/ID_inst\[31:0\]} \
{/top_tb/TOP/cpu/ID_op\[6:0\]} \
{/top_tb/TOP/cpu/ID_pc\[31:0\]} \
{/top_tb/TOP/cpu/ID_predict_taken} \
{/top_tb/TOP/cpu/ID_rs1_data_sel\[1:0\]} \
{/top_tb/TOP/cpu/ID_rs2_data_sel\[1:0\]} \
{/BLANK} \
{/top_tb/TOP/cpu/EX_actual_taken} \
{/top_tb/TOP/cpu/EX_imm_ext\[31:0\]} \
{/top_tb/TOP/cpu/EX_op\[6:0\]} \
{/top_tb/TOP/cpu/EX_pc\[31:0\]} \
{/top_tb/TOP/cpu/EX_predict_taken} \
{/top_tb/TOP/cpu/EX_reg_src1_data_sel\[1:0\]} \
{/top_tb/TOP/cpu/EX_reg_src2_data_sel\[1:0\]} \
{/BLANK} \
{/top_tb/TOP/cpu/BHB/history_reg\[1:0\]} \
{/top_tb/TOP/cpu/controller/ex_is_branch} \
{/top_tb/TOP/cpu/controller/id_is_branch} \
{/top_tb/TOP/cpu/controller/EX_mispredict} \
}
wvAddSignal -win $_nWave1 -group {"G2" \
}
wvSelectSignal -win $_nWave1 {( "G1" 37 )} 
wvSetPosition -win $_nWave1 {("G1" 37)}
wvSetPosition -win $_nWave1 {("G1" 37)}
wvSetPosition -win $_nWave1 {("G1" 37)}
wvAddSignal -win $_nWave1 -clear
wvAddSignal -win $_nWave1 -group {"G1" \
{/top_tb/TOP/clk} \
{/top_tb/TOP/dm_addr\[13:0\]} \
{/top_tb/TOP/dm_bweb\[31:0\]} \
{/top_tb/TOP/dm_ceb} \
{/top_tb/TOP/dm_din\[31:0\]} \
{/top_tb/TOP/dm_dout\[31:0\]} \
{/top_tb/TOP/dm_w_en} \
{/top_tb/TOP/im_addr\[13:0\]} \
{/top_tb/TOP/im_dout\[31:0\]} \
{/BLANK} \
{/top_tb/TOP/cpu/IF_flush} \
{/top_tb/TOP/cpu/IF_inst\[31:0\]} \
{/top_tb/TOP/cpu/IF_pc\[31:0\]} \
{/top_tb/TOP/cpu/next_pc_sel\[1:0\]} \
{/top_tb/TOP/cpu/stall} \
{/BLANK} \
{/top_tb/TOP/cpu/ID_branch_target\[31:0\]} \
{/top_tb/TOP/cpu/ID_flush} \
{/top_tb/TOP/cpu/ID_inst\[31:0\]} \
{/top_tb/TOP/cpu/ID_op\[6:0\]} \
{/top_tb/TOP/cpu/ID_pc\[31:0\]} \
{/top_tb/TOP/cpu/ID_predict_taken} \
{/top_tb/TOP/cpu/ID_rs1_data_sel\[1:0\]} \
{/top_tb/TOP/cpu/ID_rs2_data_sel\[1:0\]} \
{/BLANK} \
{/top_tb/TOP/cpu/EX_actual_taken} \
{/top_tb/TOP/cpu/EX_imm_ext\[31:0\]} \
{/top_tb/TOP/cpu/EX_op\[6:0\]} \
{/top_tb/TOP/cpu/EX_pc\[31:0\]} \
{/top_tb/TOP/cpu/EX_predict_taken} \
{/top_tb/TOP/cpu/EX_reg_src1_data_sel\[1:0\]} \
{/top_tb/TOP/cpu/EX_reg_src2_data_sel\[1:0\]} \
{/BLANK} \
{/top_tb/TOP/cpu/BHB/history_reg\[1:0\]} \
{/top_tb/TOP/cpu/controller/ex_is_branch} \
{/top_tb/TOP/cpu/controller/id_is_branch} \
{/top_tb/TOP/cpu/controller/EX_mispredict} \
}
wvAddSignal -win $_nWave1 -group {"G2" \
}
wvSelectSignal -win $_nWave1 {( "G1" 37 )} 
wvSetPosition -win $_nWave1 {("G1" 37)}
wvGetSignalClose -win $_nWave1
wvZoomIn -win $_nWave1
wvZoomIn -win $_nWave1
wvZoomIn -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomIn -win $_nWave1
wvZoomIn -win $_nWave1
wvZoomIn -win $_nWave1
wvZoomIn -win $_nWave1
wvSetCursor -win $_nWave1 1502.477444 -snap {("G1" 18)}
wvSetCursor -win $_nWave1 1535.139997 -snap {("G1" 19)}
wvSelectSignal -win $_nWave1 {( "G1" 9 )} 
wvZoomIn -win $_nWave1
wvZoomIn -win $_nWave1
wvZoomOut -win $_nWave1
wvSelectSignal -win $_nWave1 {( "G1" 20 )} 
wvSelectSignal -win $_nWave1 {( "G1" 37 )} 
wvSetCursor -win $_nWave1 43490.189492 -snap {("G1" 37)}
wvSelectSignal -win $_nWave1 {( "G1" 13 )} 
wvSetCursor -win $_nWave1 42428.656516 -snap {("G1" 13)}
wvSetCursor -win $_nWave1 41367.123539 -snap {("G1" 13)}
wvSetCursor -win $_nWave1 42444.987792 -snap {("G1" 13)}
wvSetCursor -win $_nWave1 43457.526939 -snap {("G1" 12)}
wvZoom -win $_nWave1 43081.907578 43996.459066
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvSetCursor -win $_nWave1 41481.089093 -snap {("G1" 13)}
wvSelectSignal -win $_nWave1 {( "G1" 35 )} 
wvSelectSignal -win $_nWave1 {( "G1" 36 )} 
wvSelectSignal -win $_nWave1 {( "G1" 35 )} 
wvSelectSignal -win $_nWave1 {( "G1" 36 )} 
wvSelectSignal -win $_nWave1 {( "G1" 12 )} 
wvSelectSignal -win $_nWave1 {( "G1" 37 )} 
wvSelectSignal -win $_nWave1 {( "G1" 36 )} 
wvSetCursor -win $_nWave1 42679.759358 -snap {("G1" 36)}
wvSelectSignal -win $_nWave1 {( "G1" 5 )} 
wvSetCursor -win $_nWave1 44466.456546 -snap {("G1" 11)}
wvSelectSignal -win $_nWave1 {( "G1" 37 )} 
wvSetCursor -win $_nWave1 57470.898101 -snap {("G1" 37)}
wvSetCursor -win $_nWave1 71454.630647 -snap {("G1" 37)}
wvSelectSignal -win $_nWave1 {( "G1" 14 )} 
wvGetSignalOpen -win $_nWave1
wvGetSignalSetScope -win $_nWave1 "/top_tb"
wvGetSignalSetScope -win $_nWave1 "/top_tb/TOP"
wvGetSignalSetScope -win $_nWave1 "/top_tb/TOP/cpu"
wvGetSignalSetScope -win $_nWave1 "/top_tb/TOP/cpu/BHB"
wvGetSignalSetScope -win $_nWave1 "/top_tb/TOP/cpu/controller"
wvGetSignalSetScope -win $_nWave1 "/top_tb/TOP"
wvGetSignalSetScope -win $_nWave1 "/top_tb/TOP/cpu"
wvSetPosition -win $_nWave1 {("G1" 38)}
wvSetPosition -win $_nWave1 {("G1" 38)}
wvAddSignal -win $_nWave1 -clear
wvAddSignal -win $_nWave1 -group {"G1" \
{/top_tb/TOP/clk} \
{/top_tb/TOP/dm_addr\[13:0\]} \
{/top_tb/TOP/dm_bweb\[31:0\]} \
{/top_tb/TOP/dm_ceb} \
{/top_tb/TOP/dm_din\[31:0\]} \
{/top_tb/TOP/dm_dout\[31:0\]} \
{/top_tb/TOP/dm_w_en} \
{/top_tb/TOP/im_addr\[13:0\]} \
{/top_tb/TOP/im_dout\[31:0\]} \
{/BLANK} \
{/top_tb/TOP/cpu/IF_flush} \
{/top_tb/TOP/cpu/IF_inst\[31:0\]} \
{/top_tb/TOP/cpu/IF_pc\[31:0\]} \
{/top_tb/TOP/cpu/next_pc_sel\[1:0\]} \
{/top_tb/TOP/cpu/stall} \
{/BLANK} \
{/top_tb/TOP/cpu/ID_branch_target\[31:0\]} \
{/top_tb/TOP/cpu/ID_flush} \
{/top_tb/TOP/cpu/ID_inst\[31:0\]} \
{/top_tb/TOP/cpu/ID_op\[6:0\]} \
{/top_tb/TOP/cpu/ID_pc\[31:0\]} \
{/top_tb/TOP/cpu/ID_predict_taken} \
{/top_tb/TOP/cpu/ID_rs1_data_sel\[1:0\]} \
{/top_tb/TOP/cpu/ID_rs2_data_sel\[1:0\]} \
{/BLANK} \
{/top_tb/TOP/cpu/EX_actual_taken} \
{/top_tb/TOP/cpu/EX_imm_ext\[31:0\]} \
{/top_tb/TOP/cpu/EX_op\[6:0\]} \
{/top_tb/TOP/cpu/EX_pc\[31:0\]} \
{/top_tb/TOP/cpu/EX_predict_taken} \
{/top_tb/TOP/cpu/EX_reg_src1_data_sel\[1:0\]} \
{/top_tb/TOP/cpu/EX_reg_src2_data_sel\[1:0\]} \
{/BLANK} \
{/top_tb/TOP/cpu/BHB/history_reg\[1:0\]} \
{/top_tb/TOP/cpu/controller/ex_is_branch} \
{/top_tb/TOP/cpu/controller/id_is_branch} \
{/top_tb/TOP/cpu/controller/EX_mispredict} \
{/top_tb/TOP/cpu/next_pc\[31:0\]} \
}
wvAddSignal -win $_nWave1 -group {"G2" \
}
wvSelectSignal -win $_nWave1 {( "G1" 38 )} 
wvSetPosition -win $_nWave1 {("G1" 38)}
wvSetPosition -win $_nWave1 {("G1" 38)}
wvSetPosition -win $_nWave1 {("G1" 38)}
wvAddSignal -win $_nWave1 -clear
wvAddSignal -win $_nWave1 -group {"G1" \
{/top_tb/TOP/clk} \
{/top_tb/TOP/dm_addr\[13:0\]} \
{/top_tb/TOP/dm_bweb\[31:0\]} \
{/top_tb/TOP/dm_ceb} \
{/top_tb/TOP/dm_din\[31:0\]} \
{/top_tb/TOP/dm_dout\[31:0\]} \
{/top_tb/TOP/dm_w_en} \
{/top_tb/TOP/im_addr\[13:0\]} \
{/top_tb/TOP/im_dout\[31:0\]} \
{/BLANK} \
{/top_tb/TOP/cpu/IF_flush} \
{/top_tb/TOP/cpu/IF_inst\[31:0\]} \
{/top_tb/TOP/cpu/IF_pc\[31:0\]} \
{/top_tb/TOP/cpu/next_pc_sel\[1:0\]} \
{/top_tb/TOP/cpu/stall} \
{/BLANK} \
{/top_tb/TOP/cpu/ID_branch_target\[31:0\]} \
{/top_tb/TOP/cpu/ID_flush} \
{/top_tb/TOP/cpu/ID_inst\[31:0\]} \
{/top_tb/TOP/cpu/ID_op\[6:0\]} \
{/top_tb/TOP/cpu/ID_pc\[31:0\]} \
{/top_tb/TOP/cpu/ID_predict_taken} \
{/top_tb/TOP/cpu/ID_rs1_data_sel\[1:0\]} \
{/top_tb/TOP/cpu/ID_rs2_data_sel\[1:0\]} \
{/BLANK} \
{/top_tb/TOP/cpu/EX_actual_taken} \
{/top_tb/TOP/cpu/EX_imm_ext\[31:0\]} \
{/top_tb/TOP/cpu/EX_op\[6:0\]} \
{/top_tb/TOP/cpu/EX_pc\[31:0\]} \
{/top_tb/TOP/cpu/EX_predict_taken} \
{/top_tb/TOP/cpu/EX_reg_src1_data_sel\[1:0\]} \
{/top_tb/TOP/cpu/EX_reg_src2_data_sel\[1:0\]} \
{/BLANK} \
{/top_tb/TOP/cpu/BHB/history_reg\[1:0\]} \
{/top_tb/TOP/cpu/controller/ex_is_branch} \
{/top_tb/TOP/cpu/controller/id_is_branch} \
{/top_tb/TOP/cpu/controller/EX_mispredict} \
{/top_tb/TOP/cpu/next_pc\[31:0\]} \
}
wvAddSignal -win $_nWave1 -group {"G2" \
}
wvSelectSignal -win $_nWave1 {( "G1" 38 )} 
wvSetPosition -win $_nWave1 {("G1" 38)}
wvGetSignalClose -win $_nWave1
wvSetPosition -win $_nWave1 {("G1" 36)}
wvSetPosition -win $_nWave1 {("G1" 33)}
wvSetPosition -win $_nWave1 {("G1" 32)}
wvSetPosition -win $_nWave1 {("G1" 31)}
wvSetPosition -win $_nWave1 {("G1" 30)}
wvSetPosition -win $_nWave1 {("G1" 29)}
wvSetPosition -win $_nWave1 {("G1" 28)}
wvSetPosition -win $_nWave1 {("G1" 27)}
wvSetPosition -win $_nWave1 {("G1" 26)}
wvSetPosition -win $_nWave1 {("G1" 25)}
wvSetPosition -win $_nWave1 {("G1" 24)}
wvSetPosition -win $_nWave1 {("G1" 23)}
wvSetPosition -win $_nWave1 {("G1" 22)}
wvSetPosition -win $_nWave1 {("G1" 21)}
wvSetPosition -win $_nWave1 {("G1" 20)}
wvSetPosition -win $_nWave1 {("G1" 19)}
wvSetPosition -win $_nWave1 {("G1" 18)}
wvSetPosition -win $_nWave1 {("G1" 17)}
wvSetPosition -win $_nWave1 {("G1" 16)}
wvSetPosition -win $_nWave1 {("G1" 15)}
wvSetPosition -win $_nWave1 {("G1" 14)}
wvMoveSelected -win $_nWave1
wvSetPosition -win $_nWave1 {("G1" 14)}
wvSetPosition -win $_nWave1 {("G1" 15)}
wvSelectSignal -win $_nWave1 {( "G1" 38 )} 
wvSelectSignal -win $_nWave1 {( "G1" 31 )} 
wvSelectSignal -win $_nWave1 {( "G1" 38 )} 
wvSetCursor -win $_nWave1 57432.450187 -snap {("G1" 38)}
wvSetCursor -win $_nWave1 71522.479907 -snap {("G1" 38)}
wvSelectSignal -win $_nWave1 {( "G1" 31 )} 
wvSelectSignal -win $_nWave1 {( "G1" 26 )} 
wvSelectSignal -win $_nWave1 {( "G1" 26 )} 
wvSelectSignal -win $_nWave1 {( "G1" 27 )} 
wvSelectSignal -win $_nWave1 {( "G1" 37 )} 
wvSetCursor -win $_nWave1 70436.891742 -snap {("G1" 37)}
wvSetCursor -win $_nWave1 71545.096327 -snap {("G1" 13)}
wvSetCursor -win $_nWave1 72472.369551 -snap {("G1" 13)}
wvSetCursor -win $_nWave1 6605488.042982 -snap {("G1" 38)}
wvSetCursor -win $_nWave1 6606415.316206 -snap {("G1" 15)}
wvSetCursor -win $_nWave1 6605533.275822 -snap {("G1" 15)}
wvSetCursor -win $_nWave1 6606551.014727 -snap {("G1" 15)}
wvSetCursor -win $_nWave1 6607546.137211 -snap {("G1" 13)}
wvSetCursor -win $_nWave1 6605555.892242 -snap {("G1" 26)}
wvSetCursor -win $_nWave1 6608541.259695 -snap {("G1" 13)}
wvSelectSignal -win $_nWave1 {( "G1" 13 )} 
wvSelectSignal -win $_nWave1 {( "G1" 14 )} 
wvSetCursor -win $_nWave1 72304.792654 -snap {("G1" 38)}
wvSetCursor -win $_nWave1 70585.944727 -snap {("G1" 23)}
wvSetCursor -win $_nWave1 73842.709221 -snap {("G1" 23)}
wvSetCursor -win $_nWave1 73842.709221 -snap {("G1" 23)}
wvSetCursor -win $_nWave1 73842.709221 -snap {("G1" 23)}
wvSetCursor -win $_nWave1 76737.610993 -snap {("G1" 23)}
wvSetCursor -win $_nWave1 94333.185828 -snap {("G1" 23)}
wvSetCursor -win $_nWave1 94943.829170 -snap {("G1" 23)}
wvSetCursor -win $_nWave1 70291.931266 -snap {("G1" 22)}
wvSetCursor -win $_nWave1 71581.067211 -snap {("G1" 23)}
wvSetCursor -win $_nWave1 6660183.043214 -snap {("G1" 23)}
wvDisplayGridCount -win $_nWave1 -off
wvGetSignalClose -win $_nWave1
wvReloadFile -win $_nWave1
wvSetCursor -win $_nWave1 43604.457946 -snap {("G1" 38)}
wvSelectSignal -win $_nWave1 {( "G1" 38 )} 
wvSetCursor -win $_nWave1 44328.394021 -snap {("G1" 11)}
wvSelectSignal -win $_nWave1 {( "G1" 35 )} 
wvSelectSignal -win $_nWave1 {( "G1" 36 )} 
wvSelectSignal -win $_nWave1 {( "G1" 2 )} 
wvScrollUp -win $_nWave1 1
wvScrollDown -win $_nWave1 0
wvScrollDown -win $_nWave1 0
wvScrollDown -win $_nWave1 0
wvScrollDown -win $_nWave1 0
wvSelectSignal -win $_nWave1 {( "G1" 6 )} 
wvSelectSignal -win $_nWave1 {( "G1" 2 )} 
wvSelectSignal -win $_nWave1 {( "G1" 2 )} 
wvSetRadix -win $_nWave1 -format UDec
wvSelectSignal -win $_nWave1 {( "G1" 5 )} 
wvSelectSignal -win $_nWave1 {( "G1" 2 )} 
wvSetCursor -win $_nWave1 606323.606370 -snap {("G1" 3)}
wvZoom -win $_nWave1 612950.217458 613244.230919
wvScrollDown -win $_nWave1 1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomIn -win $_nWave1
wvZoomIn -win $_nWave1
wvZoomIn -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomIn -win $_nWave1
wvSelectSignal -win $_nWave1 {( "G1" 35 )} 
wvSetCursor -win $_nWave1 6695330.640219 -snap {("G1" 38)}
wvSelectSignal -win $_nWave1 {( "G1" 38 )} 
wvSetCursor -win $_nWave1 6692654.981394 -snap {("G1" 14)}
wvSelectSignal -win $_nWave1 {( "G1" 37 )} 
wvSetCursor -win $_nWave1 6694225.476791 -snap {("G1" 37)}
wvSetCursor -win $_nWave1 6695417.889963 -snap {("G1" 13)}
wvSetCursor -win $_nWave1 6694516.309272 -snap {("G1" 14)}
wvSetCursor -win $_nWave1 6695621.472700 -snap {("G1" 14)}
wvSetCursor -win $_nWave1 6696523.053391 -snap {("G1" 14)}
wvScrollUp -win $_nWave1 1
wvSelectSignal -win $_nWave1 {( "G1" 4 )} 
wvSelectSignal -win $_nWave1 {( "G1" 5 )} 
wvSetCursor -win $_nWave1 6747476.904061 -snap {("G1" 4)}
wvSelectSignal -win $_nWave1 {( "G1" 37 )} 
wvSetCursor -win $_nWave1 6744452.246260 -snap {("G1" 37)}
wvZoomIn -win $_nWave1
wvSetCursor -win $_nWave1 6732793.955399
wvSetCursor -win $_nWave1 6737490.907817 -snap {("G1" 37)}
wvZoomOut -win $_nWave1
wvSetCursor -win $_nWave1 6744529.053857 -snap {("G1" 37)}
wvSetCursor -win $_nWave1 6737403.658072 -snap {("G1" 37)}
wvSetCursor -win $_nWave1 6744529.053857 -snap {("G1" 23)}
wvSetCursor -win $_nWave1 6737490.907817 -snap {("G1" 23)}
wvZoomIn -win $_nWave1
wvZoomIn -win $_nWave1
wvScrollDown -win $_nWave1 0
wvZoomIn -win $_nWave1
wvZoomIn -win $_nWave1
wvZoomIn -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomIn -win $_nWave1
wvScrollDown -win $_nWave1 1
wvScrollDown -win $_nWave1 0
wvScrollDown -win $_nWave1 0
wvSetCursor -win $_nWave1 6739706.687781 -snap {("G2" 0)}
wvDisplayGridCount -win $_nWave1 -off
wvGetSignalClose -win $_nWave1
wvReloadFile -win $_nWave1
wvSelectSignal -win $_nWave1 {( "G1" 5 )} 
wvSelectSignal -win $_nWave1 {( "G1" 6 )} 
wvSelectSignal -win $_nWave1 {( "G1" 23 )} 
wvSelectSignal -win $_nWave1 {( "G1" 23 )} 
wvSetCursor -win $_nWave1 7672.409368 -snap {("G1" 23)}
wvSelectSignal -win $_nWave1 {( "G1" 35 )} 
wvSetCursor -win $_nWave1 7239551.537481 -snap {("G1" 35)}
wvSetCursor -win $_nWave1 7247430.189391 -snap {("G1" 35)}
wvSetCursor -win $_nWave1 7246514.067076 -snap {("G2" 0)}
wvSetCursor -win $_nWave1 7246441.358955 -snap {("G1" 38)}
wvSelectGroup -win $_nWave1 {G2}
wvDisplayGridCount -win $_nWave1 -off
wvGetSignalClose -win $_nWave1
wvReloadFile -win $_nWave1
wvSetCursor -win $_nWave1 6670515.547743 -snap {("G1" 23)}
wvSetCursor -win $_nWave1 6694421.977680 -snap {("G1" 23)}
wvDisplayGridCount -win $_nWave1 -off
wvGetSignalClose -win $_nWave1
wvReloadFile -win $_nWave1
wvZoomIn -win $_nWave1
wvZoomIn -win $_nWave1
wvZoomIn -win $_nWave1
wvZoomIn -win $_nWave1
wvZoomIn -win $_nWave1
wvScrollDown -win $_nWave1 0
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvSetCursor -win $_nWave1 1548.682961 -snap {("G1" 9)}
wvScrollUp -win $_nWave1 1
wvZoomIn -win $_nWave1
wvSetCursor -win $_nWave1 1501.422683 -snap {("G1" 8)}
wvSetCursor -win $_nWave1 1523.235119 -snap {("G1" 9)}
wvDisplayGridCount -win $_nWave1 -off
wvGetSignalClose -win $_nWave1
wvReloadFile -win $_nWave1
wvScrollDown -win $_nWave1 0
wvScrollDown -win $_nWave1 0
wvScrollDown -win $_nWave1 0
wvScrollDown -win $_nWave1 0
wvScrollDown -win $_nWave1 0
wvScrollDown -win $_nWave1 0
wvScrollDown -win $_nWave1 0
wvScrollDown -win $_nWave1 0
wvSetCursor -win $_nWave1 2515.700961 -snap {("G1" 9)}
wvSetCursor -win $_nWave1 1530.505931 -snap {("G1" 37)}
wvSetCursor -win $_nWave1 1501.422683 -snap {("G1" 37)}
wvSetCursor -win $_nWave1 1519.599713 -snap {("G1" 37)}
wvSetCursor -win $_nWave1 1505.058089 -snap {("G1" 37)}
wvSetCursor -win $_nWave1 1534.141337 -snap {("G1" 36)}
wvSetCursor -win $_nWave1 1523.235119 -snap {("G1" 37)}
wvDisplayGridCount -win $_nWave1 -off
wvGetSignalClose -win $_nWave1
wvReloadFile -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvSetCursor -win $_nWave1 33416.652066 -snap {("G1" 13)}
wvSetCursor -win $_nWave1 39465.967670 -snap {("G1" 13)}
wvSelectSignal -win $_nWave1 {( "G1" 13 )} 
wvSetCursor -win $_nWave1 40193.048873 -snap {("G1" 13)}
wvSetCursor -win $_nWave1 6609363.871599 -snap {("G1" 13)}
wvSetCursor -win $_nWave1 6612533.945642 -snap {("G1" 13)}
