module CSR_Unit (
    input  logic        clk,
    input  logic        rst,
    input  logic        mem_wait,
    input  logic [ 6:0] WB_op,
    input  logic [ 4:0] WB_rd,
    input  logic [11:0] WB_CSR_imm,
    output logic [31:0] CSR_dout
);

    logic [63:0] CSR_instr_reg;
    logic [63:0] CSR_cycle_rsg;

    always_ff @(posedge clk or posedge rst)begin
        if (rst) begin
            CSR_instr_reg <= 64'b0;
        end else if ((WB_op == `I_arth && WB_rd == 5'b0) || mem_wait) begin // NOP
            CSR_instr_reg <= CSR_instr_reg;
        end else begin
            CSR_instr_reg <= CSR_instr_reg + 64'd1;
        end 
    end

    always_ff @(posedge clk or posedge rst)begin
        if (rst) begin
            CSR_cycle_rsg <= 64'b0;
        end else begin
            CSR_cycle_rsg <= CSR_cycle_rsg + 64'd1;
        end 
    end


    always_comb begin
        if (WB_op == `CSR) begin
            case (WB_CSR_imm)
                `RDINSTRETH: CSR_dout = CSR_instr_reg[63:32];
                `RDINSTRET:  CSR_dout = CSR_instr_reg[31:0] - 32'd3;
                `RDCYCLEH:   CSR_dout = CSR_cycle_rsg[63:32];
                `RDCYCLE:    CSR_dout = CSR_cycle_rsg[31:0] - 32'd3;
                default:     CSR_dout = 32'b0;
            endcase
        end else begin 
            CSR_dout = 32'b0;
        end
    end

endmodule
