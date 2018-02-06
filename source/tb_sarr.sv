// $Id: $
// File name:   tb_sarr.sv
// Created:     3/30/2017
// Author:      John Student
// Lab Section: 03
// Version:     1.0  Initial Design Entry
// Description: Checking the sarr
`timescale 1ns / 100ps
module tb_sarr();
	localparam CLK_PERIOD = 20;
	reg tb_clk;
	always
	begin
		tb_clk = 1'b0;
		#(CLK_PERIOD/2);
		tb_clk = 1'b1;
		#(CLK_PERIOD/2);
	end

	reg [7:0] tb_waddr_i;
	reg [7:0] tb_wdata_i;
	reg [7:0] tb_raddr_i;
	reg tb_swap_i;
	reg tb_renable_i;
	reg tb_wenable_i;
	reg [7:0] tb_rdata_o;


	sarr DUT_SARR (.clk(tb_clk),.waddr_i(tb_waddr_i),.wdata_i(tb_wdata_i),.swap_i(tb_swap_i),.wenable_i(tb_wenable_i),.renable_i(tb_renable_i),.raddr_i(tb_raddr_i),.rdata_o(tb_rdata_o));

	reg [8:0] tb_init;
initial
begin
	@(negedge tb_clk);
	//tb_reset = 1;
	tb_wenable_i = 0;
	tb_renable_i = 0;
	tb_swap_i = 0;
	tb_wdata_i = 0;
	tb_raddr_i = 0;
	@(negedge tb_clk);
        //tb_reset = 0;
	for( tb_init = 0; tb_init < 256 ;  tb_init++)
        begin
		tb_wenable_i = 1;
		tb_waddr_i = tb_init;
		tb_wdata_i = tb_init;
		@(negedge tb_clk);
	end
	@(negedge tb_clk);
	tb_wenable_i = 0;
	@(negedge tb_clk);
	//FIRST READING ONE VALUE
	tb_renable_i = 1;
	tb_raddr_i = 222;
	$info ("Readiging 222");
	@(negedge tb_clk);
	//READING SECOND VALUE
	tb_renable_i = 1;
	tb_raddr_i = 22;
	$info ("Readiging 22");
	@(negedge tb_clk);
	//SWAPPING 254 and 252
	tb_swap_i = 1;
	tb_renable_i = 0;
	tb_raddr_i = 254;
	tb_waddr_i = 252;
	$info ("Swapping 254 and 252");
	@(negedge tb_clk);
	//READGING 254
	tb_swap_i = 0;
	tb_renable_i = 1;
	tb_raddr_i = 254;
	$info ("Reading 254");
	@(negedge tb_clk);
	//READING 252
	tb_raddr_i = 252;
	$info("READING 252");
	@(negedge tb_clk);
	//DISABLE READING 
	tb_renable_i = 0;
	tb_raddr_i = 222;
	$info("DOING NOTHING");
	@(negedge tb_clk);
	tb_wenable_i = 1;
	tb_waddr_i = 255;
	tb_wdata_i = 0;
	$info("WRITING on location 255 value of 0");
	@(negedge tb_clk);
	tb_waddr_i = 252;
	tb_wdata_i = 69;
	$info("WRITING on location 252 value of 69");
	@(negedge tb_clk);
	tb_wenable_i = 0;
	tb_renable_i = 1;
	tb_raddr_i = 252;
	$info("DOUBLE Checking the location of 252 was written as 69");
	@(negedge tb_clk);
	tb_renable_i = 0;
end
endmodule
