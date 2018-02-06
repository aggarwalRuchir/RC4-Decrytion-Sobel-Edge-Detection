// $Id: $
// File name:   tb_dataToDecrypt.sv
// Created:     4/21/2017
// Author:      John Student
// Lab Section: 03
// Version:     1.0  Initial Design Entry
// Description: .
`timescale 1ns / 100ps
module tb_dataToDecrypt();
	localparam CLK_PERIOD = 35;
	reg tb_clk;
	always
	begin
		tb_clk = 1'b0;
		#(CLK_PERIOD/2);
		tb_clk = 1'b1;
		#(CLK_PERIOD/2);
	end

	
	reg tb_read_ready_i;
	reg [31:0] tb_rc4_data_i;
	reg [31:0] tb_dataToDecrypt_o;


	dataToDecrypt DUT (.clk_i(tb_clk),.read_ready_i(tb_read_ready_i),.rc4_data_i(tb_rc4_data_i),.dataToDecrypt_o(tb_dataToDecrypt_o));

initial
begin
tb_read_ready_i = 0;
tb_rc4_data_i = 44;
@(negedge tb_clk);
tb_read_ready_i = 1;
tb_rc4_data_i = 213231;
@(negedge tb_clk);
tb_read_ready_i = 1;
tb_rc4_data_i = 6969;
@(negedge tb_clk);
tb_read_ready_i = 0;
tb_rc4_data_i = 69;
end

endmodule
