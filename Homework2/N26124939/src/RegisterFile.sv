module RegisterFile(
    input logic clk_i,
    input logic rst_i,

    // from id stage
    input logic [4:0] id_rs1_i,
    input logic [4:0] id_rs2_i,

    // from wb stage
    input logic wb_reg_write_i,
    input logic wb_mul_i,
    input logic wb_mem_read_i,
    input logic [31:0] wb_alu_result_i,
    input logic [31:0] wb_reg_write_data_i,
    input logic  [4:0] wb_rd_i,

    // to id stage
    output logic [31:0] id_rs1_data_o,
    output logic [31:0] id_rs2_data_o
);

    logic [31:0] registerFile [0:31];

    // Synchronous write register
    always @(posedge clk_i) begin
        if (rst_i == 1'b0) begin
            if (wb_reg_write_i == 1'b1 && wb_rd_i != 5'd0) begin
                registerFile[wb_rd_i] <= wb_reg_write_data_i;
            end
        end
    end

    // Asynchronous read register 1
    always @(*) begin
        if (id_rs1_i == 32'd0) begin
            id_rs1_data_o = 32'd0;
        end
        // forwarding wb data
        else if (id_rs1_i == wb_rd_i && wb_reg_write_i == 1'b1 && wb_mul_i == 1'b0 && wb_mem_read_i == 1'b0) begin
            id_rs1_data_o = wb_alu_result_i;
        end
        else begin
            id_rs1_data_o = registerFile[id_rs1_i];
        end
    end

    // Asynchronous read register 2
    always @(*) begin
        if (id_rs2_i == 32'd0) begin
            id_rs2_data_o = 32'd0;
        end
        // forwarding wb data
        else if (id_rs2_i == wb_rd_i && wb_reg_write_i == 1'b1 && wb_mul_i == 1'b0 && wb_mem_read_i == 1'b0) begin
            id_rs2_data_o = wb_alu_result_i;
        end
        else begin
            id_rs2_data_o = registerFile[id_rs2_i];
        end
    end

endmodule : RegisterFile
