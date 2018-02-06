// $Id: $
// File name:   outputToXor.sv
// Created:     4/11/2017
// Author:      John Student
// Lab Section: 03
// Version:     1.0  Initial Design Entry
// Description: /

module outputToXor(
	input wire clk,
	input wire [7:0] rdata_i,
	input wire end_i,
	output reg [7:0] outputToXor_o
);

//reg noutputToXor;

always_ff @(posedge clk)
begin
	if (end_i == 1)
	begin
		outputToXor_o <= rdata_i;
	end
	else
	begin
		outputToXor_o <= outputToXor_o;
	end
end
endmodule
