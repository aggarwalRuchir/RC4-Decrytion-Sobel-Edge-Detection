// $Id: $
// File name:   tb_outputToXor.sv
// Created:     4/11/2017
// Author:      John Student
// Lab Section: 03
// Version:     1.0  Initial Design Entry
// Description: ;.
`timescale 1ns / 100ps
module tb_outputToXor();
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
	reg tb_end_i;
	reg [7:0] tb_outputToXor_o;

	outputToXor DUT (.clk(tb_clk),.rdata_i(tb_rdata_i),.end_i(tb_end_i),.outputToXor_o(tb_outputToXor_o));
	initial
	begin
	tb_end_i = 1;
	tb_rdata_i = 44;
	@(negedge tb_clk);
	tb_end_i = 0;
	tb_rdata_i = 70;
	@(negedge tb_clk);
	tb_end_i = 1;
	tb_rdata_i = 90;
	@(negedge tb_clk);
	tb_end_i = 0;
	tb_rdata_i = 90;
	@(negedge tb_clk);
	tb_end_i = 0;
	tb_rdata_i = 100;
	@(negedge tb_clk);
	tb_end_i = 1;
	tb_rdata_i = 23;
	@(negedge tb_clk);
	tb_end_i = 0;
	tb_rdata_i = 70;
	end
endmodule