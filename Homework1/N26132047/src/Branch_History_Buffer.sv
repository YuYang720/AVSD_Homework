module Branch_History_Buffer (
    input logic clk,
    input logic rst,
    input logic stall,
    input logic [6:0] EX_op,
    input logic actual_taken,      // The true outcome of the branch from the ALU
    output logic history_reg_1
);
    // This 2-bit register stores the branch history state (2-bit saturating counter)
    logic [1:0] history_reg;

    assign history_reg_1 = history_reg[1];

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            history_reg <= 2'b00;  // Weakly not taken
        end else if (EX_op == `B_type && !stall) begin
            // 2-bit saturating counter implementation
            case (history_reg)
                2'b00: history_reg <= actual_taken ? 2'b01 : 2'b00;
                2'b01: history_reg <= actual_taken ? 2'b10 : 2'b00;
                2'b10: history_reg <= actual_taken ? 2'b11 : 2'b01;
                2'b11: history_reg <= actual_taken ? 2'b11 : 2'b10;
            endcase
        end
    end
endmodule