//////////////////////////////////////////////////////////////////////
//          ██╗       ██████╗   ██╗  ██╗    ██████╗            		//
//          ██║       ██╔══█║   ██║  ██║    ██╔══█║            		//
//          ██║       ██████║   ███████║    ██████║            		//
//          ██║       ██╔═══╝   ██╔══██║    ██╔═══╝            		//
//          ███████╗  ██║  	    ██║  ██║    ██║  	           		//
//          ╚══════╝  ╚═╝  	    ╚═╝  ╚═╝    ╚═╝  	           		//
//                                                             		//
// 	2024 Advanced VLSI System Design, advisor: Lih-Yih, Chiou		//
//                                                             		//
//////////////////////////////////////////////////////////////////////
//                                                             		//
// 	Autor: 			YU-YANG, Wang             			  	   		//
//	Filename:		SRAM_Wrapper.sv		                            //
//	Description:	SRAM_Wrapper for Slave of AXI                	//
// 	Date:			2024/11/3								   		//
// 	Version:		1.0	    								   		//
//////////////////////////////////////////////////////////////////////
`include "AXI_define.svh"

module SRAM_wrapper(
    input                              ACLK,		
    input                              ARESETn,	

    // AXI Slave Write Address Channel
    input        [`AXI_IDS_BITS -1:0]  AWID_S,		
    input        [`AXI_ADDR_BITS-1:0]  AWADDR_S,   
    input        [`AXI_LEN_BITS -1:0]  AWLEN_S,    
    input        [`AXI_SIZE_BITS-1:0]  AWSIZE_S,   
    input        [1:0]                 AWBURST_S,  
    input                              AWVALID_S,	
    output logic                       AWREADY_S, 

    // AXI Slave Write Data Channel 
    input        [`AXI_DATA_BITS-1:0]  WDATA_S,	
    input        [`AXI_STRB_BITS-1:0]  WSTRB_S,    
    input                              WLAST_S,    
    input                              WVALID_S,   
    output logic                       WREADY_S,

    // AXI Slave Write RESPOND Channel 
    output logic [`AXI_IDS_BITS-1:0]   BID_S,		
    output logic [1:0]                 BRESP_S,    
    output logic                       BVALID_S,   
    input                              BREADY_S,   

    // AXI Slave Read Address Channel
    input        [`AXI_IDS_BITS -1:0]  ARID_S,     
    input        [`AXI_ADDR_BITS-1:0]  ARADDR_S,   
    input        [`AXI_LEN_BITS -1:0]  ARLEN_S,    
    input        [`AXI_SIZE_BITS-1:0]  ARSIZE_S,   
    input        [1:0]                 ARBURST_S,  
    input                              ARVALID_S,  
    output logic                       ARREADY_S,  

    // AXI Slave Read Data Channel
    output logic [`AXI_IDS_BITS -1:0]  RID_S,		
    output logic [`AXI_DATA_BITS-1:0]  RDATA_S,    
    output logic [1:0]                 RRESP_S,    
    output logic                       RLAST_S,    
    output logic                       RVALID_S,   
    input                              RREADY_S   
);

    // --------------------------------------------
    //              Signal Declaration             
    // --------------------------------------------

    // slave FSM
    typedef enum logic [2:0] {
        IDLE, READ, WRITING, WAIT_W_HS, RESPOND
    } STATE_t;

    // request structure
    typedef struct packed {
        logic [`AXI_IDS_BITS -1:0] id;
        logic [`AXI_ADDR_BITS-1:0] addr;
        logic [`AXI_LEN_BITS -1:0] len;
        logic [`AXI_SIZE_BITS-1:0] size;
    } REQUEST_t;

    STATE_t      state_c,   state_n;
    REQUEST_t    request_c, request_n;
    logic [ 3:0] burst_counter_c, burst_counter_n;
    logic        CEB, WEB, WRITE_REQ, READ_REQ;
    logic [13:0] A;
    logic [31:0] DI, BWEB, DO, ADDRESS;

    // --------------------------------------------
    //                 SRAM Module                 
    // --------------------------------------------
    assign A         = ADDRESS[15:2];
    assign CEB       = ~(WRITE_REQ | READ_REQ);
    assign WEB       = ~WRITE_REQ;
    assign BWEB      = {{8{~WSTRB_S[3]}}, {8{~WSTRB_S[2]}}, {8{~WSTRB_S[1]}}, {8{~WSTRB_S[0]}}};

    TS1N16ADFPCLLLVTA512X45M4SWSHOD i_SRAM (
        .SLP     ( 1'b0  ),
        .DSLP    ( 1'b0  ),
        .SD      ( 1'b0  ),
        .PUDELAY (       ),
        .CLK     ( clk   ),
        .CEB     ( CEB   ),
        .WEB     ( WEB   ),
        .A       ( A     ),
        .D       ( DI    ),
        .BWEB    ( BWEB  ),
        .RTSEL   ( 2'b01 ),
        .WTSEL   ( 2'b01 ),
        .Q       ( DO    )
    );

    // --------------------------------------------
    //                  AXI Slave                  
    // --------------------------------------------

    always_ff @(posedge ACLK or negedge ARESETn) begin
        if (!ARESETn) begin
            state_c         <= IDLE;
            request_c       <= REQUEST_t'(0); 
            burst_counter_c <= 4'd0;
        end else begin
            state_c         <= state_n;
            request_c       <= request_n;
            burst_counter_c <= burst_counter_n;
        end
    end

    //assign BRESP_S = 2'b0;
    //assign RRESP_S = 2'b0;

    always_comb begin

        state_n         = state_c;
        request_n       = request_c;
        burst_counter_n = burst_counter_c;

        ADDRESS   = ARADDR_S;
        DI        = WDATA_S;
        WRITE_REQ = '0;
        READ_REQ  = '0;

        AWREADY_S = '0;
        WREADY_S  = '0;
        BID_S     =  request_c.id;
        BRESP_S   = `AXI_RESP_OKAY;
        BVALID_S  = '0;
        ARREADY_S = '0;
        RID_S     =  request_c.id;
        RDATA_S   =  DO;
        RRESP_S   = `AXI_RESP_OKAY;

        RLAST_S   = '0;
        RVALID_S  = '0;

        case (state_c)
            IDLE: begin
                // assert AR/SW ready to receive load/store request
                AWREADY_S = 1'b1;
                ARREADY_S = 1'b1;

                if (ARVALID_S) begin
                    state_n   = READ;
                    request_n = {ARID_S, ARADDR_S, ARLEN_S, ARSIZE_S};

                    READ_REQ = 1'b1; // 先去讀 下一 clock 即可回傳
                    ADDRESS  = ARADDR_S;
                    burst_counter_n = 4'd1;

                end else if (AWVALID_S) begin
                    state_n = WAIT_W_HS;
                    request_n = {AWID_S, AWADDR_S, AWLEN_S, AWSIZE_S};

                    WREADY_S = 1'b1;
                    if (WVALID_S) begin
                        WRITE_REQ = 1'b1;
                        ADDRESS  = AWADDR_S;
                        burst_counter_n = 4'd1;
                        state_n = (WLAST_S) ? RESPOND : WRITING;
                    end
                end
            end 
            READ: begin
                // keep reading the same address
                READ_REQ = 1'b1;
                ADDRESS  = request_c.addr;

                // R channel RESPOND
                RVALID_S  = 1'b1;
                RID_S     = request_c.id;
                RDATA_S   = DO;
                RLAST_S   = (request_c.len + 4'd1 == burst_counter_c);
                // why + 1 ?

                // R channel handshake
                if (RREADY_S) begin
                    state_n = (RLAST_S) ? IDLE : READ;

                    RRESP_S         = `AXI_RESP_OKAY;
                    burst_counter_n = burst_counter_c + 4'd1;
                    request_n.addr  = request_c.addr + (32'd1 << request_c.size);
                    ADDRESS         = request_n.addr;
                end
            end
            WAIT_W_HS: begin
                WREADY_S = 1'b1;

                if (WVALID_S) begin
                    WRITE_REQ = 1'b1;
                    ADDRESS  = request_c.addr;
                    burst_counter_n = 4'd1;
                    
                    state_n = (WLAST_S) ? RESPOND : WRITING;
                end
            end
            WRITING: begin
                WREADY_S = 1'b1;
                
                if (WVALID_S) begin
                    WRITE_REQ = 1'b1;
                    burst_counter_n = burst_counter_c + 4'd1;
                    request_n.addr  = request_c.addr + (32'd1 << request_c.size);
                    ADDRESS         = request_n.addr;
                    
                    state_n = (WLAST_S) ? RESPOND : WRITING;
                end
            end
            RESPOND: begin
                BVALID_S = 1'b1;
                BID_S    = request_c.id; 
                if (BREADY_S) begin
                    state_n = IDLE;
                    BRESP_S = `AXI_RESP_OKAY;
                end
            end
            default: state_n = IDLE;
        endcase
    end


endmodule