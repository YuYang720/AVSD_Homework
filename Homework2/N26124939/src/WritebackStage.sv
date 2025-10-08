`timescale 1ns/10ps
module WritebackStage(
    input logic wb_mul_i,
    input logic wb_mem_read_i,
    input logic [ 1:0] wb_rs1_rs2_sign_i,
    input logic [ 2:0] wb_insn_funct3_i,
    input logic [31:0] wb_alu_result_i,
    input logic [31:0] wb_mem_read_data_i,
    input logic [31:0] wb_mul_temp_part1_i,
    input logic [31:0] wb_mul_temp_part2_i,
    input logic [31:0] wb_mul_temp_part3_i,
    input logic [31:0] wb_mul_temp_part4_i,

    output logic [31:0] wb_reg_write_data_o
);
    logic [31:0] load_read_data;
    logic [31:0] mul_data;
    logic [63:0] mul_temp, mul_temp_invert;

    assign mul_temp = {32'b0,wb_mul_temp_part1_i} +
                      {16'b0,wb_mul_temp_part2_i,16'b0} +
                      {16'b0,wb_mul_temp_part3_i,16'b0} +
                      {wb_mul_temp_part4_i,32'b0};

    assign mul_temp_invert = ~mul_temp + 1;

    always_comb begin
        if (wb_insn_funct3_i == `INST_LW) begin
            load_read_data = wb_mem_read_data_i;
        end else if (wb_insn_funct3_i == `INST_LB) begin
            case (wb_alu_result_i[1:0])
                2'b00:
                    load_read_data = {{24{wb_mem_read_data_i[7]}}, wb_mem_read_data_i[7:0]};
                2'b01:
                    load_read_data = {{24{wb_mem_read_data_i[15]}}, wb_mem_read_data_i[15:8]};
                2'b10:
                    load_read_data = {{24{wb_mem_read_data_i[23]}}, wb_mem_read_data_i[23:16]};
                2'b11:
                    load_read_data = {{24{wb_mem_read_data_i[31]}}, wb_mem_read_data_i[31:24]};
                default:
                    load_read_data = 32'hxxxx_xxxx;
            endcase
        end else if (wb_insn_funct3_i == `INST_LH) begin
            case (wb_alu_result_i[1:0])
                2'b00:
                    load_read_data = {{16{wb_mem_read_data_i[15]}}, wb_mem_read_data_i[15:0]};
                2'b01:
                    load_read_data = {{16{wb_mem_read_data_i[31]}}, wb_mem_read_data_i[31:16]};
                2'b10:
                    load_read_data = {{16{wb_mem_read_data_i[31]}}, wb_mem_read_data_i[31:16]};
                2'b11:
                    load_read_data = {{16{wb_mem_read_data_i[31]}}, wb_mem_read_data_i[31:16]};
                default:
                    load_read_data = 32'hxxxx_xxxx;
            endcase
        end else if (wb_insn_funct3_i == `INST_LBU) begin
            case (wb_alu_result_i[1:0])
                2'b00:
                    load_read_data = {24'b0, wb_mem_read_data_i[7:0]};
                2'b01:
                    load_read_data = {24'b0, wb_mem_read_data_i[15:8]};
                2'b10:
                    load_read_data = {24'b0, wb_mem_read_data_i[23:16]};
                2'b11:
                    load_read_data = {24'b0, wb_mem_read_data_i[31:24]};
                default:
                    load_read_data = 32'hxxxx_xxxx;
            endcase
        end else if (wb_insn_funct3_i == `INST_LHU) begin
            case (wb_alu_result_i[1:0])
                2'b00:
                    load_read_data = {16'b0, wb_mem_read_data_i[15:0]};
                2'b01:
                    load_read_data = {16'b0, wb_mem_read_data_i[31:16]};
                2'b10:
                    load_read_data = {16'b0, wb_mem_read_data_i[31:16]};
                2'b11:
                    load_read_data = {16'b0, wb_mem_read_data_i[31:16]};
                default:
                    load_read_data = 32'hxxxx_xxxx;
            endcase
        end else begin
            load_read_data = 32'b0;
        end
    end

    always_comb begin
        case (wb_insn_funct3_i)
            `INST_MUL:
                mul_data = mul_temp[31:0];
            `INST_MULHU:
                mul_data = mul_temp[63:32];
            `INST_MULHSU: begin
                if (wb_rs1_rs2_sign_i[1] == 1'b1) begin
                    mul_data = mul_temp_invert[63:32];
                end else begin
                    mul_data = mul_temp[63:32];
                end
            end
            `INST_MULH: begin
                case (wb_rs1_rs2_sign_i)
                    2'b00: begin
                        mul_data = mul_temp[63:32];
                    end
                    2'b11: begin
                        mul_data = mul_temp[63:32];
                    end
                    2'b10: begin
                        mul_data = mul_temp_invert[63:32];
                    end
                    2'b01: begin
                        mul_data = mul_temp_invert[63:32];
                    end
                    default: begin
                        mul_data = 32'hxxxx_xxxx;
                    end
                endcase
            end
            default:
                mul_data = 32'hxxxx_xxxx;
        endcase
    end

    assign wb_reg_write_data_o = wb_mem_read_i ? load_read_data :
                                      wb_mul_i ? mul_data : wb_alu_result_i;

endmodule : WritebackStage