// $Id: $
// File name:   tb_AHB_slave.sv
// Created:     4/16/2017
// Author:      Gautam Rangarajan
// Lab Section: 337-03
// Version:     1.0  Initial Design Entry
// Description: Test bench for AHB-slave

`timescale 1ns / 10ps
module tb_AHB_slave();

	// Define local parameters used by the test bench
	localparam CLK_PERIOD 	= 35;
	localparam CLK_DELAY 	= 30;
	localparam RESET_VALUE  = 0;

	// Declare DUT portmap signals
	reg tb_HRESETn,tb_HCLK,tb_HWRITE, tb_process_complete,tb_start, tb_HRESP, tb_HREADY;
	reg [31:0]tb_HADDR,tb_HWDATA,tb_RC4_key, tb_HRDATA;
	reg [1:0] tb_HSIZE;
	reg [11:0]tb_image_width, tb_image_height;
	reg [19:0] tb_image_startAddr;
	reg tb_error;
	//reg HRESP, HREADY;

	// Declare test bench signals
	integer tb_test_num;
	string tb_test_case;

	// Clock generation block
	always
	begin
		tb_HCLK = 1'b0;
		#(CLK_PERIOD/2.0);
		tb_HCLK = 1'b1;
		#(CLK_PERIOD/2.0);
	end
	
	// DUT Port map
	AHB_slave DUT(
		.clk(tb_HCLK),
		.n_rst(tb_HRESETn),
		.HADDR(tb_HADDR),
		.HSIZE(tb_HSIZE),
		.HWDATA(tb_HWDATA),
		.HWRITE(tb_HWRITE),
		.process_complete(tb_process_complete),
		.error(tb_error),
		.RC4_key(tb_RC4_key),
		.image_width(tb_image_width),
		.image_height(tb_image_height),
		.image_startAddr(tb_image_startAddr),
		.start(tb_start),
		.HRESP(tb_HRESP),
		.HREADY(tb_HREADY),
		.HRDATA(tb_HRDATA)
	);
	
	// Test bench main process
	initial 
	begin
		
		// Initialize all of the test inputs
		tb_HRESETn	= 1'b1;		// Initialize to be inactive
		tb_test_num = 0;
		tb_test_case = "Test bench initializaton";
		#(0.1);

		// Test Case 1: Reset of AHB-Slave
		tb_test_num = tb_test_num + 1;
		tb_test_case = "Reset everything";
		#(0.1);
		tb_HRESETn	= 1'b0; 	// Activate reset

		#(CLK_PERIOD * 0.5);

		// Check that the reset value is maintained during a clock cycle
		#(CLK_PERIOD);
		if((tb_RC4_key == RESET_VALUE) && (tb_image_width == RESET_VALUE) && (tb_image_height == RESET_VALUE) && (tb_image_startAddr == RESET_VALUE))
		begin
			$info("Reset done in %s test case", tb_test_case);
		end
		else
		begin
			$error("Reset not done in %s test case", tb_test_case);
		end

		// Test Case 2: Writing image starting address into mm-regs
		tb_test_num = tb_test_num + 1;
		tb_test_case = "Img start addr to mm-regs";
		#(0.1);

		tb_HRESETn		= 1'b1; 	// No reset		
		tb_HWDATA 		= '1;
		tb_HADDR[31:28] 	= 4'b1010;
		tb_HADDR[27:4] 		= '0;
		tb_HADDR[3:0] 		= 4'b0001;
		tb_HWRITE 		= 1'b1;
		tb_HSIZE 		= 2'b10;
		tb_process_complete 	= 1'b0;
		tb_error = 0;

		#(CLK_PERIOD * 1);
		
		// Check that the Value for starting address is stored properly ?!
		#(CLK_PERIOD);
		if(tb_HWDATA[19:0] == tb_image_startAddr)
		begin
			$info("Correct value stored for image start address in %s test case", tb_test_case);
		end
		else
		begin
			$error("Incorrect value stored for image start address in %s test case", tb_test_case);
		end

		// Test Case 3: Writing RC4 key into mm-regs
		tb_test_num = tb_test_num + 1;
		tb_test_case = "RC4 key to mm-regs";
		#(0.1);

		tb_HRESETn		= 1'b1; 	// No reset		
		tb_HWDATA 		= '1;
		tb_HADDR[31:28] 	= 4'b1010;
		tb_HADDR[27:4] 		= '0;
		tb_HADDR[3:0] 		= 4'b0010;
		tb_HWRITE 		= 1'b1;
		tb_HSIZE 		= 2'b10;
		tb_process_complete 	= 1'b0;

		#(CLK_PERIOD * 1);
		
		// Check that the Value for RC4 key is stored properly ?!
		#(CLK_PERIOD);
		if(tb_RC4_key == '1)
		begin
			$info("Correct value stored for RC4 key in %s test case", tb_test_case);
		end
		else
		begin
			$error("Incorrect value stored for RC4 key in %s test case", tb_test_case);
		end

		// Test Case 4: Writing image width into mm-regs
		tb_test_num = tb_test_num + 1;
		tb_test_case = "Img width to mm-regs";
		#(0.1);

		tb_HRESETn		= 1'b1; 	// No reset		
		tb_HWDATA 		= '1;
		tb_HADDR[31:28] 	= 4'b1010;
		tb_HADDR[27:4] 		= '0;
		tb_HADDR[3:0] 		= 4'b0100;
		tb_HWRITE 		= 1'b1;
		tb_HSIZE 		= 2'b10;
		tb_process_complete 	= 1'b0;

		#(CLK_PERIOD * 1);
		
		// Check that the Value for image width is stored properly ?!
		#(CLK_PERIOD);
		if(tb_image_width == '1)
		begin
			$info("Correct value stored for image width in %s test case", tb_test_case);
		end
		else
		begin
			$error("Incorrect value stored for image width in %s test case", tb_test_case);
		end

		// Test Case 5: Writing image height into mm-regs
		tb_test_num = tb_test_num + 1;
		tb_test_case = "Img height to mm-regs";
		#(0.1);

		tb_HRESETn		= 1'b1; 	// No reset		
		tb_HWDATA 		= '1;
		tb_HADDR[31:28] 	= 4'b1010;
		tb_HADDR[27:4] 		= '0;
		tb_HADDR[3:0] 		= 4'b1000;
		tb_HWRITE 		= 1'b1;
		tb_HSIZE 		= 2'b10;
		tb_process_complete 	= 1'b0;

		#(CLK_PERIOD * 1);
		
		// Check that the Value for image height is stored properly ?!
		#(CLK_PERIOD);
		if(tb_image_height == '1)
		begin
			$info("Correct value stored for image height in %s test case", tb_test_case);
		end
		else
		begin
			$error("Incorrect value stored for image height in %s test case", tb_test_case);
		end

		// Test Case 6: check if AHB slave is sending start signal to MCU
		tb_test_num = tb_test_num + 1;
		tb_test_case = "Start signal to MCU";
		#(0.1);

		tb_HRESETn		= 1'b1; 	// No reset		
		tb_HWDATA 		= '1;
		tb_HADDR[31:28] 	= 4'b1010;
		tb_HADDR[27:4] 		= '0;
		tb_HADDR[3:0] 		= 4'b0001;
		tb_HWRITE 		= 1'b1;
		tb_HSIZE 		= 2'b10;
		tb_process_complete 	= 1'b0;

		#(CLK_PERIOD * 1);
		
		// Check that the Value for start is set properly ?!
		#(CLK_PERIOD);
		if(tb_start == 1)
		begin
			$info("Correct value stored for start in %s test case", tb_test_case);
		end
		else
		begin
			$error("Incorrect value stored for start in %s test case", tb_test_case);
		end

		// Test Case 7: Check if HRESP goes to one while the AHB slave gets a write request when in start mcu state
		tb_test_num = tb_test_num + 1;
		tb_test_case = "HRESP signal check";
		#(0.1);

		tb_HRESETn		= 1'b1; 	// No reset		
		tb_HWDATA 		= '1;
		tb_HADDR[31:28] 	= 4'b1010;	
		tb_HADDR[27:4] 		= '0;
		tb_HADDR[3:0] 		= 4'b0001;
		tb_HWRITE 		= 1'b1;
		tb_HSIZE 		= 2'b10;
		tb_process_complete 	= 1'b0;

		#(CLK_PERIOD * 1);


		// Check that HRESP goes to 1 ?!
		#(CLK_PERIOD);
		if(tb_start == 1)
		begin
			$info("AHB slave sets HRESP to 1 correctly in %s test case", tb_test_case);
		end
		else
		begin
			$error("AHB slave not setting HRESP correctly in %s test case", tb_test_case);
		end


		// Test Case 8: check if AHB slave goes back to idle after process complete signal is received
		tb_test_num = tb_test_num + 1;
		tb_test_case = "Process complete received from MCU";
		#(0.1);

		tb_HRESETn		= 1'b1; 	// No reset		
		tb_HWDATA 		= '1;
		tb_HADDR[31:28] 	= 4'b1011;	//wrong address for AHB slave
		tb_HADDR[27:4] 		= '0;
		tb_HADDR[3:0] 		= 4'b0001;
		tb_HWRITE 		= 1'b1;
		tb_HSIZE 		= 2'b10;
		tb_process_complete 	= 1'b0;		//Process complete received
		tb_error = 1;

		#(CLK_PERIOD * 1);
		
		tb_process_complete = 0;
		tb_error = 0;

		#(CLK_PERIOD * 5);
		tb_HRESETn		= 1'b1; 	// No reset		
		tb_HWDATA 		= '1;
		tb_HADDR[31:28] 	= 4'b1010;	//wrong address for AHB slave
		tb_HADDR[27:4] 		= '0;
		tb_HADDR[3:0] 		= 4'b1111;
		tb_HWRITE 		= 1'b0;
		tb_HSIZE 		= 2'b10;
		tb_process_complete 	= 1'b0;		//Process complete received
		


		// Check that start goes back to 0 ?!
		#(CLK_PERIOD);
		if(tb_start == 0)
		begin
			$info("AHB slave goes back to idle state and start signal is reset correctly in %s test case", tb_test_case);
		end
		else
		begin
			$error("AHB slave not going back to idle state in %s test case", tb_test_case);
		end

	end
	
endmodule
