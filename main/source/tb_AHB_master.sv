// $Id: $
// File name:   tb_AHB_master
// Created:     4/17/2017
// Author:      Gautam Rangarajan
// Lab Section: 337-002
// Version:     1.0  Initial Design Entry
// Description: AHB master testbench

`timescale 1ns / 10ps
module tb_AHB_master();

	// Define local parameters used by the test bench
	localparam CLK_PERIOD 	= 35;
	localparam CLK_DELAY 	= 30;
	localparam RESET_VALUE  = 0;

	// Declare DUT portmap signals
	reg tb_HRESETn,tb_HCLK,tb_HREADY, tb_startAddr_sel, tb_HWRITE, tb_data_feedback;
	reg [31:0] tb_HRDATA, tb_wdata, tb_HADDR, tb_HWDATA, tb_rdata;
	reg [1:0] tb_mode, tb_size, tb_HSIZE;
	reg [11:0]tb_image_width, tb_image_height;
	reg [19:0] tb_pixNum, tb_image_startAddr;
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
	AHB_master DUT(
		.clk(tb_HCLK),
		.n_rst(tb_HRESETn),
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
	
	// Test bench main process
	initial 
	begin
		
		// Initialize all of the test inputs
		tb_HRESETn	= 1'b1;		// Initialize to be inactive
		tb_test_num = 0;
		tb_HREADY = 1;
		tb_HRDATA = '0;
		tb_mode = '0;
		tb_wdata = '0;
		tb_pixNum = '0;
		tb_image_startAddr = '0;
		tb_size = '0;
		tb_image_width = 640;
		tb_image_height = 480;
		tb_startAddr_sel = 0;

		#(0.1);

		#(CLK_PERIOD * 10);

		// Test Case 1: Reset of AHB-MASTER
		tb_test_num = tb_test_num + 1;
		tb_test_case = "Reset everything";
		#(0.1);
		tb_HRESETn	= 1'b0; 	// Activate reset

		#(CLK_PERIOD * 0.5);

		// Check that the reset value is maintained during a clock cycle
		#(CLK_PERIOD);
		if((tb_HWRITE == RESET_VALUE) && (tb_HSIZE == RESET_VALUE) && (tb_HWDATA == RESET_VALUE) && (tb_rdata == RESET_VALUE) && (tb_data_feedback == RESET_VALUE) && (tb_HADDR[31:28] == RESET_VALUE))
		begin
			$info("Reset done in %s test case", tb_test_case);
		end
		else
		begin
			$error("Reset not done in %s test case", tb_test_case);
		end

		

		// Test Case 2: Send Write Instruction
		tb_test_num = tb_test_num + 1;
		tb_test_case = "Read Instruction";
		#(0.1);
		tb_HRESETn	= 1'b1; 	// de-activate reset

		tb_HREADY = 1;		//HREADY is set to 1
		tb_HRDATA = '0;		//HRDATA is still all 0s, will get non-garbage data only in the next state
		tb_mode = 2'b01;	//read mode
		tb_wdata = '1;		//wdata set to all 1's. Should not affect anything
		tb_pixNum = 311; 	//pix num is set to an arbitrary number. 311 was selected here
		tb_image_startAddr = '0;
		tb_size = 2'b10;
		tb_image_width = 640;
		tb_image_height = 480;
		tb_startAddr_sel = 0;

		#(CLK_PERIOD * 1);

		tb_HREADY = 0;

		#(CLK_PERIOD * 1);

		// Check that the reset value is maintained during a clock cycle
		#(CLK_PERIOD);
		if(tb_HSIZE == tb_size)
		begin
			$info("State changes correctly in %s test case", tb_test_case);
		end
		else
		begin
			$error("State does not change correctly in %s test case", tb_test_case);
		end

	
		// Test Case 3: Read done phase
		tb_test_num = tb_test_num + 1;
		tb_test_case = "Read Done";
		#(0.1);
		tb_HRESETn	= 1'b1; 	// de-activate reset

		tb_HREADY = 0;		//HREADY is still 0. simulates the signal sent by the SRAM while retrieving the data that needs to be read from the SRAM
		tb_HRDATA = '0;
		tb_mode = 2'b00;	//idle mode. Will prevent the FSM from exiting idle state later on
		tb_wdata = '1;		//wdata set to all 1's. Should not affect anything
		tb_pixNum = 311; 	//pix num is set to an arbitrary number. 311 was selected here
		tb_image_startAddr = '0;
		tb_size = 2'b10;
		tb_image_width = 640;
		tb_image_height = 480;

		#(CLK_PERIOD * 1);

		tb_HRDATA = 3748897;	//HRDATA is some random value supplied by SRAM
		tb_HREADY = 1;	//Set HREADY back to 1 after data is received
		tb_startAddr_sel = 1;	//ranndomly try changing start address. Should not affect anything

		// Check that the reset value is maintained during a clock cycle
		#(CLK_PERIOD); // This delay is important here. You need a one clock cycle delay after hready goes to 1 before the FSM enter read done state
		if(tb_rdata == tb_HRDATA)
		begin
			$info("State changes correctly in %s test case", tb_test_case);
		end
		else
		begin
			$error("State does not change correctly in %s test case", tb_test_case);
		end

		/////FSM NOW BACK IN IDLE STATE

		



	end

endmodule

