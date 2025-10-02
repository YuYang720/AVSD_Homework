// ENTRIES = 16,
module BTB (
    input  logic clk,
    input  logic rst,

    input  logic [31:0] IF_pc,
    input  logic [ 6:0] EX_op,
    input  logic [31:0] EX_pc,
    input  logic [31:0] EX_target,

    output logic        IF_btb_b_hit,
    output logic        IF_btb_j_hit,
    output logic [31:0] IF_btb_target
);

    logic [3:0] lookup_index;
    logic [9:0] lookup_tag;

    logic [3:0] update_index;
    logic [9:0] update_tag;

    typedef struct {
        logic [ 9:0] tag;
        logic [15:0] target_pc;
        logic        b_valid;
        logic        j_valid;
    } BTB_Entry;

    BTB_Entry btb_reg [0:15];
    
    // --- 查詢邏輯 ---
    assign lookup_index = IF_pc[5:2];
    assign lookup_tag   = IF_pc[15:6];

    assign IF_btb_b_hit = btb_reg[lookup_index].b_valid && (btb_reg[lookup_index].tag == lookup_tag);
    assign IF_btb_j_hit = btb_reg[lookup_index].j_valid && (btb_reg[lookup_index].tag == lookup_tag);

    assign IF_btb_target = {{16{1'b0}}, btb_reg[lookup_index].target_pc};
    
    // --- 更新邏輯 ---
    assign update_index = EX_pc[5:2];
    assign update_tag   = EX_pc[15:6];
    
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            for (int i = 0; i < 16; i++) begin
                btb_reg[i].b_valid   <= 1'b0;
                btb_reg[i].j_valid   <= 1'b0;
                btb_reg[i].tag       <= 10'b0;
                btb_reg[i].target_pc <= 16'b0;
            end
        end else if (EX_op == `JAL) begin
            btb_reg[update_index].j_valid   <= 1'b1;
            btb_reg[update_index].b_valid   <= 1'b0;
            btb_reg[update_index].tag       <= update_tag;
            btb_reg[update_index].target_pc <= EX_target;
        end else if (EX_op == `B_type) begin
            btb_reg[update_index].b_valid   <= 1'b1;
            btb_reg[update_index].j_valid   <= 1'b0;
            btb_reg[update_index].tag       <= update_tag;
            btb_reg[update_index].target_pc <= EX_target;
        end
    end

endmodule