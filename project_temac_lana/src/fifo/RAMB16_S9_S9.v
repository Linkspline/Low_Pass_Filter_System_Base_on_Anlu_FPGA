// ===========================================================================
// Copyright (c) 2011-2020 Anlogic Inc. All Right Reserved.
//
// TEL: 86-21-61633787
// WEB: http://www.anlogic.com/
// ===========================================================================
//
//
//  
//
//
// ===========================================================================

`timescale 1ns / 1ps

module RAMB16_S9_S9 ( 
	doa, dia, addra, cea, clka, wea, rsta, 
	dob, dib, addrb, ceb, clkb, web, rstb
);

	output [8:0] doa;
	output [8:0] dob;

	input  [8:0] dia;
	input  [8:0] dib;
	input  [10:0] addra;
	input  [10:0] addrb;
	input  wea;
	input  web;
	input  cea;
	input  ceb;
	input  clka;
	input  clkb;
	input  rsta;
	input  rstb;

	PH1_LOGIC_ERAM #( .DATA_WIDTH_A(9),
				.DATA_WIDTH_B(9),
				.ADDR_WIDTH_A(11),
				.ADDR_WIDTH_B(11),
				.DATA_DEPTH_A(2048),
				.DATA_DEPTH_B(2048),
				.MODE("DP"),
				.REGMODE_A("NOREG"),
				.REGMODE_B("NOREG"),
				.WRITEMODE_A("WRITETHROUGH"),
				.WRITEMODE_B("WRITETHROUGH"),
				.IMPLEMENT("20K"),
				.ECC_ENCODE("DISABLE"),
				.ECC_DECODE("DISABLE"),
				.CLKMODE("ASYNC"),
				.SSROVERCE("DISABLE"),
				.OREGSET_A("SET"),
				.OREGSET_B("SET"),
				.RESETMODE_A("SYNC"),
				.RESETMODE_B("SYNC"),
				.ASYNC_RESET_RELEASE_A("SYNC"),
				.ASYNC_RESET_RELEASE_B("SYNC"),
				.INIT_FILE("NONE"),
				.FILL_ALL("NONE"))
			inst(
				.dia(dia),
				.dib(dib),
				.addra(addra),
				.addrb(addrb),
				.cea(cea),
				.ceb(ceb),
				.ocea(1'b0),
				.oceb(1'b0),
				.clka(clka),
				.clkb(clkb),
				.wea(wea),
				.web(web),
				.bea(1'b0),
				.beb(1'b0),
				.rsta(1'b0),
				.rstb(1'b0),
				.doa(doa),
				.ecc_sbiterr(open),
				.ecc_dbiterr(open),
				.dob(dob));


endmodule