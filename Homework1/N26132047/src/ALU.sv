`include "FP_calculator.sv"
module ALU (
    input  logic [ 6:0] op,
    input  logic [ 2:0] func3,
    input  logic [ 6:0] func7,
    input  logic [31:0] operand1,
    input  logic [31:0] operand2,
    output logic [31:0] alu_out
);
    
    logic [31:0] fp_result;
    FP_calculator FP_unit (
        .operand1(operand1),
        .operand2(operand2),
        .func7_bits(func7[6:2]),
        .fp_result(fp_result)
    );

    always_comb begin
        case(op)
        // for R_type func7 define add/sub, I_type always add
        `R_type, `I_arth: begin
            case(func3)
                `ADD_SUB: alu_out = (op == `R_type && func7[5]) ? (operand1 - operand2) : (operand1 + operand2);
                `SLL:     alu_out = operand1 << operand2[4:0];
                `SLT:     alu_out = {{31{1'b0}}, ($signed(operand1) < $signed(operand2))};
                `SLTU:    alu_out = {{31{1'b0}}, (operand1 < operand2)};
                `XOR:     alu_out = operand1 ^ operand2;
                `SRL_SRA: alu_out = (func7[5]) ? ($signed(operand1) >>> operand2[4:0]) : ($signed(operand1) >> operand2[4:0]);
                `OR:      alu_out = operand1 | operand2;
                `AND:     alu_out = operand1 & operand2;
            endcase
        end  
        `B_type: begin
            case(func3)
                `BEQ:     alu_out = {{31{1'b0}}, (operand1 == operand2)};
                `BNE:     alu_out = {{31{1'b0}}, (operand1 != operand2)};
                `BLT:     alu_out = {{31{1'b0}}, ($signed(operand1) < $signed(operand2))};
                `BGE:     alu_out = {{31{1'b0}}, ($signed(operand1) >= $signed(operand2))};
                `BLTU:    alu_out = {{31{1'b0}}, (operand1 < operand2)};
                `BGEU:    alu_out = {{31{1'b0}}, (operand1 >= operand2)};
                default:  alu_out = 32'b0;
            endcase
        end
        `LUI:             alu_out = operand2; 
        `F_arth:          alu_out = fp_result;
        `JAL, `JALR:      alu_out = operand1 + 32'd4;
        `AUIPC, `I_load, `S_type, `F_FLW, `F_FSW: alu_out = operand1 + operand2;
        default:          alu_out = 32'b0;
        endcase
    end
endmodule
        
            
