module Program_Counter_reg (
    input  logic        clk,
    input  logic        rst,
    input  logic        stall,
    input  logic        mem_wait,

    input  logic [31:0] next_pc,
    output logic [31:0] current_pc
);
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            current_pc <= 32'h0;
        end else if (!stall & !mem_wait) begin    
            current_pc <= next_pc;
        end else begin
            current_pc <= current_pc;
        end
    end
endmodule
