// $Id: $
// File name:   locSafe.sv
// Created:     4/11/2017
// Author:      John Student
// Lab Section: 03
// Version:     1.0  Initial Design Entry
// Description: .

module locSafe(
	input wire clk,
	input wire [7:0] locEnd_i,
	input wire store_loc_i,
	output reg [7:0] locSafe_o
);

//reg [7:0] nlocSafe;

always_ff @(posedge clk)
begin
	if (store_loc_i == 1)
	begin
		locSafe_o <= locEnd_i;
	end
	else
	begin
		locSafe_o <= locSafe_o;
	end
end
endmodule
