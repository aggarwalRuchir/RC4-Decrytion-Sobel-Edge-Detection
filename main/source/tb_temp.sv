// $Id: $
// File name:   tb_temp.sv
// Created:     4/11/2017
// Author:      John Student
// Lab Section: 03
// Version:     1.0  Initial Design Entry
// Description: .
`timescale 1ns / 100ps
module tb_temp();
	localparam CLK_PERIOD = 20;
	reg tb_clk;
	always
	begin
		tb_clk = 1'b0;
		#(CLK_PERIOD/2);
		tb_clk = 1'b1;
		#(CLK_PERIOD/2);
	end

	
	reg [7:0] tb_rdata_i;
	reg tb_store_temp_i;
	reg [7:0] tb_temp_o;

	temp DUT (.clk(tb_clk),.rdata_i(tb_rdata_i),.store_temp_i(tb_store_temp_i),.temp_o(tb_temp_o));
	initial
	begin
	tb_store_temp_i = 1;
	tb_rdata_i = 44;
	@(negedge tb_clk);
	tb_store_temp_i = 0;
	tb_rdata_i = 70;
	@(negedge tb_clk);
	tb_store_temp_i = 1;
	tb_rdata_i = 90;
	@(negedge tb_clk);
	tb_store_temp_i = 0;
	tb_rdata_i = 90;
	@(negedge tb_clk);
	tb_store_temp_i = 0;
	tb_rdata_i = 100;
	@(negedge tb_clk);
	tb_store_temp_i = 1;
	tb_rdata_i = 23;
	@(negedge tb_clk);
	tb_store_temp_i = 0;
	tb_rdata_i = 70;
	end
endmodule
