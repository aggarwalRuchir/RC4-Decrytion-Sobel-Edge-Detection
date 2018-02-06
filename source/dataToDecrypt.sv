// $Id: $
// File name:   dataToDecrypt.sv
// Created:     4/14/2017
// Author:      John Student
// Lab Section: 03
// Version:     1.0  Initial Design Entry
// Description: .


module dataToDecrypt(
	input wire clk_i,
	input wire read_ready_i,
	input wire [31:0] rc4_data_i,
	output reg [31:0] dataToDecrypt_o
);

always_ff @(posedge clk_i)
begin
	if (read_ready_i == 1)
	begin
		dataToDecrypt_o <= rc4_data_i;
	end
	else
	begin
		dataToDecrypt_o <= dataToDecrypt_o;
	end
end
endmodule
