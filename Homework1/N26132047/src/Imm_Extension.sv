module Imm_Extension (
    input logic [31:0] ID_inst,
    output logic [31:0] imm_ext_out
);
    always_comb begin  
        case (ID_inst[6:0])
            `R_type: imm_ext_out = 32'b0;  // no need 
            `I_load: imm_ext_out = {{20{ID_inst[31]}}, ID_inst[31:20]};
            `I_arth: imm_ext_out = {{20{ID_inst[31]}}, ID_inst[31:20]};
            `JALR  : imm_ext_out = {{20{ID_inst[31]}}, ID_inst[31:20]};
            `S_type: imm_ext_out = {{20{ID_inst[31]}}, ID_inst[31:25], ID_inst[11:7]};
            `B_type: imm_ext_out = {{20{ID_inst[31]}}, ID_inst[7], ID_inst[30:25], ID_inst[11:8], 1'b0};
            `AUIPC : imm_ext_out = {ID_inst[31:12], 12'b0};
            `LUI   : imm_ext_out = {ID_inst[31:12], 12'b0};
            `JAL   : imm_ext_out = {{12{ID_inst[31]}}, ID_inst[19:12], ID_inst[20], ID_inst[30:21], 1'b0};
            `F_FLW : imm_ext_out = {{20{ID_inst[31]}}, ID_inst[31:20]};
            `F_FSW : imm_ext_out = {{20{ID_inst[31]}}, ID_inst[31:25], ID_inst[11:7]};
            `F_arth: imm_ext_out = 32'b0;  // no need 
            `CSR   : imm_ext_out = {20'b0, ID_inst[31:20]};
            default: imm_ext_out = 32'b0;
        endcase
    end
    
endmodule