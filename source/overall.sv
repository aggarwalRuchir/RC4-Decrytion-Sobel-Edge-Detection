module overall(
		input wire tb_clk,
		input wire tb_n_rst,
		input wire tb_HWRITE_slave,
		input wire [1:0] tb_HSIZE_slave,
		input wire [31:0] tb_HADDR_slave,
		input wire [31:0] tb_HWDATA_slave,
		input wire [31:0] tb_HRDATA,
		input wire tb_HREADY,
		input wire tb_HRESP,
		//output wire tb_HREADY_slave,
		output wire tb_HRESP_slave,
		output wire [31:0] tb_HRDATA_slave,
		output wire tb_HWRITE,
		output wire [1:0] tb_HSIZE,
		output wire [31:0] tb_HADDR,
		output wire [31:0] tb_HWDATA,
		output wire tb_RC4_done,
		output wire tb_process_complete
	);


	reg [19:0] tb_image_startAddr;

	//Variable Declarations for Edge-Detection
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

	//Variable Declarations for Sample-Image Data Storage
	reg [1:0] tb_SI_mode;
	reg tb_SI_dfb;
	reg [31:0] tb_SI_rdata;
	reg [19:0] tb_SI_rpixNum;	

	//Variable Decalarations for MCU
	reg tb_start;
	//reg tb_process_complete;
	reg tb_error;
	
	//Variable Declarations for RC4
	reg tb_RC4_start;
	//reg tb_RC4_done;
	reg [31:0]tb_RC4_wdata;
	reg [19:0] tb_RC4_pixNum;
	reg [1:0] tb_RC4_mode;
	reg [31:0] tb_rdata;
	reg tb_data_feedback;
	reg [31:0] tb_RC4_rdata;
	reg tb_RC4_dfb;
	reg [31:0] tb_RC4_key;

	//Variable Decalrations for
	reg tb_startAddr_sel;
	reg [31:0] tb_wdata;
	reg [1:0] tb_size;
	reg [1:0] tb_mode;
	reg [19:0] tb_pixNum;
	


	//DUT PORT MAPPING
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
		.error(tb_error),
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
		.ED_wpixNum(tb_ED_wpixnum),
		.ED_mode(tb_ED_mode),
		.SI_rpixNum(tb_SI_rpixNum),
		.rdata(tb_rdata),
		.data_feedback(tb_data_feedback),
		.SI_mode(tb_SI_mode),
		.RC4_rdata(tb_RC4_rdata),
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
		.n_rst(tb_n_rst),
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
		.rdata(tb_rdata),
		.error(tb_error),
		.HRESP(tb_HRESP)
	);

	AHB_slave DUT_ahbS(
		.clk(tb_clk),
		.n_rst(tb_n_rst),
		.HADDR(tb_HADDR_slave),
		.HSIZE(tb_HSIZE_slave),
		.HWDATA(tb_HWDATA_slave),
		.HWRITE(tb_HWRITE_slave),
		.process_complete(tb_process_complete),
		.error(tb_error),
		.RC4_key(tb_RC4_key),
		.image_width(tb_image_width),
		.image_height(tb_image_height),
		.image_startAddr(tb_image_startAddr),
		.start(tb_start),
		.HRESP(tb_HRESP_slave),
		//.HREADY(tb_HREADY_slave),
		.HRDATA(tb_HRDATA_slave)
	);

	
	RC4 DUT_RC4(
		.clk(tb_clk),
		.n_rst_i(tb_n_rst),
		.img_width_i({8'b00000000,tb_image_width}),
		.img_hight_i({8'b00000000,tb_image_height}),
		.rc4_dfb_i(tb_RC4_dfb),
		.rc4_rdata_i(tb_RC4_rdata),
		.rc4_start_i(tb_RC4_start),
		.rc4_key(tb_RC4_key),
		.rc4_mode_o(tb_RC4_mode),
		.rc4_wdata_o(tb_RC4_wdata),
		.rc4_pix_num_o(tb_RC4_pixNum),
		.rc4_done_o(tb_RC4_done)
	);
endmodule	
