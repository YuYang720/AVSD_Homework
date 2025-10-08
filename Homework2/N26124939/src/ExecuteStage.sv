`timescale 1ns/10ps
`include "Defines.sv"

module ExecuteStage(
    input logic [ 1:0] ex_forwardA_i,
    input logic [ 1:0] ex_forwardB_i,
    input logic [31:0] ex_insn_i,
    input logic [31:0] ex_rs1_data_i,
    input logic [31:0] ex_rs2_data_i,
    input logic [31:0] mem_alu_result_i,
    input logic [31:0] wb_alu_result_i,
    input logic [31:0] ex_immediate_gen_i,
    input logic [31:0] id_pc_i,
    input logic [31:0] ex_pc_add4_i,
    input logic [31:0] ex_pc_add_imm_i,
    input logic [63:0] ex_instret_i,
    input logic [63:0] ex_cycle_i,

    output logic ex_flush_o,
    output logic [ 1:0] ex_rs1_rs2_sign_o,
    output logic [ 2:0] ex_insn_funct3_o,
    output logic [ 3:0] ex_mem_web_o,
    output logic [31:0] ex_jump_addr_o,
    output logic [31:0] ex_mem_wdata_o,
    output logic [31:0] ex_alu_result_o,
    output logic [31:0] ex_mul_op1_o,
    output logic [31:0] ex_mul_op2_o
);

    logic [31:0] rs1_data, rs2_data;
    logic [31:0] rs1_data_invert, rs2_data_invert;
    logic [31:0] ex_jump_addr_w;
    logic [31:0] ex_alu_result_w;
    logic [63:0] instret, cycle;

    logic jump_flag;

    logic [6:0] opcode, funct7;
    logic [2:0] funct3;

    assign opcode           = ex_insn_i  [6:0];
    assign funct3           = ex_insn_i[14:12];
    assign funct7           = ex_insn_i[31:25];
    assign ex_insn_funct3_o = ex_insn_i[14:12];
    assign ex_jump_addr_o   = ex_jump_addr_w;
    assign ex_alu_result_o  = ex_alu_result_w;

    // alu operand
    always_comb begin
        case(ex_forwardA_i)
            `FORWARD_WB_DATA :
                rs1_data = wb_alu_result_i;
            `FORWARD_MEM_DATA :
                rs1_data = mem_alu_result_i;
            `NO_FORWARD :
                rs1_data = ex_rs1_data_i;
            default:
                rs1_data = 32'hxxxx_xxxx;
        endcase

        case(ex_forwardB_i)
            `FORWARD_WB_DATA :
                rs2_data = wb_alu_result_i;
            `FORWARD_MEM_DATA :
                rs2_data = mem_alu_result_i;
            `NO_FORWARD :
                rs2_data = ex_rs2_data_i;
            default:
                rs2_data = 32'hxxxx_xxxx;
        endcase
    end

    assign rs1_data_invert = ~rs1_data + 1;
    assign rs2_data_invert = ~rs2_data + 1;

    // mul operand
    always_comb begin
        if (opcode == `INST_TYPE_R_M && funct7 == 7'b0000001) begin
            case (funct3)
                `INST_MUL: begin
                    ex_mul_op1_o = rs1_data;
                    ex_mul_op2_o = rs2_data;
                end
                `INST_MULHU: begin
                    ex_mul_op1_o = rs1_data;
                    ex_mul_op2_o = rs2_data;
                end
                `INST_MULHSU: begin
                    ex_mul_op1_o = (rs1_data[31] == 1'b1) ? rs1_data_invert : rs1_data;
                    ex_mul_op2_o = rs2_data;
                end
                `INST_MULH: begin
                    ex_mul_op1_o = (rs1_data[31] == 1'b1) ? rs1_data_invert : rs1_data;
                    ex_mul_op2_o = (rs2_data[31] == 1'b1) ? rs2_data_invert : rs2_data;
                end
                default: begin
                    ex_mul_op1_o = 32'hxxxx_xxxx;
                    ex_mul_op2_o = 32'hxxxx_xxxx;
                end
            endcase
        end else begin
            ex_mul_op1_o = rs1_data;
            ex_mul_op2_o = rs2_data;
        end
        ex_rs1_rs2_sign_o[1] = rs1_data[31];
        ex_rs1_rs2_sign_o[0] = rs2_data[31];
    end

    always_comb begin
        case (opcode)
            `INST_TYPE_R_M: begin
                jump_flag = 1'b0;
                ex_flush_o = 1'b0;
                ex_mem_web_o = 4'b1111;
                ex_mem_wdata_o = 32'b0;
                ex_jump_addr_w = 32'b0;
                case (funct7)
                    7'b0000000:
                        case (funct3)
                            `INST_ADD:
                                ex_alu_result_w = rs1_data + rs2_data;
                            `INST_SLL:
                                ex_alu_result_w = rs1_data << rs2_data[4:0];
                            `INST_SLT:
                                ex_alu_result_w = $signed(rs1_data) < $signed(rs2_data) ? 32'd1 : 32'd0;
                            `INST_STLU:
                                ex_alu_result_w = rs1_data < rs2_data ? 32'd1 : 32'd0;
                            `INST_XOR:
                                ex_alu_result_w = rs1_data ^ rs2_data;
                            `INST_SRL:
                                ex_alu_result_w = rs1_data >> rs2_data[4:0];
                            `INST_OR:
                                ex_alu_result_w = rs1_data | rs2_data;
                            `INST_AND:
                                ex_alu_result_w = rs1_data & rs2_data;
                            default:
                                ex_alu_result_w = 32'hxxxx_xxxx;
                        endcase
                    7'b0100000:
                        case (funct3)
                            `INST_SUB:
                                ex_alu_result_w = rs1_data - rs2_data;
                            `INST_SRA:
                                ex_alu_result_w = $signed(rs1_data) >>> rs2_data[4:0];
                            default:
                                ex_alu_result_w = 32'hxxxx_xxxx;
                        endcase
                    default: begin
                        ex_alu_result_w = 32'hxxxx_xxxx;
                    end
                endcase
            end
            `INST_TYPE_I: begin
                jump_flag = 1'b0;
                ex_flush_o = 1'b0;
                ex_mem_web_o = 4'b1111;
                ex_mem_wdata_o = 32'b0;
                ex_jump_addr_w = 32'b0;
                case (funct3)
                    `INST_ADDI:
                        ex_alu_result_w = rs1_data + ex_immediate_gen_i;
                    `INST_SLTI:
                        ex_alu_result_w = $signed(rs1_data) < $signed(ex_immediate_gen_i) ? 1'b1 : 1'b0;
                    `INST_SLTIU:
                        ex_alu_result_w = rs1_data < ex_immediate_gen_i ? 1'b1 : 1'b0;
                    `INST_XORI:
                        ex_alu_result_w = rs1_data ^ ex_immediate_gen_i;
                    `INST_ORI:
                        ex_alu_result_w = rs1_data | ex_immediate_gen_i;
                    `INST_ANDI:
                        ex_alu_result_w = rs1_data & ex_immediate_gen_i;
                    `INST_SLLI:
                        if (funct7 == 7'b0000000) begin
                            ex_alu_result_w = rs1_data << ex_immediate_gen_i[4:0];
                        end else begin
                            ex_alu_result_w = 32'b0;
                        end
                    `INST_SRLI:
                        if (funct7 == 7'b0000000) begin
                            //INST_SRLI
                            ex_alu_result_w = rs1_data >> ex_immediate_gen_i[4:0];
                        end else if (funct7 == 7'b0100000) begin
                            //INST_SRAI
                            ex_alu_result_w = $signed(rs1_data) >>> ex_immediate_gen_i[4:0];
                        end else begin
                            ex_alu_result_w = 32'b0;
                        end
                    default:
                        ex_alu_result_w = 32'hxxxx_xxxx;
                endcase
            end
            `INST_TYPE_L: begin
                jump_flag = 1'b0;
                ex_flush_o = 1'b0;
                ex_mem_web_o = 4'b1111;
                ex_mem_wdata_o = 32'b0;
                ex_jump_addr_w = 32'b0;
                case (funct3)
                    `INST_LW, `INST_LB, `INST_LH, `INST_LBU, `INST_LHU: begin
                        ex_alu_result_w = rs1_data + ex_immediate_gen_i;
                    end
                    default: begin
                        ex_alu_result_w = 32'hxxxx_xxxx;
                    end
                endcase
            end
            `INST_TYPE_S: begin
                jump_flag = 1'b0;
                ex_flush_o = 1'b0;
                ex_jump_addr_w = 32'b0;
                case (funct3)
                    `INST_SW: begin
                        ex_alu_result_w = rs1_data + ex_immediate_gen_i;
                        ex_mem_wdata_o = rs2_data;
                        ex_mem_web_o   = 4'b0000;  //active low
                    end
                    `INST_SB: begin
                        ex_alu_result_w = rs1_data + ex_immediate_gen_i;
                        case (ex_alu_result_w[1:0])
                            2'b00: begin
                                ex_mem_wdata_o = {24'b0, rs2_data[7:0]};
                                ex_mem_web_o   = 4'b1110;
                            end
                            2'b01: begin
                                ex_mem_wdata_o = {16'b0, rs2_data[7:0], 8'b0};
                                ex_mem_web_o   = 4'b1101;
                            end
                            2'b10: begin
                                ex_mem_wdata_o = {8'b0, rs2_data[7:0], 16'b0};
                                ex_mem_web_o   = 4'b1011;
                            end
                            2'b11: begin
                                ex_mem_wdata_o = {rs2_data[7:0], 24'b0};
                                ex_mem_web_o   = 4'b0111;
                            end
                            default: begin
                                ex_mem_wdata_o = 32'hxxxx_xxxx;
                                ex_mem_web_o   = 4'bxxxx;
                            end
                        endcase
                    end
                    `INST_SH: begin
                        ex_alu_result_w = rs1_data + ex_immediate_gen_i;
                        case (ex_alu_result_w[1:0])
                            2'b00: begin
                                ex_mem_wdata_o = {16'b0, rs2_data[15:0]};
                                ex_mem_web_o   = 4'b1100;
                            end
                            2'b01, 2'b10, 2'b11: begin
                                ex_mem_wdata_o = {rs2_data[15:0], 16'b0};
                                ex_mem_web_o   = 4'b0011;
                            end
                            default: begin
                                ex_mem_wdata_o = 32'hxxxx_xxxx;
                                ex_mem_web_o   = 4'bxxxx;
                            end
                        endcase
                    end
                    default: begin
                        ex_alu_result_w = 32'hxxxx_xxxx;
                        ex_mem_wdata_o = 32'hxxxx_xxxx;
                        ex_mem_web_o   = 4'bxxxx;
                    end
                endcase
            end
            `INST_TYPE_B: begin
                ex_mem_web_o = 4'b1111;
                ex_alu_result_w = 32'b0;
                ex_mem_wdata_o = 32'b0;
                case (funct3)
                    `INST_BEQ: begin
                        jump_flag = rs1_data == rs2_data ? 1'b1 : 1'b0;
                        ex_jump_addr_w = jump_flag ? ex_pc_add_imm_i : ex_pc_add4_i;
                        ex_flush_o   = ex_jump_addr_w != id_pc_i;
                    end
                    `INST_BNE: begin
                        jump_flag = rs1_data != rs2_data ? 1'b1 : 1'b0;
                        ex_jump_addr_w = jump_flag ? ex_pc_add_imm_i : ex_pc_add4_i;
                        ex_flush_o   = ex_jump_addr_w != id_pc_i;
                    end
                    `INST_BLT: begin
                        jump_flag = $signed(rs1_data) < $signed(rs2_data) ? 1'b1 : 1'b0;
                        ex_jump_addr_w = jump_flag ? ex_pc_add_imm_i : ex_pc_add4_i;
                        ex_flush_o   = ex_jump_addr_w != id_pc_i;
                    end
                    `INST_BGE: begin
                        jump_flag = $signed(rs1_data) >= $signed(rs2_data) ? 1'b1 : 1'b0;
                        ex_jump_addr_w = jump_flag ? ex_pc_add_imm_i : ex_pc_add4_i;
                        ex_flush_o   = ex_jump_addr_w != id_pc_i;
                    end
                    `INST_BLTU: begin
                        jump_flag = rs1_data < rs2_data ? 1'b1 : 1'b0;
                        ex_jump_addr_w = jump_flag ? ex_pc_add_imm_i : ex_pc_add4_i;
                        ex_flush_o   = ex_jump_addr_w != id_pc_i;
                    end
                    `INST_BGEU: begin
                        jump_flag = rs1_data >= rs2_data ? 1'b1 : 1'b0;
                        ex_jump_addr_w = jump_flag ? ex_pc_add_imm_i : ex_pc_add4_i;
                        ex_flush_o   = ex_jump_addr_w != id_pc_i;
                    end
                    default: begin
                        jump_flag = 1'b0;
                        ex_jump_addr_w = 32'b0;
                        ex_flush_o = 1'b0;
                    end
                endcase
            end
            `INST_TYPE_AUIPC: begin
                jump_flag = 1'b0;
                ex_flush_o = 1'b0;
                ex_mem_web_o = 4'b1111;
                ex_mem_wdata_o = 32'b0;
                ex_jump_addr_w = 32'b0;
                ex_alu_result_w = ex_pc_add_imm_i;
            end
            `INST_TYPE_LUI: begin
                jump_flag = 1'b0;
                ex_flush_o = 1'b0;
                ex_mem_web_o = 4'b1111;
                ex_mem_wdata_o = 32'b0;
                ex_jump_addr_w = 32'b0;
                ex_alu_result_w = ex_immediate_gen_i;
            end
            `INST_TYPE_JAL: begin
                jump_flag   = 1'b1;
                ex_flush_o = 1'b0;
                ex_mem_web_o = 4'b1111;
                ex_mem_wdata_o = 32'b0;
                ex_jump_addr_w = ex_pc_add_imm_i;
                ex_alu_result_w = ex_pc_add4_i;
            end
            `INST_TYPE_JALR: begin
                ex_mem_web_o = 4'b1111;
                jump_flag       = 1'b1;
                ex_mem_wdata_o = 32'b0;
                ex_jump_addr_w  = (rs1_data + ex_immediate_gen_i) & 32'hffff_fffe;
                ex_flush_o   = ex_jump_addr_w != id_pc_i;
                ex_alu_result_w = ex_pc_add4_i;
            end
            `INST_TYPE_CSR: begin
                ex_flush_o = 1'b0;
                jump_flag = 1'b0;
                ex_mem_web_o = 4'b1111;
                ex_mem_wdata_o = 32'b0;
                ex_jump_addr_w = 32'b0;
                case (ex_insn_i[31:12])
                    `INST_RDINSTRETH:
                        ex_alu_result_w = ex_instret_i[63:32];
                    `INST_RDINSTRET:
                        ex_alu_result_w = ex_instret_i[31:0];
                    `INST_RDCYCLEH:
                        ex_alu_result_w = ex_cycle_i[63:32];
                    `INST_RDCYCLE:
                        ex_alu_result_w = ex_cycle_i[31:0];
                    default:
                        ex_alu_result_w = 32'hxxxx_xxxx;
                endcase
            end
            default: begin
                jump_flag = 1'b0;
                ex_flush_o   = 1'b0;
                ex_mem_web_o = 4'b1111;
                ex_alu_result_w = 32'hxxxx_xxxx;
                ex_mem_wdata_o = 32'hxxxx_xxxx;
                ex_jump_addr_w = 32'hxxxx_xxxx;
            end
        endcase
    end

endmodule : ExecuteStage