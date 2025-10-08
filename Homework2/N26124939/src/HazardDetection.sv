`timescale 1ns/10ps
module HazardDetection(
    input logic if_insn_axi_valid_i       ,
    input logic [31:0] if_insn_axi_addr_i ,
    input logic [31:0] if_pc_reg_i        ,
    input logic mem_mem_store_i           ,
    input logic mem_axi_wvalid_i          ,
    input logic mem_axi_rvalid_i          ,
    input logic [31:0] mem_axi_raddr_i    ,
    input logic [31:0] mem_axi_waddr_i    ,
    input logic [3:0]  mem_mem_web_i      ,
    input logic [3:0]  mem_axi_web_i      ,
    input logic [31:0] mem_axi_wdata_i    ,
    input logic [31:0] mem_alu_result_i   ,
    input logic [31:0] mem_mem_wdata_i    ,
    input logic [4:0] ex_rd_i,
    input logic [4:0] mem_rd_i,
    input logic [4:0] wb_rd_i,
    input logic ex_reg_write_i,
    input logic mem_reg_write_i,
    input logic wb_reg_write_i,
    input logic ex_mul_i,
    input logic mem_mul_i,
    input logic wb_mul_i,
    input logic ex_mem_read_i,
    input logic mem_mem_read_i,
    input logic wb_mem_read_i,

    input logic [4:0] id_rs1_i,
    input logic [4:0] id_rs2_i,

    input logic id_op1_is_reg_i,
    input logic id_op2_is_reg_i,

    output logic stall_o,
    output logic stall_axi_im_o,
    output logic stall_axi_dm_o
);

    localparam NONE = 2'b00;
    localparam EX   = 2'b01;
    localparam MEM  = 2'b10;
    localparam WB   = 2'b11;

    logic [1:0] rs1_latest_rd_data, rs2_latest_rd_data;

    always_comb begin
        rs1_latest_rd_data = NONE;
        if (id_op1_is_reg_i && (id_rs1_i == wb_rd_i) && wb_reg_write_i) begin
            rs1_latest_rd_data = WB;
        end
        if (id_op1_is_reg_i && (id_rs1_i == mem_rd_i) && mem_reg_write_i) begin
            rs1_latest_rd_data = MEM;
        end
        if (id_op1_is_reg_i && (id_rs1_i == ex_rd_i) && ex_reg_write_i) begin
            rs1_latest_rd_data = EX;
        end
        if (id_rs1_i == 5'd0) begin
            rs1_latest_rd_data = NONE;
        end
    end

    always_comb begin
        rs2_latest_rd_data = NONE;
        if (id_op2_is_reg_i && (id_rs2_i == wb_rd_i) && wb_reg_write_i) begin
            rs2_latest_rd_data = WB;
        end
        if (id_op2_is_reg_i && (id_rs2_i == mem_rd_i) && mem_reg_write_i) begin
            rs2_latest_rd_data = MEM;
        end
        if (id_op2_is_reg_i && (id_rs2_i == ex_rd_i) && ex_reg_write_i) begin
            rs2_latest_rd_data = EX;
        end
        if (id_rs2_i == 5'd0) begin
            rs2_latest_rd_data = NONE;
        end
    end

    always_comb begin
        stall_o = 1'b0;
        stall_axi_im_o = 1'b0;
        stall_axi_dm_o = 1'b0;

        if (rs1_latest_rd_data == WB && (wb_mul_i || wb_mem_read_i)) begin
            stall_o = 1'b1;
        end else if (rs1_latest_rd_data == MEM && (mem_mul_i || mem_mem_read_i)) begin
            stall_o = 1'b1;
        end else if (rs1_latest_rd_data == EX && (ex_mul_i || ex_mem_read_i)) begin
            stall_o = 1'b1;
        end

        if (rs2_latest_rd_data == WB && (wb_mul_i || wb_mem_read_i)) begin
            stall_o = 1'b1;
        end else if (rs2_latest_rd_data == MEM && (mem_mul_i || mem_mem_read_i)) begin
            stall_o = 1'b1;
        end else if (rs2_latest_rd_data == EX && (ex_mul_i || ex_mem_read_i)) begin
            stall_o = 1'b1;
        end

        if ((if_pc_reg_i != if_insn_axi_addr_i) || ~if_insn_axi_valid_i) begin
            stall_axi_im_o = 1'b1;
        end

        if (mem_mem_store_i && ((mem_axi_waddr_i != mem_alu_result_i) || ~mem_axi_wvalid_i || (mem_axi_wdata_i != mem_mem_wdata_i) || (mem_mem_web_i != mem_axi_web_i))) begin
            stall_axi_dm_o = 1'b1;
        end

        if (mem_mem_read_i  && ((mem_axi_raddr_i != mem_alu_result_i) || ~mem_axi_rvalid_i)) begin
            stall_axi_dm_o = 1'b1;
        end
    end

endmodule : HazardDetection