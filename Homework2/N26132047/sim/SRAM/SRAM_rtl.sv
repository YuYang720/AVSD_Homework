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
// 	Autor: 			TZUNG-JIN, TSAI (Leo)				  	   		//
//	Filename:		SRAM_rtl.sv                               		//
//	Description:	RTL model of 									//
//					TS1N16ADFPCLLLVTA512X45M4SWSHOD SRAM macro  	//
//					no timing information included, unsynthesizable	//
// 	Date:			2024/09/28								   		//
// 	Version:		1.0	    								   		//
//////////////////////////////////////////////////////////////////////
module TS1N16ADFPCLLLVTA512X45M4SWSHOD (
	SLP,
    DSLP,
    SD,
    PUDELAY,
    CLK, CEB, WEB,
    A, D,
    BWEB,
    RTSEL,
    WTSEL,
    Q);
	
	parameter Words 	= 16384;
	parameter Bits 		= 8;
	parameter Bytes	    = 4;
	parameter numRow = 512;
	parameter numCM = 32;	
	
	//=== IO Ports ===//

	// Normal Mode Input
	input SLP;
	input DSLP;
	input SD;
	input CLK;
	input CEB;
	input WEB;
	input [13:0] A;
	input [31:0] D;
	input [31:0] BWEB;


	// Data Output
	output logic [31:0] Q;
	output PUDELAY;


	// Test Mode
	input [1:0] RTSEL;
	input [1:0] WTSEL;
	
	
	logic	[Bytes*Bits-1:0] 	MEMORY [numRow][numCM];
	logic						WEB0, WEB1, WEB2, WEB3;
	logic   [Bytes*Bits-1:0]    latched_DO;   
	
	assign WEB0 = |BWEB[0*Bits+:Bits];
	assign WEB1 = |BWEB[1*Bits+:Bits];
	assign WEB2 = |BWEB[2*Bits+:Bits];
	assign WEB3 = |BWEB[3*Bits+:Bits];
	
	assign PUDELAY = 1'b0;
	
	
	always @(posedge CLK)
	begin
		if (~WEB0)
		begin
			MEMORY[A/32][A%32][0*Bits+:Bits] = D[0*Bits+:Bits];
			latched_DO[0*Bits+:Bits] <= D[0*Bits+:Bits];
		end
		else
		begin
			latched_DO[0*Bits+:Bits] <= MEMORY[A/32][A%32][0*Bits+:Bits];
		end
		if (~WEB1)
		begin
			MEMORY[A/32][A%32][1*Bits+:Bits] = D[1*Bits+:Bits];
			latched_DO[1*Bits+:Bits] <= D[1*Bits+:Bits];
		end
		else
		begin
			latched_DO[1*Bits+:Bits] <= MEMORY[A/32][A%32][1*Bits+:Bits];
		end
		if (~WEB2)
		begin
			MEMORY[A/32][A%32][2*Bits+:Bits] = D[2*Bits+:Bits];
			latched_DO[2*Bits+:Bits] <= D[2*Bits+:Bits];
		end
		else
		begin
			latched_DO[2*Bits+:Bits] <= MEMORY[A/32][A%32][2*Bits+:Bits];
		end
		if (~WEB3)
		begin
			MEMORY[A/32][A%32][3*Bits+:Bits] = D[3*Bits+:Bits];
			latched_DO[3*Bits+:Bits] <= D[3*Bits+:Bits];
		end
		else
		begin
			latched_DO[3*Bits+:Bits] <= MEMORY[A/32][A%32][3*Bits+:Bits];
		end
	end
	
	always_comb
	begin
		Q = latched_DO;
	end
	
endmodule
