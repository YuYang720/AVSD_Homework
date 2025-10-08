`timescale 1ns/10ps
`include "../include/AXI_define.svh"
`include "CPU.sv"

module CPU_wrapper (

    input  logic ACLK                            ,
	input  logic ARESETn                         ,

    //WRITE ADDRESS M0
    output logic [`AXI_ID_BITS  -1:0] AWID_M0    ,
    output logic [`AXI_ADDR_BITS-1:0] AWADDR_M0  ,
    output logic [`AXI_LEN_BITS -1:0] AWLEN_M0   ,
    output logic [`AXI_SIZE_BITS-1:0] AWSIZE_M0  ,
    output logic [1:0]                AWBURST_M0 ,
    output logic                      AWVALID_M0 ,
    input  logic                      AWREADY_M0 ,

    //WRITE DATA M0
    output logic [`AXI_DATA_BITS-1:0] WDATA_M0   ,
    output logic [`AXI_STRB_BITS-1:0] WSTRB_M0   ,
    output logic                      WLAST_M0   ,
    output logic                      WVALID_M0  ,
    input  logic                      WREADY_M0  ,

    //WRITE RESPONSE M0
    input  logic [`AXI_ID_BITS  -1:0] BID_M0     ,
    input  logic [1:0]                BRESP_M0   ,
    input  logic                      BVALID_M0  ,
    output logic                      BREADY_M0  ,

    //READ ADDRESS M0
    output logic [`AXI_ID_BITS  -1:0] ARID_M0    ,
    output logic [`AXI_ADDR_BITS-1:0] ARADDR_M0  ,
    output logic [`AXI_LEN_BITS -1:0] ARLEN_M0   ,
    output logic [`AXI_SIZE_BITS-1:0] ARSIZE_M0  ,
    output logic [1:0]                ARBURST_M0 ,
    output logic                      ARVALID_M0 ,
    input  logic                      ARREADY_M0 ,

    //READ DATA M0
    input  logic [`AXI_ID_BITS  -1:0] RID_M0     ,
    input  logic [`AXI_DATA_BITS-1:0] RDATA_M0   ,
    input  logic [1:0]                RRESP_M0   ,
    input  logic                      RLAST_M0   ,
    input  logic                      RVALID_M0  ,
    output logic                      RREADY_M0  ,

    //WRITE ADDRESS M1
    output logic [`AXI_ID_BITS  -1:0] AWID_M1    ,
    output logic [`AXI_ADDR_BITS-1:0] AWADDR_M1  ,
    output logic [`AXI_LEN_BITS -1:0] AWLEN_M1   ,
    output logic [`AXI_SIZE_BITS-1:0] AWSIZE_M1  ,
    output logic [1:0]                AWBURST_M1 ,
    output logic                      AWVALID_M1 ,
    input  logic                      AWREADY_M1 ,

    //WRITE DATA M1
    output logic [`AXI_DATA_BITS-1:0] WDATA_M1   ,
    output logic [`AXI_STRB_BITS-1:0] WSTRB_M1   ,
    output logic                      WLAST_M1   ,
    output logic                      WVALID_M1  ,
    input  logic                      WREADY_M1  ,

    //WRITE RESPONSE M1
    input  logic [`AXI_ID_BITS  -1:0] BID_M1     ,
    input  logic [1:0]                BRESP_M1   ,
    input  logic                      BVALID_M1  ,
    output logic                      BREADY_M1  ,

    //READ ADDRESS M1
    output logic [`AXI_ID_BITS  -1:0] ARID_M1    ,
    output logic [`AXI_ADDR_BITS-1:0] ARADDR_M1  ,
    output logic [`AXI_LEN_BITS -1:0] ARLEN_M1   ,
    output logic [`AXI_SIZE_BITS-1:0] ARSIZE_M1  ,
    output logic [1:0]                ARBURST_M1 ,
    output logic                      ARVALID_M1 ,
    input  logic                      ARREADY_M1 ,

    //READ DATA M1
    input  logic [`AXI_ID_BITS  -1:0] RID_M1     ,
    input  logic [`AXI_DATA_BITS-1:0] RDATA_M1   ,
    input  logic [1:0]                RRESP_M1   ,
    input  logic                      RLAST_M1   ,
    input  logic                      RVALID_M1  ,
    output logic                      RREADY_M1
);

    //*******************localparam************************//
    localparam IDLE_P           = 3'd0;
    localparam WRITE_ADDRESS_P  = 3'd1;
    localparam WRITE_DATA_P     = 3'd2;
    localparam WRITE_RESPONSE_P = 3'd3;
    localparam READ_ADDRESS_P   = 3'd4;
    localparam WAIT_READ_DATA_P = 3'd6;
    localparam SAVE_READ_DATA_P = 3'd7;
    //*******************register*************************//
    logic [2:0]                state_current_m0_r  ;
    logic [2:0]                state_current_m1_r  ;

    logic [`AXI_DATA_BITS-1:0] if_insn_axi_r       ;
    logic [`AXI_ADDR_BITS-1:0] if_insn_axi_addr_r  ;
    logic                      if_insn_axi_valid_r ;
    logic [`AXI_ADDR_BITS-1:0] mem_axi_raddr_r     ;
    logic [3:0]                mem_axi_web_r       ;
    logic [`AXI_DATA_BITS-1:0] mem_axi_wdata_r     ;
    logic [`AXI_ADDR_BITS-1:0] mem_axi_waddr_r     ;
    logic                      mem_axi_wvalid_r    ;
    logic [`AXI_DATA_BITS-1:0] mem_axi_rdata_r     ;
    logic                      mem_axi_rvalid_r    ;

    //READ ADDRESS M0
    logic                      arvalid_m0_r    ;
    logic [`AXI_ADDR_BITS-1:0] araddr_m0_r     ;

    //READ DATA M0
    logic                      rready_m0_r     ;

    //WRITE ADDRESS M1
    logic [`AXI_ADDR_BITS-1:0] awaddr_m1_r     ;
    logic                      awvalid_m1_r    ;

    //WRITE DATA M1
    logic [`AXI_STRB_BITS-1:0] wstrb_m1_r      ;
    logic                      wvalid_m1_r     ;
    logic [`AXI_DATA_BITS-1:0] wdata_m1_r      ;
    logic                      wlast_m1_r      ;

    //WRITE RESPONSE M1
    logic                      bready_m1_r     ;

    //READ ADDRESS M1
    logic                      arvalid_m1_r    ;
    logic [`AXI_ADDR_BITS-1:0] araddr_m1_r     ;

    //READ DATA M1
    logic                      rready_m1_r     ;

    //*******************wire*****************************//
    logic [2:0]                state_next_m0_w     ;
    logic [2:0]                state_next_m1_w     ;

    //MASTER 0
    logic                      if_insn_axi_valid_w ;
    logic [31:0]               if_insn_axi_w       ;
    logic [31:0]               if_pc_reg_w         ;
    logic [31:0]               if_insn_axi_addr_w  ;

    //MASTER 1
    logic                      mem_axi_wvalid_w    ;
    logic                      mem_axi_rvalid_w    ;
    logic                      mem_mem_store_w     ;
    logic                      mem_mem_read_w      ;
    logic [3:0]                mem_mem_web_w       ;
    logic [31:0]               mem_mem_addr_w      ;
    logic [3:0]                mem_axi_web_w       ;
    logic [31:0]               mem_axi_wdata_w     ;
    logic [31:0]               mem_axi_waddr_w     ;
    logic [31:0]               mem_axi_raddr_w     ;
    logic [31:0]               mem_mem_wdata_w     ;
    logic [31:0]               mem_mem_read_data_w ;

    //*******************combination**********************//

    //WRITE ADDRESS M0
    assign AWID_M0      = 4'b0000                ;
    assign AWADDR_M0    = 32'b0                  ;
    assign AWLEN_M0     = 4'b0000                ;
    assign AWSIZE_M0    = 3'b010                 ;
    assign AWBURST_M0   = 2'b01                  ;
    assign AWVALID_M0   = 1'b0                   ;

    //WRITE DATA M0
    assign WDATA_M0   = 32'b0                    ;
    assign WSTRB_M0   = 4'b0000                  ;
    assign WLAST_M0   = 1'b0                     ;
    assign WVALID_M0  = 1'b0                     ;

    //WRITE RESPONSE M0
    assign BREADY_M0  = 1'b1                     ;

    //READ ADDRESS M0
    assign ARID_M0    = 4'b0000                  ;
    assign ARADDR_M0  = araddr_m0_r              ;
    assign ARLEN_M0   = 4'b0000                  ;
    assign ARSIZE_M0  = 3'b010                   ;
    assign ARBURST_M0 = 2'b01                    ;
    assign ARVALID_M0 = arvalid_m0_r             ;

    //READ DATA M0
    assign RREADY_M0  = rready_m0_r              ;

    //WRITE ADDRESS M1
    assign AWID_M1    = 4'b0001                  ;
    assign AWADDR_M1  = awaddr_m1_r              ;
    assign AWLEN_M1   = 4'b0000                  ;
    assign AWSIZE_M1  = 3'b010                   ;
    assign AWBURST_M1 = 2'b01                    ;
    assign AWVALID_M1 = awvalid_m1_r             ;

    //WRITE DATA M1
    assign WDATA_M1   = wdata_m1_r               ;
    assign WSTRB_M1   = wstrb_m1_r               ;
    assign WLAST_M1   = wlast_m1_r               ;
    assign WVALID_M1  = wvalid_m1_r              ;

    //WRITE RESPONSE M1
    assign BREADY_M1  = bready_m1_r              ;

    //READ ADDRESS M1
    assign ARID_M1    = 4'b0001                  ;
    assign ARADDR_M1  = araddr_m1_r              ;
    assign ARLEN_M1   = 4'b0000                  ;
    assign ARSIZE_M1  = 3'b010                   ;
    assign ARBURST_M1 = 2'b01                    ;
    assign ARVALID_M1 = arvalid_m1_r             ;

    //READ DATA M1
    assign RREADY_M1  = rready_m1_r                  ;

    assign if_insn_axi_w       = if_insn_axi_r       ;
    assign if_insn_axi_valid_w = if_insn_axi_valid_r ;
    assign if_insn_axi_addr_w  = if_insn_axi_addr_r  ;
    assign mem_mem_read_data_w = mem_axi_rdata_r     ;
    assign mem_axi_raddr_w     = mem_axi_raddr_r     ;
    assign mem_axi_web_w       = mem_axi_web_r       ;
    assign mem_axi_wdata_w     = mem_axi_wdata_r     ;
    assign mem_axi_waddr_w     = mem_axi_waddr_r     ;
    assign mem_axi_wvalid_w    = mem_axi_wvalid_r    ;
    assign mem_axi_rvalid_w    = mem_axi_rvalid_r    ;

    //*******************state machine********************//
    always_ff @ (posedge ACLK, negedge ARESETn) begin
        if (~ARESETn) begin
            state_current_m0_r <= IDLE_P;
        end
        else begin
            state_current_m0_r <= state_next_m0_w;
        end
    end

    always_comb begin
        if (state_current_m0_r == IDLE_P) begin
            if ((if_insn_axi_addr_r != if_pc_reg_w) || ~if_insn_axi_valid_r) begin
                state_next_m0_w = READ_ADDRESS_P;
            end else begin
                state_next_m0_w = IDLE_P;
            end
        end else if (state_current_m0_r == READ_ADDRESS_P) begin
            if (ARVALID_M0 && ARREADY_M0) begin
                state_next_m0_w = WAIT_READ_DATA_P;
            end else begin
                state_next_m0_w = READ_ADDRESS_P;
            end
        end else if (state_current_m0_r == WAIT_READ_DATA_P) begin
            if (RVALID_M0 && RREADY_M0) begin
                state_next_m0_w = SAVE_READ_DATA_P;
            end else begin
                state_next_m0_w = WAIT_READ_DATA_P;
            end
        end else if (state_current_m0_r == SAVE_READ_DATA_P) begin
            state_next_m0_w = IDLE_P;
        end
            else
	    state_next_m0_w = IDLE_P;
    end

    always_ff @(posedge ACLK) begin
        if (~ARESETn) begin
            araddr_m0_r         <= 32'b0;
            arvalid_m0_r        <= 1'b0;
            rready_m0_r         <= 1'b0;
            if_insn_axi_r       <= 32'b0;
            if_insn_axi_valid_r <= 1'b0;
            if_insn_axi_addr_r  <= 32'b0;
        end
        else if (state_next_m0_w == READ_ADDRESS_P) begin
            araddr_m0_r  <= if_pc_reg_w;
            arvalid_m0_r <= 1'b1;
        end else if (state_next_m0_w == WAIT_READ_DATA_P) begin
            arvalid_m0_r <= 1'b0;
            rready_m0_r  <= 1'b1;
        end else if (state_next_m0_w == SAVE_READ_DATA_P) begin
            if_insn_axi_r       <= RDATA_M0;
            if_insn_axi_valid_r <= 1'b1;
            if_insn_axi_addr_r  <= araddr_m0_r;
        end else begin // IDLE
            araddr_m0_r         <= 32'b0;
            arvalid_m0_r        <= 1'b0;
            rready_m0_r         <= 1'b0;
            if_insn_axi_r       <= if_insn_axi_r;
            if_insn_axi_valid_r <= if_insn_axi_valid_r;
            if_insn_axi_addr_r  <= if_insn_axi_addr_r;
        end
    end


    //*******************state machine********************//
    always_ff @(posedge ACLK) begin
        if (~ARESETn) begin
            state_current_m1_r <= IDLE_P;
        end else begin 
            state_current_m1_r <= state_next_m1_w;
        end
    end

    always_comb begin
        if (state_current_m1_r == IDLE_P) begin
            if (mem_mem_store_w && ((mem_axi_waddr_r != mem_mem_addr_w) || ~mem_axi_wvalid_r || (mem_axi_wdata_r != mem_mem_wdata_w))) begin
                state_next_m1_w = WRITE_ADDRESS_P;
            end else if (mem_mem_read_w && ((mem_axi_raddr_r != mem_mem_addr_w) || ~mem_axi_rvalid_r)) begin
                state_next_m1_w = READ_ADDRESS_P;
            end else begin
                state_next_m1_w = IDLE_P;
            end
        end else if (state_current_m1_r == WRITE_ADDRESS_P) begin
            if (AWVALID_M1 && AWREADY_M1) begin
                state_next_m1_w = WRITE_DATA_P;
            end else begin
                state_next_m1_w = WRITE_ADDRESS_P;
            end
        end else if (state_current_m1_r == READ_ADDRESS_P) begin
            if (ARVALID_M1 && ARREADY_M1) begin
                state_next_m1_w = WAIT_READ_DATA_P;
            end else begin
                state_next_m1_w = READ_ADDRESS_P;
            end
        end else if (state_current_m1_r == WRITE_DATA_P) begin
            if (WVALID_M1 && WREADY_M1) begin
                state_next_m1_w = WRITE_RESPONSE_P;
            end else begin
                state_next_m1_w = WRITE_DATA_P;
            end
        end else if (state_current_m1_r == WRITE_RESPONSE_P) begin
            if (BREADY_M1 && BVALID_M1) begin
                state_next_m1_w = IDLE_P;
            end else begin
                state_next_m1_w = WRITE_RESPONSE_P;
            end
        end else if (state_current_m1_r == WAIT_READ_DATA_P) begin
            if (RVALID_M1 && RREADY_M1) begin
                state_next_m1_w = SAVE_READ_DATA_P;
            end else begin
                state_next_m1_w = WAIT_READ_DATA_P;
            end
        end else if (state_current_m1_r == SAVE_READ_DATA_P) begin
            state_next_m1_w = IDLE_P;
        end
	    else
	    state_next_m1_w = IDLE_P;
    end

    always_ff @(posedge ACLK) begin
        if (~ARESETn) begin
            awaddr_m1_r      <= 32'b0;
            awvalid_m1_r     <= 1'b0;
            araddr_m1_r      <= 32'b0;
            arvalid_m1_r     <= 1'b0;
            wstrb_m1_r       <= 4'b0000;
            wvalid_m1_r      <= 1'b0;
            wdata_m1_r       <= 32'b0;
            wlast_m1_r       <= 1'b0;
            mem_axi_waddr_r  <= 32'b0;
            mem_axi_web_r    <= 4'b1111;
            mem_axi_wdata_r  <= 32'b0;
            mem_axi_wvalid_r <= 1'b0;
            rready_m1_r      <= 1'b0;
            bready_m1_r      <= 1'b0;
            mem_axi_raddr_r  <= 32'b0;
            mem_axi_rdata_r  <= 32'b0;
            mem_axi_rvalid_r <= 1'b0;
        end
        else if (state_next_m1_w == WRITE_ADDRESS_P) begin
            awaddr_m1_r      <= mem_mem_addr_w;
            awvalid_m1_r     <= 1'b1;
        end else if (state_next_m1_w == READ_ADDRESS_P) begin
            araddr_m1_r      <= mem_mem_addr_w;
            arvalid_m1_r     <= 1'b1;
        end else if (state_next_m1_w == WRITE_DATA_P) begin
            awvalid_m1_r     <= 1'b0;
            wstrb_m1_r       <= ~mem_mem_web_w;
            wvalid_m1_r      <= 1'b1;
            wdata_m1_r       <= mem_mem_wdata_w;
            wlast_m1_r       <= 1'b1;
            mem_axi_rvalid_r <= 1'b0;
        end else if (state_next_m1_w == WAIT_READ_DATA_P) begin
            arvalid_m1_r     <= 1'b0;
            rready_m1_r      <= 1'b1;
        end else if (state_next_m1_w == WRITE_RESPONSE_P) begin
	    wvalid_m1_r      <= 1'b0;
            wlast_m1_r       <= 1'b0;
            rready_m1_r      <= 1'b0;
            bready_m1_r      <= 1'b1;
            mem_axi_web_r    <= mem_mem_web_w;
            mem_axi_wdata_r  <= mem_mem_wdata_w;
            mem_axi_waddr_r  <= awaddr_m1_r;
            mem_axi_wvalid_r <= 1'b1;
        end else if (state_next_m1_w == SAVE_READ_DATA_P) begin
            mem_axi_raddr_r  <= araddr_m1_r;
            mem_axi_rdata_r  <= RDATA_M1;
            mem_axi_rvalid_r <= 1'b1;
        end else begin //IDLE
            awaddr_m1_r      <= 32'b0;
            awvalid_m1_r     <= 1'b0;
            araddr_m1_r      <= 32'b0;
            arvalid_m1_r     <= 1'b0;
            wstrb_m1_r       <= 4'b0000;
            wvalid_m1_r      <= 1'b0;
            wdata_m1_r       <= 32'b0;
            wlast_m1_r       <= 1'b0;
            mem_axi_web_r    <= mem_axi_web_r;
            mem_axi_wdata_r  <= mem_axi_wdata_r; 
            mem_axi_waddr_r  <= mem_axi_waddr_r;
            mem_axi_wvalid_r <= mem_axi_wvalid_r;
            rready_m1_r      <= 1'b0;
            bready_m1_r      <= 1'b0;
            mem_axi_raddr_r  <= mem_axi_raddr_r;
            mem_axi_rdata_r  <= mem_axi_rdata_r;
            mem_axi_rvalid_r <= mem_axi_rvalid_r;
        end
    end

    //*******************instance**********************//
    CPU cpu(
        .clk_i                  (ACLK)                ,
        .rst_i                  (~ARESETn)            ,
        .if_insn_axi_valid_i    (if_insn_axi_valid_w) ,
        .if_insn_axi_addr_i     (if_insn_axi_addr_w)  ,
        .if_insn_axi_i          (if_insn_axi_w)       ,
        .mem_mem_read_data_i    (mem_mem_read_data_w) ,
        .mem_axi_raddr_i        (mem_axi_raddr_w)     ,
        .mem_axi_web_i          (mem_axi_web_w)       ,
        .mem_axi_wdata_i        (mem_axi_wdata_w)     ,
        .mem_axi_waddr_i        (mem_axi_waddr_w)     ,
        .mem_axi_wvalid_i       (mem_axi_wvalid_w)    ,
        .mem_axi_rvalid_i       (mem_axi_rvalid_w)    ,
        .mem_mem_store_o        (mem_mem_store_w)     ,
        .mem_mem_read_o         (mem_mem_read_w)      ,
        .mem_mem_web_o          (mem_mem_web_w)       ,
        .if_pc_reg_o            (if_pc_reg_w)         ,
        .mem_mem_addr_o         (mem_mem_addr_w)      ,
        .mem_mem_wdata_o        (mem_mem_wdata_w)
    );
endmodule : CPU_wrapper
