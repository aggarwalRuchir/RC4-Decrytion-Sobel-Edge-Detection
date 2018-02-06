// $Id: $
// File name:   tb_AHB_helper.sv
// Created:     4/17/2017
// Author:      Ruchir Aggarwal
// Lab Section: 337-03
// Version:     1.0  Initial Design Entry
// Description: Test bench file for AHB-Helper

`timescale 1ns / 10ps

module tb_AHB_helper ();

	// Define parameters
	// basic test bench parameters
	localparam	CLK_PERIOD  = 35;
	localparam	CHECK_DELAY = 30; // Check 2ns after the rising edge to allow for propagation delay

	reg tb_clk;

	// Shared Test Variables
	
	reg tb_RC4_start,tb_ED_start;
	reg [31:0] tb_RC4_wdata,tb_rdata,tb_ED_wdata,tb_RC4_data, tb_SI_rdata, tb_wdata;
	reg [19:0] tb_RC4_pixNum,tb_ED_wpixNum,tb_SI_rpixNum, tb_pixNum;
	reg [1:0] tb_RC4_mode,tb_ED_mode, tb_size, tb_mode, tb_SI_mode;
	reg tb_data_feedback,tb_RC4_dfb, tb_ED_dfb, tb_SI_dfb, tb_startAddr_sel;

	integer tb_test_num;
	string tb_test;

	// Clock generation block
	always
	begin
		tb_clk = 1'b0;
		#(CLK_PERIOD/2.0);
		tb_clk = 1'b1;
		#(CLK_PERIOD/2.0);
	end

	// DUT portmaps
	AHB_helper DUT
	(
		.RC4_start(tb_RC4_start),
		.ED_start(tb_ED_start),
		.RC4_wdata(tb_RC4_wdata),
		.RC4_pixNum(tb_RC4_pixNum),
		.RC4_mode(tb_RC4_mode),
		.ED_wdata(tb_ED_wdata),
		.ED_wpixNum(tb_ED_wpixNum),
		.ED_mode(tb_ED_mode),
		.SI_rpixNum(tb_SI_rpixNum),
		.rdata(tb_rdata),
		.data_feedback(tb_data_feedback),
		.SI_mode(tb_SI_mode),
		.RC4_rdata(tb_RC4_data),
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

	// Default Configuration Test bench main process
	initial
	begin
		// Initialize all of the test inputs
		tb_RC4_start 		= 1'b0;
		tb_ED_start 		= 1'b0;
		tb_RC4_wdata 		= '0;
		tb_RC4_pixNum 		= '0;
		tb_RC4_mode 		= '0;
		tb_ED_wdata 		= '0;
		tb_ED_wpixNum 		='0;
		tb_ED_mode 		= '0;
		tb_SI_mode 		= '0;
		tb_SI_rpixNum 		= '0;
		tb_rdata 		= '0; 
		tb_data_feedback 	= 1'b0;

		//TC - 0	- Sitting Idle
		tb_test_num 	= 0;
		@(posedge tb_clk);
		@(posedge tb_clk);
		
		/*
		//TC - 1	- Reading instruction for RC4
		tb_RC4_start = 1'b1;
		tb_RC4_wdata = '0;
		tb_RC4_pixNum[0] = 1;
		tb_RC4_mode = 2'b01;

		tb_ED_start = 1'b0;
		tb_ED_wdata = '0;
		tb_ED_wpixNum '0;
		tb_ED_mode = '0;
		tb_SI_rpixNum = '0;
		
		tb_rdata = '0; 
		
		tb_data_feedback = 1'b0;
		
		@(posedge tb_clk);
		@(posedge tb_clk);
       		#(CHECK_DELAY);
		if((tb_RC4_start != 1'b0) && (tb_ED_start != 1'b0))
			$error("Test case: FAILED");
		else
			$info("Test case: PASSED");
		@(posedge tb_clk);
		@(posedge tb_clk);

		//TC - 2	- Writing instruction for RC4
		tb_test_num 	= 2;
		@(posedge tb_clk);
		@(posedge tb_clk);
       		#(CHECK_DELAY);
		if((tb_RC4_start != 1'b1) && (tb_ED_start != 1'b0))
			$error("Test case: FAILED");
		else
			$info("Test case: PASSED");
		@(posedge tb_clk);
		@(posedge tb_clk);

		*/
		//Reset Values

		//TC - 3	- Reading instruction from Edge-Detection to AHB-Master Via AHB-Helper
		tb_test_num 	= 3;
		tb_ED_start 	= 1'b1;
		@(posedge tb_clk);
		tb_ED_mode 	= 2'b01;
		@(posedge tb_clk);
		tb_SI_mode = 2'b01;
		tb_SI_rpixNum = 1;
       		
		#(CHECK_DELAY);
		if((tb_pixNum == tb_SI_rpixNum) && (tb_mode == tb_SI_mode) && (tb_size == 2'b10) && (tb_startAddr_sel == 1'b0))
			$info("Test case: Passed");
		else
			$error("Test case: FAILED");
		@(posedge tb_clk);
		tb_SI_mode = 2'b00;
		@(posedge tb_clk);


		//TC - 4	- Successful Data Read by AHB-master relayed back to Sample image Data Storage
		tb_test_num 	= 4;
		tb_rdata 	= 1;
		tb_data_feedback = 1'b1;
		@(posedge tb_clk);
		tb_data_feedback = 1'b0;
		@(posedge tb_clk);
       		
		#(CHECK_DELAY);
		if((tb_ED_dfb == tb_data_feedback) && (tb_SI_rdata == tb_rdata))
			$info("PASSED: Successful read successfully told to EdgeDetection");
		else
			$error("FAILED: Insuccessful read successfully told to EdgeDetection");
		@(posedge tb_clk);
		@(posedge tb_clk);


		//TC - 5	- Filling of buffer of Sample Image Data Storage
		tb_test_num 	= 5;
		tb_test = "Buffer Fill";
		tb_SI_mode = 2'b01;
		tb_SI_rpixNum 	= 480 + 1;
		@(posedge tb_clk);
		tb_SI_mode = 2'b00;
		@(posedge tb_clk);
		tb_rdata	= 255;
		tb_data_feedback = 1'b1;
		@(posedge tb_clk);
		tb_data_feedback = 1'b0;
		@(posedge tb_clk);
		tb_SI_mode = 2'b01;
		tb_SI_rpixNum 	= (2*480) + 1;
		@(posedge tb_clk);
		tb_SI_mode = 2'b00;
		@(posedge tb_clk);
		tb_rdata	= 512;
		tb_data_feedback = 1'b1;
		@(posedge tb_clk);
		tb_data_feedback = 1'b0;
		@(posedge tb_clk);

		#(CHECK_DELAY);
		if((tb_ED_dfb == tb_data_feedback) && (tb_SI_rdata == tb_rdata))
			$info("PASSED: Successful read successfully told to EdgeDetection");
		else
			$error("FAILED: Insuccessful read successfully told to EdgeDetection");
		@(posedge tb_clk);
		@(posedge tb_clk);



		//TC - 5	- Insuccessful Data Read by AHB-master relayed back to Sample image Data Storage
		tb_test_num 	= 6;
		tb_test = "Insuccessful Read";
		tb_rdata[1:0] = 2'b00;
		tb_data_feedback = 1'b0;
		@(posedge tb_clk);
		@(posedge tb_clk);
       		
		#(CHECK_DELAY);
		if((tb_ED_dfb == tb_data_feedback) && (tb_SI_rdata == tb_rdata))
			$info("PASSED: Insuccessful read successfully told to EdgeDetection");
		else
			$error("FAILED: Insuccessful read insuccessfully told to EdgeDetection");
		@(posedge tb_clk);
		@(posedge tb_clk);

/*
		//TC - 5	- Writing Instruction for Edge-Detection
		tb_test_num 	= 4;
		@(posedge tb_clk);
       		@(posedge tb_clk);
		#(CHECK_DELAY);
		if((tb_RC4_start != 1'b0) && (tb_ED_start != 1'b0))
			$error("Test case: FAILED");
		else
			$info("Test case: PASSED");
		@(posedge tb_clk);
		@(posedge tb_clk);
		*/
	end
endmodule
