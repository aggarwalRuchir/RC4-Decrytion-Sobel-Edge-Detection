// $Id: $
// File name:   tb_sids.sv
// Created:     4/29/2017
// Author:      Ruchir Aggarwal
// Lab Section: 337-03
// Version:     1.0  Initial Design Entry
// Description: Test bench for sample image data storage

module tb_sample_image_data_storage();

		localparam CLK_PERIOD	= 20ns;	
		reg tb_clk;
		reg tb_n_rst;

		reg tb_SI_dfb;
		reg [31:0] tb_SI_rdata;
		reg [19:0] tb_ED_rpixnum;
		reg tb_fill_buff;
		reg tb_buff_filled;
		reg [95:0] tb_ED_rdata;
		reg [19:0] tb_SI_rpixNum;
		reg [1:0] tb_SI_mode;

	// Clock gen block
		always
		begin : CLK_GEN
			tb_clk = 1'b0;
			#(CLK_PERIOD / 2.0);
			tb_clk = 1'b1;
			#(CLK_PERIOD / 2.0);
		end


/*/////////////////////////////////////////////////////////////////////////////////////
//			Tasks related to File IO				     //
*//////////////////////////////////////////////////////////////////////////////////////
	
	parameter	INPUT1_FILENAME		= "./images/encrypted_fruits.bmp";		//Input file name which is encrypted
	parameter	INT1_FILENAME		= "./docs/decrypted_fruits.bmp";		//File where we write the decrypted Data
	parameter	RESULT1_FILENAME	= "./docs/edge_detected_fruits.bmp";		//File where we write the Edge-Detected Data
	
	parameter	INPUT2_FILENAME		= "./images/encrypted_girl.bmp";		//Input file name which is encrypted
	parameter	INT2_FILENAME		= "./docs/decrypted_girl.bmp";			//File where we write the decrypted Data
	parameter	RESULT2_FILENAME	= "./docs/edge_detected_girl.bmp";		//File where we write the Edge-Detected Data
	
	parameter	INPUT3_FILENAME		= "./images/Marked_enc.bmp";		//Input file name which is encrypted
	parameter	INT3_FILENAME		= "./docs/decrypted_marked.bmp";		//File where we write the decrypted Data
	parameter	RESULT3_FILENAME	= "./docs/edge_detected_marked.bmp";		//File where we write the Edge-Detected Data

	// Define file IO offset constants
	localparam SEEK_START		= 0;
	localparam SEEK_CUR		= 1;
	localparam SEEK_END		= 2;
	
	// Bitmap file based parameters
	localparam BMP_HEADER_SIZE_BYTES	= 14;						// The length of the BMP file header field in Bytes
	localparam PIXEL_ARR_PTR_ADDR		= BMP_HEADER_SIZE_BYTES - 4;			// calculates the pointer to the start of the image
	localparam DIB_HEADER_C1_SIZE		= 40; 						// The length of the expected BITMAPINFOHEADER DIB header
	localparam DIB_HEADER_C2_SIZE		= 12; 						// The length of the expected BITMAPCOREHEADER DIB header
	localparam NO_COMPRESSION 		= 0;						// The compression mode value should be 0 if no compression is used (normal case)

	// Define local constants
	localparam NUM_VAL_BITS		= 16;							// Number of bits per pixel
	localparam MAX_VAL_BIT		= NUM_VAL_BITS - 1;
	localparam CHECK_DELAY		= 1ns;							// Clock delay for chicking a condition within the test bench

	// Declare Image Processing Test Bench Variables
	integer r;										// Loop variable for working with rows of pixels
	integer c;										// Loop variable for working with pixels in a row
	reg [7:0] tmp_byte;									// temp variable for read/writing bytes from/to files
	integer in_file;									// Input file handle
	integer res_file;									// Result file handle
	string  curr_res_filename;								// File pointer for hte purpose of file IO
	integer num_rows;									// The number of rows of pixels in the image file
	integer num_cols;									// The number of pixels pwer row in the image file
	integer num_pad_bytes;									// The number of padding bytes at the end of each row
	reg [7:0] in_pixel_val;									// The raw bytes read from the input file
	reg [7:0] res_pixel_val;								// The averaged values for the result file
	integer i;										// Loop variable for misc. for loops
	integer quiet_catch; 									// Just used to remove warnings about not capturing the value of the file function returns
	integer count;
	integer testCase;
	
	// The bitmap file header is 14 Bytes
	reg [(BMP_HEADER_SIZE_BYTES - 1):0][7:0] in_bmp_file_header;
	reg [(BMP_HEADER_SIZE_BYTES - 1):0][7:0] res_bmp_file_header;
	reg [31:0] in_image_data_ptr;								// The starting byte address of the pixel array in the input file
	reg [31:0] res_image_data_ptr;								// The starting byte address of the pixel array in the result file
	
	// The normal/supported DIB header is 40 Bytes
	reg [(DIB_HEADER_C1_SIZE - 1):0][7:0] dib_header;
	reg [31:0] dib_header_size;								// The dib header size is a 32-bit unsigned integer
	reg [31:0] image_width;									// The image width (pixels) is a 32-bit signed integer
	reg [31:0] image_height;								// The image height (pixels) is a 32-bit signed integer
	reg [15:0] num_pixel_bits;								// The number of pixels per bit (1, 4, 8, 16, 24, 32) is an unsigned integer
	reg [31:0] compression_mode;								// The type of compression used (this test bench doesn't support compression)
	
	// Buffers to simuate S-RAM
	reg [7:0] tb_input_image_RC4 [][];							// Array to store encrypted image read from file
	reg [7:0] tb_input_image_ED [][]; 							// Array to store correctly read data fro, decrpyted image for edge-detection
	reg [7:0] tb_output_image_RC4 [][];							// Array to store correctly decrypted data
	reg [7:0] tb_output_image_ED [][];							// Array to store correctly edge-dectedted data

	integer row,col;									// To keep a track of which row is reading and
	reg [3:0][7:0] buffer;									// Buffer of 4 since a read/write instruction involves 4-bytes at one time from S-RAM
	reg [95:0] input_buffer;	

	// Pixel array stuff
	integer row_size_bytes;									// Used to store the calculated row size for the pixel array
	

	sample_image_data_storage DUT_BUFF(
		.clk(tb_clk),
		.n_rst(tb_n_rst),
		.image_width(image_width),
		.SI_dfb(tb_SI_dfb),
		.SI_rdata(tb_SI_rdata),
		.ED_rpixNum(tb_ED_rpixnum),
		.fill_buff(tb_fill_buff),
		.buff_filled(tb_buff_filled),
		.ED_rdata(tb_ED_rdata),
		.SI_rpixNum(tb_SI_rpixNum),
		.SI_mode(tb_SI_mode)
	);

	//////////////////////////////////////////////////////////////////
	//Task for sending/handling a buffer to Edge-Detection module	//
	//////////////////////////////////////////////////////////////////
	task send_buffer_ED;
	begin
		// Synchronize to a negative clock edge to avoid metastability
		@(negedge tb_clk);
		//tb_HREADY = 1;	
	

		// Start sending the new sample value
		row = tb_SI_rpixNum / image_width;				// Update row for correct read
		col = tb_SI_rpixNum % image_width;				// Update column for correct read
		buffer[0] = tb_input_image_ED[row][col];		// Read the first byte from SRAM	
		buffer[1] = tb_input_image_ED[row][col + 1];		// Read the second byte from SRAM	
		buffer[2] = tb_input_image_ED[row][col + 2];		// Read the third byte from SRAM	
		buffer[3] = tb_input_image_ED[row][col + 3];		// Read the fourth byte from SRAM	
		
	end
	endtask
	
	//////////////////////////////////////////////////////////////////
	//Task for extracting the input file's header info		//
	//////////////////////////////////////////////////////////////////
	task read_input_header;
		input string filename;
	begin
		$display("########################################");
		$display("ImageFile : %s",filename);
		$display("########################################");
			
		// Open the input file
		in_file = $fopen(filename, "rb");
		
		// Read in the Bitmap file header information (data is stored in little-endian (LSB first) format)
		for(i = 0; i < BMP_HEADER_SIZE_BYTES; i = i + 1) 						// Read the data in LSB format
		begin
			// Read a byte at a time
			quiet_catch = $fscanf(in_file,"%c" , in_bmp_file_header[i]);
		end
		
		// Extract the pixel array pointer (contains the file byte offset of the first byte of the pixel array)
		in_image_data_ptr[31:0] = in_bmp_file_header[(BMP_HEADER_SIZE_BYTES - 1):PIXEL_ARR_PTR_ADDR]; 	// The pixel array pointer is a 4 byte unsigned integer at the end of the header
		
		// Read in the DIB header information (LSB format)
		quiet_catch = $fscanf(in_file,"%c" , dib_header[0]);
		quiet_catch = $fscanf(in_file,"%c" , dib_header[1]);
		quiet_catch = $fscanf(in_file,"%c" , dib_header[2]);
		quiet_catch = $fscanf(in_file,"%c" , dib_header[3]);
		dib_header_size = dib_header[3:0];
		if(DIB_HEADER_C1_SIZE == dib_header_size)
		begin
			$display("Input bitmap file uses the BITMAPINFOHEADER type of DIB header");
			for(i = 4; i < dib_header_size; i = i + 1) // Read data in LSB format
			begin
				// Read a byte at a time
				quiet_catch = $fscanf(in_file,"%c" , dib_header[i]);
			end
			
			// Exract useful values from the header
			image_width		= dib_header[7:4];	// image width is bytes 4-7
			image_height		= dib_header[11:8];	// image height is bytes 8-11
			num_pixel_bits		= dib_header[15:14];	// number of bits per pixel is bytes 14 & 15
			compression_mode	= dib_header[19:16];	// compression mode is bytes 16-19
			
			
			$info("%d %d %d %d %d", image_width , image_height, num_pixel_bits, dib_header[35:32], in_file);

			if(16'd8 != num_pixel_bits)
				$fatal("This input file is using a pixel size (%0d)that is not supported, only 24bpp is supported", num_pixel_bits);
			
			if(NO_COMPRESSION != compression_mode)
				$fatal("This input file is using compression, this is not supported by this test bench");
		end
		else if(DIB_HEADER_C2_SIZE == dib_header_size)
		begin
			$display("Input bitmap file uses the BITMAPCOREHEADER  type of DIB header");
			for(i = 4; i < dib_header_size; i = i + 1) // Read data in LSB format
			begin
				// Read a byte at a time
				quiet_catch = $fscanf(in_file,"%c" , dib_header[i]);
			end
			
			// Exract useful values from the header
			image_width			= {16'd0,dib_header[5:4]};	// image width is bytes 4 & 5
			image_height			= {16'd0,dib_header[7:6]};	// image height is bytes 6 & 7
			num_pixel_bits			= dib_header[11:10];		// number of bits per pixel is bytes 10 & 11
			
			if(16'd8 != num_pixel_bits)
				$fatal("This input file is using a pixel size (%0d)that is not supported, only 24bpp is supported", num_pixel_bits);
		end
		else
		begin
			$fatal("Unsupported DIB header size of %0d found in input file", dib_header_size);
		end
		
		// Shouldn't need a color palette -> skip it
		res_image_data_ptr = BMP_HEADER_SIZE_BYTES + dib_header_size;
		$info("res_image_data_ptr = %d", res_image_data_ptr);
		
		// Should be at the start of the image data (there shoudln't be a color palette)
		// Skip padding if needed
		if($ftell(in_file) != in_image_data_ptr)
			quiet_catch = $fseek(in_file, in_image_data_ptr, SEEK_START);
	end
	endtask

	//////////////////////////////////////////////////////////////////
	//Task for extracting decrypted image for Edge-Detection Module	//
	//////////////////////////////////////////////////////////////////
	task extract_input_image_ED;
	begin
		// Calculate image data row size
		row_size_bytes = (((num_pixel_bits * image_width) + 31) / 32) * 4;
		
		// Calculate the number of rows in the pixel array
		num_rows = image_height;
		
		// Calculate the number of pixels per row
		num_cols = image_width;
		
		// Calculate the number of padding bytes per row
		num_pad_bytes	= row_size_bytes - (num_cols);
		$info("num_pad_bytes in Decrpyted image = %d", num_pad_bytes);
		tb_input_image_ED = new[num_rows];

		//quiet_catch = $fseek(in_file, 1023 , SEEK_START);

		for(r = num_rows - 1; r >= 0 ; r = r - 1)
		begin
			tb_input_image_ED[r] = new[num_cols];
			for(c = 0; c < num_cols; c = c + 1)
			begin
				// Get the input pixel value from the file (LSB format)
				quiet_catch = $fscanf(in_file, "%c", tb_input_image_ED[r][c]);
			end
			// Finished a row of pixels
			// Skip past any padding bytes in the input file (get to the next row)
			
			quiet_catch = $fseek(in_file, num_pad_bytes, SEEK_CUR);
			// Ready to start working on the next row of pixels
		end
		
		// Done with pixel array section of input and row-dimension 1-D pass
		// Done with input file
		$fclose(in_file);
	end
	endtask

	////////////////////////////////////////////////////////////
	//Task for resetting all the input signals		  //
	////////////////////////////////////////////////////////////
	task resetSignals;
	begin
		
	end
	endtask


	////////////////////////////////////////////////////////////
	//Task for printing the image data	 		 //
	////////////////////////////////////////////////////////////
	task printOutputArray;
		input reg imageArray [][];
	begin
		for(r = 0; r < num_rows - 2 ; r = r + 1)
		begin
			for(c = 0; c < num_cols - 2; c = c + 1)
			begin
				$display("%d",imageArray[r][c]);
			end
		end
	end
	endtask


/*/////////////////////////////////////////////////////////////////////////////////////
//			Test Cases for the Actual Design			     //
*//////////////////////////////////////////////////////////////////////////////////////
	initial
	begin

		// Wait for some time before starting test cases
		#(CLK_PERIOD);

		
		//////////////////////////////////////////
		///	Test case for image1		//
		//////////////////////////////////////////
		testCase = 0;
		
		// Read the input header
		read_input_header(INT1_FILENAME);
		
		// Populate the input buffer and close up the input file
		extract_input_image_ED;

		//Reset AHB slave
		tb_n_rst = 1;
		#(CLK_PERIOD);
		tb_n_rst = 0;
		#(CLK_PERIOD);
		tb_n_rst = 1;

		testCase = 1;
		@(posedge tb_clk);
		
		reg tb_SI_dfb;
		reg [31:0] tb_SI_rdata;
		reg tb_buff_filled;
		reg [31:0] tb_ED_rdata;
		reg [19:0] tb_SI_rpixNum;

		tb_fill_buff = 1;
		tb_ED_rpixNum = 0;
		if(tb_SI_mode == 2b'01)
		begin
			send_buffer_ED();
			tb_SI_dfb = 1;
			#(CLK_PERIOD)
			input_buffer[31:0] = buffer;
			tb_SI_dfb = 0;
		end
		#(CLK_PERIOD)
		if(tb_SI_mode == 2b'01)
		begin
			send_buffer_ED();
			tb_SI_dfb = 1;
			#(CLK_PERIOD)
			input_buffer[63:32] = buffer;
			tb_SI_dfb = 0;
		end
		#(CLK_PERIOD)
		if(tb_SI_mode == 2b'01)
		begin
			send_buffer_ED();
			tb_SI_dfb = 1;
			#(CLK_PERIOD)
			input_buffer[95:64] = buffer;
			tb_SI_dfb = 0;
		end
		#(CLK_PERIOD)
		if(tb_buff_filled == 1)
		begin
			$display("%s %s"input_buffer, )
			if(input_buffer == tb_ED_rdata)
				$display("TEST PASSED")
		end

	end
endmodule
