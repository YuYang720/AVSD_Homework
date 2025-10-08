`timescale 1ns/10ps
`include "./AXI/AXI.sv"
`include "../include/AXI_define.svh"
`include "CPU_wrapper.sv"
`include "SRAM_wrapper.sv"
`include "Defines.sv"

module top(
    input logic clk,
    input logic rst
);

    //AXI wire
    //SLAVE INTERFACE FOR MASTERS
    //WRITE ADDRESS M0_w
    logic [`AXI_ID_BITS  -1:0] AWID_M0_w      ;
    logic [`AXI_ADDR_BITS-1:0] AWADDR_M0_w    ;
    logic [`AXI_LEN_BITS -1:0] AWLEN_M0_w     ;
    logic [`AXI_SIZE_BITS-1:0] AWSIZE_M0_w    ;
    logic [1:0]                AWBURST_M0_w   ;
    logic                      AWVALID_M0_w   ;
    logic                      AWREADY_M0_w   ;

    //WRITE DATA M0_w
    logic [`AXI_DATA_BITS-1:0] WDATA_M0_w     ;
    logic [`AXI_STRB_BITS-1:0] WSTRB_M0_w     ;
    logic                      WLAST_M0_w     ;
    logic                      WVALID_M0_w    ;
    logic                      WREADY_M0_w    ;

    //WRITE RESPONSE M0_w
    logic [`AXI_ID_BITS  -1:0] BID_M0_w       ;
    logic [1:0]                BRESP_M0_w     ;
    logic                      BVALID_M0_w    ;
    logic                      BREADY_M0_w    ;

    //READ ADDRESS M0_w
    logic [`AXI_ID_BITS  -1:0] ARID_M0_w      ;
    logic [`AXI_ADDR_BITS-1:0] ARADDR_M0_w    ;
    logic [`AXI_LEN_BITS -1:0] ARLEN_M0_w     ;
    logic [`AXI_SIZE_BITS-1:0] ARSIZE_M0_w    ;
    logic [1:0]                ARBURST_M0_w   ;
    logic                      ARVALID_M0_w   ;
    logic                      ARREADY_M0_w   ;

    //READ DATA M0_w
    logic [`AXI_ID_BITS  -1:0] RID_M0_w       ;
    logic [`AXI_DATA_BITS-1:0] RDATA_M0_w     ;
    logic [1:0]                RRESP_M0_w     ;
    logic                      RLAST_M0_w     ;
    logic                      RVALID_M0_w    ;
    logic                      RREADY_M0_w    ;

    //WRITE ADDRESS M1_w
    logic [`AXI_ID_BITS  -1:0] AWID_M1_w      ;
    logic [`AXI_ADDR_BITS-1:0] AWADDR_M1_w    ;
    logic [`AXI_LEN_BITS -1:0] AWLEN_M1_w     ;
    logic [`AXI_SIZE_BITS-1:0] AWSIZE_M1_w    ;
    logic [1:0]                AWBURST_M1_w   ;
    logic                      AWVALID_M1_w   ;
    logic                      AWREADY_M1_w   ;

    //WRITE DATA M1_w
    logic [`AXI_DATA_BITS-1:0] WDATA_M1_w     ;
    logic [`AXI_STRB_BITS-1:0] WSTRB_M1_w     ;
    logic                      WLAST_M1_w     ;
    logic                      WVALID_M1_w    ;
    logic                      WREADY_M1_w    ;

    //WRITE RESPONSE M1_w
    logic [`AXI_ID_BITS  -1:0] BID_M1_w       ;
    logic [1:0]                BRESP_M1_w     ;
    logic                      BVALID_M1_w    ;
    logic                      BREADY_M1_w    ;

    //READ ADDRESS M1_w
    logic [`AXI_ID_BITS  -1:0] ARID_M1_w      ;
    logic [`AXI_ADDR_BITS-1:0] ARADDR_M1_w    ;
    logic [`AXI_LEN_BITS -1:0] ARLEN_M1_w     ;
    logic [`AXI_SIZE_BITS-1:0] ARSIZE_M1_w    ;
    logic [1:0]                ARBURST_M1_w   ;
    logic                      ARVALID_M1_w   ;
    logic                      ARREADY_M1_w   ;

    //READ DATA M1_w
    logic [`AXI_ID_BITS  -1:0] RID_M1_w       ;
    logic [`AXI_DATA_BITS-1:0] RDATA_M1_w     ;
    logic [1:0]                RRESP_M1_w     ;
    logic                      RLAST_M1_w     ;
    logic                      RVALID_M1_w    ;
    logic                      RREADY_M1_w    ;

    //MASTER INTERFACE FOR SLAVES
    //WRITE ADDRESS S0_w
    logic [`AXI_IDS_BITS -1:0] AWID_S0_w      ;
    logic [`AXI_ADDR_BITS-1:0] AWADDR_S0_w    ;
    logic [`AXI_LEN_BITS -1:0] AWLEN_S0_w     ;
    logic [`AXI_SIZE_BITS-1:0] AWSIZE_S0_w    ;
    logic [1:0]                AWBURST_S0_w   ;
    logic                      AWVALID_S0_w   ;
    logic                      AWREADY_S0_w   ;

    //WRITE DATA S0_w
    logic [`AXI_DATA_BITS-1:0] WDATA_S0_w     ;
    logic [`AXI_STRB_BITS-1:0] WSTRB_S0_w     ;
    logic                      WLAST_S0_w     ;
    logic                      WVALID_S0_w    ;
    logic                      WREADY_S0_w    ;

    //WRITE RESPONSE S0_w
    logic [`AXI_IDS_BITS -1:0] BID_S0_w       ;
    logic [1:0]                BRESP_S0_w     ;
    logic                      BVALID_S0_w    ;
    logic                      BREADY_S0_w    ;

    //READ ADDRESS S0_w
    logic [`AXI_IDS_BITS -1:0] ARID_S0_w      ;
    logic [`AXI_ADDR_BITS-1:0] ARADDR_S0_w    ;
    logic [`AXI_LEN_BITS -1:0] ARLEN_S0_w     ;
    logic [`AXI_SIZE_BITS-1:0] ARSIZE_S0_w    ;
    logic [1:0]                ARBURST_S0_w   ;
    logic                      ARVALID_S0_w   ;
    logic                      ARREADY_S0_w   ;

    //READ DATA S0_w
    logic [`AXI_IDS_BITS -1:0] RID_S0_w       ;
    logic [`AXI_DATA_BITS-1:0] RDATA_S0_w     ;
    logic [1:0]                RRESP_S0_w     ;
    logic                      RLAST_S0_w     ;
    logic                      RVALID_S0_w    ;
    logic                      RREADY_S0_w    ;

    //WRITE ADDRESS S1_w
    logic [`AXI_IDS_BITS -1:0] AWID_S1_w      ;
    logic [`AXI_ADDR_BITS-1:0] AWADDR_S1_w    ;
    logic [`AXI_LEN_BITS -1:0] AWLEN_S1_w     ;
    logic [`AXI_SIZE_BITS-1:0] AWSIZE_S1_w    ;
    logic [1:0]                AWBURST_S1_w   ;
    logic                      AWVALID_S1_w   ;
    logic                      AWREADY_S1_w   ;

    //WRITE DATA S1_w
    logic [`AXI_DATA_BITS-1:0] WDATA_S1_w     ;
    logic [`AXI_STRB_BITS-1:0] WSTRB_S1_w     ;
    logic                      WLAST_S1_w     ;
    logic                      WVALID_S1_w    ;
    logic                      WREADY_S1_w    ;

    //WRITE RESPONSE S1_w
    logic [`AXI_IDS_BITS -1:0] BID_S1_w       ;
    logic [1:0]                BRESP_S1_w     ;
    logic                      BVALID_S1_w    ;
    logic                      BREADY_S1_w    ;

    //READ ADDRESS S1_w
    logic [`AXI_IDS_BITS -1:0] ARID_S1_w      ;
    logic [`AXI_ADDR_BITS-1:0] ARADDR_S1_w    ;
    logic [`AXI_LEN_BITS -1:0] ARLEN_S1_w     ;
    logic [`AXI_SIZE_BITS-1:0] ARSIZE_S1_w    ;
    logic [1:0]                ARBURST_S1_w   ;
    logic                      ARVALID_S1_w   ;
    logic                      ARREADY_S1_w   ;

    //READ DATA S1_w
    logic [`AXI_IDS_BITS -1:0] RID_S1_w       ;
    logic [`AXI_DATA_BITS-1:0] RDATA_S1_w     ;
    logic [1:0]                RRESP_S1_w     ;
    logic                      RLAST_S1_w     ;
    logic                      RVALID_S1_w    ;
    logic                      RREADY_S1_w    ;

    AXI AXI(
        .ACLK                 (clk                ),
        .ARESETn              (~rst               ),

        // .AWID_M0              (AWID_M0_w          ),
        // .AWADDR_M0            (AWADDR_M0_w        ),
        // .AWLEN_M0             (AWLEN_M0_w         ),
        // .AWSIZE_M0            (AWSIZE_M0_w        ),
        // .AWBURST_M0           (AWBURST_M0_w       ),
        // .AWVALID_M0           (AWVALID_M0_w       ),
        // .AWREADY_M0           (AWREADY_M0_w       ),

        // .WDATA_M0             (WDATA_M0_w         ),
        // .WSTRB_M0             (WSTRB_M0_w         ),
        // .WLAST_M0             (WLAST_M0_w         ),
        // .WVALID_M0            (WVALID_M0_w        ),
        // .WREADY_M0            (WREADY_M0_w        ),

        // .BID_M0               (BID_M0_w           ),
        // .BRESP_M0             (BRESP_M0_w         ),
        // .BVALID_M0            (BVALID_M0_w        ),
        // .BREADY_M0            (BREADY_M0_w        ),

        .ARID_M0              (ARID_M0_w          ),
        .ARADDR_M0            (ARADDR_M0_w        ),
        .ARLEN_M0             (ARLEN_M0_w         ),
        .ARSIZE_M0            (ARSIZE_M0_w        ),
        .ARBURST_M0           (ARBURST_M0_w       ),
        .ARVALID_M0           (ARVALID_M0_w       ),
        .ARREADY_M0           (ARREADY_M0_w       ),

        .RID_M0               (RID_M0_w           ),
        .RDATA_M0             (RDATA_M0_w         ),
        .RRESP_M0             (RRESP_M0_w         ),
        .RLAST_M0             (RLAST_M0_w         ),
        .RVALID_M0            (RVALID_M0_w        ),
        .RREADY_M0            (RREADY_M0_w        ),

        .AWID_M1              (AWID_M1_w          ),
        .AWADDR_M1            (AWADDR_M1_w        ),
        .AWLEN_M1             (AWLEN_M1_w         ),
        .AWSIZE_M1            (AWSIZE_M1_w        ),
        .AWBURST_M1           (AWBURST_M1_w       ),
        .AWVALID_M1           (AWVALID_M1_w       ),
        .AWREADY_M1           (AWREADY_M1_w       ),

        .WDATA_M1             (WDATA_M1_w         ),
        .WSTRB_M1             (WSTRB_M1_w         ),
        .WLAST_M1             (WLAST_M1_w         ),
        .WVALID_M1            (WVALID_M1_w        ),
        .WREADY_M1            (WREADY_M1_w        ),

        .BID_M1               (BID_M1_w           ),
        .BRESP_M1             (BRESP_M1_w         ),
        .BVALID_M1            (BVALID_M1_w        ),
        .BREADY_M1            (BREADY_M1_w        ),

        .ARID_M1              (ARID_M1_w          ),
        .ARADDR_M1            (ARADDR_M1_w        ),
        .ARLEN_M1             (ARLEN_M1_w         ),
        .ARSIZE_M1            (ARSIZE_M1_w        ),
        .ARBURST_M1           (ARBURST_M1_w       ),
        .ARVALID_M1           (ARVALID_M1_w       ),
        .ARREADY_M1           (ARREADY_M1_w       ),

        .RID_M1               (RID_M1_w           ),
        .RDATA_M1             (RDATA_M1_w         ),
        .RRESP_M1             (RRESP_M1_w         ),
        .RLAST_M1             (RLAST_M1_w         ),
        .RVALID_M1            (RVALID_M1_w        ),
        .RREADY_M1            (RREADY_M1_w        ),

        .AWID_S0              (AWID_S0_w          ),
        .AWADDR_S0            (AWADDR_S0_w        ),
        .AWLEN_S0             (AWLEN_S0_w         ),
        .AWSIZE_S0            (AWSIZE_S0_w        ),
        .AWBURST_S0           (AWBURST_S0_w       ),
        .AWVALID_S0           (AWVALID_S0_w       ),
        .AWREADY_S0           (AWREADY_S0_w       ),

        .WDATA_S0             (WDATA_S0_w         ),
        .WSTRB_S0             (WSTRB_S0_w         ),
        .WLAST_S0             (WLAST_S0_w         ),
        .WVALID_S0            (WVALID_S0_w        ),
        .WREADY_S0            (WREADY_S0_w        ),

        .BID_S0               (BID_S0_w           ),
        .BRESP_S0             (BRESP_S0_w         ),
        .BVALID_S0            (BVALID_S0_w        ),
        .BREADY_S0            (BREADY_S0_w        ),

        .ARID_S0              (ARID_S0_w          ),
        .ARADDR_S0            (ARADDR_S0_w        ),
        .ARLEN_S0             (ARLEN_S0_w         ),
        .ARSIZE_S0            (ARSIZE_S0_w        ),
        .ARBURST_S0           (ARBURST_S0_w       ),
        .ARVALID_S0           (ARVALID_S0_w       ),
        .ARREADY_S0           (ARREADY_S0_w       ),

        .RID_S0               (RID_S0_w           ),
        .RDATA_S0             (RDATA_S0_w         ),
        .RRESP_S0             (RRESP_S0_w         ),
        .RLAST_S0             (RLAST_S0_w         ),
        .RVALID_S0            (RVALID_S0_w        ),
        .RREADY_S0            (RREADY_S0_w        ),

        .AWID_S1              (AWID_S1_w          ),
        .AWADDR_S1            (AWADDR_S1_w        ),
        .AWLEN_S1             (AWLEN_S1_w         ),
        .AWSIZE_S1            (AWSIZE_S1_w        ),
        .AWBURST_S1           (AWBURST_S1_w       ),
        .AWVALID_S1           (AWVALID_S1_w       ),
        .AWREADY_S1           (AWREADY_S1_w       ),

        .WDATA_S1             (WDATA_S1_w         ),
        .WSTRB_S1             (WSTRB_S1_w         ),
        .WLAST_S1             (WLAST_S1_w         ),
        .WVALID_S1            (WVALID_S1_w        ),
        .WREADY_S1            (WREADY_S1_w        ),

        .BID_S1               (BID_S1_w           ),
        .BRESP_S1             (BRESP_S1_w         ),
        .BVALID_S1            (BVALID_S1_w        ),
        .BREADY_S1            (BREADY_S1_w        ),

        .ARID_S1              (ARID_S1_w          ),
        .ARADDR_S1            (ARADDR_S1_w        ),
        .ARLEN_S1             (ARLEN_S1_w         ),
        .ARSIZE_S1            (ARSIZE_S1_w        ),
        .ARBURST_S1           (ARBURST_S1_w       ),
        .ARVALID_S1           (ARVALID_S1_w       ),
        .ARREADY_S1           (ARREADY_S1_w       ),

        .RID_S1               (RID_S1_w           ),
        .RDATA_S1             (RDATA_S1_w         ),
        .RRESP_S1             (RRESP_S1_w         ),
        .RLAST_S1             (RLAST_S1_w         ),
        .RVALID_S1            (RVALID_S1_w        ),
        .RREADY_S1            (RREADY_S1_w        )
    );

    CPU_wrapper CPU(
        .ACLK                 (clk                ),
        .ARESETn              (~rst               ),

        .AWID_M0              (AWID_M0_w          ),
        .AWADDR_M0            (AWADDR_M0_w        ),
        .AWLEN_M0             (AWLEN_M0_w         ),
        .AWSIZE_M0            (AWSIZE_M0_w        ),
        .AWBURST_M0           (AWBURST_M0_w       ),
        .AWVALID_M0           (AWVALID_M0_w       ),
        .AWREADY_M0           (AWREADY_M0_w       ),

        .WDATA_M0             (WDATA_M0_w         ),
        .WSTRB_M0             (WSTRB_M0_w         ),
        .WLAST_M0             (WLAST_M0_w         ),
        .WVALID_M0            (WVALID_M0_w        ),
        .WREADY_M0            (WREADY_M0_w        ),

        .BID_M0               (BID_M0_w           ),
        .BRESP_M0             (BRESP_M0_w         ),
        .BVALID_M0            (BVALID_M0_w        ),
        .BREADY_M0            (BREADY_M0_w        ),

        .ARID_M0              (ARID_M0_w          ),
        .ARADDR_M0            (ARADDR_M0_w        ),
        .ARLEN_M0             (ARLEN_M0_w         ),
        .ARSIZE_M0            (ARSIZE_M0_w        ),
        .ARBURST_M0           (ARBURST_M0_w       ),
        .ARVALID_M0           (ARVALID_M0_w       ),
        .ARREADY_M0           (ARREADY_M0_w       ),

        .RID_M0               (RID_M0_w           ),
        .RDATA_M0             (RDATA_M0_w         ),
        .RRESP_M0             (RRESP_M0_w         ),
        .RLAST_M0             (RLAST_M0_w         ),
        .RVALID_M0            (RVALID_M0_w        ),
        .RREADY_M0            (RREADY_M0_w        ),

        .AWID_M1              (AWID_M1_w          ),
        .AWADDR_M1            (AWADDR_M1_w        ),
        .AWLEN_M1             (AWLEN_M1_w         ),
        .AWSIZE_M1            (AWSIZE_M1_w        ),
        .AWBURST_M1           (AWBURST_M1_w       ),
        .AWVALID_M1           (AWVALID_M1_w       ),
        .AWREADY_M1           (AWREADY_M1_w       ),

        .WDATA_M1             (WDATA_M1_w         ),
        .WSTRB_M1             (WSTRB_M1_w         ),
        .WLAST_M1             (WLAST_M1_w         ),
        .WVALID_M1            (WVALID_M1_w        ),
        .WREADY_M1            (WREADY_M1_w        ),

        .BID_M1               (BID_M1_w           ),
        .BRESP_M1             (BRESP_M1_w         ),
        .BVALID_M1            (BVALID_M1_w        ),
        .BREADY_M1            (BREADY_M1_w        ),

        .ARID_M1              (ARID_M1_w          ),
        .ARADDR_M1            (ARADDR_M1_w        ),
        .ARLEN_M1             (ARLEN_M1_w         ),
        .ARSIZE_M1            (ARSIZE_M1_w        ),
        .ARBURST_M1           (ARBURST_M1_w       ),
        .ARVALID_M1           (ARVALID_M1_w       ),
        .ARREADY_M1           (ARREADY_M1_w       ),

        .RID_M1               (RID_M1_w           ),
        .RDATA_M1             (RDATA_M1_w         ),
        .RRESP_M1             (RRESP_M1_w         ),
        .RLAST_M1             (RLAST_M1_w         ),
        .RVALID_M1            (RVALID_M1_w        ),
        .RREADY_M1            (RREADY_M1_w        )
    );

    SRAM_wrapper IM1(
        .ACLK                 (clk                ),
        .ARESETn              (~rst               ),

        .AWID                 (AWID_S0_w          ),
        .AWADDR               (AWADDR_S0_w        ),
        .AWLEN                (AWLEN_S0_w         ),
        .AWSIZE               (AWSIZE_S0_w        ),
        .AWBURST              (AWBURST_S0_w       ),
        .AWVALID              (AWVALID_S0_w       ),
        .AWREADY              (AWREADY_S0_w       ),

        .WDATA                (WDATA_S0_w         ),
        .WSTRB                (WSTRB_S0_w         ),
        .WLAST                (WLAST_S0_w         ),
        .WVALID               (WVALID_S0_w        ),
        .WREADY               (WREADY_S0_w        ),

        .BID                  (BID_S0_w           ),
        .BRESP                (BRESP_S0_w         ),
        .BVALID               (BVALID_S0_w        ),
        .BREADY               (BREADY_S0_w        ),

        .ARID                 (ARID_S0_w          ),
        .ARADDR               (ARADDR_S0_w        ),
        .ARLEN                (ARLEN_S0_w         ),
        .ARSIZE               (ARSIZE_S0_w        ),
        .ARBURST              (ARBURST_S0_w       ),
        .ARVALID              (ARVALID_S0_w       ),
        .ARREADY              (ARREADY_S0_w       ),

        .RID                  (RID_S0_w           ),
        .RDATA                (RDATA_S0_w         ),
        .RRESP                (RRESP_S0_w         ),
        .RLAST                (RLAST_S0_w         ),
        .RVALID               (RVALID_S0_w        ),
        .RREADY               (RREADY_S0_w        )
    );

    SRAM_wrapper DM1(
        .ACLK                 (clk                ),
        .ARESETn              (~rst               ),

        .AWID                 (AWID_S1_w          ),
        .AWADDR               (AWADDR_S1_w        ),
        .AWLEN                (AWLEN_S1_w         ),
        .AWSIZE               (AWSIZE_S1_w        ),
        .AWBURST              (AWBURST_S1_w       ),
        .AWVALID              (AWVALID_S1_w       ),
        .AWREADY              (AWREADY_S1_w       ),

        .WDATA                (WDATA_S1_w         ),
        .WSTRB                (WSTRB_S1_w         ),
        .WLAST                (WLAST_S1_w         ),
        .WVALID               (WVALID_S1_w        ),
        .WREADY               (WREADY_S1_w        ),

        .BID                  (BID_S1_w           ),
        .BRESP                (BRESP_S1_w         ),
        .BVALID               (BVALID_S1_w        ),
        .BREADY               (BREADY_S1_w        ),

        .ARID                 (ARID_S1_w          ),
        .ARADDR               (ARADDR_S1_w        ),
        .ARLEN                (ARLEN_S1_w         ),
        .ARSIZE               (ARSIZE_S1_w        ),
        .ARBURST              (ARBURST_S1_w       ),
        .ARVALID              (ARVALID_S1_w       ),
        .ARREADY              (ARREADY_S1_w       ),

        .RID                  (RID_S1_w           ),
        .RDATA                (RDATA_S1_w         ),
        .RRESP                (RRESP_S1_w         ),
        .RLAST                (RLAST_S1_w         ),
        .RVALID               (RVALID_S1_w        ),
        .RREADY               (RREADY_S1_w        )
    );

endmodule : top
