`ifndef _AXI
`define _AXI

`define AXI_ID_BITS     4
`define AXI_IDS_BITS    8
`define AXI_ADDR_BITS   32
`define AXI_LEN_BITS    4
`define AXI_SIZE_BITS   3
`define AXI_DATA_BITS   32
`define AXI_STRB_BITS   4
`define AXI_LEN_ONE     4'h0
`define AXI_SIZE_BYTE   3'b000
`define AXI_SIZE_HWORD  3'b001
`define AXI_SIZE_WORD   3'b010
`define AXI_BURST_INC   2'h1
`define AXI_STRB_WORD   4'b1111
`define AXI_STRB_HWORD  4'b0011
`define AXI_STRB_BYTE   4'b0001
`define AXI_RESP_OKAY   2'h0
`define AXI_RESP_SLVERR 2'h2
`define AXI_RESP_DECERR 2'h3

typedef enum logic {
    M0, M1
} MASTER_ID;

typedef enum logic [1:0] {
    S0, S1, DEFAULT_SLAVE
} SLAVE_ID;

`define S0_start_addr   32'h0000_0000
`define S0_end_addr     32'h0000_FFFF

`define S1_start_addr   32'h0001_0000
`define S1_end_addr     32'h0001_FFFF

`endif