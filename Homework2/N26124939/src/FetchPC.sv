module FetchPC(
    input logic stall_i,
    input logic stall_axi_im_i,
    input logic stall_axi_dm_i,
    input logic id_flush_i,
    input logic ex_flush_i,
    input logic [31:0] if_pc_reg_i,
    input logic [31:0] if_next_pc_i,
    input logic [31:0] ex_jump_addr_i,
    input logic [31:0] id_predict_jump_addr_i,

    output logic [31:0] if_fetch_pc_o
);
    always_comb begin
        if (stall_axi_im_i || stall_axi_dm_i) begin
            if_fetch_pc_o = if_pc_reg_i;
        end if (ex_flush_i == 1'b1) begin
            if_fetch_pc_o = ex_jump_addr_i;
        end else if (stall_i) begin
            if_fetch_pc_o = if_pc_reg_i;
        end else if (id_flush_i == 1'b1) begin
            if_fetch_pc_o = id_predict_jump_addr_i;
        end else begin
            if_fetch_pc_o = if_next_pc_i;
        end
    end

endmodule : FetchPC