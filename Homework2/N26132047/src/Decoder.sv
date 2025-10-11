module Decoder (
    input logic [31:0] ID_inst,  

    output logic [6:0] ID_op,
    output logic [2:0] ID_func3,
    output logic [6:0] ID_func7,
    output logic [4:0] ID_rs1_index,   
    output logic [4:0] ID_rs2_index,
    output logic [4:0] ID_rd_index   
);
    assign ID_op        = ID_inst[ 6: 0];
    assign ID_func3     = ID_inst[14:12];
    assign ID_func7     = ID_inst[31:25];
    assign ID_rs1_index = ID_inst[19:15];
    assign ID_rs2_index = ID_inst[24:20];
    assign ID_rd_index  = ID_inst[11: 7];
    
endmodule