module Register_File (
    input logic        clk,
    input logic        rst,
    input logic        w_en,
    input logic [31:0] w_data,
    input logic [ 4:0] rs1_index,
    input logic [ 4:0] rs2_index,
    input logic [ 4:0] rd_index,
    
    output logic [31:0] rs1_data,
    output logic [31:0] rs2_data
);

    logic [31:0] register [0:31];

    // Read
    assign rs1_data = register[rs1_index];
    assign rs2_data = register[rs2_index];

    // Write
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin // 初始值設定為X 1.02可通過 設定為0則需1.06 否則在寫如memory時會少寫一個bit進去
            register[0] <= 32'b0;
            for (int i = 1; i < 32; i++) begin
                register[i] <= 32'bx;
            end
        end else if (w_en && rd_index != 5'd0) begin
            register[rd_index] <= w_data;
        end
    end

    
    logic [31:0] x0, ra, sp, gp, tp, t0, t1, t2, s0, s1, a0, a1, a2, a3, a4, a5, a6, a7;
    logic [31:0] s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, t3, t4, t5, t6;

    assign x0 = register[0];
    assign ra = register[1];
    assign sp = register[2];
    assign gp = register[3];
    assign tp = register[4];
    assign t0 = register[5];
    assign t1 = register[6];
    assign t2 = register[7];
    assign s0 = register[8];
    assign s1 = register[9];
    assign a0 = register[10];
    assign a1 = register[11];
    assign a2 = register[12];
    assign a3 = register[13];
    assign a4 = register[14];
    assign a5 = register[15];
    assign a6 = register[16];
    assign a7 = register[17];
    assign s2 = register[18];
    assign s3 = register[19];
    assign s4 = register[20];
    assign s5 = register[21];
    assign s6 = register[22];
    assign s7 = register[23];
    assign s8 = register[24];
    assign s9 = register[25];
    assign s10 = register[26];
    assign s11 = register[27];
    assign t3 = register[28];
    assign t4 = register[29];
    assign t5 = register[30];
    assign t6 = register[31];
    
    
endmodule