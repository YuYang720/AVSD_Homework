`ifndef DEFINES
    `define DEFINES

    // R and M type inst
    `define INST_TYPE_R_M 7'b0110011
    `define INST_ADD  3'b000
    `define INST_SUB  3'b000
    `define INST_SLL  3'b001
    `define INST_SLT  3'b010
    `define INST_STLU 3'b011
    `define INST_XOR  3'b100
    `define INST_SRL  3'b101
    `define INST_SRA  3'b101
    `define INST_OR   3'b110
    `define INST_AND  3'b111

    `define INST_MUL    3'b000
    `define INST_MULH   3'b001
    `define INST_MULHSU 3'b010
    `define INST_MULHU  3'b011

    // I type inst
    `define INST_TYPE_I 7'b0010011
    `define INST_ADDI   3'b000
    `define INST_SLTI   3'b010
    `define INST_SLTIU  3'b011
    `define INST_XORI   3'b100
    `define INST_ORI    3'b110
    `define INST_ANDI   3'b111
    `define INST_SLLI   3'b001
    `define INST_SRLI   3'b101
    `define INST_SRAI   3'b101

    // L type inst
    `define INST_TYPE_L 7'b0000011
    `define INST_LW     3'b010
    `define INST_LB     3'b000
    `define INST_LH     3'b001
    `define INST_LBU    3'b100
    `define INST_LHU    3'b101

    // S type inst
    `define INST_TYPE_S 7'b0100011
    `define INST_SW     3'b010
    `define INST_SB     3'b000
    `define INST_SH     3'b001

    // B type inst
    `define INST_TYPE_B 7'b1100011
    `define INST_BEQ    3'b000
    `define INST_BNE    3'b001
    `define INST_BLT    3'b100
    `define INST_BGE    3'b101
    `define INST_BLTU   3'b110
    `define INST_BGEU   3'b111

    // U type inst
    `define INST_TYPE_AUIPC  7'b0010111
    `define INST_TYPE_LUI    7'b0110111
    `define INST_NOP         32'h00000001
    `define INST_NOP_OP      7'b0000001

    // J type inst
    `define INST_TYPE_JAL    7'b1101111
    `define INST_TYPE_JALR   7'b1100111
    `define INST_JALR        3'b000

    // CSR type inst
    `define INST_TYPE_CSR         7'b1110011
    `define INST_RDINSTRETH 20'b11001000001000000010
    `define INST_RDINSTRET  20'b11000000001000000010
    `define INST_RDCYCLEH   20'b11001000000000000010
    `define INST_RDCYCLE    20'b11000000000000000010

    // ALU Operations
    //--------------------------------------------------------------------
    `define ALU_NONE                                4'b0000
    `define ALU_SHIFTL                              4'b0001
    `define ALU_SHIFTR                              4'b0010
    `define ALU_SHIFTR_ARITH                        4'b0011
    `define ALU_ADD                                 4'b0100
    `define ALU_SUB                                 4'b0110
    `define ALU_AND                                 4'b0111
    `define ALU_OR                                  4'b1000
    `define ALU_XOR                                 4'b1001
    `define ALU_LESS_THAN                           4'b1010
    `define ALU_LESS_THAN_SIGNED                    4'b1011
    `define ALU_GREATER_THAN                        4'b1100
    `define ALU_GREATER_THAN_SIGNED                 4'b1101
    `define ALU_EQUAL                               4'b1110
    `define ALU_NOT_EQUAL                           4'b1111

    //--------------------------------------------------------------------
    // Instructions Masks
    //--------------------------------------------------------------------


    //--------------------------------------------------------------------
    // Forwarding
    //--------------------------------------------------------------------

    `define NO_FORWARD 2'b00
    `define FORWARD_MEM_DATA 2'b01
    `define FORWARD_WB_DATA 2'b10
`endif