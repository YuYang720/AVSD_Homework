module Branch_History_Buffer (
    input logic clk,
    input logic rst,
    input logic actual_taken,      // The true outcome of the branch from the ALU
    output logic history_reg_1
);
    // This 2-bit register stores the outcome of the last two branches.
    logic [1:0] history_reg;

    assign history_reg_1 = history_reg[1];

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            history_reg <= 2'b00;
        end else begin // 若此時加入判斷是否為B-type才更新->則prog1 3 4 會錯誤
            history_reg <= {history_reg[0], actual_taken};
        end
    end
endmodule