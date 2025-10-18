module IF_ID_reg (
    input logic        clk,
    input logic        rst,
    input logic        mem_wait,
    input logic        stall,
    input logic        flush,
    
    input logic [31:0] IF_pc,
    input logic [31:0] IF_inst,
    input logic        IF_btb_b_hit,
    input logic        IF_btb_j_hit,
    input logic        IF_gbc_predict_taken,
    input logic [ 3:0] IF_bhr,

    output logic        ID_btb_b_hit,
    output logic        ID_btb_j_hit,
    output logic        ID_gbc_predict_taken,
    output logic [ 3:0] ID_bhr,
    output logic [31:0] ID_pc,
    output logic [31:0] ID_inst
);

    // rst: active high
    // rst_released: active low -> 製程限定 sequential part 在 reset 時要為0
    logic        prev_stall, prev_flush, rst_released;
    logic [31:0] stored_inst;
    logic        prev_wait;

    // PC register logic
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            ID_pc <= 32'b0;
        end else if (flush) begin
            ID_pc <= 32'b0;
	    end else if (stall) begin
            ID_pc <= ID_pc;
        end else begin
            ID_pc <= IF_pc;
        end
    end

    // Sequential logic for control signal delays and reset tracking
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            prev_stall   <= 1'b0;
            prev_wait    <= 1'b0;
            //prev_flush   <= 1'b0;
            rst_released <= 1'b0;
        end else begin 
            prev_stall   <= stall;
            prev_wait    <= mem_wait;
            //prev_flush   <= flush;
            rst_released <= 1'b1;
        end
    end

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            prev_flush   <= 1'b0;
        end else if (mem_wait) begin 
            prev_flush   <= prev_flush;
        end else begin 
            prev_flush   <= flush;
        end
    end


    // Instruction storage register (for stall handling)
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            stored_inst <= 32'b0;
        end else if (prev_stall & !mem_wait) begin // 當load-use
            stored_inst <= stored_inst;
        end else if (flush) begin
            stored_inst <= `NOP;
        end else begin
            stored_inst <= IF_inst;
        end
    end

    // Output instruction logic
    always_comb begin
        if (rst) begin
            ID_inst = 32'd0;
        end else if (prev_flush || !rst_released) begin 
            ID_inst = `NOP;
        end else if (prev_stall & !mem_wait) begin
            ID_inst = stored_inst;
        end else begin
            ID_inst = IF_inst;
        end
    end

    /*
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            ID_inst <= `NOP;
        end else if (flush) begin
            ID_inst <= `NOP;
        end else if (stall & !prev_wait) begin
            ID_inst <= stored_inst;
        end else begin
            ID_inst <= IF_inst;
        end
    end*/
    
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            ID_btb_b_hit         <= 1'b0;
            ID_btb_j_hit         <= 1'b0;
            ID_gbc_predict_taken <= 1'b0;
            ID_bhr               <= 4'b0;
        end else if (stall) begin
            ID_btb_b_hit         <= ID_btb_b_hit;
            ID_btb_j_hit         <= ID_btb_j_hit;
            ID_gbc_predict_taken <= ID_gbc_predict_taken;
            ID_bhr               <= ID_bhr;
        end else begin
            ID_btb_b_hit         <= IF_btb_b_hit;
            ID_btb_j_hit         <= IF_btb_j_hit;
            ID_gbc_predict_taken <= IF_gbc_predict_taken;
            ID_bhr               <= IF_bhr;
        end
    end

endmodule
