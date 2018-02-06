// $Id: $
// File name:   RC4_Core_comb.sv
// Created:     4/14/2017
// Author:      John Student
// Lab Section: 03
// Version:     1.0  Initial Design Entry
// Description: .

module RC4_Core_comb(
	input wire [7:0] outputToXor_i,
	input wire [19:0] couterPixel_i,
	input wire ready_to_write_i,
	input wire ready_to_read_i,
	input wire xor_sig_i,
	input wire one_byte_dec_i,//useless
	input wire [31:0] dataToDecrypt_i,
	output reg enable_write_o,
	output reg [1:0] writeLoc_o,
	output reg [7:0] data_o,
	output reg [19:0] rc4_pix_num_o
);

always_comb
begin
	writeLoc_o = 0;
	data_o = 0;
	if (xor_sig_i == 1)
	begin
		if ( couterPixel_i % 4 == 0)
		begin
			data_o = ( outputToXor_i ^ dataToDecrypt_i[31:24]);
			writeLoc_o = 0;
		end
		else if ( couterPixel_i % 4 == 1)
		begin
			data_o = ( outputToXor_i ^ dataToDecrypt_i[23:16]);
			writeLoc_o = 1;
		end
		else if ( couterPixel_i % 4 == 2)
		begin
			data_o = ( outputToXor_i ^ dataToDecrypt_i[15:8]);
			writeLoc_o = 2;
		end
		else
		begin
			data_o = ( outputToXor_i ^ dataToDecrypt_i[7:0]);
			writeLoc_o = 3;
		end
		enable_write_o = 1;
	end
	else
	begin
		enable_write_o = 0; 
	end

	if ( ready_to_write_i == 1 )
	begin
		rc4_pix_num_o = couterPixel_i - 4;
	end

	else if ( ready_to_read_i == 1 )
	begin
		rc4_pix_num_o = couterPixel_i;
	end
	
	else
	begin
		rc4_pix_num_o = couterPixel_i;
	end


end
endmodule
