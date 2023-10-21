module up(
	input clk,
    input reset,
    input [11:0] CounterX,
    input [11:0] CounterY,
    input [2:0] sel,
    input [7:0]  play,
	input [23:0] vol_i,
	input [23:0] freq_i,
    output [7:0] o_r,
    output [7:0] o_g,
    output [7:0] o_b
);
    reg [3:0] state_r, state_w;
    reg [10:0] cnt_r, cnt_w;
    reg [11:0] line_y_r [19:0], line_y_w [19:0];
    wire [2:0] vol[0:6], freq[0:6];
    reg [2:0] vol_ave_r, vol_ave_w;
    reg [2:0] freq_ave_r, freq_ave_w;
    reg [7:0] r_r[19:0], r_w[19:0];
    reg [7:0] g_r[19:0], g_w[19:0];
    reg [7:0] b_r[19:0], b_w[19:0];
    reg [7:0] o_r1, o_g1, o_b1;
    parameter IDLE = 0;
    parameter PLAY = 1;
    parameter ORI_X = 0;
    parameter ORI_Y = 150;
    parameter LINE_X1 = 32;
    parameter LINE_X2 = 28;
    parameter LINE_Y = 20;
    int i;

    genvar gi;
	generate
		for (gi=6; gi>=0; gi=gi-1) begin : in
            assign vol[gi] = vol_i[3 + gi*3 +: 3];
            assign freq[gi] = freq_i[3 + gi*3 +: 3];
        end
	endgenerate

    assign o_r = o_r1 ;
    assign o_g = o_g1;
    assign o_b = o_b1;
    parameter c1_r = 255, c1_g = 255, c1_b = 0; //黃
    parameter c2_r = 160, c2_g = 32, c2_b = 240;   //紫
    always @(*) begin
        state_w = state_r;
        vol_ave_w = vol_ave_r;
        freq_ave_w = freq_ave_r;       
        for (i = 0 ; i < 20 ; i++) line_y_w[i] = line_y_r[i];
        o_r1 = 0; o_g1 = 0; o_b1 = 0;
        cnt_w = cnt_r + 1;  
        line_y_w[19] = vol_ave_r * LINE_Y;
                            
        r_w[19] = r_r[19]; g_w[19] = g_r[19]; b_w[19] = b_r[19];
        for (i = 0 ; i < 19 ; i++) begin
            line_y_w[i] = line_y_r[i+1];
            r_w[i] = r_r[i+1]; g_w[i] = g_r[i+1]; b_w[i] = b_r[i+1];
        end
        if(cnt_r >= 7-freq_ave_r) begin 
            if(r_r[19] == c2_r) begin r_w[19] = c1_r; g_w[19] = c1_g; b_w[19] = c1_b; end
            else               begin r_w[19] = c2_r; g_w[19] = c2_g; b_w[19] = c2_b; end
            if(play[sel]) begin
                vol_ave_w = vol[sel-1];
                freq_ave_w = freq[sel-1];
            end
            else begin
                vol_ave_w = 0;
                freq_ave_w = 0;
            end
            cnt_w = 0; 
        end
        for (i = 0 ; i < 20 ; i++) begin
            if((CounterX>=ORI_X+i*LINE_X1) && (CounterX<ORI_X+i*LINE_X1+LINE_X2) && 
            (CounterY<ORI_Y) && (CounterY>=(ORI_Y-line_y_r[i]))) begin   
                o_r1=r_r[i]; o_g1=g_r[i]; o_b1=b_r[i];
            end
        end
    end
    always @(negedge reset or posedge clk) begin
        if(!reset) begin
            cnt_r = 0;
            vol_ave_r = 0;
            freq_ave_r = 0;
            state_r = IDLE;
            for (i = 0 ; i < 20 ; i++) begin 
                line_y_r[i] = 0;
                r_r[i] = 0;
                g_r[i] = 0;
                b_r[i] = 0;
            end
        end
        else begin
            cnt_r = cnt_w;
            vol_ave_r = vol_ave_w;
            freq_ave_r = freq_ave_w;
            state_r = state_w;
            for (i = 0 ; i < 20 ; i++) begin 
                line_y_r[i] = line_y_w[i];
                r_r[i] = r_w[i];
                g_r[i] = g_w[i];
                b_r[i] = b_w[i];
            end
        end
    end
endmodule