
// opcode
`define R_type 7'b0110011
`define I_load 7'b0000011
`define I_arth 7'b0010011
`define JALR   7'b1100111
`define S_type 7'b0100011
`define B_type 7'b1100011
`define AUIPC  7'b0010111
`define LUI    7'b0110111
`define JAL    7'b1101111
`define F_FLW  7'b0000111
`define F_FSW  7'b0100111
`define F_arth 7'b1010011
`define CSR    7'b1110011

// func7 M-type
`define M_type 7'b0000001

// func3 arthimetic
`define ADD_SUB 3'b000 
`define SLL     3'b001
`define SLT     3'b010
`define SLTU    3'b011
`define XOR     3'b100
`define SRL_SRA 3'b101
`define OR      3'b110
`define AND     3'b111

// func7 add/sub srl/sra
`define ADD_SRL 7'b0000000
`define SUB_SRA 7'b0000001

// func3 mul
`define MUL     3'b000
`define MULH    3'b001
`define MULHSU  3'b010
`define MULHU   3'b011

// func3 LOAD/STORE
`define LB      3'b000
`define LH      3'b001
`define LW      3'b010
`define LBU     3'b100
`define LHU     3'b101

// func3 branch
`define BEQ     3'b000
`define BNE     3'b001
`define BLT     3'b100
`define BGE     3'b101
`define BLTU    3'b110
`define BGEU    3'b111

// func5 F-type
`define FADD_S  5'b00000
`define FSUB_S  5'b00001

//imm CSR
`define RDINSTRETH 12'b110010000010
`define RDINSTRET  12'b110000000010
`define RDCYCLEH   12'b110010000000
`define RDCYCLE    12'b110000000000

`define NOP 32'b00000000000000000000000000010011