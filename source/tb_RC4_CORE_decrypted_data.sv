// $Id: $
// File name:   tb_RC4_CORE_decrypted_data.sv
// Created:     4/21/2017
// Author:      John Student
// Lab Section: 03
// Version:     1.0  Initial Design Entry
// Description: .
`timescale 1ns / 100ps
module tb_RC4_CORE_decrypted_data();
	localparam CLK_PERIOD = 20;
	reg tb_clk;
	always
	begin
		tb_clk = 1'b0;
		#(CLK_PERIOD/2);
		tb_clk = 1'b1;
		#(CLK_PERIOD/2);
	end

	reg tb_enable_write_i;
	reg [1:0] tb_writeLoc_i;
	reg [7:0] tb_data_i;
	reg [31:0] tb_rc4_wdata_o;


	RC4_CORE_decrypted_data DUT (.clk(tb_clk),.enable_write_i(tb_enable_write_i),.writeLoc_i(tb_writeLoc_i),.data_i(tb_data_i),.rc4_wdata_o(tb_rc4_wdata_o));

initial
begin
	//1st
	@(negedge tb_clk);
	tb_enable_write_i = 0;
	tb_writeLoc_i = 2;
	tb_data_i = "S";
	@(negedge tb_clk);
	tb_enable_write_i = 1;
	tb_writeLoc_i = 0;
	tb_data_i = "D";
	//2nd
	@(negedge tb_clk);
	tb_enable_write_i = 0;
	tb_writeLoc_i = 2;
	tb_data_i = "S";
	@(negedge tb_clk);
	tb_enable_write_i = 1;
	tb_writeLoc_i = 1;
	tb_data_i = "i";
	//3rd
	@(negedge tb_clk);
	tb_enable_write_i = 0;
	tb_writeLoc_i = 2;
	tb_data_i = "m";
	@(negedge tb_clk);
	tb_enable_write_i = 1;
	tb_writeLoc_i = 2;
	tb_data_i = "m";
	//4th
	@(negedge tb_clk);
	tb_enable_write_i = 1;
	tb_writeLoc_i = 3;
	tb_data_i = "c";
	@(negedge tb_clk);
	tb_enable_write_i = 1;
	tb_writeLoc_i = 0;
	tb_data_i = "D";


end
endmodule
