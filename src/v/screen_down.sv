module down(
	input clk,
    input reset,
    input [11:0] CounterX,
    input [11:0] CounterY,
    input [2:0]  sel,
	input [7:0]  play,
	input [23:0] vol_i,
	input [23:0] freq_i,
    output [7:0] o_r,
    output [7:0] o_g,
    output [7:0] o_b
);
    reg [3:0] state_r, state_w;
    reg [10:0] cnt_r, cnt_w;   
    reg [2:0] random_r, random_w;
    reg [7:0] r_reg[0:7], g_reg[0:7], b_reg[0:7];
    reg [7:0] o_r1, o_g1, o_b1;
    reg [7:0] o_r2, o_g2, o_b2;
    wire [2:0] vol[0:6];
    reg [2:0] vol_r[0:6], vol_w[0:6];
    parameter IDLE = 0;
    parameter PLAY = 1;

    parameter ORI_X1 = 45;
    parameter ORI_Y1 = 380;
    parameter DIS_1 = 90;
    parameter LINE_A = 45;
    parameter LINE_B = 40;

    parameter ORI_X2 = 5;
    parameter ORI_Y2 = 420;
    parameter DIS_2 = 90;
    parameter LINE_X = 80;
    parameter LINE_Y = 11;
    int i, j, k;

	genvar gi;
	generate
		for (gi=6; gi>=0; gi=gi-1) begin : in
            assign vol[gi] = vol_i[3 + gi*3 +: 3];
        end
	endgenerate

    assign o_r = o_r1 + o_r2;
    assign o_g = o_g1 + o_g2;
    assign o_b = o_b1 + o_b2;

    parameter red_r = 255, red_g = 192, red_b = 203; //粉紅
    parameter org_r = 255, org_g = 0, org_b = 255;    //深紅
    parameter yel_r = 135, yel_g = 38, yel_b = 87;   //草莓
    parameter gre_r = 160, gre_g = 32, gre_b = 240;     //紫
    parameter blu_r = 153, blu_g = 51, blu_b = 250;     //湖紫
    parameter ind_r = 135, ind_g = 206, ind_b = 235;   //天藍
    parameter pur_r = 0, pur_g = 255, pur_b = 255;  //青
    parameter whi_r = 189, whi_g = 252, whi_b = 201;  //薄荷
    always @(*) begin
        state_w = state_r;
        cnt_w = cnt_r;
        random_w = random_r * 3 + 5;
        for(k = 0 ; k < 7 ; k++) vol_w[k] = vol_r[k];

        r_reg[0] = red_r; g_reg[0] = red_g; b_reg[0] = red_b;
        r_reg[1] = org_r; g_reg[1] = org_g; b_reg[1] = org_b;
        r_reg[2] = yel_r; g_reg[2] = yel_g; b_reg[2] = yel_b;
        r_reg[3] = gre_r; g_reg[3] = gre_g; b_reg[3] = gre_b;
        r_reg[4] = blu_r; g_reg[4] = blu_g; b_reg[4] = blu_b;
        r_reg[5] = ind_r; g_reg[5] = ind_g; b_reg[5] = ind_b;
        r_reg[6] = pur_r; g_reg[6] = pur_g; b_reg[6] = pur_b;
        r_reg[7] = whi_r; g_reg[7] = whi_g; b_reg[7] = whi_b;                

        o_r1 = 0; o_r2 = 0; o_g1 = 0; o_g2 = 0; o_b1 = 0; o_b2 = 0;
        for(k = 0 ; k < 7 ; k++) vol_w[k] = vol[k];             
        for (i = 0 ; i < 7 ; i++) begin              
            if( (play[i+1]) && 
                (CounterX>=ORI_X1+i*DIS_1-LINE_A) && (CounterX<=(ORI_X1+i*DIS_1+LINE_A)) &&
                (CounterY>=ORI_Y1-LINE_A) && (CounterY<=(ORI_Y1+LINE_A))) begin
                o_r1 = r_reg[random_r+i]; o_g1 = g_reg[random_r+i]; o_b1 = b_reg[random_r+i];
            end
            if( (play[i+1]) && 
                ((CounterX>=ORI_X1+i*DIS_1-LINE_B) && (CounterX<=(ORI_X1+i*DIS_1+LINE_B))) &&
                ((CounterY>=ORI_Y1-LINE_B) && (CounterY<=(ORI_Y1+LINE_B)))) begin
                o_r1 = 0; o_g1 = 0; o_b1 = 0;
            end           
            if( (play[i+1]) && vol_r[i] != 0 &&
                (CounterX>=ORI_X2+i*DIS_2) && (CounterX<=ORI_X2+i*DIS_2+LINE_X) && 
                (CounterY<=ORI_Y2) && (CounterY>=ORI_Y2-LINE_Y*vol_r[i]) ) begin
                o_r1 = r_reg[random_r+i]; o_g1 = g_reg[random_r+i]; o_b1 = b_reg[random_r+i];
            end            
            if( (sel[2:0] == i+1) &&
                (CounterX>=ORI_X1+i*DIS_1-LINE_A) && (CounterX<=(ORI_X1+i*DIS_1+LINE_A)) &&
                (CounterY>=ORI_Y1+LINE_A) && (CounterY<=(ORI_Y1+LINE_A+5))) begin
                o_r1 = 255; o_g1 = 255; o_b1 = 255;
            end
        end
    end
    always @(negedge reset or posedge clk) begin
        if(!reset) begin
            cnt_r = 0;
            state_r = IDLE;
            random_r = 0;
            for(k = 0 ; k < 7 ; k++) vol_r[k] = 0;
        end
        else begin
            cnt_r = cnt_w;
            state_r = state_w;
            random_r = random_w;
            for(k = 0 ; k < 7 ; k++) vol_r[k] = vol_w[k];
        end
    end
endmodule