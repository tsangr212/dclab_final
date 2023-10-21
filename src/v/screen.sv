module screen(
	input CLK,
	input VGA_CLK,
    input reset,
	input [2:0] sel,
	input [7:0] play,
	input [23:0] vol,
	input [23:0] freq,
	output vga_sync,	
	output vga_h_sync,
	output vga_v_sync,
	output inDisplayArea,	
	output [7:0] vga_R,
	output [7:0] vga_G, 
	output [7:0] vga_B
);
	assign  vga_sync=1;	

	wire [11:0] CounterX;
	wire [11:0] CounterY;
	wire [7:0] r_up, r_mid, r_down, g_up, g_mid, g_down, b_up, b_mid, b_down; 
	vga_time_generator vga0(
		.pixel_clk(VGA_CLK),
		.h_disp   (640),
		.h_fporch (16),
		.h_sync   (96), 
		.h_bporch (48),
		.v_disp   (480),
		.v_fporch (10),
		.v_sync   (2),
		.v_bporch (33),
		.vga_hs   (vga_h_sync),
		.vga_vs   (vga_v_sync),
		.vga_blank(inDisplayArea),
		.CounterY(CounterY),
		.CounterX(CounterX) 
	);


    reg [31:0] CLKo;
	wire clk_up = CLKo[21];
	wire clk_down = CLKo[22];

	always @( posedge VGA_CLK ) begin
		if(!reset) begin
			CLKo <= 0;
		end
        else begin 
			CLKo <= CLKo + 1;
		end
    end

	up up0(
		.clk(clk_up),
		.reset(reset),
        .CounterX(CounterX),
        .CounterY(CounterY),
		.sel(sel),
		.play(play),
        .vol_i(vol),
		.freq_i(freq),
        .o_r(r_up),
		.o_g(g_up),
		.o_b(b_up)
	);
	
	down down0(
		.clk(clk_down),
		.reset(reset),
        .CounterX(CounterX),
        .CounterY(CounterY),
		.sel(sel),
		.play(play),
        .vol_i(vol),
		.freq_i(freq),
        .o_r(r_down),
		.o_g(g_down),
		.o_b(b_down)
	);

	pic pic0(
		.vga_clk(VGA_CLK),
		.sys_rst_n(reset),
        .pix_x(CounterX),
        .pix_y(CounterY),
        .o_r(r_mid),
		.o_g(g_mid),
		.o_b(b_mid)
	);

	// parameter   UART_BPS    =   14'd9600        ,   //比特率
    //         CLK_FREQ    =   26'd50_000_000  ;   //时钟频率

	// uart_rx
	// #(
	// 	.UART_BPS    (UART_BPS),         //串口波特率
	// 	.CLK_FREQ    (CLK_FREQ)          //时钟频率
	// )
	// uart_rx_inst
	// (
	// 	.sys_clk     (CLK  ),   //输入工作时钟,频率50MHz,1bit
	// 	.sys_rst_n   (reset    ),   //输入复位信号,低电平有效,1bit
	// 	.rx          (rx       ),   //输入串口的图片数据,1bit

	// 	.po_data     (po_data  ),   //输出拼接好的图片数据
	// 	.po_flag     (po_flag  )    //输出数据标志信号
	// );

	// uart_pic     vga_pic_inst
	// (
	// 	.vga_clk        (vga_clk    ),  //输入工作时钟,频率25MHz,1bit
	// 	.sys_clk        (CLK    ),  //输入RAM写时钟,1bit
	// 	.sys_rst_n      (reset      ),  //输入复位信号,低电平有效,1bit
	// 	.pi_flag        (po_flag    ),  //输入RAM写使能,1bit
	// 	.pi_data        (po_data    ),  //输入RAM写数据,8bit
	// 	.pix_x          (pix_x      ),  //输入VGA有效显示区域像素点X轴坐标,10bit
	// 	.pix_y          (pix_y      ),  //输入VGA有效显示区域像素点Y轴坐标,10bit

	// 	.pix_data_out   (pix_data   )   //输出像素点色彩信息,8bit

	// );
	assign vga_R = r_up + r_mid + r_down;
	assign vga_G = g_up + g_mid + g_down;
	assign vga_B = b_up + b_mid + b_down;
endmodule