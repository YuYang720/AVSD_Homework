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
// 	Autor: 			SIMON				                 	   		//
//	Filename:		CPU_Wrapper.sv		                            //
//	Description:	CPU_Wrapper for Master of AXI                	//
// 	Date:			2024/10/18								   		//
// 	Version:		1.0	    								   		//
//////////////////////////////////////////////////////////////////////
module CPU_wrapper(

    input ACLK,
    input ARESETn,
    //-------------------------------------//
    //      Port: MASTER <-> AXI BUS       //
    //-------------------------------------//
// AXI Master1 Write Address Channel (DM)
    output logic [`AXI_ID_BITS-1:0]     AWID_M1,
    output logic [`AXI_ADDR_BITS-1:0]   AWADDR_M1,
    output logic [`AXI_LEN_BITS-1:0]    AWLEN_M1,
    output logic [`AXI_SIZE_BITS-1:0]   AWSIZE_M1,
    output logic [1:0]                  AWBURST_M1,
    output logic                        AWVALID_M1,
    input                               AWREADY_M1,
        
// AXI Master1 Write Data Channel (DM)
    output logic [`AXI_DATA_BITS-1:0]   WDATA_M1,
    output logic [`AXI_STRB_BITS-1:0]   WSTRB_M1,
    output logic                        WLAST_M1,
    output logic                        WVALID_M1,
    input                               WREADY_M1,
        
// AXI Master1 Write Response Channel (DM)
    input [`AXI_ID_BITS-1:0]            BID_M1,
    input [1:0]                         BRESP_M1,
    input                               BVALID_M1,
    output logic                        BREADY_M1,

// AXI Master1 Read Address Channel (DM)
    output logic [`AXI_ID_BITS-1:0]     ARID_M1,
    output logic [`AXI_ADDR_BITS-1:0]   ARADDR_M1,
    output logic [`AXI_LEN_BITS-1:0]    ARLEN_M1,
    output logic [`AXI_SIZE_BITS-1:0]   ARSIZE_M1,
    output logic [1:0]                  ARBURST_M1,
    output logic                        ARVALID_M1,
    input                               ARREADY_M1,
        
// AXI Master1 Read Data Channel (DM)
    input [`AXI_ID_BITS-1:0]            RID_M1,
    input [`AXI_DATA_BITS-1:0]          RDATA_M1,
    input [1:0]                         RRESP_M1,
    input                               RLAST_M1,
    input                               RVALID_M1,
    output logic                        RREADY_M1,

// AXI Master0 Read Address Channel (IM)
    output logic [`AXI_ID_BITS-1:0]     ARID_M0,
    output logic [`AXI_ADDR_BITS-1:0]   ARADDR_M0,
    output logic [`AXI_LEN_BITS-1:0]    ARLEN_M0,
    output logic [`AXI_SIZE_BITS-1:0]   ARSIZE_M0,
    output logic [1:0]                  ARBURST_M0,
    output logic                        ARVALID_M0,
    input                               ARREADY_M0,
        
// AXI Master0 Read Data Channel (IM)
    input [`AXI_ID_BITS-1:0]            RID_M0,
    input [`AXI_DATA_BITS-1:0]          RDATA_M0,
    input [1:0]                         RRESP_M0,
    input                               RLAST_M0,
    input                               RVALID_M0,
    output logic                        RREADY_M0

);


endmodule