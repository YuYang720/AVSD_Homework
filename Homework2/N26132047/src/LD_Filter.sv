module LD_Filter(
    input logic [ 2:0] func3,
    input logic [31:0] cal_out,
    input logic [31:0] ld_data,
    
    output logic [31:0] ld_f_data
);
    logic [15:0] selected_half;
    logic [ 7:0] selected_byte;

    always_comb begin
        case(cal_out[1:0])
            2'd0: begin
                selected_byte = ld_data[7:0];
                selected_half = ld_data[15:0];
            end
            2'd1: begin
                selected_byte = ld_data[15:8];
                selected_half = ld_data[23:8]; 
            end
            2'd2: begin
                selected_byte = ld_data[23:16];
                selected_half = ld_data[31:16];
            end
            2'd3: begin
                selected_byte = ld_data[31:24];
                selected_half = 16'b0;
            end
        endcase

        case(func3)
            `LW:  ld_f_data = ld_data;
            `LH:  ld_f_data = {{16{selected_half[15]}}, selected_half};
            `LB:  ld_f_data = {{24{selected_byte[7]}}, selected_byte};
            `LHU: ld_f_data = {16'b0, selected_half};
            `LBU: ld_f_data = {24'b0, selected_byte};
            default: ld_f_data = 32'b0;
        endcase
    end
endmodule
