// $Id: $
// File name:   temp.sv
// Created:     4/11/2017
// Author:      John Student
// Lab Section: 03
// Version:     1.0  Initial Design Entry
// Description: .

module temp(
	input wire clk,
	input wire [7:0] rdata_i,
	input wire store_temp_i,
	output reg [7:0] temp_o
);

//reg [7:0] ntemp;

always_ff @(posedge clk)
begin
	if (store_temp_i == 1)
	begin
		temp_o <= rdata_i;
	end
	else
	begin
		temp_o <= temp_o;
	end
end
endmodule
