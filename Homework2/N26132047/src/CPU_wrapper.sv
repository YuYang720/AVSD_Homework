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
// 	Autor: 			YU-YANG, WANG			               	   		//
//	Filename:		CPU_Wrapper.sv		                            //
//	Description:	CPU_Wrapper for Master of AXI                	//
// 	Date:			2024/10/18								   		//
// 	Version:		1.0	    								   		//
//////////////////////////////////////////////////////////////////////
`include "AXI_define.svh"
`include "CPU.sv"

module CPU_wrapper(

    input ACLK,
    input ARESETn,
    //-------------------------------------//
    //      Port: MASTER <-> AXI BUS       //
    //-------------------------------------//
// AXI Master1 Write Address Channel (DM)
    output logic [`AXI_ID_BITS  -1:0] AWID_M1,
    output logic [`AXI_ADDR_BITS-1:0] AWADDR_M1,
    output logic [`AXI_LEN_BITS -1:0] AWLEN_M1,
    output logic [`AXI_SIZE_BITS-1:0] AWSIZE_M1,
    output logic [1:0]                AWBURST_M1,
    output logic                      AWVALID_M1,
    input                             AWREADY_M1,
    
// AXI Master1 Write Data Channel (DM)
    output logic [`AXI_DATA_BITS-1:0] WDATA_M1,
    output logic [`AXI_STRB_BITS-1:0] WSTRB_M1,
    output logic                      WLAST_M1,
    output logic                      WVALID_M1,
    input                             WREADY_M1,
        
// AXI Master1 Write RESPOND Channel (DM)
    input        [`AXI_ID_BITS-1:0]   BID_M1,
    input        [1:0]                BRESP_M1,
    input                             BVALID_M1,
    output logic                      BREADY_M1,

// AXI Master1 Read Address Channel (DM)
    output logic [`AXI_ID_BITS  -1:0] ARID_M1,
    output logic [`AXI_ADDR_BITS-1:0] ARADDR_M1,
    output logic [`AXI_LEN_BITS -1:0] ARLEN_M1,
    output logic [`AXI_SIZE_BITS-1:0] ARSIZE_M1,
    output logic [1:0]                ARBURST_M1,
    output logic                      ARVALID_M1,
    input                             ARREADY_M1,

// AXI Master1 Read Data Channel (DM)
    input        [`AXI_ID_BITS  -1:0] RID_M1,
    input        [`AXI_DATA_BITS-1:0] RDATA_M1,
    input        [1:0]                RRESP_M1,
    input                             RLAST_M1,
    input                             RVALID_M1,
    output logic                      RREADY_M1,

// AXI Master0 Read Address Channel (IM)
    output logic [`AXI_ID_BITS  -1:0] ARID_M0,
    output logic [`AXI_ADDR_BITS-1:0] ARADDR_M0,
    output logic [`AXI_LEN_BITS -1:0] ARLEN_M0,
    output logic [`AXI_SIZE_BITS-1:0] ARSIZE_M0,
    output logic [1:0]                ARBURST_M0,
    output logic                      ARVALID_M0,
    input                             ARREADY_M0,
        
// AXI Master0 Read Data Channel (IM)
    input        [`AXI_ID_BITS  -1:0] RID_M0,
    input        [`AXI_DATA_BITS-1:0] RDATA_M0,
    input        [1:0]                RRESP_M0,
    input                             RLAST_M0,
    input                             RVALID_M0,
    output logic                      RREADY_M0

);
// --------------------------------------------
//              Signal Declaration             
// --------------------------------------------
    // master FSM
    typedef enum logic [2:0] {
        IDLE, AR_CHAN, R_CHAN, AW_CHAN, W_CHAN, B_CHAN
    } AXI_STATE_t;

    // request_buffer
    typedef struct packed {
        logic        valid;
        logic [31:0] addr;
        logic [31:0] data;
        logic [ 3:0] strb;
    } REQUEST_t;

    // FSM
    AXI_STATE_t I_state_c, I_state_n;
    AXI_STATE_t D_state_c, D_state_n;

    // request buffer
    REQUEST_t   I_request_c, I_request_n;
    REQUEST_t   D_request_c, D_request_n;

// Master 0 <-> Slave 0 (IM)
    // from CPU
    logic        im_request;
    logic [31:0] im_pc;
    // to CPU 
    logic [31:0] im_addr; // pc
    logic        im_wait; 
    logic [31:0] im_dout;  // inst

// Master 1 <-> Slave 1 (DM)
    // from CPU
    logic        dm_request;
    logic [ 3:0] dm_bit_write;
    logic [31:0] dm_addr;
    logic [31:0] dm_din;
    // to CPU
    logic        dm_wait;
    logic [31:0] dm_dout;

    CPU cpu (
        .clk     (ACLK),
        .rst     (~ARESETn),

        // Instruction Memory
        .im_request_o (im_request),
        .im_pc_o      (im_pc),
        .im_wait_i    (im_wait),
        .im_addr_i    (im_addr),
        .im_dout_i    (im_dout),

        // Data Memory
        .dm_request_o   (dm_request),
        .dm_bit_write_o (dm_bit_write),
        .dm_wait_i      (dm_wait),
        .dm_addr_o      (dm_addr),
        .dm_din_o       (dm_din),
        .dm_dout_i      (dm_dout)
    );

// --------------------------------------------
//    Master0: Instruction Fetch (Read Only)   
// --------------------------------------------
    always_ff @(posedge ACLK or negedge ARESETn) begin
        if (!ARESETn) begin
            I_state_c   <= IDLE;
            I_request_c <= REQUEST_t'(0);
        end else begin
            I_state_c   <= I_state_n;
            I_request_c <= I_request_n;
        end
    end

    always_comb begin
        ARID_M0    = '0;
        ARADDR_M0  = '0;
        ARLEN_M0   = '0;
        ARSIZE_M0  = `AXI_SIZE_WORD;
        ARBURST_M0 = `AXI_BURST_INC;
        ARVALID_M0 = '0;
        RREADY_M0  = '0;

        im_addr = 32'b0;
        im_wait = 1'b1; 
        im_dout  = I_request_c.data;

        I_request_n = I_request_c;
        I_state_n   = I_state_c;
        case (I_state_c)
            IDLE: begin
                im_wait = 1'b0;
                if (im_request) begin
                    I_state_n = AR_CHAN;
                    I_request_n = {1'b1, im_pc, 32'b0, 4'b0};

                    ARVALID_M0 = 1'b1;
                    ARADDR_M0 = I_request_n.addr;

                    if (ARREADY_M0) I_state_n = R_CHAN;
                end
            end
            AR_CHAN: begin
                ARVALID_M0 = 1'b1;
                ARADDR_M0  = I_request_c.addr;
                if (ARREADY_M0) begin
                    I_state_n = R_CHAN;
                end
            end
            R_CHAN: begin
                RREADY_M0 = 1'b1;

                if (RVALID_M0) begin
                    im_dout = RDATA_M0;

                    if (RLAST_M0) begin
                        // im_wait = 1'b0;
                        I_state_n = IDLE;
                        I_request_n.valid = 1'b0;
                        I_request_n.data  = RDATA_M0;
                    end
                end
            end
            default: I_state_n = IDLE;
        endcase
    end


// --------------------------------------------
//    Master1: Load & store (Read & Write)   
// --------------------------------------------

    always_ff @(posedge ACLK or negedge ARESETn) begin
        if (!ARESETn) begin
            D_state_c   <= IDLE;
            D_request_c <= REQUEST_t'(0);
        end else begin
            D_state_c   <= D_state_n;
            D_request_c <= D_request_n;
        end
    end

    always_comb begin
        ARID_M1    = '0;
        ARADDR_M1  = '0;
        ARLEN_M1   = '0;
        ARSIZE_M1  = `AXI_SIZE_WORD;
        ARBURST_M1 = `AXI_BURST_INC;
        ARVALID_M1 = '0;
        RREADY_M1  = '0;

        AWID_M1    = '0;
        AWADDR_M1  = '0;
        AWLEN_M1   = '0;
        AWSIZE_M1  = `AXI_SIZE_WORD;
        AWBURST_M1 = `AXI_BURST_INC;
        AWVALID_M1 = '0;
        WDATA_M1   = '0;
        WSTRB_M1   = '0;
        WLAST_M1   = '0;
        WVALID_M1  = '0;
        BREADY_M1  = '0;

        dm_wait  = 1'b1;
        dm_dout  = D_request_c.data;

        D_request_n = D_request_c;
        D_state_n   = D_state_c;
        case (D_state_c)
            IDLE: begin
                dm_wait = 1'b0;
                if (dm_request & ~|dm_bit_write) begin // load
                    D_state_n = AR_CHAN;
                    D_request_n = {1'b1, dm_addr, dm_din, dm_bit_write};

                    ARVALID_M1 = 1'b1;
                    ARADDR_M1  = D_request_n.addr;

                    if (ARREADY_M1) D_state_n = R_CHAN;

                end else if (dm_request) begin // store
                    D_state_n = AW_CHAN;
                    D_request_n = {1'b1, dm_addr, dm_din, dm_bit_write};

                    AWVALID_M1 = 1'b1;
                    AWADDR_M1  = D_request_n.addr;

                    if (AWREADY_M1) begin 
                        D_state_n = W_CHAN;

                        WLAST_M1   = 1'b1;
                        WVALID_M1  = 1'b1;
                        WDATA_M1   = D_request_n.data;
                        WSTRB_M1   = D_request_n.strb;

                        if (WREADY_M1) D_state_n = B_CHAN;
                    end
                end
            end
            AR_CHAN: begin
                ARVALID_M1 = 1'b1; 
                ARADDR_M1  = D_request_c.addr;
                if (ARREADY_M1) begin
                    D_state_n = R_CHAN;
                end
            end
            R_CHAN: begin
                RREADY_M1 = 1'b1;

                if (RVALID_M1) begin
                    dm_dout = RDATA_M1;

                    if (RLAST_M1) begin
                        // dm_wait = 1'b0;
                        D_state_n = IDLE;
                        D_request_n.valid = 1'b0;
                        D_request_n.data  = RDATA_M1;
                    end
                end
            end
            AW_CHAN: begin
                AWVALID_M1 = 1'b1;
                AWADDR_M1  = D_request_c.addr;
                
                if (AWREADY_M1) begin
                    D_state_n = W_CHAN;

                    WLAST_M1   = 1'b1;
                    WVALID_M1  = 1'b1;
                    WDATA_M1   = D_request_c.data;
                    WSTRB_M1   = D_request_c.strb;

                    if (WREADY_M1) D_state_n = B_CHAN; 
                end
            end
            W_CHAN: begin
                WVALID_M1 = 1'b1;
                WLAST_M1  = 1'b1;
                WDATA_M1  = D_request_c.data;
                WSTRB_M1  = D_request_c.strb;
            
                if (WREADY_M1) D_state_n = B_CHAN; 
            end
            B_CHAN: begin
                BREADY_M1 = 1'b1;
                if (BVALID_M1) begin
                    D_state_n = IDLE;
                    D_request_n.valid = 1'b0;
                    dm_wait  = 1'b0;
                end
            end
            default: D_state_n = IDLE; 
        endcase
    end

endmodule