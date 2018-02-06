// $Id: $
// File name:   RC4_CORE_decrypted_data.sv
// Created:     4/14/2017
// Author:      John Student
// Lab Section: 03
// Version:     1.0  Initial Design Entry
// Description: .
module RC4_CORE_decrypted_data(
	input wire clk,
	input wire enable_write_i,
	input wire [1:0] writeLoc_i,
	input wire [7:0] data_i,
	output reg [31:0] rc4_wdata_o
);




always_ff @ (posedge clk)
begin
	if (enable_write_i == 1)
	begin
		if ( writeLoc_i == 0)
		begin
			rc4_wdata_o[31:24] = data_i;
		end
		else if ( writeLoc_i == 1)
		begin
			rc4_wdata_o[23:16] = data_i;
		end
		else if ( writeLoc_i == 2)
		begin
			rc4_wdata_o[15:8] = data_i;
		end
		else
		begin
			rc4_wdata_o[7:0] = data_i;
		end
	end
end
endmodule
