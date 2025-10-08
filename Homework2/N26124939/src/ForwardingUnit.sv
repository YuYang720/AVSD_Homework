`include "Defines.sv"
`timescale 1ns/10ps
module ForwardingUnit(
    input logic [ 4:0] ex_rs1_i,
    input logic [ 4:0] ex_rs2_i,
    input logic [ 4:0] mem_rd_i,
    input logic [ 4:0] wb_rd_i,
    input logic mem_reg_write_i,
    input logic wb_reg_write_i,
    input logic wb_mul_i,
    input logic wb_mem_read_i,

    output logic [1:0] ex_forwardA_o,  // 00 regData 01 EX_MEM data 10 MEM_WB data
    output logic [1:0] ex_forwardB_o
);

    always_comb begin
        ex_forwardA_o = `NO_FORWARD;
        ex_forwardB_o = `NO_FORWARD;

        if(ex_rs1_i == wb_rd_i  && wb_reg_write_i && (wb_mem_read_i == 1'b0) && (wb_mul_i == 1'b0))
                                                    ex_forwardA_o = `FORWARD_WB_DATA;
        if(ex_rs1_i == mem_rd_i && mem_reg_write_i) ex_forwardA_o = `FORWARD_MEM_DATA;
        if(ex_rs1_i == 5'd0)                        ex_forwardA_o = `NO_FORWARD;

        if(ex_rs2_i == wb_rd_i  && wb_reg_write_i && (wb_mem_read_i == 1'b0) && (wb_mul_i == 1'b0))
                                                    ex_forwardB_o = `FORWARD_WB_DATA;
        if(ex_rs2_i == mem_rd_i && mem_reg_write_i) ex_forwardB_o = `FORWARD_MEM_DATA;
        if(ex_rs2_i == 5'd0)                        ex_forwardB_o = `NO_FORWARD;
    end
endmodule : ForwardingUnit