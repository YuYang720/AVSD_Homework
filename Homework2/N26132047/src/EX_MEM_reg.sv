module EX_MEM_reg (
    input logic        clk,
    input logic        rst,
    input logic        stall, 
    input logic        mem_wait,

    input logic [31:0] EX_pc, 
    input logic [6:0]  EX_op,
    input logic [4:0]  EX_rd,
    input logic [ 2:0] EX_func3,
    input logic [31:0] EX_cal_out,
    input logic [31:0] EX_rs2_data,
    input logic [31:0] EX_imm_ext,        

    output logic [31:0] MEM_pc,
    output logic [ 6:0] MEM_op,
    output logic [ 4:0] MEM_rd,
    output logic [ 2:0] MEM_func3,
    output logic [31:0] MEM_cal_out,
    output logic [31:0] MEM_rs2_data,
    output logic [11:0] MEM_CSR_imm
);

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin    
            MEM_pc      <= 7'b0;
            MEM_op      <= 7'b0;
            MEM_func3   <= 3'b0;
            MEM_rd      <= 5'b0;
            MEM_cal_out <= 32'b0;
            MEM_CSR_imm <= 12'b0;
        end else if (mem_wait) begin
            MEM_pc      <= MEM_pc;
            MEM_op      <= MEM_op;
            MEM_func3   <= MEM_func3;
            MEM_rd      <= MEM_rd;
            MEM_cal_out <= MEM_cal_out;
            MEM_CSR_imm <= MEM_CSR_imm;
        end else begin
            MEM_pc      <= EX_pc;
            MEM_op      <= EX_op;
            MEM_func3   <= EX_func3;
            MEM_rd      <= EX_rd;
            MEM_cal_out <= EX_cal_out;
            MEM_CSR_imm <= EX_imm_ext[11:0];
        end
    end

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            MEM_rs2_data <= 32'b0;
        end else if (mem_wait) begin
            MEM_rs2_data <= MEM_rs2_data;
        end else if (EX_func3 == 3'b010) begin
            MEM_rs2_data <= EX_rs2_data;
        end else begin
            case (EX_cal_out[1:0])
                2'b00: MEM_rs2_data <= {16'b0, EX_rs2_data[15:0]};
                2'b01: MEM_rs2_data <= {8'b0, EX_rs2_data[15:0], 8'b0};
                2'b10: MEM_rs2_data <= {EX_rs2_data[15:0], 16'b0};
                default: MEM_rs2_data <= {EX_rs2_data[7:0], 24'b0};
            endcase
        end
    end

endmodule