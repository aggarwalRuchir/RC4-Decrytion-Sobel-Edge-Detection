// $Id: $
// File name:   tb_counterI.sv
// Created:     4/13/2017
// Author:      John Student
// Lab Section: 03
// Version:     1.0  Initial Design Entry
// Description: .
`timescale 1ns / 100ps
module tb_counterI();
	localparam CLK_PERIOD = 20;
	reg tb_clk;
	always
	begin
		tb_clk = 1'b0;
		#(CLK_PERIOD/2);
		tb_clk = 1'b1;
		#(CLK_PERIOD/2);
	end

	reg tb_n_rst;
	reg tb_clear;
	reg tb_count_enable;
	reg tb_rollover_flag;
	reg [7:0] tb_count_out;
		
	counterI DUT 
			(.clk(tb_clk),.n_rst(tb_n_rst),.clear(tb_clear),.count_enable(tb_count_enable),
			   .rollover_val(8'b11111111),.count_out(tb_count_out),.rollover_flag(tb_rollover_flag));

	initial
	begin
	tb_n_rst = 0;
	tb_clear = 0;
	tb_count_enable = 0;
	@(negedge tb_clk);
	tb_n_rst = 1;
	tb_clear = 0;
	tb_count_enable = 0;
	@(negedge tb_clk);
	tb_n_rst = 1;
	tb_clear = 0;
	tb_count_enable = 1;
	@(negedge tb_clk);
	tb_n_rst = 1;
	tb_clear = 0;
	tb_count_enable = 1;
	@(negedge tb_clk);
	tb_n_rst = 1;
	tb_clear = 0;
	tb_count_enable = 1;
	@(negedge tb_clk);
	tb_n_rst = 1;
	tb_clear = 1;
	tb_count_enable = 0;
	@(negedge tb_clk);
	tb_n_rst = 1;
	tb_clear = 0;
	tb_count_enable = 1;
	end
endmodule
