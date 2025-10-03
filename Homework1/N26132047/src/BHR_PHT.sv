// assume golbal history registor is 4 bits (m = 4)
module BHR_PHT (
    input logic clk,
    input logic rst,

    //input logic [3:0] EX_pc_for_hash,
    input logic [6:0] EX_op,
    input logic       EX_actual_taken, // EX stage 得到的 branch 實際結果
    input logic [3:0] EX_bhr, // 當初在 IF stage 做預測時的 BHR 值

    output logic       IF_gbc_predict_taken,
    output logic [3:0] IF_bhr_out
);

    logic [3:0] bhr_reg;
    
    logic [1:0] pht_reg [0:15];
    logic [1:0] current_entry;
    

    assign current_entry = pht_reg[EX_bhr];
    assign IF_bhr_out = bhr_reg;
    assign IF_gbc_predict_taken = pht_reg[bhr_reg][1];

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            bhr_reg <= 4'b0;
            for (integer i = 0; i < 16; i++) begin
                pht_reg[i] <= 2'b00;
            end
        end else if (EX_op == `B_type) begin
            bhr_reg <= {bhr_reg[2:0], EX_actual_taken};

            if (EX_actual_taken) begin
                pht_reg[EX_bhr] <= (current_entry == 2'b11) ? 2'b11 : current_entry + 1;
            end else begin
                pht_reg[EX_bhr] <= (current_entry == 2'b00) ? 2'b00 : current_entry - 1;
            end
        end
    end


endmodule