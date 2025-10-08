`timescale 1ns/10ps
module NextPC(
    input logic clk_i,
    input logic rst_i,
    input logic stall_i,
    input logic stall_axi_im_i,
    input logic stall_axi_dm_i,
    input logic [31:0] if_fetch_pc_i,

    output logic [31:0] if_next_pc_o
);

    always_ff @(posedge clk_i or posedge rst_i) begin
        if (rst_i) begin
            if_next_pc_o <= 32'b0;
        end else if (stall_i || stall_axi_im_i || stall_axi_dm_i) begin
            ;
        end else begin
            if_next_pc_o <= if_fetch_pc_i + 3'd4;
        end
    end

endmodule : NextPC