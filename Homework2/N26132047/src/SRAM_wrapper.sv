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

module SRAM_wrapper(
    input                              ACLK,		
    input                              ARESETn,	
    input        [31:0]                BASE_ADDR,

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

    // AXI Slave Write Response Channel 
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
        IDLE, READ, WRITE, WAIT_WVALID, REAPONSE
    } STATE_t;

    // request structure
    typedef struct packed {
        logic [`AXI_IDS_BITS -1:0] id;
        logic [`AXI_ADDR_BITS-1:0] addr;
        logic [`AXI_LEN_BITS -1:0] len;
        logic [`AXI_SIZE_BITS-1:0] size;
    } REQUEST_t;

    STATE_t    state_c,   state_n;
    REQUEST_t  request_c, request_n;
    logic [ 3:0] burst_counter_c, burst_counter_n;
    logic        CEB, WEB, WRITE_REQ, READ_REQ;
    logic [13:0] A;
    logic [31:0] DI, BWEB, DO, ADDRESS, real_addr;

    // --------------------------------------------
    //                 SRAM Module                 
    // --------------------------------------------
    assign real_addr = ADDRESS - BASE_ADDR;
    assign A         = real_addr[15:2];
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

    always_ff @(posedge)


endmodule