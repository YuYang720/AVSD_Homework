module MEM_WB_reg (
    input logic        clk,
    input logic        rst,
    input logic        mem_wait,

    input logic [ 6:0] MEM_op,
    input logic [ 4:0] MEM_rd,
    input logic [ 2:0] MEM_func3,
    input logic [31:0] MEM_cal_out,
    input logic [31:0] MEM_ld_data,
    input logic [11:0] MEM_CSR_imm,

    output logic [ 6:0] WB_op,
    output logic [ 4:0] WB_rd,
    output logic [ 2:0] WB_func3,
    output logic [31:0] WB_cal_out,
    output logic [31:0] WB_ld_data,
    output logic [11:0] WB_CSR_imm
);

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            WB_op      <= 7'b0;
            WB_func3   <= 3'b0;
            WB_rd      <= 5'b0;
            WB_cal_out <= 32'b0;
            WB_CSR_imm <= 12'b0;
            WB_ld_data <= 31'b0;
        end else if (mem_wait) begin
            WB_op      <= WB_op;
            WB_func3   <= WB_func3;
            WB_rd      <= WB_rd;
            WB_cal_out <= WB_cal_out;
            WB_CSR_imm <= WB_CSR_imm;
            WB_ld_data <= WB_ld_data;
        end else begin
            WB_op      <= MEM_op;
            WB_func3   <= MEM_func3;
            WB_rd      <= MEM_rd;
            WB_cal_out <= MEM_cal_out;
            WB_CSR_imm <= MEM_CSR_imm;
            WB_ld_data <= MEM_ld_data;
        end
    end

    //assign WB_ld_data = MEM_ld_data;

endmodule
