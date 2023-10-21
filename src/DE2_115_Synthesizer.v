module DE2_115_Synthesizer(

	//////// CLOCK //////////
	CLOCK_50,
	CLOCK2_50,
	CLOCK3_50,
	ENETCLK_25,

	//////// Sma //////////
	SMA_CLKIN,
	SMA_CLKOUT,

	//////// LED //////////
	LEDG,
	LEDR,

	//////// KEY //////////
	KEY,

	//////// SW //////////
	SW,

	//////// SEG7 //////////
	HEX0,
	HEX1,
	HEX2,
	HEX3,
	HEX4,
	HEX5,
	HEX6,
	HEX7,

	//////// LCD //////////
	LCD_BLON,
	LCD_DATA,
	LCD_EN,
	LCD_ON,
	LCD_RS,
	LCD_RW,

	//////// RS232 //////////
	UART_CTS,
	UART_RTS,
	UART_RXD,
	UART_TXD,

	//////// PS2 //////////
	PS2_CLK,
	PS2_DAT,
	PS2_CLK2,
	PS2_DAT2,

	//////// SDCARD //////////
	SD_CLK,
	SD_CMD,
	SD_DAT,
	SD_WP_N,

	//////// VGA //////////
	VGA_B,
	VGA_BLANK_N,
	VGA_CLK,
	VGA_G,
	VGA_HS,
	VGA_R,
	VGA_SYNC_N,
	VGA_VS,

	//////// Audio //////////
	AUD_ADCDAT,
	AUD_ADCLRCK,
	AUD_BCLK,
	AUD_DACDAT,
	AUD_DACLRCK,
	AUD_XCK,

	//////// I2C for EEPROM //////////
	EEP_I2C_SCLK,
	EEP_I2C_SDAT,

	//////// I2C for Audio and Tv-Decode //////////
	I2C_SCLK,
	I2C_SDAT,

	//////// Ethernet 0 //////////
	ENET0_GTX_CLK,
	ENET0_INT_N,
	ENET0_MDC,
	ENET0_MDIO,
	ENET0_RST_N,
	ENET0_RX_CLK,
	ENET0_RX_COL,
	ENET0_RX_CRS,
	ENET0_RX_DATA,
	ENET0_RX_DV,
	ENET0_RX_ER,
	ENET0_TX_CLK,
	ENET0_TX_DATA,
	ENET0_TX_EN,
	ENET0_TX_ER,
	ENET0_LINK100,

	//////// Ethernet 1 //////////
	ENET1_GTX_CLK,
	ENET1_INT_N,
	ENET1_MDC,
	ENET1_MDIO,
	ENET1_RST_N,
	ENET1_RX_CLK,
	ENET1_RX_COL,
	ENET1_RX_CRS,
	ENET1_RX_DATA,
	ENET1_RX_DV,
	ENET1_RX_ER,
	ENET1_TX_CLK,
	ENET1_TX_DATA,
	ENET1_TX_EN,
	ENET1_TX_ER,
	ENET1_LINK100,

	//////// TV Decoder //////////
	TD_CLK27,
	TD_DATA,
	TD_HS,
	TD_RESET_N,
	TD_VS,

	/////// USB OTG controller
   OTG_DATA,
   OTG_ADDR,
   OTG_CS_N,
   OTG_WR_N,
   OTG_RD_N,
   OTG_INT,
   OTG_RST_N,
	//////// IR Receiver //////////
	IRDA_RXD,

	//////// SDRAM //////////
	DRAM_ADDR,
	DRAM_BA,
	DRAM_CAS_N,
	DRAM_CKE,
	DRAM_CLK,
	DRAM_CS_N,
	DRAM_DQ,
	DRAM_DQM,
	DRAM_RAS_N,
	DRAM_WE_N,

	//////// SRAM //////////
	SRAM_ADDR,
	SRAM_CE_N,
	SRAM_DQ,
	SRAM_LB_N,
	SRAM_OE_N,
	SRAM_UB_N,
	SRAM_WE_N,

	//////// Flash //////////
	FL_ADDR,
	FL_CE_N,
	FL_DQ,
	FL_OE_N,
	FL_RST_N,
	FL_RY,
	FL_WE_N,
	FL_WP_N,

	//////// GPIO //////////
	GPIO,

	//////// HSMC (LVDS) //////////
//	HSMC_CLKIN_N1,
//	HSMC_CLKIN_N2,
	HSMC_CLKIN_P1,
	HSMC_CLKIN_P2,
	HSMC_CLKIN0,
//	HSMC_CLKOUT_N1,
//	HSMC_CLKOUT_N2,
	HSMC_CLKOUT_P1,
	HSMC_CLKOUT_P2,
	HSMC_CLKOUT0,
	HSMC_D,
//	HSMC_RX_D_N,
	HSMC_RX_D_P,
//	HSMC_TX_D_N,
	HSMC_TX_D_P,

//////// EXTEND IO //////////
	EX_IO	
	);

//=======================================================
//  PARAMETER declarations
//=======================================================


//=======================================================
//  PORT declarations
//=======================================================
//////////// SEVENHEXDECORDER //////////


//////////// CLOCK //////////
input		          		CLOCK_50;
input		          		CLOCK2_50;
input		          		CLOCK3_50;
input		          		ENETCLK_25;

//////////// Sma //////////
input		          		SMA_CLKIN;
output		          	SMA_CLKOUT;

//////////// LED //////////
output		  [8:0]		LEDG;
output		  [17:0]		LEDR;

//////////// KEY //////////
input		     [3:0]		KEY;

//////////// SW //////////
input		     [17:0]		SW;

//////////// SEG7 //////////
output		  [6:0]		HEX0;
output		  [6:0]		HEX1;
output		  [6:0]		HEX2;
output		  [6:0]		HEX3;
output		  [6:0]		HEX4;
output		  [6:0]		HEX5;
output		  [6:0]		HEX6;
output		  [6:0]		HEX7;

//////////// LCD //////////
output		        		LCD_BLON;
inout		     [7:0]		LCD_DATA;
output		        		LCD_EN;
output		        		LCD_ON;
output		        		LCD_RS;
output		        		LCD_RW;

//////////// RS232 //////////
input		        		UART_CTS;
output		          		UART_RTS;
input		          		UART_RXD;
output		        		UART_TXD;

//////////// PS2 //////////
inout		          		PS2_CLK;
inout		          		PS2_DAT;
inout		          		PS2_CLK2;
inout		          		PS2_DAT2;

//////////// SDCARD //////////
output		        		SD_CLK;
inout		          		SD_CMD;
inout		     [3:0]		SD_DAT;
input		          		SD_WP_N;

//////////// VGA //////////
output		  [7:0]		VGA_B;
output		        		VGA_BLANK_N;
output		        		VGA_CLK;
output		  [7:0]		VGA_G;
output	         		VGA_HS;
output	     [7:0]		VGA_R;
output	         		VGA_SYNC_N;
output		        		VGA_VS;

//////////// Audio //////////
input		          		AUD_ADCDAT;
inout		          		AUD_ADCLRCK;
inout		          		AUD_BCLK;
output		        		AUD_DACDAT;
inout		          		AUD_DACLRCK;
output		        		AUD_XCK;

//////////// I2C for EEPROM //////////
output		        		EEP_I2C_SCLK;
inout		          		EEP_I2C_SDAT;

//////////// I2C for Audio and Tv-Decode //////////
output		        		I2C_SCLK;
inout		          		I2C_SDAT;

//////////// Ethernet 0 //////////
output		        		ENET0_GTX_CLK;
input		          		ENET0_INT_N;
output		        		ENET0_MDC;
inout		          		ENET0_MDIO;
output		        		ENET0_RST_N;
input		          		ENET0_RX_CLK;
input		          		ENET0_RX_COL;
input		          		ENET0_RX_CRS;
input		     [3:0]		ENET0_RX_DATA;
input		          		ENET0_RX_DV;
input		          		ENET0_RX_ER;
input		          		ENET0_TX_CLK;
output		  [3:0]		ENET0_TX_DATA;
output		        		ENET0_TX_EN;
output		        		ENET0_TX_ER;
input		          		ENET0_LINK100;

//////////// Ethernet 1 //////////
output		        		ENET1_GTX_CLK;
input		          		ENET1_INT_N;
output		        		ENET1_MDC;
input		          		ENET1_MDIO;
output		        		ENET1_RST_N;
input		          		ENET1_RX_CLK;
input		          		ENET1_RX_COL;
input		          		ENET1_RX_CRS;
input		     [3:0]		ENET1_RX_DATA;
input		          		ENET1_RX_DV;
input		          		ENET1_RX_ER;
input		          		ENET1_TX_CLK;
output		  [3:0]		ENET1_TX_DATA;
output		        		ENET1_TX_EN;
output		        		ENET1_TX_ER;
input		          		ENET1_LINK100;

//////////// TV Decoder 1 //////////
input		          		TD_CLK27;
input		     [7:0]		TD_DATA;
input		          		TD_HS;
output		        		TD_RESET_N;
input		          		TD_VS;


//////////// USB OTG controller //////////
inout         [15:0]    OTG_DATA;
output        [1:0]     OTG_ADDR;
output                  OTG_CS_N;
output                  OTG_WR_N;
output                  OTG_RD_N;
input                   OTG_INT;
output                  OTG_RST_N;

//////////// IR Receiver //////////
input		          		IRDA_RXD;

//////////// SDRAM //////////
output		 [12:0]		DRAM_ADDR;
output		 [1:0]		DRAM_BA;
output		       		DRAM_CAS_N;
output		        		DRAM_CKE;
output		        		DRAM_CLK;
output		        		DRAM_CS_N;
inout		    [31:0]		DRAM_DQ;
output		 [3:0]		DRAM_DQM;
output		          	DRAM_RAS_N;
output		          	DRAM_WE_N;

//////////// SRAM //////////
output		 [19:0]		SRAM_ADDR;
output		          	SRAM_CE_N;
inout		    [15:0]		SRAM_DQ;
output		          	SRAM_LB_N;
output		          	SRAM_OE_N;
output		          	SRAM_UB_N;
output		          	SRAM_WE_N;

//////////// Flash //////////
output		 [22:0]		FL_ADDR;
output		          	FL_CE_N;
inout		    [7:0]		FL_DQ;
output		          	FL_OE_N;
output		          	FL_RST_N;
input		          		FL_RY;
output		          	FL_WE_N;
output		          	FL_WP_N;

//////////// GPIO //////////
inout		    [35:0]		GPIO;

//////////// HSMC (LVDS) //////////

//input		          	HSMC_CLKIN_N1;
//input		          	HSMC_CLKIN_N2;
input		          		HSMC_CLKIN_P1;
input		          		HSMC_CLKIN_P2;
input		          		HSMC_CLKIN0;
//output		       		HSMC_CLKOUT_N1;
//output		          	HSMC_CLKOUT_N2;
output		        		HSMC_CLKOUT_P1;
output		        		HSMC_CLKOUT_P2;
output		        		HSMC_CLKOUT0;
inout		    [3:0]		HSMC_D;
//input		 [16:0]		HSMC_RX_D_N;
input		    [16:0]		HSMC_RX_D_P;
//output		 [16:0]	   HSMC_TX_D_N;
output		 [16:0]		HSMC_TX_D_P;

//////// EXTEND IO //////////
inout		    [6:0]		EX_IO;


wire			            I2C_END;
wire					      AUD_CTRL_CLK;
reg			 [31:0]		VGA_CLKo;
wire   						keyboard_sysclk;
wire   						demo_clock ; 
wire		    [7:0]		demo_code1;
wire 			 [7:0]		scan_code;
wire 			   			get_gate;
wire 				   		key1_on;
wire 					   	key2_on;
wire 			 [7:0]		key1_code;
wire 			 [7:0]		key2_code;
wire   				[7:0]		VGA_R1,VGA_G1,VGA_B1;
wire   				[7:0]		VGA_R2,VGA_G2,VGA_B2;

		
assign PS2_DAT2 = 1'b1;	
assign PS2_CLK2 = 1'b1;
	
assign TD_RESET_N =1'b1;
			
SEG7_LUT_8 	u0	(
	HEX0,
	HEX1,
	HEX2,
	HEX3,
	HEX4,
	HEX5,
	HEX6,
	HEX7,
	{7'b0,5'b0,state_r,5'b0,volume,5'b0,state_sel} //31 bits -> 8 hexadecimal output
);


// I2C //
	I2C_AV_Config 		u7	(
		.iCLK		( CLOCK_50),
		.iRST_N		( KEY[0] ),
		.o_I2C_END	( I2C_END ),
		.I2C_SCLK	( I2C_SCLK ),
		.I2C_SDAT	( I2C_SDAT )	
	);


// Clock //
	assign	AUD_ADCLRCK	=	AUD_DACLRCK;
	assign	AUD_XCK	   =	AUD_CTRL_CLK;			

	VGA_Audio_PLL 	u1	(	
		.areset ( ~I2C_END ),
		.inclk0 ( TD_CLK27 ),
		.c1		( AUD_CTRL_CLK )	
	);

	assign keyboard_sysclk = VGA_CLKo[12];
	assign demo_clock      = VGA_CLKo[18]; 
	assign VGA_CLK         = VGA_CLKo[0];

	always @( posedge CLOCK_50 ) VGA_CLKo <= VGA_CLKo + 1;


// Keyboard //
	ps2_keyboard keyboard( 						  
		.iCLK_50  ( CLOCK_50),  	
		.ps2_dat  ( PS2_DAT ),		
		.ps2_clk  ( PS2_CLK ),	
		.sys_clk  ( keyboard_sysclk ), 
		.reset    ( KEY[3] ), 		 	
		.reset1   ( KEY[2] ),	
		.scandata ( scan_code ),		
		.key1_on  ( key1_on ),	
		.key2_on  ( key2_on ),	
		.key1_code( key1_code ),
		.key2_code( key2_code ) 	
	);
	

// Screen //
	assign VGA_R= VGA_R1;
	assign VGA_G= VGA_G1;
	assign VGA_B= VGA_B1;

	screen screen1(
		.VGA_CLK   		( VGA_CLK ),  
		.reset			( KEY[1] ), 
		.vga_h_sync		( VGA_HS ), 
		.vga_v_sync		( VGA_VS ), 
		.vga_sync  		( VGA_SYNC_N ),	
		.inDisplayArea	( VGA_BLANK_N ),
		.vga_R			( VGA_R1 ), 
		.vga_G			( VGA_G1 ), 
		.vga_B			( VGA_B1 ),
		.sel			(state_sel),
		.play			(codec_state),
		.vol			(vol_scr),
		.freq			(fre_scr)
	);


// Sound //
	wire [15:0]	sound1;
	wire [15:0]	sound2;
	wire [15:0]	sound3;
	wire [15:0]	sound4;
	wire 			sound_off1;
	wire 			sound_off2;
	wire 			sound_off3;
	wire 			sound_off4;

	wire [7:0]sound_code1 = key1_code ;
	wire [7:0]sound_code2 = key2_code ;
	wire [7:0]sound_code3 = 8'hf0;
	wire [7:0]sound_code4 = 8'hf0;

	staff sf1 (
		.scan_code1(sound_code1),
		.scan_code2(sound_code2),
		.scan_code3(sound_code3),
		.scan_code4(sound_code4),
		.sound1(sound1),
		.sound2(sound2),
		.sound3(sound3),
		.sound4(sound4),
		.sound_off1(sound_off1),
		.sound_off2(sound_off2),
		.sound_off3(sound_off3),
		.sound_off4(sound_off4)
	);
	

// LED Display //
	assign LEDR[17:14] = { AUD_ADCDAT,sound_off3,sound_off2,sound_off1 };


// AUDIO CODEC //
	wire [23:0] vol_scr;
	wire [23:0] fre_scr;
	assign LEDR[4:0] = addr_record[19:15];
	assign LEDR[9:5] = addr_play[19:15];
	wire [7:0] codec_state;
	assign LEDG[7:0] = codec_state;
	wire [2:0] state_sel;
	wire [2:0] volume,freq;
	wire [1:0] speed;
	wire [2:0] volume_piano;
	wire [3:0] instru_sel;
	wire [7:0] counter_test;
	wire [15:0] music_bgm;
	wire [15:0] music_total;
	assign music_bgm = (play_start) ? dac_data : 0;
	adio_codec ad1	(
		.oAUD_BCK 	( AUD_BCLK ),
		.oAUD_DATA	( AUD_DACDAT ),
		.oAUD_LRCK	( AUD_DACLRCK ),																
		.iCLK_18_4	( AUD_CTRL_CLK ),
		.iRST_N	  	( KEY[0] ),							
		.iSrc_Select( 2'b00 ),

		.key1_on		( sound_off1 ),		
		.key2_on		( sound_off2 ),
		.key3_on		( 1'b0 ),
		.key4_on		( 1'b0 ), 						
		.sound1		( sound1 ),	
		.sound2		( sound2 ),	
		.sound3		( sound3 ),
		.sound4		( sound4 ),						
		.instru		( SW[0] ),

		.key1_code	(key1_code),
		.key2_code	(key2_code),
		.music_bgm	(music_bgm),
		.music_total(music_total),
		
		.o_state	(codec_state),
		.state_sel	(state_sel),
		.volume		(volume),
		.freq		(freq),
		.vol_scr		(vol_scr),
		.fre_scr		(fre_scr),
		.speed		(speed),
		.volume_piano (volume_piano),
		.instru_sel	(instru_sel),
		.counter_test(counter_test)
	);


// Recorder //
	localparam S_IDLE       = 3'd0;
	localparam S_I2C        = 3'd1;
	localparam S_RECD       = 3'd2;
	localparam S_RECD_PAUSE = 3'd3;
	localparam S_PLAY       = 3'd4;
	localparam S_PLAY_PAUSE = 3'd5;
	localparam S_IDLE0       = 3'd6;

	wire i2c_oen;
	wire [19:0] addr_record, addr_play;
	wire [15:0] data_record, data_play, dac_data;

	assign SRAM_ADDR = (state_r == S_RECD) ? addr_record : addr_play[19:0];
	assign SRAM_DQ  = (state_r == S_RECD) ? data_record : 16'dz; // sram_dq as output
	assign data_play   = (state_r != S_RECD) ? SRAM_DQ : 16'd0; // sram_dq as input

	assign SRAM_WE_N = (state_r == S_RECD) ? 1'b0 : 1'b1;
	assign SRAM_CE_N = 1'b0;
	assign SRAM_OE_N = 1'b0;
	assign SRAM_LB_N = 1'b0;
	assign SRAM_UB_N = 1'b0;

	//new-defined parts
	reg [2:0] state_r,state_w;
	reg rec_start;
	wire recing;
	reg [21:0] end_address_r,end_address_w;
	assign recing = (state_r == S_RECD) ? 1 : 0;
	assign o_state = state_r;

	// === AudDSP ===
	// responsible for DSP operations including fast play and slow play at different speed
	// in other words, determine which data addr to be fetch for player 
	wire play_pause,play_stop,play_start;
	assign play_pause  = (state_r == S_PLAY_PAUSE) ? 1'b1 : 1'b0;
	assign play_stop   = (state_r == S_I2C) ? 1'b1 : 1'b0;
	assign play_start  = (state_r == S_PLAY) ? 1'b1 : 1'b0;


	AudDSP dsp0(
		.i_rst_n(KEY[0]),
		.i_clk(AUD_BCLK),
		.i_start(play_start),
		.i_pause(play_pause),
		.i_stop(play_stop),
		.i_speed(0),
		.i_fast(0),
		.i_slow_0(0), // constant interpolation
		.i_slow_1(0), // linear interpolation
		.i_daclrck(AUD_DACLRCK),
		.i_sram_data(data_play),
		.i_end_addr(end_address_r),
		.o_dac_data(dac_data),
		.o_sram_addr(addr_play)
	);

	// === AudRecorder ===
	// receive data from WM8731 with I2S protocal and save to SRAM
	wire rec_pause,rec_stop;
	assign rec_pause  = (state_r == S_RECD_PAUSE) ? 1'b1 : 1'b0;
	assign rec_stop   = (state_r == S_I2C) ? 1'b1 : 1'b0;
	wire [1:0] s;
	assign LEDR[13:11] = {rec_pause,rec_stop,rec_start};
	AudRecorder recorder0(
		.i_rst_n(KEY[0]), 
		.i_clk(AUD_BCLK),
		.i_lrc(AUD_ADCLRCK),
		.i_start(rec_start),
		.i_pause(rec_pause),
		.i_stop(rec_stop),
		.i_data(AUD_ADCDAT),
		.i_music_total(music_total),
		.o_address(addr_record),
		.o_data(data_record)
	);

	always @(*) begin 
		state_w = state_r;
		end_address_w = end_address_r;
		rec_start = 0;
		case(state_r)
			S_I2C:begin
				if ((key1_code == 8'h22) && (key1_last != 8'h22)) begin
					state_w = S_RECD;
					rec_start = 1;
				end
				else if ((key1_code == 8'h21) && (key1_last != 8'h21)) begin
					state_w = S_PLAY; 
				end
			end
			
			S_RECD: begin
				if ((key1_code == 8'h22) && (key1_last != 8'h22)) begin
					state_w = S_RECD_PAUSE;
				end
				else if ((key1_code == 8'h1a) && (key1_last != 8'h1a)) begin
					state_w = S_I2C;
					end_address_w = addr_record;
				end
			end
			
			S_PLAY: begin
				if ((key1_code == 8'h21) && (key1_last != 8'h21)) state_w = S_PLAY_PAUSE;
				else if ((key1_code == 8'h1a) && (key1_last != 8'h1a)) state_w = S_I2C;

				else if (addr_play >= end_address_r) begin
					state_w = S_I2C;
				end
			end
			
			S_RECD_PAUSE: begin
				if ((key1_code == 8'h22) && (key1_last != 8'h22)) begin
					state_w = S_RECD;
					rec_start = 1;
				end
				else if ((key1_code == 8'h1a) && (key1_last != 8'h1a)) begin
					state_w = S_I2C;
					end_address_w = addr_record;
				end
			end

			S_PLAY_PAUSE: begin
				if ((key1_code == 8'h21) && (key1_last != 8'h21)) state_w = S_PLAY;
				else if ((key1_code == 8'h1a) && (key1_last != 8'h1a)) state_w = S_I2C;
			end

		endcase // state_r
	end


reg [7:0] key1_last;
always @(negedge AUD_DACLRCK or negedge KEY[0]) begin
	if (!KEY[0]) begin

		state_r <= S_I2C;
		end_address_r <= 0;
		key1_last <= 0;
	end
	else begin
		state_r <= state_w;
		end_address_r <= end_address_w;
		key1_last <= key1_code;
	end
end

endmodule
