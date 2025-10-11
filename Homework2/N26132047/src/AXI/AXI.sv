//////////////////////////////////////////////////////////////////////
//          ██╗       ██████╗   ██╗  ██╗    ██████╗            		//
//          ██║       ██╔══█║   ██║  ██║    ██╔══█║            		//
//          ██║       ██████║   ███████║    ██████║            		//
//          ██║       ██╔═══╝   ██╔══██║    ██╔═══╝            		//
//          ███████╗  ██║  	    ██║  ██║    ██║  	           		//
//          ╚══════╝  ╚═╝  	    ╚═╝  ╚═╝    ╚═╝  	           		//
//                                                             		//
// 	2025 Advanced VLSI System Design, advisor: Lih-Yih, Chiou		//
//                                                             		//
//////////////////////////////////////////////////////////////////////
//                                                             		//
// 	Autor: 			YU-YANG, WANG        				  	   		//
//	Filename:		AXI.sv			                            	//
//	Description:	Top module of AXI	 							//
// 	Version:		1.0	    								   		//
//////////////////////////////////////////////////////////////////////
`include "AXI_define.svh"

module AXI (

    input ACLK,
    input ARESETn,

// SLAVE INTERFACE FOR MASTERS
// AW channel: WRITE ADDRESS 1
    input        [`AXI_ID_BITS  -1:0]  AWID_M1,
    input        [`AXI_ADDR_BITS-1:0]  AWADDR_M1,
    input        [`AXI_LEN_BITS -1:0]  AWLEN_M1,
    input        [`AXI_SIZE_BITS-1:0]  AWSIZE_M1,
    input        [1:0]                 AWBURST_M1,
    input                              AWVALID_M1,
    output logic                       AWREADY_M1,
    
// W channel: WRITE DATA 1
    input        [`AXI_DATA_BITS-1:0]  WDATA_M1,
    input        [`AXI_STRB_BITS-1:0]  WSTRB_M1,
    input                              WLAST_M1,
    input                              WVALID_M1,
    output logic                       WREADY_M1,
                           
//  B channel: WRITE RESPONSE 1
    output logic [`AXI_ID_BITS-1:0]    BID_M1,
    output logic [1:0]                 BRESP_M1,
    output logic                       BVALID_M1,
    input                              BREADY_M1,

// AR channel: READ ADDRESS 0
    input        [`AXI_ID_BITS  -1:0]  ARID_M0,
    input        [`AXI_ADDR_BITS-1:0]  ARADDR_M0,
    input        [`AXI_LEN_BITS -1:0]  ARLEN_M0,
    input        [`AXI_SIZE_BITS-1:0]  ARSIZE_M0,
    input        [1:0]                 ARBURST_M0,
    input                              ARVALID_M0,
    output logic                       ARREADY_M0,
    
//  R channel: READ DATA 0
    output logic [`AXI_ID_BITS  -1:0]  RID_M0,
    output logic [`AXI_DATA_BITS-1:0]  RDATA_M0,
    output logic [1:0]                 RRESP_M0,
    output logic                       RLAST_M0,
    output logic                       RVALID_M0,
    input                              RREADY_M0,
    
// AR channel: READ ADDRESS 1
    input        [`AXI_ID_BITS  -1:0]  ARID_M1,
    input        [`AXI_ADDR_BITS-1:0]  ARADDR_M1,
    input        [`AXI_LEN_BITS -1:0]  ARLEN_M1,
    input        [`AXI_SIZE_BITS-1:0]  ARSIZE_M1,
    input        [1:0]                 ARBURST_M1,
    input                              ARVALID_M1,
    output logic                       ARREADY_M1,
    
//  R channel: READ DATA 1
    output logic [`AXI_ID_BITS  -1:0]  RID_M1,
    output logic [`AXI_DATA_BITS-1:0]  RDATA_M1,
    output logic [1:0]                 RRESP_M1,
    output logic                       RLAST_M1,
    output logic                       RVALID_M1,
    input                              RREADY_M1,

// MASTER INTERFACE FOR SLAVES
// AW channel: WRITE ADDRESS 0
    output logic [`AXI_IDS_BITS -1:0]  AWID_S0,
    output logic [`AXI_ADDR_BITS-1:0]  AWADDR_S0,
    output logic [`AXI_LEN_BITS -1:0]  AWLEN_S0,
    output logic [`AXI_SIZE_BITS-1:0]  AWSIZE_S0,
    output logic [1:0]                 AWBURST_S0,
    output logic                       AWVALID_S0,
    input                              AWREADY_S0,
    
// W xhannel: WRITE DATA 0
    output logic [`AXI_DATA_BITS-1:0]  WDATA_S0,
    output logic [`AXI_STRB_BITS-1:0]  WSTRB_S0,
    output logic                       WLAST_S0,
    output logic                       WVALID_S0,
    input                              WREADY_S0,
    
// B channel: WRITE RESPONSE 0
    input        [`AXI_IDS_BITS-1:0]   BID_S0,
    input        [1:0]                 BRESP_S0,
    input                              BVALID_S0,
    output logic                       BREADY_S0,
    
// AW channel: WRITE ADDRESS 1
    output logic [`AXI_IDS_BITS -1:0]  AWID_S1,
    output logic [`AXI_ADDR_BITS-1:0]  AWADDR_S1,
    output logic [`AXI_LEN_BITS -1:0]  AWLEN_S1,
    output logic [`AXI_SIZE_BITS-1:0]  AWSIZE_S1,
    output logic [1:0]                 AWBURST_S1,
    output logic                       AWVALID_S1,
    input                              AWREADY_S1,
    
// W channel: WRITE DATA 1
    output logic [`AXI_DATA_BITS-1:0]  WDATA_S1,
    output logic [`AXI_STRB_BITS-1:0]  WSTRB_S1,
    output logic                       WLAST_S1,
    output logic                       WVALID_S1,
    input                              WREADY_S1,
    
// B channel: WRITE RESPONSE 1
    input        [`AXI_IDS_BITS-1:0]   BID_S1,
    input        [1:0]                 BRESP_S1,
    input                              BVALID_S1,
    output logic                       BREADY_S1,
    
// AR channel: READ ADDRESS 0
    output logic [`AXI_IDS_BITS -1:0]  ARID_S0,
    output logic [`AXI_ADDR_BITS-1:0]  ARADDR_S0,
    output logic [`AXI_LEN_BITS -1:0]  ARLEN_S0,
    output logic [`AXI_SIZE_BITS-1:0]  ARSIZE_S0,
    output logic [1:0]                 ARBURST_S0,
    output logic                       ARVALID_S0,
    input                              ARREADY_S0,
    
//  R channel: READ DATA 0
    input        [`AXI_IDS_BITS -1:0]  RID_S0,
    input        [`AXI_DATA_BITS-1:0]  RDATA_S0,
    input        [1:0]                 RRESP_S0,
    input                              RLAST_S0,
    input                              RVALID_S0,
    output logic                       RREADY_S0,
    
// AR channel: READ ADDRESS 1
    output logic  [`AXI_IDS_BITS -1:0] ARID_S1,
    output logic  [`AXI_ADDR_BITS-1:0] ARADDR_S1,
    output logic  [`AXI_LEN_BITS -1:0] ARLEN_S1,
    output logic  [`AXI_SIZE_BITS-1:0] ARSIZE_S1,
    output logic  [1:0]                ARBURST_S1,
    output logic                       ARVALID_S1,
    input                              ARREADY_S1,
    
//  R channel: READ DATA 1
    input         [`AXI_IDS_BITS -1:0] RID_S1,
    input         [`AXI_DATA_BITS-1:0] RDATA_S1,
    input         [1:0]                RRESP_S1,
    input                              RLAST_S1,
    input                              RVALID_S1,
    output logic                       RREADY_S1
    
);

    typedef enum logic {
        READ, WRITE
    } TYPE_t;

    typedef struct packed {
        logic     busy;              // if the slave is busy
        TYPE_t    transaction_type;  // when slave busy : reading or writing
        MASTER_ID current_master;    // who use the slave
    } SLAVE_STATUS_t;

    SLAVE_ID decoded_AR_M0, decoded_AR_M1, decoded_AW_M1;  // slave target by master (S0 S1 DEFAULT_SLAVE)

    logic          request_valid_s0   , request_valid_s1   ; // If any master want to use slave
    TYPE_t         request_type_s0    , request_type_s1    ; // Request is read or write
    MASTER_ID      request_master_s0  , request_master_s1  ; // Which master want to use slave
    logic          transaction_done_s0, transaction_done_s1; // 

    MASTER_ID      master_priority_c, master_priority_n;

    SLAVE_STATUS_t slave_status_c_s0, slave_status_c_s1;
    SLAVE_STATUS_t slave_status_n_s0, slave_status_n_s1;

    // --------------------------------------------
    //                Address Decode               
    // --------------------------------------------

    // decoder for master 0 (read only)
    always_comb begin
        decoded_AR_M0 = DEFAULT_SLAVE;
        if (ARVALID_M0) begin
            if      (ARADDR_M0 >= `S0_start_addr && ARADDR_M0 <= `S0_end_addr) decoded_AR_M0 = S0;
            else if (ARADDR_M0 >= `S1_start_addr && ARADDR_M0 <= `S1_end_addr) decoded_AR_M0 = S1;
        end
    end

    // decoder for master 1 (read & write)
    always_comb begin
        decoded_AR_M1 = DEFAULT_SLAVE;
        decoded_AW_M1 = DEFAULT_SLAVE;
        if (ARVALID_M1) begin
            if      (ARADDR_M1 >= `S0_start_addr && ARADDR_M1 <= `S0_end_addr) decoded_AR_M1 = S0;
            else if (ARADDR_M1 >= `S1_start_addr && ARADDR_M1 <= `S1_end_addr) decoded_AR_M1 = S1;
        end
        if (AWVALID_M1) begin
            if      (AWADDR_M1 >= `S0_start_addr && AWADDR_M1 <= `S0_end_addr) decoded_AW_M1 = S0;
            else if (AWADDR_M1 >= `S1_start_addr && AWADDR_M1 <= `S1_end_addr) decoded_AW_M1 = S1;
        end
    end

    // --------------------------------------------
    //               Arbitration Logic             
    // --------------------------------------------

    // FSM state register
    always_ff @(posedge ACLK or negedge ARESETn) begin
        if (!ARESETn) begin
            master_priority_c <= M0;
            slave_status_c_s0 <= SLAVE_STATUS_t'(0);
            slave_status_c_s1 <= SLAVE_STATUS_t'(0);
        end else begin
            master_priority_c <= master_priority_n;
            slave_status_c_s0 <= slave_status_n_s0;
            slave_status_c_s1 <= slave_status_n_s1;
        end
    end

    // Master status
    always_comb begin
        request_valid_s0 = 1'b0; request_type_s0 = READ; request_master_s0 = M0;
        request_valid_s1 = 1'b0; request_type_s1 = READ; request_master_s1 = M0;

        // set up request?
        /*
        if (ARVALID_M0) begin
            case (decoded_AR_M0)
                S0: begin request_valid_s0 = 1'b1; request_type_s0 = READ; request_master_s0 = M0; end
                S1: begin request_valid_s1 = 1'b1; request_type_s1 = READ; request_master_s1 = M0; end
            endcase
        end
        if (ARVALID_M1) begin
            case (decoded_AR_M1)
                S0: begin request_valid_s0 = 1'b1; request_type_s0 = READ; request_master_s0 = M1; end
                S1: begin request_valid_s1 = 1'b1; request_type_s1 = READ; request_master_s1 = M1; end
            endcase
        end
        if (AWVALID_M1) begin
            case (decoded_AW_M1)
                S0: begin request_valid_s0 = 1'b1; request_type_s0 = WRITE; request_master_s0 = M1; end
                S1: begin request_valid_s1 = 1'b1; request_type_s1 = WRITE; request_master_s1 = M1; end
            endcase
        end*/

        // check the highest priority can get the request
        if (master_priority_c == M0) begin
            if (ARVALID_M0) begin
                case (decoded_AR_M0)
                    S0: begin request_valid_s0 = 1'b1; request_type_s0 = READ; request_master_s0 = M0; end
                    S1: begin request_valid_s1 = 1'b1; request_type_s1 = READ; request_master_s1 = M0; end
                endcase
            end
        end else if (master_priority_c == M1) begin
            if (ARVALID_M1) begin
                case (decoded_AR_M1)
                    S0: begin request_valid_s0 = 1'b1; request_type_s0 = READ; request_master_s0 = M1; end
                    S1: begin request_valid_s1 = 1'b1; request_type_s1 = READ; request_master_s1 = M1; end
                endcase
            end
            if (AWVALID_M1) begin
                case (decoded_AW_M1)
                    S0: begin request_valid_s0 = 1'b1; request_type_s0 = WRITE; request_master_s0 = M1; end
                    S1: begin request_valid_s1 = 1'b1; request_type_s1 = WRITE; request_master_s1 = M1; end
                endcase
            end
        end

        // update proirity
        master_priority_n = (master_priority_c == M0) ? M1 : M0;
    end

    // Slave status
    always_comb begin
        // default
        slave_status_n_s0 = slave_status_c_s1;
        slave_status_n_s1 = slave_status_c_s1;

        // finish transaction when slave R handshake or B handshake
        transaction_done_s0 = (RVALID_S0 & RREADY_S0 & RLAST_S0) | (BVALID_S0 & BREADY_S0);
        transaction_done_s1 = (RVALID_S1 & RREADY_S1 & RLAST_S1) | (BVALID_S1 & BREADY_S1);

        // reset busy to idle if finish transcation
        if (slave_status_c_s0.busy & transaction_done_s0) begin
            slave_status_c_s0.busy = 1'b0;
            // remain busy if next request is still the same master and same type
            if (request_valid_s0 & 
                request_master_s0 == slave_status_c_s0.current_master &
                request_type_s0 == slave_status_c_s0.transaction_type) begin
                slave_status_c_s0.busy = 1'b1;        
            end
        end
        
        if (slave_status_c_s1.busy & transaction_done_s1) begin
            slave_status_c_s1.busy = 1'b0;
            // remain busy if next request is still the same master and same type
        end

        // Next state logic for Slave
        if (!slave_status_c_s0.busy & request_valid_s0) begin
            slave_status_n_s0.busy             = 1'b1;
            slave_status_n_s0.transaction_type = request_type_s0;
            slave_status_n_s0.current_master   = request_master_s0;
        end
        if (!slave_status_c_s1.busy & request_valid_s1) begin
            slave_status_n_s1.busy             = 1'b1;
            slave_status_n_s1.transaction_type = request_type_s1;
            slave_status_n_s1.current_master   = request_master_s1;
        end
    end

    //------------------------------------------------
    // 3. Crossbar MUX
    //------------------------------------------------
    always_comb begin
        // default master output to CPU
        ARREADY_M0 = 1'b0;
        RRESP_M0   = `AXI_RESP_OKAY;
        {RID_M0, RDATA_M0, RLAST_M0, RVALID_M0} = '0;

        ARREADY_M1 = 1'b0;
        RRESP_M1   = `AXI_RESP_OKAY;
        {RID_M1, RDATA_M1, RLAST_M1, RVALID_M1} = '0;

        BRESP_M1   = `AXI_RESP_OKAY;
        {AWREADY_M1, WREADY_M1, BID_M1, BVALID_M1} = '0; 

        // default slave output to Memory
        ARLEN_S0   = `AXI_LEN_ONE;
        ARSIZE_S0  = `AXI_SIZE_WORD;
        ARBURST_S0 = `AXI_BURST_INC;
        {ARID_S0, ARADDR_S0, ARVALID_S0, RREADY_S0} = '0;

        AWLEN_S0   = `AXI_LEN_ONE;
        AWSIZE_S0  = `AXI_SIZE_WORD;
        AWBURST_S0 = `AXI_BURST_INC;
        {AWID_S0, AWADDR_S0, AWVALID_S0} = '0;
        WSTRB_S0   = `AXI_STRB_WORD;
        {WDATA_S0, WLAST_S0, WVALID_S0, BREADY_S0} = '0; 

        ARLEN_S1   = `AXI_LEN_ONE;
        ARSIZE_S1  = `AXI_SIZE_WORD;
        ARBURST_S1 = `AXI_BURST_INC;
        {ARID_S1, ARADDR_S1, ARVALID_S1, RREADY_S1} = '0; 

        AWLEN_S1   = `AXI_LEN_ONE;
        AWSIZE_S1  = `AXI_SIZE_WORD;
        AWBURST_S1 = `AXI_BURST_INC;
        {AWID_S1, AWADDR_S1, AWVALID_S1} = '0; 
        WSTRB_S1  = `AXI_STRB_WORD;
        {WDATA_S1, WLAST_S1, WVALID_S1, BREADY_S1} = '0; // S1: W, B

        if (slave_status_c_s0.busy) begin
            case (slave_status_c_s0.transaction_type)
                READ: begin
                    case (slave_status_c_s0.current_master)
                        M0: begin // M0 - S0
                            // AR channel
                            ARVALID_S0 = ARVALID_M0;
                            ARREADY_M0 = ARREADY_S0; 
                            ARID_S0    = {4'b0, ARID_M0};
                            ARADDR_S0  = ARADDR_M0 ;
                            ARLEN_S0   = ARLEN_M0  ;
                            ARSIZE_S0  = ARSIZE_M0 ;
                            ARBURST_S0 = ARBURST_M0;
                            // R channel
                            RVALID_M0  = RVALID_S0;
                            RREADY_S0  = RREADY_M0;
                            RID_M0     = RID_S0[`AXI_ID_BITS-1:0];
                            RDATA_M0   = RDATA_S0 ;
                            RRESP_M0   = RRESP_S0 ;
                            RLAST_M0   = RLAST_S0 ;
                        end
                        M1: begin // M1 - S0
                            // AR channel
                            ARVALID_S0 = ARVALID_M1;
                            ARREADY_M1 = ARREADY_S0; 
                            ARID_S0    = {4'b0, ARID_M1};
                            ARADDR_S0  = ARADDR_M1 ;
                            ARLEN_S0   = ARLEN_M1  ;
                            ARSIZE_S0  = ARSIZE_M1 ;
                            ARBURST_S0 = ARBURST_M1;
                            // R channel
                            RVALID_M1  = RVALID_S0;
                            RREADY_S0  = RREADY_M1;
                            RID_M1     = RID_S0[`AXI_ID_BITS-1:0];
                            RDATA_M1   = RDATA_S0 ;
                            RRESP_M1   = RRESP_S0 ;
                            RLAST_M1   = RLAST_S0 ;
                        end 
                    endcase
                end 
                WRITE: begin // M1 - S0
                    if (slave_status_c_s0.current_master == M1) begin
                        // AW channel
                        AWVALID_S0 = AWVALID_M1;
                        AWREADY_M1 = AWREADY_S0;
                        AWID_S0    = {4'b0, AWID_M1};
                        AWADDR_S0  = AWADDR_M1 ;
                        AWLEN_S0   = AWLEN_M1  ;
                        AWSIZE_S0  = AWSIZE_M1 ;
                        AWBURST_S0 = AWBURST_M1;
                        // W channel
                        WVALID_S0  = WVALID_M1;
                        WREADY_M1  = WREADY_S0;
                        WDATA_S0   = WDATA_M1 ;
                        WSTRB_S0   = WSTRB_M1 ;
                        WLAST_S0   = WLAST_M1 ;
                        // B channel
                        BVALID_M1  = BVALID_S0;
                        BREADY_S0  = BREADY_M1;
                        BID_M1     = BID_S0[`AXI_ID_BITS-1:0];
                        BRESP_M1   = BRESP_S0 ;
                    end
                end 
            endcase
        end

        if (slave_status_c_s1.busy) begin
            case (slave_status_c_s1.transaction_type)
                READ: begin
                    case (slave_status_c_s1.current_master)
                        M0: begin // M0 - S1
                            // AR channel
                            ARVALID_S1 = ARVALID_M0;
                            ARREADY_M0 = ARREADY_S1; 
                            ARID_S1    = {4'b0, ARID_M0};
                            ARADDR_S1  = ARADDR_M0 ;
                            ARLEN_S1   = ARLEN_M0  ;
                            ARSIZE_S1  = ARSIZE_M0 ;
                            ARBURST_S1 = ARBURST_M0;
                            // R channel
                            RVALID_M0  = RVALID_S1;
                            RREADY_S1  = RREADY_M0;
                            RID_M0     = RID_S1[`AXI_ID_BITS-1:0];
                            RDATA_M0   = RDATA_S1 ;
                            RRESP_M0   = RRESP_S1 ;
                            RLAST_M0   = RLAST_S1 ;
                        end
                        M1: begin // M1 - S1
                            // AR channel
                            ARVALID_S1 = ARVALID_M1;
                            ARREADY_M1 = ARREADY_S1; 
                            ARID_S1    = {4'b0, ARID_M1};
                            ARADDR_S1  = ARADDR_M1 ;
                            ARLEN_S1   = ARLEN_M1  ;
                            ARSIZE_S1  = ARSIZE_M1 ;
                            ARBURST_S1 = ARBURST_M1;
                            // R channel
                            RVALID_M1  = RVALID_S1;
                            RREADY_S1  = RREADY_M1;
                            RID_M1     = RID_S1[`AXI_ID_BITS-1:0];
                            RDATA_M1   = RDATA_S1 ;
                            RRESP_M1   = RRESP_S1 ;
                            RLAST_M1   = RLAST_S1 ;
                        end 
                    endcase
                end 
                WRITE: begin // M1 - S1
                    if (slave_status_c_s1.current_master == M1) begin
                        // AW channel
                        AWVALID_S1 = AWVALID_M1;
                        AWREADY_M1 = AWREADY_S1;
                        AWID_S1    = {4'b0, AWID_M1};
                        AWADDR_S1  = AWADDR_M1 ;
                        AWLEN_S1   = AWLEN_M1  ;
                        AWSIZE_S1  = AWSIZE_M1 ;
                        AWBURST_S1 = AWBURST_M1;
                        // W channel
                        WVALID_S1  = WVALID_M1;
                        WREADY_M1  = WREADY_S1;
                        WDATA_S1   = WDATA_M1 ;
                        WSTRB_S1   = WSTRB_M1 ;
                        WLAST_S1   = WLAST_M1 ;
                        // B channel
                        BVALID_M1  = BVALID_S1;
                        BREADY_S1  = BREADY_M1;
                        BID_M1     = BID_S1[`AXI_ID_BITS-1:0];
                        BRESP_M1   = BRESP_S1 ;
                    end
                end 
            endcase
        end

    end

    
endmodule
