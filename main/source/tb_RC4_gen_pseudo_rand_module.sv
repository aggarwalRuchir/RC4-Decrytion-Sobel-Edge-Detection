// $Id: $
// File name:   tb_RC4_gen_pseudo_rand_module.sv
// Created:     4/12/2017
// Author:      John Student
// Lab Section: 03
// Version:     1.0  Initial Design Entry
// Description: .
`timescale 1ns / 100ps
module tb_RC4_gen_pseudo_rand_module();
	localparam CLK_PERIOD = 35;
	reg tb_clk;
	always
	begin
		tb_clk = 1'b0;
		#(CLK_PERIOD/2);
		tb_clk = 1'b1;
		#(CLK_PERIOD/2);
	end

	reg tb_n_rst;
	reg tb_genStateArr_i;
	reg tb_genVal_i;
	reg [31:0] tb_rc4_key_i;
	reg [7:0] tb_outputToXor_o;
	reg tb_sarrGenerated_o;
	reg tb_valReady_o;

	RC4_gen_pseudo_rand_module DUT (.clk(tb_clk),.n_rst(tb_n_rst),.genStateArr_i(tb_genStateArr_i),.genVal_i(tb_genVal_i),
					.rc4_key_i_(tb_rc4_key_i),.outputToXor_o(tb_outputToXor_o),.sarrGenerated_o_(tb_sarrGenerated_o),.valReady_o_(tb_valReady_o));

	logic flag = 0;
initial
begin
	tb_n_rst = 0;
	tb_genStateArr_i = 0;
	tb_genVal_i = 0;
	tb_rc4_key_i = "DR.J";
	tb_outputToXor_o = 0;
	tb_sarrGenerated_o = 0;
	tb_valReady_o = 0;
	@(negedge tb_clk);
	tb_n_rst = 1;
	@(negedge tb_clk);
	tb_genStateArr_i = 1;
	@(negedge tb_clk);
	#(CLK_PERIOD);
	flag = 1;
	#(CLK_PERIOD);
	flag = 0;
//	while(tb_sarrGenerated_o == 0)
//	begin
//		if (tb_sarrGenerated_o == 1)
//		begin
//		@(negedge tb_clk);
//		flag = 1;
//	end]
	tb_genVal_i = 1;
	if (flag == 1)
	begin
		@(negedge tb_clk);
		@(negedge tb_clk);
		@(negedge tb_clk);
		@(negedge tb_clk);
		@(negedge tb_clk);
		@(negedge tb_clk);
		@(negedge tb_clk);
		@(negedge tb_clk);
		tb_genVal_i = 1;
		flag = 0;
	end
	else
	begin
		tb_genVal_i = 1;
	end
end
endmodule
