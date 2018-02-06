// $Id: $
// File name:   tb_edm.sv
// Created:     4/18/2017
// Author:      Ribhav Agarwal
// Lab Section: 337-03
// Version:     1.0  Initial Design Entry
// Description: This is the test bench for edm

`timescale 1ns/10ps

module tb_edm();

	localparam CLK_PERIOD	= 35ns;
	reg tb_clk;
	always
	begin
		tb_clk = 1'b0;
		#(CLK_PERIOD/2.0);
		tb_clk = 1'b1;
		#(CLK_PERIOD/2.0);
	end

	reg tb_n_rst;
	reg tb_ED_start;
	reg tb_ED_dfb;
	reg tb_buff_filled;
	reg [11:0] tb_image_width;
	reg [11:0] tb_image_height;
	reg [95:0] tb_ED_rdata;
	reg tb_fill_buff;
	reg tb_ED_done;
	reg [1:0] tb_ED_mode;
	reg [19:0] tb_ED_rpixnum;
	reg [19:0] tb_ED_wpixnum;
	reg [15:0] tb_ED_wdata;

	reg [1:0] tb_SI_mode;
	reg tb_SI_dfb;
	reg [31:0] tb_SI_rdata;
	reg [19:0] tb_SI_rpixNum;	

	reg tb_start;
	reg tb_process_complete;
	reg tb_RC4_start;
	reg tb_RC4_done;

	reg [31:0]tb_RC4_wdata;
	reg [19:0] tb_RC4_pixNum;
	reg [1:0] tb_RC4_mode);
	reg [31:0] tb_rdata;
	reg tb_data_feedback;
	reg [31:0] tb_RC4_data;
	reg RC4_dfb;
	reg tb_startAddr_sel;
	reg [31:0] wdata;
	reg [1:0] tb_size;
	reg [1:0] tb_mode;
	reg [19:0] pixNum;


	reg tb_HREADY;
	reg [31:0] tb_HRDATA;
	reg [31:0] tb_HADDR;
	reg [1:0] tb_HSIZE;
	reg [31:0] tb_HWDATA;
	reg tb_HWRITE;
	

	edm DUT_EDM(
	.clk(tb_clk),
	.n_rst(tb_n_rst),
	.ED_start(tb_ED_start),
	.ED_dfb(tb_ED_dfb),
	.buff_filled(tb_buff_filled),
	.image_width(tb_image_width),
	.image_height(tb_image_height),
	.ED_rdata(tb_ED_rdata),
	.fill_buff(tb_fill_buff),
	.ED_done(tb_ED_done),
	.ED_mode(tb_ED_mode),
	.ED_rpixnum(tb_ED_rpixnum),
	.ED_wpixnum(tb_ED_wpixnum),
	.ED_wdata(tb_ED_wdata)
	);

	sample_image_data_storage DUT_BUFF(
	.clk(tb_clk),
	.n_rst(tb_n_rst),
	.image_width(tb_image_width),
	.SI_dfb(tb_SI_dfb),
	.SI_rdata(tb_SI_rdata),
	.ED_rpixNum(tb_ED_rpixnum),
	.fill_buff(tb_fill_buff),
	.buff_filled(tb_buff_filled),
	.ED_rdata(tb_ED_rdata),
	.SI_rpixNum(tb_SI_rpixNum),
	.SI_mode(tb_SI_mode)
	);

	mcu DUT_mcu(
	.clk(tb_clk),
	.n_rst(tb_n_rst),	
	.start(tb_start),
	.RC4_done(tb_RC4_done),
	.ED_done(tb_ED_done),
	.RC4_start(tb_RC4_start),
	.ED_start(tb_ED_start),
	.process_complete(tb_process_complete)
	);


	AHB_helper DUT_ahbH(
	.RC4_start(tb_RC4_start),
	.ED_start(tb_ED_start),
	.RC4_wdata(tb_RC4_wdata),
	.RC4_pixNum(tb_RC4_pixNum),
	.RC4_mode(tb_RC4_mode),
	.ED_wdata(tb_ED_wdata),
	.ED_wpixNim(tb_ED_wpixnum),
	.ED_mode(tb_ED_mode),
	.SI_rpixNum(tb_SI_rpixnum),
	.rdata(tb_rdata),
	.data_feedback(tb_data_feedback),
	.SI_mode(tb_SI_mode),
	.RC4_data(tb_RC4_data),
	.RC4_dfb(tb_RC4_dfb),
	.ED_dfb(tb_ED_dfb),
	.SI_rdata(tb_SI_rdata),
	.SI_dfb(tb_SI_dfb),
	.startAddr_sel(tb_startAddr_sel),
	.wdata(tb_wdata),
	.size(tb_size),
	.mode(tb_mode),
	.pixNum(tb_pixNum)
	);

	

	AHB_master DUT_ahbM(
	.clk(tb_clk),
	.n_rst(tb_n_rst)
	.HREADY(tb_HREADY),
	.HRDATA(tb_HRDATA),
	.mode(tb_mode),
	.wdata(tb_wdata),
	.pixNum(tb_pixNum),
	.image_startAddr(tb_image_startAddr),
	.size(tb_size),
	.image_width(tb_image_width),
	.image_height(tb_image_height),
	.startAddr_sel(tb_startAddr_sel),
	.HADDR(tb_HADDR),
	.HWDATA(tb_HWDATA),
	.HWRITE(tb_HWRITE),
	.HSIZE(tb_HSIZE),
	.data_feedback(tb_data_feedback),
	.rdata(tb_rdata)
	);


////////////////////////////INTERMOD CODE
	parameter	INPUT_FILENAME		= "./images/fruits.bmp";
	parameter	RESULT1_FILENAME	= "./docs/edge_detected_fruit.bmp";
	parameter	RESULT2_FILENAME	= "./docs/edge_detected_fruit2.txt";

	// Define file io offset constants
	localparam SEEK_START		= 0;
	localparam SEEK_CUR		= 1;
	localparam SEEK_END		= 2;
	

	// Bitmap file based parameters
	localparam BMP_HEADER_SIZE_BYTES	= 14;	// The length of the BMP file header field in Bytes
	localparam PIXEL_ARR_PTR_ADDR			= BMP_HEADER_SIZE_BYTES - 4;
	localparam DIB_HEADER_C1_SIZE			= 40; // The length of the expected BITMAPINFOHEADER DIB header
	localparam DIB_HEADER_C2_SIZE			= 12; // The length of the expected BITMAPCOREHEADER DIB header
	localparam NO_COMPRESSION 		= 0;	// The compression mode value should be 0 if no compression is used (normal case)

	// Define local constants
	localparam NUM_VAL_BITS		= 16;
	localparam MAX_VAL_BIT		= NUM_VAL_BITS - 1;
	localparam CHECK_DELAY		= 1ns;
	//localparam CLK_PERIOD		= 10ns;

	// Declare Image Processing Test Bench Variables
	integer r;							// Loop variable for working with rows of pixels
	integer c;							// Loop variable for working with pixels in a row
	reg [7:0] tmp_byte;						// temp variable for read/writing bytes from/to files
	integer in_file;						// Input file handle
	integer res_file;						// Result file handle
	string  curr_res_filename;
	integer num_rows;						// The number of rows of pixels in the image file
	integer num_cols;						// The number of pixels pwer row in the image file
	integer num_pad_bytes;						// The number of padding bytes at the end of each row
	reg [7:0] in_pixel_val;						// The raw bytes read from the input file
	reg [7:0] res_pixel_val;					// The averaged values for the result file
	integer i;							// Loop variable for misc. for loops
	integer quiet_catch; 						// Just used to remove warnings about not capturing the value of the file function returns
	integer count;
	// The bitmap file header is 14 Bytes
	reg [(BMP_HEADER_SIZE_BYTES - 1):0][7:0] in_bmp_file_header;
	reg [(BMP_HEADER_SIZE_BYTES - 1):0][7:0] res_bmp_file_header;
	reg [31:0] in_image_data_ptr;					// The starting byte address of the pixel array in the input file
	reg [31:0] res_image_data_ptr;					// The starting byte address of the pixel array in the result file
	
	// The normal/supported DIB header is 40 Bytes
	reg [(DIB_HEADER_C1_SIZE - 1):0][7:0] dib_header;
	reg [31:0] dib_header_size;		// The dib header size is a 32-bit unsigned integer
	reg [31:0] image_width;			// The image width (pixels) is a 32-bit signed integer
	reg [31:0] image_height;		// The image height (pixels) is a 32-bit signed integer
	reg [15:0] num_pixel_bits;		// The number of pixels per bit (1, 4, 8, 16, 24, 32) is an unsigned integer
	reg [31:0] compression_mode;		// The type of compression used (this test bench doesn't support compression)
	
	// 2-D Filter approach buffers
	reg [7:0] tb_input_image [][]; 
	reg [7:0] tb_output_image [][];

	//
	//reg [19:0] ED_rpixNum;
	//reg [19:0] ED_wpixNum;
	integer row,col;
	reg [3:0][7:0] buffer;

	// Pixel array stuff
	integer row_size_bytes;	// Used to store the calculated row size for the pixel array

	integer k;
	
	//Task for sending/handling a buffer
	task send_buffer;
	begin
		// Synchronize to a negative clock edge to avoid metastability
		@(negedge tb_clk);
		
		
		// Start sending the new sample value
		row = tb_SI_rpixNum / image_width;
		col = tb_SI_rpixNum % image_width;
		buffer[0] = tb_input_image[row][col];	
		buffer[1] = tb_input_image[row][col + 1];
		buffer[2] = tb_input_image[row][col + 2];
		buffer[3] = tb_input_image[row][col + 3];	
		
		
	end
	endtask
	

	// Task for extracting the input file's header info
	task read_input_header;
	begin
		// Open the input file
		in_file = $fopen(INPUT_FILENAME, "rb");
		// Read in the Bitmap file header information (data is stored in little-endian (LSB first) format)
		for(i = 0; i < BMP_HEADER_SIZE_BYTES; i = i + 1) // Read the data in LSB format
		begin
			// Read a byte at a time
			quiet_catch = $fscanf(in_file,"%c" , in_bmp_file_header[i]);
		end
		// Extract the pixel array pointer (contains the file byte offset of the first byte of the pixel array)
		in_image_data_ptr[31:0] = in_bmp_file_header[(BMP_HEADER_SIZE_BYTES - 1):PIXEL_ARR_PTR_ADDR]; // The pixel array pointer is a 4 byte unsigned integer at the end of the header
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
			
			$info("%d %d %d", image_width , image_height, num_pixel_bits);

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
		
		// Should be at the start of the image data (there shoudln't be a color palette)
		// Skip padding if needed
		if($ftell(in_file) != in_image_data_ptr)
			quiet_catch = $fseek(in_file, in_image_data_ptr, SEEK_START);
	end
	endtask

	// Task to populate the input image buffer
	task extract_input_image;
	begin
		// Calculate image data row size
		row_size_bytes = (((num_pixel_bits * image_width) + 31) / 32) * 4;
		// Calculate the number of rows in the pixel array
		num_rows = image_height;
		// Calculate the number of pixels per row
		num_cols = image_width;
		// Calculate the number of padding bytes per row
		num_pad_bytes	= row_size_bytes - (num_cols);
		tb_input_image = new[num_rows];
		for(r = num_rows - 1; r >= 0 ; r = r - 1)
		begin
			tb_input_image[r] = new[num_cols];
			for(c = 0; c < num_cols; c = c + 1)
			begin
				// Get the input pixel value from the file (LSB format)
				quiet_catch = $fscanf(in_file, "%c", tb_input_image[r][c]);
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

	// Task for generating the output file's header info to match the input one's
	task generate_output_header;
		input string filename;
	begin
		// Open the result file
		curr_res_filename = filename;
		res_file = $fopen(filename, "wb");
		// Create the bmp file header field (shouldn't change from input file, except for potetinally the image data ptr field)
		res_bmp_file_header = in_bmp_file_header;
		// Correct the image data ptr for discarding the color palette when allowed
		res_bmp_file_header[(BMP_HEADER_SIZE_BYTES - 1):PIXEL_ARR_PTR_ADDR] = res_image_data_ptr;
		// Write the bitmap header field to the result file
		for(i = 0; i < BMP_HEADER_SIZE_BYTES; i = i + 1) // Write data in LSB format
		begin
			// Write a byte at a time
			$fwrite(res_file, "%c", res_bmp_file_header[i]);
		end
		// Create the DIB header for the result file (shouldn't change from input file)
		for(i = 0; i < dib_header_size; i = i + 1) // Write data in LSB format
		begin
			// Write a byte at a time
			$fwrite(res_file, "%c", dib_header[i]);
		end
		
		// Should be at the start of the image data (there shoudln't be a color palette)
		// Skip padding if needed
		if($ftell(res_file) != res_image_data_ptr)
			quiet_catch = $fseek(res_file, res_image_data_ptr, SEEK_START);
	end
	endtask
	
	// Task for dumping an image buffer to the currently open result file
	task dump_image_buffer_to_file;
	//	input reg [7:0] image_buffer [][];
	begin
		curr_res_filename = RESULT2_FILENAME;
		res_file = $fopen(RESULT2_FILENAME, "wb");
		// Populate the image data in the result file
		for(r = 0; r < num_rows - 2 ; r = r + 1)
		begin
			for(c = 0; c < num_cols - 2; c = c + 1)
			begin
				// Done filtering each color portion of the pixel -> store full pixel to the file (LSB Format)
				$fwrite(res_file, "%c", tb_output_image[r][c]);
			end
			// Finished a row of pixels
			// Add padding bytes to result file (advance it to the next row)
			quiet_catch = $fseek(res_file, num_pad_bytes, SEEK_CUR);
		end
		
		// Done with result file
		// Create end of file marker
		$fwrite(res_file, "%c", 8'd0);
		// Done with result file
		$fclose(res_file);
		$info("Done generating filtered file '%s' from input file '%s'", curr_res_filename, INPUT_FILENAME);
	end
	endtask

/////////////////////////////////
	initial
	begin

		// Wait for some time before starting test cases
		#(1ns);
		
		// Read the input header
		read_input_header;
		
		// Populate the input buffer and close up the input file
		extract_input_image;


		tb_n_rst = 1;
		tb_image_width = image_width;
		tb_image_height = image_height;
		tb_ED_dfb = 0;
		tb_SI_dfb = 0;
		tb_ED_start = 0;
		tb_buff_filled = 0;
		tb_startAddr = 0;


		#(CLK_PERIOD);

		tb_n_rst = 0;

		#(CLK_PERIOD);

		tb_n_rst = 1;
		tb_start = 1;

		#(CLK_PERIOD);
		tb_start = 0;

		#(CLK_PERIOD * 5);	
		tb_RC4_done = 1;
		#(CLK_PERIOD);
		tb_RC4_done = 0; //RC4 is 'done' decrypting the image. MCU goes to start edge detection

		//Generating Output Header
		generate_output_header(RESULT1_FILENAME);

		//Allocate space for output image
		tb_output_image = new[num_rows - 2];
		for(r = num_rows - 3; r >= 0 ; r = r - 1)
		begin
			tb_output_image[r] = new[num_cols - 2];
		end

		//Edge detection process
		tb_SI_dfb = 0;
		
		while(tb_process_complete != 1) //Run this loop as long as Edge detection is still running.
		begin
			tb_ED_dfb = 0;
			//#(CLK_PERIOD);

			//filling the sample data storage
			while(tb_ED_mode == 2'b01)
			begin

				send_buffer();
				#(CLK_PERIOD);
				@(posedge tb_clk);
				tb_SI_rdata = buffer;
				tb_SI_dfb = 1;
				#(CLK_PERIOD);
				tb_SI_dfb = 0;
				#(CLK_PERIOD);

					
			end //Sample buffer should be filled at this point

			#(CLK_PERIOD);
			tb_output_image[tb_ED_wpixnum / (tb_image_width - 2)][tb_ED_wpixnum % (tb_image_width - 2)] = tb_ED_wdata[7:0];
			tb_output_image[tb_ED_wpixnum / (tb_image_width - 2)][(tb_ED_wpixnum % (tb_image_width - 2)) + 1] = tb_ED_wdata[15:8];
			//#(CLK_PERIOD * 2);
			tb_ED_dfb = 1;
			#(CLK_PERIOD);
		end

		tb_start = 0;
		
		#(CLK_PERIOD);
		tb_n_rst = 1;
		#(CLK_PERIOD);
		tb_n_rst = 0;
		#(CLK_PERIOD);
		tb_n_rst = 1;
		
		dump_image_buffer_to_file();		


		for(r = 0; r < num_rows - 2 ; r = r + 1)
		begin
			for(c = 0; c < num_cols - 2; c = c + 1)
			begin
				$display("%d",tb_output_image[r][c]);
			end
		end
		
			
	end

endmodule
