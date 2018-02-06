// $Id: $
// File name:   tb_mcu.sv
// Created:     4/16/2017
// Author:      Ruchir Aggarwal
// Lab Section: 337-03
// Version:     1.0  Initial Design Entry
// Description: Test bench file for the MCU

`timescale 1ns / 10ps

module tb_mcu ();

	// Define parameters
	// basic test bench parameters
	localparam	CLK_PERIOD  = 35;
	localparam	CHECK_DELAY = 30; // Check 2ns after the rising edge to allow for propagation delay

	// Shared Test Variables
	reg tb_clk, tb_n_rst;
	integer tb_test_num;
	reg tb_start, tb_RC4_done, tb_ED_done, tb_RC4_start, tb_ED_start, tb_process_complete;

	// Clock generation block
	always
	begin
		tb_clk = 1'b0;
		#(CLK_PERIOD/2.0);
		tb_clk = 1'b1;
		#(CLK_PERIOD/2.0);
	end

	// DUT portmaps
	mcu DUT
	(
		.clk(tb_clk),
		.n_rst(tb_n_rst),
		.start(tb_start),
		.RC4_done(tb_RC4_done),
		.ED_done(tb_ED_done),
		.RC4_start(tb_RC4_start),
		.ED_start(tb_ED_start),
		.process_complete(tb_process_complete)
	);

	// Default Configuration Test bench main process
	initial
	begin
		// Initialize all of the test inputs
		tb_n_rst	= 1'b1;				// Initialize to be inactive
		tb_start	= 1'b0;
		tb_RC4_done 	= 1'b0;
		tb_ED_done	= 1'b0;

		//TC - 0	- RESET of MCU
		tb_test_num 	= 0;
		tb_start 	= 1'b0;
		tb_RC4_done 	= 1'b0;
		tb_ED_done	= 1'b0;
		tb_n_rst	= 1'b0;
		@(posedge tb_clk);
		@(posedge tb_clk);
       		#(CHECK_DELAY);
		if((tb_RC4_start != 1'b0) && (tb_ED_start != 1'b0) && (tb_process_complete != 1'b0))
			$error("Test case: FAILED");
		else
			$info("Test case: PASSED");
		@(posedge tb_clk);
		@(posedge tb_clk);
		

		//TC - 1	- No start of the MCU
		tb_test_num 	= 1;
		tb_n_rst	= 1'b1;
		tb_start 	= 1'b0;
		tb_RC4_done 	= 1'b0;
		tb_ED_done	= 1'b0;
		@(posedge tb_clk);
		@(posedge tb_clk);
       		#(CHECK_DELAY);
		if((tb_RC4_start != 1'b0) && (tb_ED_start != 1'b0) && (tb_process_complete != 1'b0))
			$error("Test case: FAILED");
		else
			$info("Test case: PASSED");
		@(posedge tb_clk);
		@(posedge tb_clk);

		//TC - 2	- Initial starting of the MCU
		tb_test_num 	= 2;
		tb_start 	= 1'b1;
		tb_RC4_done 	= 1'b0;
		tb_ED_done	= 1'b0;
		@(posedge tb_clk);
		@(posedge tb_clk);
       		#(CHECK_DELAY);
		if((tb_RC4_start != 1'b1) && (tb_ED_start != 1'b0) && (tb_process_complete != 1'b0))
			$error("Test case: FAILED");
		else
			$info("Test case: PASSED");
		@(posedge tb_clk);
		@(posedge tb_clk);


		//TC - 3	- To do transition from RC4 to Edge-detection
		tb_test_num 	= 3;
		tb_start 	= 1'b0;
		tb_RC4_done 	= 1'b1;
		tb_ED_done	= 1'b0;
		@(posedge tb_clk);
		@(posedge tb_clk);
       		#(CHECK_DELAY);
		if((tb_RC4_start != 1'b0) && (tb_ED_start != 1'b1) && (tb_process_complete != 1'b0))
			$error("Test case: FAILED");
		else
			$info("Test case: PASSED");
		@(posedge tb_clk);
		@(posedge tb_clk);


		//TC - 4	- To do Edge-detection to Process complete
		tb_test_num 	= 4;
		tb_start 	= 1'b0;
		tb_RC4_done 	= 1'b1;
		tb_ED_done	= 1'b1;
		@(posedge tb_clk);
       		@(posedge tb_clk);
		#(CHECK_DELAY);
		if((tb_RC4_start != 1'b0) && (tb_ED_start != 1'b0) && (tb_process_complete != 1'b1))
			$error("Test case: FAILED");
		else
			$info("Test case: PASSED");
		@(posedge tb_clk);
		@(posedge tb_clk);

		
	end
endmodule
