//////////////////////////////////////////////////////////////////////
//          ██╗       ██████╗   ██╗  ██╗    ██████╗            		//
//          ██║       ██╔══█║   ██║  ██║    ██╔══█║            		//
//          ██║       ██████║   ███████║    ██████║            		//
//          ██║       ██╔═══╝   ██╔══██║    ██╔═══╝            		//
//          ███████╗  ██║  	    ██║  ██║    ██║  	           		//
//          ╚══════╝  ╚═╝  	    ╚═╝  ╚═╝    ╚═╝  	           		//
//                                                             		//
// 	2025 Advanced VLSI System Design, Advisor: Lih-Yih, Chiou		//
//                                                             		//
//////////////////////////////////////////////////////////////////////
//                                                             		//
// 	Author: 		                           				  	    //
//	Filename:		top.sv		                                    //
//	Description:	top module for AVSD HW1                     	//
// 	Date:			2025/XX/XX								   		//
// 	Version:		1.0	    								   		//
//////////////////////////////////////////////////////////////////////

`include "CPU.sv"
`include "SRAM_wrapper.sv"

module top (
    input clk,
    input rst // system reset (active high)
);

    // --------------------------//
    //   Instance Your CPU Here  //
    // --------------------------//

    // Instruction Memory
    logic [13:0] im_addr;
    logic [31:0] im_dout;

    // Data Memory
    logic        dm_ceb; // chip enable (active low)
    logic        dm_w_en; // read: active high /  write: active low
    logic [31:0] dm_bweb; // bit write enable (active low)
    logic [13:0] dm_addr;
    logic [31:0] dm_din, dm_dout;

    // CPU instance
    CPU cpu (
        .clk     (clk),
        .rst     (rst),

        // Instruction Memory
        .im_addr (im_addr),
        .im_dout (im_dout),

        // Data Memory
        .dm_ceb  (dm_ceb),
        .dm_w_en (dm_w_en),
        .dm_bweb (dm_bweb),
        .dm_addr (dm_addr),
        .dm_din  (dm_din),
        .dm_dout (dm_dout)
    );


    SRAM_wrapper IM1(
        .CLK   (clk),
        .RST   (rst),
        .CEB   (1'b0),
        .WEB   (1'b1),
        .BWEB  (32'hFFFFFFFF),
        .A     (im_addr),
        .DI    (32'b0),
        .DO    (im_dout)
    );

    SRAM_wrapper DM1(
        .CLK  (clk),
        .RST  (rst),
        .CEB  (dm_ceb),
        .WEB  (dm_w_en),
        .BWEB (dm_bweb),
        .A    (dm_addr),
        .DI   (dm_din),
        .DO   (dm_dout)
    );

endmodule