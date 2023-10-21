module adio_codec (
output			oAUD_DATA,
output			oAUD_LRCK,
output	reg		oAUD_BCK,
input key1_on,
input key2_on,
input key3_on,
input key4_on,

input	[1:0]	iSrc_Select,
input			iCLK_18_4,
input			iRST_N,
input   [15:0]	sound1,
input   [15:0]	sound2,
input   [15:0]	sound3,
input   [15:0]	sound4,

input           instru,
input	[7:0]	key1_code,
input	[7:0]	key2_code,
input   [15:0]  music_bgm,
output  [15:0]  music_total,

//debug
output 	[7:0]	o_state,
output  [2:0]	state_sel,
output  [2:0]   volume,
output  [2:0]   freq,
output  [23:0]   vol_scr,
output  [23:0]   fre_scr,
output  [1:0]	speed,
output  [2:0]   volume_piano,
output  [3:0]   instru_sel,
output  [7:0]   counter_test
						);				

parameter	REF_CLK			=	18432000;	//	18.432	MHz
parameter	SAMPLE_RATE		=	48000;		//	48		KHz
parameter   QUARTER			= 	24000;
parameter   SECTION			= 	96000;
parameter	DATA_WIDTH		=	16;			//	16		Bits
parameter	CHANNEL_NUM		=	2;			//	Dual Channel

parameter	SIN_SAMPLE_DATA	=	48;



////////////	Input Source Number	//////////////
parameter	SIN_SANPLE		=	0;
//////////////////////////////////////////////////
//	Internal Registers and Wires
reg		[3:0]	BCK_DIV;
reg		[8:0]	LRCK_1X_DIV;
reg		[7:0]	LRCK_2X_DIV;
reg		[6:0]	LRCK_4X_DIV;
reg		[3:0]	SEL_Cont;
////////	DATA Counter	////////
reg		[5:0]	SIN_Cont;
////////////////////////////////////
reg							LRCK_1X;
reg							LRCK_2X;
reg							LRCK_4X;




//////////// bug test ///////////
assign o_state = playing_r;
assign state_sel = state_sel_r;
assign volume = volume_r[state_sel_r];
assign freq = freq_r[state_sel_r];
assign speed = speed_r[state_sel_r];
assign volume_piano = volume_piano_r;
assign instru_sel = instru_sel_r;
assign counter_test = counter_sin_r[0][20:13];
assign music_total = sound_o;

genvar      gi;
generate
    for (gi=7; gi>=0; gi=gi-1) begin : out
		assign vol_scr[gi*3 +: 3] = volume_r[gi];
		assign fre_scr[gi*3 +: 3] = freq_r[gi];
    end 
endgenerate

////////////	AUD_BCK Generator	//////////////
always@(posedge iCLK_18_4 or negedge iRST_N)
begin
	if(!iRST_N)
	begin
		BCK_DIV		<=	0;
		oAUD_BCK	<=	0;
	end
	else
	begin
		if(BCK_DIV >= REF_CLK/(SAMPLE_RATE*DATA_WIDTH*CHANNEL_NUM*2)-1 )
		begin
			BCK_DIV		<=	0;
			oAUD_BCK	<=	~oAUD_BCK;
		end
		else
		BCK_DIV		<=	BCK_DIV+1;
	end
end
//////////////////////////////////////////////////
////////////	AUD_LRCK Generator	//////////////
always@(posedge iCLK_18_4 or negedge iRST_N)
begin
	if(!iRST_N)
	begin
		LRCK_1X_DIV	<=	0;
		LRCK_2X_DIV	<=	0;
		LRCK_4X_DIV	<=	0;
		LRCK_1X		<=	0;
		LRCK_2X		<=	0;
		LRCK_4X		<=	0;
	end
	else
	begin
		//	LRCK 1X
		if(LRCK_1X_DIV >= REF_CLK/(SAMPLE_RATE*2)-1 )
		begin
			LRCK_1X_DIV	<=	0;
			LRCK_1X	<=	~LRCK_1X;
		end
		else
		LRCK_1X_DIV		<=	LRCK_1X_DIV+1;
		//	LRCK 2X
		if(LRCK_2X_DIV >= REF_CLK/(SAMPLE_RATE*4)-1 )
		begin
			LRCK_2X_DIV	<=	0;
			LRCK_2X	<=	~LRCK_2X;
		end
		else
		LRCK_2X_DIV		<=	LRCK_2X_DIV+1;		
		//	LRCK 4X
		if(LRCK_4X_DIV >= REF_CLK/(SAMPLE_RATE*8)-1 )
		begin
			LRCK_4X_DIV	<=	0;
			LRCK_4X	<=	~LRCK_4X;
		end
		else
		LRCK_4X_DIV		<=	LRCK_4X_DIV+1;		
	end
end
assign	oAUD_LRCK	=	LRCK_1X;
//////////////////////////////////////////////////
//////////	Sin LUT ADDR Generator	//////////////
always@(negedge LRCK_1X or negedge iRST_N)
begin
	if(!iRST_N)
	SIN_Cont	<=	0;
	else
	begin
		if(SIN_Cont < SIN_SAMPLE_DATA-1 )
		SIN_Cont	<=	SIN_Cont+1;
		else
		SIN_Cont	<=	0;
	end
end

////////// channel selection //////////
reg [2:0] state_sel_r,state_sel_w;

always @(*) begin
	// state_sel_w = state_sel_r;
	if (key1_code == 8'h16 && (key1_last != 8'h16)) //press down 1
		state_sel_w = 1;
	else if (key1_code == 8'h1e && (key1_last != 8'h1e)) //press down 2
		state_sel_w = 2;
	else if (key1_code == 8'h26 && (key1_last != 8'h26)) //press down 3
		state_sel_w = 3;
	else if (key1_code == 8'h25 && (key1_last != 8'h25)) //press down 4
		state_sel_w = 4;
	else if (key1_code == 8'h2e && (key1_last != 8'h2e)) //press down 5
		state_sel_w = 5;
	else if (key1_code == 8'h36 && (key1_last != 8'h36)) //press down 6
		state_sel_w = 6;
	else if (key1_code == 8'h3d && (key1_last != 8'h3d)) //press down 7
		state_sel_w = 7;
	else if (key1_code == 8'h3e && (key1_last != 8'h3e)) //press down 8
		state_sel_w = 8;
	else begin
		state_sel_w = state_sel_r;
	end
end

always@(posedge iCLK_18_4 or negedge iRST_N)
begin
	if(!iRST_N)
	begin
		state_sel_r <= 0;
	end else begin
		state_sel_r <= state_sel_w;
	end
end

///////////channel State management///////////
reg [7:0] playing_r,playing_w;
reg [7:0] key1_last;
integer i;
always @(*) begin
	for (i=0 ; i<=7 ; i=i+1) begin
			playing_w[i] = playing_r[i];
	end
	///////////

	if (key1_code == 8'h29 && (key1_last != 8'h29)) //press down space
		playing_w[state_sel_r] = ~playing_r[state_sel_r];

end
always@(posedge iCLK_18_4 or negedge iRST_N)
begin
	if(!iRST_N)
	begin
		playing_r	<= 0;
		key1_last	<= 0;
	end else begin
		playing_r	<= playing_w;
		key1_last	<= key1_code;
	end
end

// volume control
reg [2:0] volume_r [0:7];
reg [2:0] volume_w [0:7];

always@(*)begin
	for (i=0 ; i<=7 ; i=i+1) begin
		if ((i == state_sel_r) && ((key1_code == 8'h04) && (key1_last != 8'h04))) begin //press f3
			volume_w[i] = volume_r[i] - 1;
		end else if ((i == state_sel_r) && ((key1_code == 8'h0c) && (key1_last != 8'h0c))) begin //press f4
			volume_w[i] = volume_r[i] + 1;
		end else
			volume_w[i] = volume_r[i];
	end
end

always@(posedge iCLK_18_4 or negedge iRST_N)
begin
	if(!iRST_N)
	begin
		for (i=0 ; i<=7 ; i=i+1)
			volume_r[i]	<= 4;
	end else begin
		for (i=0 ; i<=7 ; i=i+1)
			volume_r[i]	<= volume_w[i];
	end
end


// freq control
reg [2:0] freq_r [0:7];
reg [2:0] freq_w [0:7];

always@(*)begin
	for (i=0 ; i<=7 ; i=i+1) begin
		if ((i == state_sel_r) && ((key1_code == 8'h03) && (key1_last != 8'h03))) begin //press f5
			freq_w[i] = freq_r[i] - 1;
		end else if ((i == state_sel_r) && ((key1_code == 8'h0b) && (key1_last != 8'h0b))) begin //press f6
			freq_w[i] = freq_r[i] + 1;
		end else
			freq_w[i] = freq_r[i];
	end
end

always@(posedge iCLK_18_4 or negedge iRST_N)
begin
	if(!iRST_N)
	begin
		for (i=0 ; i<=7 ; i=i+1)
			freq_r[i]	<= 2;
	end else begin
		for (i=0 ; i<=7 ; i=i+1)
			freq_r[i]	<= freq_w[i];
	end
end

// speed control
reg [1:0] speed_r [0:7];
reg [1:0] speed_w [0:7];

always@(*)begin
	for (i=0 ; i<=7 ; i=i+1) begin
		if ((i == state_sel_r) && ((key1_code == 8'h83) && (key1_last_lrck != 8'h83))) begin //press f7
			speed_w[i] = speed_r[i] - 1;
		end else if ((i == state_sel_r) && ((key1_code == 8'h0a) && (key1_last_lrck != 8'h0a))) begin //press f8
			speed_w[i] = speed_r[i] + 1;
		end else
			speed_w[i] = speed_r[i];
	end
end

always@(negedge iRST_N or negedge LRCK_1X)
begin
	if(!iRST_N)
	begin
		for (i=0 ; i<=7 ; i=i+1)
			speed_r[i]	<= 0;
	end else begin
		for (i=0 ; i<=7 ; i=i+1)
			speed_r[i]	<= speed_w[i];
	end
end

// time counter//
reg [20:0] counter_r [0:7];
reg [20:0] counter_w [0:7];
reg [7:0] key1_last_lrck;

always@(*)begin
	for (i=0 ; i<=7 ; i=i+1) begin
		if (playing_r[i] && !((key1_code == 8'h5a) && (key1_last_lrck != 8'h5a))) begin //press down enter: reset
			if ((counter_r[i] >= SECTION))
				counter_w[i] = 0;
			else if ((i == state_sel_r) && ((key1_code == 8'h06) && (key1_last_lrck != 8'h06))) //press down f2
				counter_w[i] = counter_r[i] + 1200;
			else if ((i == state_sel_r) && ((key1_code == 8'h05) && (key1_last_lrck != 8'h05))) //press down f1
				counter_w[i] = counter_r[i] - 1200;
			else
				counter_w[i] = counter_r[i] + 1 + speed_r[i];
		end
		else counter_w[i] = 0;
	end


end

always@(negedge iRST_N or negedge LRCK_1X)begin
	if(!iRST_N) begin
		for (i=0 ; i<=7 ; i=i+1) begin
			counter_r[i] <= 0;
		end
		key1_last_lrck <= 0;
		
	end else begin
		for (i=0 ; i<=7 ; i=i+1) begin
			counter_r[i] <= counter_w[i];
		end
		key1_last_lrck <= key1_code;
	end
end





///////////////////Wave-Source generate////////////////
////////////Timbre selection & SoundOut///////////////

	wire [15:0]music1,music2,music3,music4,music5,music6,music7;
	
	assign music1 = (playing_r[1]) ? ($signed($signed(music1_patterned) * volume_r[1]) >>> 3 ):0;
	assign music2 = (playing_r[2]) ? ($signed($signed(music2_patterned) * volume_r[2]) >>> 3 ):0;
	assign music3 = (playing_r[3]) ? ($signed($signed(music3_patterned) * volume_r[3]) >>> 3 ):0;
	assign music4 = (playing_r[4]) ? ($signed($signed(music4_patterned) * volume_r[4]) >>> 3 ):0;
	
	assign music5 = (playing_r[5]) ? ($signed($signed(music5_patterned) * volume_r[5]) >>> 3 ):0;
	assign music6 = (playing_r[6]) ? ($signed($signed(music6_patterned) * volume_r[6]) >>> 3 ):0;
	assign music7 = (playing_r[7]) ? ($signed($signed(music7_patterned) * volume_r[7]) >>> 3 ):0;



	//assign music1 = (playing_r[1]) ? music1_patterned:0;
	//assign music2 = (playing_r[2]) ? music2_patterned:0;
	//assign music3 = (playing_r[3]) ? music3_patterned:0;
	//assign music4 = (playing_r[4]) ? music4_patterned:0;
	wire [15:0]sound_o,sound_1,sound_2;
	assign sound_1=music1+music2+music3+music4;
	assign sound_2=music5+music6+music7+music_piano;	
	assign sound_o=sound_1+sound_2 + music_drum + ($signed(music_bgm));
	always@(negedge oAUD_BCK or negedge iRST_N)begin
		if(!iRST_N)
			SEL_Cont	<=	0;
		else
			SEL_Cont	<=	SEL_Cont+1;
	end
	assign	oAUD_DATA	=  sound_o[~SEL_Cont];

//////////Ramp address generater//////////////
	reg  [15:0]ramp1,ramp1_f;
	reg  [15:0]ramp2,ramp2_f;
	reg  [15:0]ramp3,ramp3_f;
	reg  [15:0]ramp4_1,ramp4_2,ramp4_1_f,ramp4_2_f;
	reg  [15:0]ramp5,ramp5_f;
	reg  [15:0]ramp6,ramp6_f;
	reg  [15:0]ramp7,ramp7_f;
	wire [15:0]ramp_max=60000;

	// 16 + 128 * (2+1) = 400;
	wire [15:0]ramp1_basic = 16 + ((freq_r[1] + 1) << 7) ;
	wire [15:0]ramp2_basic = 16 + ((freq_r[2] + 1) << 7) ;
	wire [15:0]ramp3_basic = 16 + ((freq_r[3] + 1) << 7) ;
	wire [15:0]ramp4_basic = 16 + ((freq_r[4] + 1) << 7) ;
	
	wire [15:0]ramp5_basic = 16 + ((freq_r[5] + 1) << 7) ;
	wire [15:0]ramp6_basic = 16 + ((freq_r[6] + 1) << 7) ;
	wire [15:0]ramp7_basic = 16 + ((freq_r[7] + 1) << 7) ;
	
/////Ramp//////
	
// freq	management
	//string
	always@(negedge playing_r[1] or negedge LRCK_1X)begin
	ramp1_f = ramp1 + ramp1_basic; //forwarded

	if (!playing_r[1])
		ramp1=0;
	else if (ramp1>ramp_max) ramp1=0;
	else if (counter_r[1] <= SAMPLE_RATE) ramp1 = ramp1_f;
	else ramp1= ramp1_f + 300;
	end

	// retro
	always@(negedge playing_r[2] or negedge LRCK_1X)begin
	ramp2_f = ramp2 + ramp2_basic;

	if (!playing_r[2])
		ramp2=0;
	else if (ramp2>ramp_max) ramp2=0;
	else if (counter_r[2] < QUARTER) ramp2= ramp2_f- 100;
	else if (counter_r[2] < SAMPLE_RATE) ramp2= ramp2_f;
	else if (counter_r[2] < QUARTER + SAMPLE_RATE) ramp2= ramp2_f - 175;
	else ramp2= ramp2_f +100;
	end

	//drum
	//1s : 48000
	reg [15:0] ramp3_max;
	always@(negedge playing_r[3] or negedge LRCK_1X)begin
	ramp3_max = ramp3 + ramp3_basic - (counter_r[3]>>>3); //freq weakening
	
	if (!playing_r[3])
		ramp3=0;
	else if (ramp3>ramp_max) ramp3=0;
	else if (counter_r[3] < QUARTER) ramp3=ramp3_max;
	else if (counter_r[3] < (QUARTER<<1)) ramp3=ramp3_max + 3000;
	else if (counter_r[3] < (SAMPLE_RATE + (QUARTER >> 1))) ramp3=ramp3_max + 6000;
	else if (counter_r[3] < (SAMPLE_RATE + QUARTER)) ramp3=ramp3_max + 7500;
	else ramp3= ramp3_max + 9000;
	end

	// slow string
	always@(negedge playing_r[4] or negedge LRCK_1X)begin
	ramp4_1_f = ramp4_1 + ramp4_basic;
	ramp4_2_f = ramp4_2 + (ramp4_basic << 1);

	if (!playing_r[4]) begin
		ramp4_1=0;
		ramp4_2=0;
	end else if (ramp4_1>ramp_max) begin
		ramp4_1 = 0;
	end else if (ramp4_2>ramp_max) begin
		ramp4_2 = 0;
	end else if (counter_r[4] < SAMPLE_RATE + QUARTER)  begin 
		ramp4_1 = ramp4_1_f;
		ramp4_2 = ramp4_2_f;
	end else begin
		ramp4_1 = ramp4_1_f + ($signed(ramp4_basic) >> 2);
		ramp4_2 = ramp4_2_f + ($signed(ramp4_basic) >> 1);
	end
	end
	
	// brass
	always@(negedge playing_r[5] or negedge LRCK_1X)begin
	ramp5_f = ramp5 + ramp5_basic; //forwarded

	if (!playing_r[5])
		ramp5=0;
	else if (ramp5>ramp_max) ramp5=0;
	else if (counter_r[5] <= SAMPLE_RATE + QUARTER) ramp5 = ramp5_f;
	else ramp5= ramp5_f + 100;
	end

	// star
	always@(negedge playing_r[6] or negedge LRCK_1X)begin
	ramp6_f = ramp6 + ramp6_basic; //forwarded

	if (!playing_r[6])
		ramp6=0;
	else if (ramp6>ramp_max) 
		ramp6=0;
	else if (counter_r[6] <= (QUARTER>>1))
		ramp6 = ramp6_f + 140;
	else if(counter_r[6] <= (QUARTER))
		ramp6 = ramp6_f + 140;
	else if(counter_r[6] <= (QUARTER+ (QUARTER >> 1)))
		ramp6 = ramp6_f + 497;
	else if(counter_r[6] <= (SAMPLE_RATE))
		ramp6 = ramp6_f + 497;
	else if(counter_r[6] <= (SAMPLE_RATE + (QUARTER >> 1)))
		ramp6 = ramp6_f + 595;
	else if(counter_r[6] <= (SAMPLE_RATE + QUARTER))
		ramp6 = ramp6_f + 595;
	else 
		ramp6 = ramp6_f + 497;
	end

	//1s : 48000
	//drum 2
	reg [15:0] ramp7_max;
	always@(negedge playing_r[7] or negedge LRCK_1X)begin
	ramp7_max = ramp7 + ramp7_basic - (counter_r[7]>>>2); //freq weakening

	if (!playing_r[7])
		ramp7=0;
	else if (ramp7>ramp_max) ramp7=0;
	else if (counter_r[7] < SAMPLE_RATE) ramp7=ramp7_max;
	else if (counter_r[7] < (SAMPLE_RATE + (QUARTER >> 1))) ramp7=ramp7_max + 12000;
	else if (counter_r[7] < (SAMPLE_RATE + QUARTER)) ramp7=ramp7_max + 15000 + 250;
	else ramp7=ramp7_max + 9000;
	end
	
//pattern management

	reg [15:0] music1_patterned,music2_patterned,music3_patterned,music4_patterned;
	reg [15:0] music5_patterned,music6_patterned,music7_patterned;

	//1s : 48000
	always@(negedge LRCK_1X)begin

		if (counter_r[1] < QUARTER)
			music1_patterned = ((music1_ramp << 1)/ ((counter_r[1] >> 6)+1));
		else if ((counter_r[1] >= SAMPLE_RATE) && (counter_r[1] < QUARTER + SAMPLE_RATE))
			music1_patterned = ((music1_ramp << 1)/ ((counter_r[1] >> 6)-749));
		else begin
			music1_patterned = 0;
		end
		
	end

	always@(negedge LRCK_1X)begin
		music2_patterned = $signed(music2_ramp) >>> 2;
	end

		//1s : 48000
		//drum
	always@(negedge LRCK_1X)begin
		if (counter_r[3] < QUARTER)
			music3_patterned = (music3_ramp << 1) / ((counter_r[3] >> 6)+1)<<1;
		else if (counter_r[3] < (SAMPLE_RATE)) 
			music3_patterned = (music3_ramp << 1) / ((counter_r[3] >> 6)-375)<<1;
		else if (counter_r[3] < (SAMPLE_RATE + (QUARTER >> 1))) 
			music3_patterned = (music3_ramp << 1) / ((counter_r[3] >> 6)-750)<<1;
		else if (counter_r[3] < (SAMPLE_RATE + QUARTER))  
			music3_patterned = (music3_ramp << 1) / ((counter_r[3] >> 6)-937)<<1;
		else if (counter_r[3] < (SECTION)) 
			music3_patterned = (music3_ramp << 1) / ((counter_r[3] >> 6)-1125)<<1;
		else
			music3_patterned = 0;
	end
	//1s : 48000
	reg [15:0] music4_combine;
	always@(negedge LRCK_1X)begin
		music4_combine = music4_ramp_1 + ($signed(music4_ramp_2) >>> 1);

		if (counter_r[4] <= QUARTER)
			music4_patterned = ((music4_combine << 1)/ ((counter_r[4] >> 8)+1));
		else if (counter_r[4] < (SAMPLE_RATE)) 
			music4_patterned = ((music4_combine << 1)/ ((counter_r[4] >> 8)-92));
		else if (counter_r[4] < QUARTER + SAMPLE_RATE)
			music4_patterned = ((music4_combine << 1)/ ((counter_r[4] >> 8)-186));
		else begin
			music4_patterned = ((music4_combine << 1)/ ((counter_r[4] >> 8)-280));
		end
		
	end

	always@(negedge LRCK_1X)begin
		if ((QUARTER-1000 <= counter_r[5]) && (counter_r[5] <= QUARTER))
			music5_patterned = 0;
		else if ((SAMPLE_RATE-1000 <= counter_r[5]) && (counter_r[5] <= SAMPLE_RATE))
			music5_patterned = 0;
		else if ((SAMPLE_RATE + QUARTER -1000 <= counter_r[5]) && (counter_r[5] <= SAMPLE_RATE + QUARTER))
			music5_patterned = 0;
		else if ((SECTION-1000 <= counter_r[5]) && (counter_r[5] <= SECTION))
			music5_patterned = 0;
		else
			music5_patterned = $signed(music5_ramp) >>> 2;
	end

	//star
	always@(negedge LRCK_1X)begin
		if (((QUARTER>>1)-1000 <= counter_r[6]) && (counter_r[6] <= (QUARTER>>1)))
			music6_patterned = 0;
		else if(((QUARTER)-1000 <= counter_r[6]) && (counter_r[6] <= (QUARTER)))
			music6_patterned = 0;
		else if(((QUARTER + (QUARTER >> 1))-1000 <= counter_r[6]) && (counter_r[6] <= (QUARTER+ (QUARTER >> 1))))
			music6_patterned = 0;
		else if(((SAMPLE_RATE)-1000 <= counter_r[6]) && (counter_r[6] <= (SAMPLE_RATE)))
			music6_patterned = 0;
		else if(((SAMPLE_RATE + (QUARTER >> 1)-1000) <= counter_r[6]) && (counter_r[6] <= (SAMPLE_RATE + (QUARTER >> 1))))
			music6_patterned = 0;
		else if(((SAMPLE_RATE + QUARTER -1000) <= counter_r[6]) && (counter_r[6] <= (SAMPLE_RATE + QUARTER)))
			music6_patterned = 0;
		else if(((SECTION - 1000) <= counter_r[6]) && (counter_r[6] <= (SECTION)))
			music6_patterned = 0;
		else
			music6_patterned = $signed(music6_ramp) >>> 2;
	end

	//1s : 48000
	//drum 2
	always@(negedge LRCK_1X)begin
		if (counter_r[7] < SAMPLE_RATE)
			music7_patterned = (music7_ramp << 3) / ((counter_r[7] >> 3)+1)<<1;
		else if (counter_r[7] < (SAMPLE_RATE + (QUARTER >> 1))) 
			music7_patterned = (music7_ramp << 3) / ((counter_r[7] >> 3)-5999)<<1;
		else if (counter_r[7] < (SAMPLE_RATE + QUARTER))  
			music7_patterned = (music7_ramp << 3) / ((counter_r[7] >> 3)-7499)<<1;
		else
			music7_patterned = 0;
	end


////////////Ramp address assign//////////////
	wire [5:0]ramp1_ramp= ramp1[15:10];
	wire [5:0]ramp2_ramp= ramp2[15:10];
	wire [5:0]ramp3_ramp= ramp3[15:10];
	wire [5:0]ramp4_1_ramp= ramp4_1[15:10];
	wire [5:0]ramp4_2_ramp= ramp4_2[15:10];
	wire [5:0]ramp5_ramp= ramp5[15:10];
	wire [5:0]ramp6_ramp= ramp6[15:10];
	wire [5:0]ramp7_ramp= ramp7[15:10];
	

	wire [15:0] music1_ramp,music2_ramp,music3_ramp;
	wire [15:0] music4_ramp_1,music4_ramp_2;
	wire [15:0] music5_ramp,music6_ramp,music7_ramp;


//wave extraction
	wave_gen_string r1(
		.ramp(ramp1_ramp),
		.music_o(music1_ramp)
	);

	wave_gen_square r2(
		.ramp(ramp2_ramp),
		.music_o(music2_ramp)
	);

	wave_gen_string r3(
		.ramp(ramp3_ramp),
		.music_o(music3_ramp)
	);

	//mix
	wave_gen_sin r4_1(
		.ramp(ramp4_1_ramp),
		.music_o(music4_ramp_1)
	);

	wave_gen_sin r4_2(
		.ramp(ramp4_2_ramp),
		.music_o(music4_ramp_2)
	);

	wave_gen_brass r5(
		.ramp(ramp5_ramp),
		.music_o(music5_ramp)
	);

	ramp_wave_gen r6(
		.ramp(ramp6_ramp),
		.music_o(music6_ramp)
	);

	wave_gen_sin r7(
		.ramp(ramp7_ramp),
		.music_o(music7_ramp)
	);



///////////// Piano /////////////

wire [15:0]music_piano,music_sel,sum_sin,sum_sqr,sum_bra,sum_ram,sum_str,sum_sin_c;
wire [15:0]sum_sqr_c,sum_bra_c,sum_ram_c;
//assign sum_sin = $signed($signed($signed(music_sin1 + music_sin2 + music_sin3 + music_sin4)) * volume_piano_r) >>> 3;
//assign sum_sqr = $signed($signed($signed(music_sqr1 + music_sqr2 + music_sqr3 + music_sqr4)) * volume_piano_r) >>> 3;
assign sum_sin = $signed(music_sin1 + music_sin2 + music_sin3 + music_sin4);
assign sum_sqr = $signed(music_sqr1 + music_sqr2 + music_sqr3 + music_sqr4);
assign sum_bra = $signed(music_bra1 + music_bra2 + music_bra3 + music_bra4);
assign sum_ram = $signed(music_ram1 + music_ram2 + music_ram3 + music_ram4);
assign sum_str = $signed(music_str1 + music_str2 + music_str3 + music_str4);
assign sum_sin_c = $signed(music_sin1_patterned + music_sin2_patterned + music_sin3_patterned + music_sin4_patterned);
assign sum_sqr_c = $signed(music_sqr1_patterned + music_sqr2_patterned + music_sqr3_patterned + music_sqr4_patterned);
assign sum_bra_c = $signed(music_bra1_patterned + music_bra2_patterned + music_bra3_patterned + music_bra4_patterned);
assign sum_ram_c = $signed(music_ram1_patterned + music_ram2_patterned + music_ram3_patterned + music_ram4_patterned);

assign music_sel =  (instru_sel_r == 1) ? sum_sin:(
					(instru_sel_r == 2) ? sum_sqr:(
					(instru_sel_r == 3) ? sum_bra:(
					(instru_sel_r == 4) ? sum_ram:(
					(instru_sel_r == 5) ? sum_str:(
					(instru_sel_r == 6) ? sum_sin_c:(
					(instru_sel_r == 7) ? sum_sqr_c:(
					(instru_sel_r == 8) ? sum_bra_c:(
					(instru_sel_r == 9) ? sum_ram_c:(
					
	0)))))))));
assign music_piano = $signed($signed(music_sel) * volume_piano_r) >>> 3;
					 
wire [15:0]music_sin1,music_sin2,music_sin3,music_sin4;
assign music_sin1 = (piano_on[0]) ?  $signed(music1_sin_piano) >>> 2 : 0;
assign music_sin2 = (piano_on[1]) ?  $signed(music2_sin_piano) >>> 2 : 0;
assign music_sin3 = (piano_on[2]) ?  $signed(music3_sin_piano) >>> 2 : 0;
assign music_sin4 = (piano_on[3]) ?  $signed(music4_sin_piano) >>> 2 : 0;

wire [15:0]music_sqr1,music_sqr2,music_sqr3,music_sqr4;
assign music_sqr1 = (piano_on[0]) ?  $signed(music1_sqr_piano) >>> 2 : 0;
assign music_sqr2 = (piano_on[1]) ?  $signed(music2_sqr_piano) >>> 2 : 0;
assign music_sqr3 = (piano_on[2]) ?  $signed(music3_sqr_piano) >>> 2 : 0;
assign music_sqr4 = (piano_on[3]) ?  $signed(music4_sqr_piano) >>> 2 : 0;

wire [15:0]music_bra1,music_bra2,music_bra3,music_bra4;
assign music_bra1 = (piano_on[0]) ?  $signed(music1_bra_piano) >>> 3 : 0;
assign music_bra2 = (piano_on[1]) ?  $signed(music2_bra_piano) >>> 3 : 0;
assign music_bra3 = (piano_on[2]) ?  $signed(music3_bra_piano) >>> 3 : 0;
assign music_bra4 = (piano_on[3]) ?  $signed(music4_bra_piano) >>> 3 : 0;

wire [15:0]music_ram1,music_ram2,music_ram3,music_ram4;
assign music_ram1 = (piano_on[0]) ?  $signed(music1_ram_piano) >>> 3 : 0;
assign music_ram2 = (piano_on[1]) ?  $signed(music2_ram_piano) >>> 3 : 0;
assign music_ram3 = (piano_on[2]) ?  $signed(music3_ram_piano) >>> 3 : 0;
assign music_ram4 = (piano_on[3]) ?  $signed(music4_ram_piano) >>> 3 : 0;

wire [15:0]music_str1,music_str2,music_str3,music_str4;
assign music_str1 = (piano_on[0]) ?  $signed(music1_str_piano) >>> 2 : 0;
assign music_str2 = (piano_on[1]) ?  $signed(music2_str_piano) >>> 2 : 0;
assign music_str3 = (piano_on[2]) ?  $signed(music3_str_piano) >>> 2 : 0;
assign music_str4 = (piano_on[3]) ?  $signed(music4_str_piano) >>> 2 : 0;



wire [3:0] piano_on;
wire [1:0] channel_num;
assign piano_on[0] = (sound1 >= 100);
assign piano_on[1] = (sound2 >= 100);
assign piano_on[2] = (sound3 >= 100);
assign piano_on[3] = (sound4 >= 100);
assign channel_num = piano_on[0] + piano_on[1] + piano_on[2] + piano_on[3];

///// instru management

reg [3:0] instru_sel_r,instru_sel_w;

always @(*) begin
	if (key1_code == 8'h69 && (key1_last != 8'h69)) //press down 1
		instru_sel_w = 1;
	else if (key1_code == 8'h72 && (key1_last != 8'h72)) //press down 2
		instru_sel_w = 2;
	else if (key1_code == 8'h7a && (key1_last != 8'h7a)) //press down 3
		instru_sel_w = 3;
	else if (key1_code == 8'h6b && (key1_last != 8'h6b)) //press down 4
		instru_sel_w = 4;
	else if (key1_code == 8'h73 && (key1_last != 8'h73)) //press down 5
		instru_sel_w = 5;
	else if (key1_code == 8'h74 && (key1_last != 8'h74)) //press down 6
		instru_sel_w = 6;
	else if (key1_code == 8'h6c && (key1_last != 8'h6c)) //press down 7
		instru_sel_w = 7;
	else if (key1_code == 8'h75 && (key1_last != 8'h75)) //press down 8
		instru_sel_w = 8;
	else if (key1_code == 8'h7d && (key1_last != 8'h7d)) //press down 9
		instru_sel_w = 9;
	else begin
		instru_sel_w = instru_sel_r;
	end
end

always@(posedge iCLK_18_4 or negedge iRST_N)
begin
	if(!iRST_N)
	begin
		instru_sel_r <= 0;
	end else begin
		instru_sel_r <= instru_sel_w;
	end
end

////// volume management

reg [2:0] volume_piano_r ;
reg [2:0] volume_piano_w ;

always@(*)begin
	
	if (((key1_code == 8'h79) && (key1_last != 8'h79))) begin //press +
		volume_piano_w = volume_piano_r + 1;
	end else if (((key1_code == 8'h7b) && (key1_last != 8'h7b))) begin //press -
		volume_piano_w = volume_piano_r - 1;
	end else
		volume_piano_w = volume_piano_r;
	
end

always@(posedge iCLK_18_4 or negedge iRST_N)
begin
	if(!iRST_N)
	begin
		
		volume_piano_r	<= 4;
	end else begin
		
		volume_piano_r	<= volume_piano_w;
	end
end




///// freq management
reg [15:0] ramp1_piano,ramp2_piano,ramp3_piano,ramp4_piano;

always@(negedge iRST_N or negedge LRCK_1X)begin
	if (!iRST_N)
		ramp1_piano=0;
	else if (ramp1_piano>ramp_max) ramp1_piano=0;
	else ramp1_piano= ramp1_piano + sound1;
end
always@(negedge iRST_N or negedge LRCK_1X)begin
	if (!iRST_N)
		ramp2_piano=0;
	else if (ramp2_piano>ramp_max) ramp2_piano=0;
	else ramp2_piano= ramp2_piano + sound2;
end
always@(negedge iRST_N or negedge LRCK_1X)begin
	if (!iRST_N)
		ramp3_piano=0;
	else if (ramp3_piano>ramp_max) ramp3_piano=0;
	else ramp3_piano= ramp3_piano + sound3;
end
always@(negedge iRST_N or negedge LRCK_1X)begin
	if (!iRST_N)
		ramp4_piano=0;
	else if (ramp4_piano>ramp_max) ramp4_piano=0;
	else ramp4_piano= ramp4_piano + sound4;
end

// pattern management
reg [15:0] music_sin1_patterned;
reg [15:0] music_sin2_patterned;
reg [15:0] music_sin3_patterned;
reg [15:0] music_sin4_patterned;
reg [15:0] music_sqr1_patterned;
reg [15:0] music_sqr2_patterned;
reg [15:0] music_sqr3_patterned;
reg [15:0] music_sqr4_patterned;
reg [15:0] music_bra1_patterned;
reg [15:0] music_bra2_patterned;
reg [15:0] music_bra3_patterned;
reg [15:0] music_bra4_patterned;
reg [15:0] music_ram1_patterned;
reg [15:0] music_ram2_patterned;
reg [15:0] music_ram3_patterned;
reg [15:0] music_ram4_patterned;

reg  [20:0] counter_sin_r [0:3];
reg  [20:0] counter_sin_w [0:3];
wire [3:0] key_on;
assign key_on[0] = key1_on;
assign key_on[1] = key2_on;
assign key_on[2] = key3_on;
assign key_on[3] = key4_on;
reg  [3:0] sound_last;


always@(*)begin
	for (i=0 ; i<=3 ; i=i+1) begin
		
		
		if ((key_on[i]) && (!sound_last[i])) 
			counter_sin_w[i] = 0;
		else if ((counter_sin_r[i] >= SECTION))
			counter_sin_w[i] = counter_sin_r[i];
		else
			counter_sin_w[i] = counter_sin_r[i] + 1;

	end


end

always@(negedge iRST_N or negedge LRCK_1X)begin
	if(!iRST_N) begin
		for (i=0 ; i<=3 ; i=i+1) begin
			counter_sin_r[i] <= 0;
			sound_last[i] <= 0;
		end
		
	end else begin
		for (i=0 ; i<=3 ; i=i+1) begin
			counter_sin_r[i] <= counter_sin_w[i];
		end

		sound_last[0] <= key1_on;
		sound_last[1] <= key2_on;
		sound_last[2] <= key3_on;
		sound_last[3] <= key4_on;
	end
end

always @(*)begin
	music_sin1_patterned = $signed($signed(music1_sin_piano) >>> 1) >>> ($signed(counter_sin_r[0]) >>> 11);
	music_sin2_patterned = $signed($signed(music2_sin_piano) >>> 1) >>> ($signed(counter_sin_r[1]) >>> 11);
	music_sin3_patterned = 0;
	music_sin4_patterned = 0;
end

always @(*)begin
	music_sqr1_patterned = $signed($signed(music1_sqr_piano) >>> 1) >>> ($signed(counter_sin_r[0]) >>> 11);
	music_sqr2_patterned = $signed($signed(music2_sqr_piano) >>> 1) >>> ($signed(counter_sin_r[1]) >>> 11);
	music_sqr3_patterned = 0;
	music_sqr4_patterned = 0;
end

always @(*)begin
	music_bra1_patterned = $signed($signed(music1_sin_piano) >>> 1) >>> ($signed(counter_sin_r[0]) >>> 13);
	music_bra2_patterned = $signed($signed(music2_sin_piano) >>> 1) >>> ($signed(counter_sin_r[1]) >>> 13);
	music_bra3_patterned = 0;
	music_bra4_patterned = 0;
end

always @(*)begin
	music_ram1_patterned = $signed($signed(music1_ram_piano) >>> 1) >>> ($signed(counter_sin_r[0]) >>> 13);
	music_ram2_patterned = $signed($signed(music2_ram_piano) >>> 1) >>> ($signed(counter_sin_r[1]) >>> 13);
	music_ram3_patterned = 0;
	music_ram4_patterned = 0;
end

// wave generation
wire [15:0] music1_sin_piano;
wire [15:0] music2_sin_piano;
wire [15:0] music3_sin_piano;
wire [15:0] music4_sin_piano;
wire [15:0] music1_sqr_piano;
wire [15:0] music2_sqr_piano;
wire [15:0] music3_sqr_piano;
wire [15:0] music4_sqr_piano;
wire [15:0] music1_bra_piano;
wire [15:0] music2_bra_piano;
wire [15:0] music3_bra_piano;
wire [15:0] music4_bra_piano;
wire [15:0] music1_ram_piano;
wire [15:0] music2_ram_piano;
wire [15:0] music3_ram_piano;
wire [15:0] music4_ram_piano;
wire [15:0] music1_str_piano;
wire [15:0] music2_str_piano;
wire [15:0] music3_str_piano;
wire [15:0] music4_str_piano;

wire [5:0]ramp1_piano_ramp= ramp1_piano[15:10];
wire [5:0]ramp2_piano_ramp= ramp2_piano[15:10];
wire [5:0]ramp3_piano_ramp= ramp3_piano[15:10];
wire [5:0]ramp4_piano_ramp= ramp4_piano[15:10];

wave_gen_sin p1(
	.ramp(ramp1_piano_ramp),
	.music_o(music1_sin_piano)
);
wave_gen_sin p2(
	.ramp(ramp2_piano_ramp),
	.music_o(music2_sin_piano)
);
wave_gen_sin p3(
	.ramp(ramp3_piano_ramp),
	.music_o(music3_sin_piano)
);
wave_gen_sin p4(
	.ramp(ramp4_piano_ramp),
	.music_o(music4_sin_piano)
);
///////////////////
wave_gen_square p5(
	.ramp(ramp1_piano_ramp),
	.music_o(music1_sqr_piano)
);
wave_gen_square p6(
	.ramp(ramp2_piano_ramp),
	.music_o(music2_sqr_piano)
);
wave_gen_square p7(
	.ramp(ramp3_piano_ramp),
	.music_o(music3_sqr_piano)
);
wave_gen_square p8(
	.ramp(ramp4_piano_ramp),
	.music_o(music4_sqr_piano)
);
///////////////////
wave_gen_brass p54(
	.ramp(ramp1_piano_ramp),
	.music_o(music1_bra_piano)
);
wave_gen_brass p63(
	.ramp(ramp2_piano_ramp),
	.music_o(music2_bra_piano)
);
wave_gen_brass p72(
	.ramp(ramp3_piano_ramp),
	.music_o(music3_bra_piano)
);
wave_gen_brass p81(
	.ramp(ramp4_piano_ramp),
	.music_o(music4_bra_piano)
);
///////////////////
ramp_wave_gen p51(
	.ramp(ramp1_piano_ramp),
	.music_o(music1_ram_piano)
);
ramp_wave_gen p62(
	.ramp(ramp2_piano_ramp),
	.music_o(music2_ram_piano)
);
ramp_wave_gen p73(
	.ramp(ramp3_piano_ramp),
	.music_o(music3_ram_piano)
);
ramp_wave_gen p84(
	.ramp(ramp4_piano_ramp),
	.music_o(music4_ram_piano)
);
///////////////////
wave_gen_string p55(
	.ramp(ramp1_piano_ramp),
	.music_o(music1_str_piano)
);
wave_gen_string p66(
	.ramp(ramp2_piano_ramp),
	.music_o(music2_str_piano)
);
wave_gen_string p77(
	.ramp(ramp3_piano_ramp),
	.music_o(music3_str_piano)
);
wave_gen_string p88(
	.ramp(ramp4_piano_ramp),
	.music_o(music4_str_piano)
);

//////////// drum /////////////


reg [23:0] drum_r,drum_w;
always@(*)begin
		if ((key1_code == 8'h32) && (key1_last_lrck != 8'h32)) //b 
			drum_w = 0;
		else if ((drum_r[i] >= SECTION))
			drum_w = drum_r;
		else
			drum_w = drum_r + 1;

end

reg [23:0] drum2_r,drum2_w;
always@(*)begin
		if ((key1_code == 8'h31) && (key1_last_lrck != 8'h31)) //n 
			drum2_w = 0;
		else if ((drum2_r[i] >= SECTION))
			drum2_w = drum2_r;
		else
			drum2_w = drum2_r + 1;

end

always@(negedge iRST_N or negedge LRCK_1X)begin
	if(!iRST_N) begin
		drum_r <= 0;
		drum2_r <= 0;
	end else begin
		drum_r <= drum_w;
		drum2_r <= drum2_w;
	end
end

//////
reg [15:0] ramp_drum,ramp_drum_max;
always@(negedge iRST_N or negedge LRCK_1X)begin
	ramp_drum_max = ramp_drum + 150 - (drum_r >>> 3);
	if (!iRST_N)
		ramp_drum =0;
	else if (ramp_drum > ramp_max) ramp_drum =0;
	else ramp_drum = ramp_drum_max;
end

reg [15:0] ramp_drum2,ramp_drum2_max;
always@(negedge iRST_N or negedge LRCK_1X)begin
	ramp_drum2_max = ramp_drum2 + 500 - (drum2_r >>> 3);
	if (!iRST_N)
		ramp_drum2 =0;
	else if (ramp_drum2 > ramp_max) ramp_drum2 =0;
	else ramp_drum2 = ramp_drum2_max;
end

//2/////


wire [15:0] music_drum;
assign music_drum = music_drum1 + music_drum2;

reg [15:0] music_drum1,music_drum2;

always @(*) begin
	music_drum1 = $signed(music_drum_ramp << 2) >>> ((drum_r >> 9)+1);
end

always @(*) begin
	music_drum2 = $signed(music_drum2_ramp << 2) >>> ((drum2_r >> 9)+1);
end

////////
wire [5:0]ramp_drum_ramp= ramp_drum[15:10];
wire [5:0]ramp_drum2_ramp= ramp_drum2[15:10];
wire [15:0] music_drum_ramp,music_drum2_ramp;

wave_gen_string r39(
	.ramp(ramp_drum_ramp),
	.music_o(music_drum_ramp)
);
wave_gen_string r486(
	.ramp(ramp_drum2_ramp),
	.music_o(music_drum2_ramp)
);


endmodule