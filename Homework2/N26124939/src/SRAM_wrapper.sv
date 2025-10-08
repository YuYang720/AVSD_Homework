`timescale 1ns/10ps
`include "../include/AXI_define.svh"

module SRAM_wrapper (
	input  logic ACLK                         ,
	input  logic ARESETn                      ,

	//WRITE ADDRESS
	input  logic [`AXI_IDS_BITS -1:0] AWID    ,
	input  logic [`AXI_ADDR_BITS-1:0] AWADDR  ,
	input  logic [`AXI_LEN_BITS -1:0] AWLEN   ,
	input  logic [`AXI_SIZE_BITS-1:0] AWSIZE  ,
	input  logic [1:0]                AWBURST ,
	input  logic                      AWVALID ,
	output logic                      AWREADY ,

	//WRITE DATA
	input  logic [`AXI_DATA_BITS-1:0] WDATA   ,
	input  logic [`AXI_STRB_BITS-1:0] WSTRB   ,
	input  logic                      WLAST   ,
	input  logic                      WVALID  ,
	output logic                      WREADY  ,

	//WRITE RESPONSE
	output logic [`AXI_IDS_BITS -1:0] BID     ,
	output logic [1:0]                BRESP   ,
	output logic                      BVALID  ,
	input  logic                      BREADY  ,

    //READ ADDRESS
	input  logic [`AXI_IDS_BITS -1:0] ARID    ,
	input  logic [`AXI_ADDR_BITS-1:0] ARADDR  ,
	input  logic [`AXI_LEN_BITS -1:0] ARLEN   ,
	input  logic [`AXI_SIZE_BITS-1:0] ARSIZE  ,
	input  logic [1:0]                ARBURST ,
	input  logic                      ARVALID ,
	output logic                      ARREADY ,

	//READ DATA
	output logic [`AXI_IDS_BITS -1:0] RID     ,
	output logic [`AXI_DATA_BITS-1:0] RDATA   ,
	output logic [1:0]                RRESP   ,
	output logic                      RLAST   ,
	output logic                      RVALID  ,
	input  logic                      RREADY
);
    //*******************localparam*********************/
    localparam IDLE_P                = 4'd0;
    localparam WRITE_ADDRESS_P       = 4'd1;
    localparam WRITE_DATA_P          = 4'd2;
    localparam WRITE_RESPONSE_P      = 4'd3;
    localparam READ_ADDRESS_P        = 4'd4;
    localparam READ_DATA_P           = 4'd5;
    localparam WRITE_ADDRESS_READY_P = 4'd6;
    localparam READ_ADDRESS_READY_P  = 4'd7;
    localparam SAVE_READ_DATA_P      = 4'd8;
    localparam WAIT_RECEIVE_DATA_P   = 4'd9;

    //*******************wire*********************/
    logic [3:0]                state_next_w;

    logic                      CK  ;
    logic                      OE  ;
    logic                      CS  ;
    logic [`AXI_STRB_BITS-1:0] WEB ;
    logic [13:0]               A   ;
    logic [`AXI_DATA_BITS-1:0] DO  ;
    logic [`AXI_DATA_BITS-1:0] DI  ;

    //*******************register*********************/
    logic [3:0]                state_current_r ;
    logic [`AXI_ADDR_BITS-1:0] sram_out_addr_r ;
    logic                      sram_out_valid_r;

    //WRITE ADDRESS SLAVE
    logic [`AXI_IDS_BITS -1:0] awid_r;
    logic [`AXI_LEN_BITS -1:0] awlen_r;
    logic [`AXI_ADDR_BITS-1:0] awaddr_r;
    logic                      awready_r;

    //WRITE DATA SLAVE
    logic                      wready_r;

    //WRITE RESPONSE SLAVE
    logic [`AXI_IDS_BITS -1:0] bid_r;
    logic [1:0]                bresp_r;
    logic                      bvalid_r;

    //READ ADDRESS SLAVE
    logic [`AXI_ADDR_BITS-1:0] araddr_r;
    logic [`AXI_LEN_BITS -1:0] arlen_r;
    logic                      arready_r;

    //READ DATA SLAVE
    logic [`AXI_IDS_BITS -1:0] rid_r;
    logic [`AXI_DATA_BITS-1:0] rdata_r;
    logic [`AXI_LEN_BITS -1:0] rdata_count_r;
    logic [1:0]                rresp_r;
    logic                      rlast_r;
    logic                      rvalid_r;

    //*******************combination*********************/
    assign CK = ACLK;
    assign OE = 1'b1;
    assign CS = 1'b1;

    assign AWREADY = awready_r ;
    assign WREADY  = wready_r  ;
    assign BID     = bid_r     ;
    assign BRESP   = bresp_r   ;
    assign BVALID  = bvalid_r  ;
    assign ARREADY = arready_r ;
    assign RID     = rid_r     ;
    assign RDATA   = rdata_r   ;
    assign RRESP   = rresp_r   ;
    assign RLAST   = rlast_r   ;
    assign RVALID  = rvalid_r  ;

    //*******************state machine********************//
    always_ff @(posedge ACLK) begin
        if (~ARESETn) begin
            state_current_r <= IDLE_P;
        end else begin 
            state_current_r <= state_next_w;
        end
    end

    always_comb begin
        A   = 32'b0;
        DI  = 32'b0;
        WEB = 4'b1111; 
        if (state_current_r == IDLE_P) begin
            if (AWVALID) begin
                state_next_w = WRITE_ADDRESS_READY_P;
            end else if (ARVALID) begin
                state_next_w = READ_ADDRESS_READY_P;
            end else begin
                state_next_w = IDLE_P;
            end
        end else if (state_current_r == WRITE_ADDRESS_READY_P) begin
            if (AWVALID && AWREADY) begin
                state_next_w = WRITE_ADDRESS_P;
            end else begin
                state_next_w = WRITE_ADDRESS_READY_P;
            end
        end else if (state_current_r == WRITE_ADDRESS_P) begin
	        state_next_w = WRITE_DATA_P;
        end else if (state_current_r == READ_ADDRESS_READY_P) begin
            if (ARVALID && ARREADY) begin
                state_next_w = READ_ADDRESS_P;
            end else begin
                state_next_w = READ_ADDRESS_READY_P;
            end
        end else if (state_current_r == READ_ADDRESS_P) begin
	        state_next_w = READ_DATA_P;
        end else if (state_current_r == WRITE_DATA_P) begin
            A = awaddr_r[15:2];
            if (WVALID && WREADY) begin
                DI  = WDATA;
                WEB = ~WSTRB; //active low
            end
            if (WVALID && WREADY && WLAST) begin
                state_next_w = WRITE_RESPONSE_P;
            end else begin
                state_next_w = WRITE_DATA_P;
            end
        end else if (state_current_r == WRITE_RESPONSE_P) begin
            if (BVALID && BREADY) begin
                state_next_w = IDLE_P;
            end else begin
                state_next_w = WRITE_RESPONSE_P;
            end
        end else if (state_current_r == READ_DATA_P) begin
            A = araddr_r[15:2];
            if ((sram_out_addr_r == araddr_r[15:2]) && sram_out_valid_r) begin
                state_next_w = SAVE_READ_DATA_P;
            end else begin
                state_next_w = READ_DATA_P;
            end
        end else if (state_current_r == SAVE_READ_DATA_P) begin
	        state_next_w = WAIT_RECEIVE_DATA_P;
        end else if (state_current_r == WAIT_RECEIVE_DATA_P) begin
	    if (RLAST && RVALID && RREADY) begin
                state_next_w = IDLE_P;
            end else if (RVALID && RREADY) begin
                state_next_w = READ_DATA_P;
            end else begin
                state_next_w = WAIT_RECEIVE_DATA_P;
            end
        end else begin
            state_next_w = IDLE_P;
        end
    end

    always_ff @(posedge ACLK) begin
	if (!ARESETn)	begin
	    awid_r        <= `AXI_IDS_BITS'b0;
            awaddr_r      <= `AXI_ADDR_BITS;
            awready_r     <= 1'b0;
            wready_r      <= 1'b0;
            bid_r         <= `AXI_IDS_BITS'd0;
            bresp_r       <= 2'b0;
            bvalid_r      <= 1'b0;
            arlen_r       <= `AXI_LEN_BITS'b0;
            araddr_r      <= `AXI_ADDR_BITS'b0;
            arready_r     <= 1'b0;
            rid_r         <= `AXI_IDS_BITS'b0;
            rdata_r       <= `AXI_DATA_BITS'b0;
            rresp_r       <= 2'b0;
            rlast_r       <= 1'b0;
            rvalid_r      <= 1'b0;
            rdata_count_r <= `AXI_LEN_BITS'b0;
	end else if (state_next_w == WRITE_ADDRESS_READY_P) begin
            awready_r <= 1'b1;
        end else if (state_next_w == WRITE_ADDRESS_P) begin
            awid_r    <= AWID;
            awaddr_r  <= AWADDR;
            awready_r <= 1'b0;
        end else if (state_next_w == READ_ADDRESS_READY_P) begin
            arready_r <= 1'b1;
        end else if (state_next_w == WRITE_DATA_P) begin
            wready_r  <= 1'b1;
        end else if ((state_current_r == WAIT_RECEIVE_DATA_P) && (state_next_w == READ_DATA_P)) begin
            rdata_count_r <= rdata_count_r + 1;
            araddr_r      <= araddr_r + 4;
            rdata_r       <= 32'b0;
            rvalid_r      <= 1'b0;
            rlast_r       <= 1'b0;
        end else if (state_next_w == READ_ADDRESS_P) begin
            rid_r     <= ARID;
            arlen_r   <= ARLEN;
            araddr_r  <= ARADDR;
        end else if (state_next_w == READ_DATA_P) begin
            arready_r <= 1'b0;
        end else if (state_next_w == WRITE_RESPONSE_P) begin
            bid_r     <= awid_r;
            bresp_r   <= `AXI_RESP_OKAY;
            bvalid_r  <= 1'b1;
        end else if (state_next_w == WAIT_RECEIVE_DATA_P) begin
	    rvalid_r  <= 1'b1;
            if (rdata_count_r == arlen_r) begin
                rlast_r <= 1'b1;
            end else begin
                rlast_r <= 1'b0;
            end
        end else if (state_next_w == SAVE_READ_DATA_P) begin
            rdata_r       <= DO;
        end else begin //RESET IDLE_P
            awid_r        <= `AXI_IDS_BITS'b0;
            awaddr_r      <= `AXI_ADDR_BITS;
            awready_r     <= 1'b0;
            wready_r      <= 1'b0;
            bid_r         <= `AXI_IDS_BITS'd0;
            bresp_r       <= 2'b0;
            bvalid_r      <= 1'b0;
            arlen_r       <= `AXI_LEN_BITS'b0;
            araddr_r      <= `AXI_ADDR_BITS'b0;
            arready_r     <= 1'b0;
            rid_r         <= `AXI_IDS_BITS'b0;
            rdata_r       <= `AXI_DATA_BITS'b0;
            rresp_r       <= 2'b0;
            rlast_r       <= 1'b0;
            rvalid_r      <= 1'b0;
            rdata_count_r <= `AXI_LEN_BITS'b0;
        end
    end

    always_ff @(posedge ACLK) begin
        if (~ARESETn) begin
            sram_out_addr_r  <= 32'b0;
            sram_out_valid_r <= 1'b0;
        end else if (state_current_r == READ_DATA_P) begin
            sram_out_addr_r  <= A;
            sram_out_valid_r <= 1'b1;
        end else begin
            sram_out_valid_r <= 1'b0;
        end
    end

    SRAM i_SRAM (
        .A0   (A[0]  ),
        .A1   (A[1]  ),
        .A2   (A[2]  ),
        .A3   (A[3]  ),
        .A4   (A[4]  ),
        .A5   (A[5]  ),
        .A6   (A[6]  ),
        .A7   (A[7]  ),
        .A8   (A[8]  ),
        .A9   (A[9]  ),
        .A10  (A[10] ),
        .A11  (A[11] ),
        .A12  (A[12] ),
        .A13  (A[13] ),
        .DO0  (DO[0] ),
        .DO1  (DO[1] ),
        .DO2  (DO[2] ),
        .DO3  (DO[3] ),
        .DO4  (DO[4] ),
        .DO5  (DO[5] ),
        .DO6  (DO[6] ),
        .DO7  (DO[7] ),
        .DO8  (DO[8] ),
        .DO9  (DO[9] ),
        .DO10 (DO[10]),
        .DO11 (DO[11]),
        .DO12 (DO[12]),
        .DO13 (DO[13]),
        .DO14 (DO[14]),
        .DO15 (DO[15]),
        .DO16 (DO[16]),
        .DO17 (DO[17]),
        .DO18 (DO[18]),
        .DO19 (DO[19]),
        .DO20 (DO[20]),
        .DO21 (DO[21]),
        .DO22 (DO[22]),
        .DO23 (DO[23]),
        .DO24 (DO[24]),
        .DO25 (DO[25]),
        .DO26 (DO[26]),
        .DO27 (DO[27]),
        .DO28 (DO[28]),
        .DO29 (DO[29]),
        .DO30 (DO[30]),
        .DO31 (DO[31]),
        .DI0  (DI[0] ),
        .DI1  (DI[1] ),
        .DI2  (DI[2] ),
        .DI3  (DI[3] ),
        .DI4  (DI[4] ),
        .DI5  (DI[5] ),
        .DI6  (DI[6] ),
        .DI7  (DI[7] ),
        .DI8  (DI[8] ),
        .DI9  (DI[9] ),
        .DI10 (DI[10]),
        .DI11 (DI[11]),
        .DI12 (DI[12]),
        .DI13 (DI[13]),
        .DI14 (DI[14]),
        .DI15 (DI[15]),
        .DI16 (DI[16]),
        .DI17 (DI[17]),
        .DI18 (DI[18]),
        .DI19 (DI[19]),
        .DI20 (DI[20]),
        .DI21 (DI[21]),
        .DI22 (DI[22]),
        .DI23 (DI[23]),
        .DI24 (DI[24]),
        .DI25 (DI[25]),
        .DI26 (DI[26]),
        .DI27 (DI[27]),
        .DI28 (DI[28]),
        .DI29 (DI[29]),
        .DI30 (DI[30]),
        .DI31 (DI[31]),
        .CK   (CK    ),
        .WEB0 (WEB[0]),
        .WEB1 (WEB[1]),
        .WEB2 (WEB[2]),
        .WEB3 (WEB[3]),
        .OE   (OE    ),
        .CS   (CS    )
    );

endmodule : SRAM_wrapper
