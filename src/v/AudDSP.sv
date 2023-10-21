module AudDSP (
	input   i_rst_n,
	input   i_clk,
	input   i_start,
	input   i_pause,
	input   i_stop,
	input   [2:0] i_speed,
	input   i_fast,
	input   i_slow_0, // constant interpolation
	input   i_slow_1, // linear interpolation
	input   i_daclrck,
    input   [20:0] i_end_addr,
	input   [15:0] i_sram_data,
	output  [15:0] o_dac_data,
	output  [20:0] o_sram_addr,
	output [2:0]   o_state
);

parameter S_IDLE 	 = 3'd0;
parameter S_FAST 	 = 3'd1;
parameter S_SL_INIT	 = 3'd2;
parameter S_SLOW_0   = 3'd3;
parameter S_SLOW_1   = 3'd4;
parameter S_PAUSE	 = 3'd5;

logic [2:0] state_r,state_w;
logic [20:0] sram_addr_r, sram_addr_w, sram_out;
logic signed [16:0] pre_data_r, pre_data_w, pre_data_tmp;
logic signed [16:0] cur_data_r, cur_data_w;
logic signed [16:0] out_data;
logic [3:0] counter_r,counter_w;
logic daclrck_dly, clkneg;
logic finish_r, finish_w;
logic start_flag_r, start_flag_w;


assign clkneg = ~i_daclrck & daclrck_dly;
assign o_dac_data = out_data;
assign o_sram_addr = sram_out;
assign o_state = state_r;
//FSM
always_comb begin
    state_w = state_r;
	finish_w = finish_r;
	start_flag_w = start_flag_r;
	case (state_r)
	    S_IDLE: begin
		 start_flag_w = 0;
		 finish_w = 0;
            if(i_start && finish_r == 0) start_flag_w = 1;
			if(start_flag_r) begin
                state_w = S_SL_INIT;
            end
        end
		S_SL_INIT: begin
			if(clkneg) begin
				if (i_slow_0) state_w = S_SLOW_0;
                else if (i_slow_1) state_w = S_SLOW_1;
                else   state_w = S_FAST;
			end
		end
        S_SLOW_0: begin
			if (i_stop)  state_w = S_IDLE;
	    	else if (i_pause) state_w = S_PAUSE;
			else if(counter_r >= i_speed) state_w = S_SL_INIT;
			else state_w = S_SLOW_0;
         if (sram_out >= i_end_addr) begin
			state_w = S_IDLE;
			finish_w = 1;
			end
        end
        S_SLOW_1: begin
            if (i_stop)  state_w = S_IDLE;
	    	else if (i_pause) state_w = S_PAUSE;
			else if(counter_r >= i_speed) state_w = S_SL_INIT;
			else state_w = S_SLOW_1;
         if (sram_out >= i_end_addr) begin
			state_w = S_IDLE;
			finish_w = 1;
			end
        end
        S_FAST: begin
			start_flag_w = 0;
            if (i_stop)  state_w = S_IDLE;
	    	else if (i_pause) state_w = S_PAUSE;
            else if (sram_out >= i_end_addr) begin
				state_w = S_IDLE;
				finish_w = 1;
			end
			else state_w = S_SL_INIT;
        end
        S_PAUSE: begin
            if(i_stop) state_w = S_IDLE;
            else if(i_start) begin
                if(i_slow_0) state_w = S_SLOW_0;
                else if(i_slow_1) state_w = S_SLOW_1;
                else   state_w = S_FAST;
            end
        end
        default begin
			start_flag_w = start_flag_r;
			state_w = state_r;
        end
    endcase
end
// sram address
always_comb begin
    sram_addr_w = sram_out;
    case (state_r)
        S_IDLE: sram_addr_w = 0;
		S_FAST: begin
			sram_addr_w = i_fast ? sram_addr_r + {17'b0, ({1'b0, i_speed} + 4'd1)} : sram_addr_r + 21'd1;
		end
		S_SLOW_0: begin
			if(counter_r >= i_speed) sram_addr_w = sram_addr_r + 1;
		end
		S_SLOW_1: begin
			if(counter_r >= i_speed) sram_addr_w = sram_addr_r + 1;
		end
		default sram_addr_w = sram_out;
	endcase
end

// sram data
always_comb begin
	cur_data_w = cur_data_r;
	pre_data_w = pre_data_r;
	counter_w = counter_r;
	out_data = 0;
    case (state_r)
        S_IDLE: begin
            counter_w = 0;
            pre_data_w = 0;
            cur_data_w = 0;
				out_data = 0;
        end
		S_FAST: begin
			out_data = cur_data_r;
			cur_data_w = i_sram_data;
			pre_data_w = cur_data_r;
		end
		S_SL_INIT: begin
			counter_w = 4'b0;
			pre_data_w = pre_data_tmp;
			out_data = pre_data_tmp;
		end
		S_SLOW_0: begin
            	if (counter_r < i_speed) begin
					counter_w = counter_r + 1;
					out_data = pre_data_r;
				end
				else begin
					counter_w = 4'b0;
					cur_data_w = i_sram_data;
					pre_data_w = cur_data_r;	
				end
		end
		S_SLOW_1: begin
				out_data = $signed(pre_data_r) + $signed(cur_data_r - pre_data_r) / $signed({13'b0, ({1'b0, i_speed} + 4'd1)}) * $signed({13'b0, counter_r});
				if (counter_r < i_speed) begin
					counter_w = counter_r + 1;
					
				end
				else begin
					counter_w = 4'b0;
					cur_data_w = i_sram_data;
					pre_data_w = cur_data_r;
            	end
		end
		S_PAUSE: begin
			out_data = 0;
			// cur_data_w = 0;
		end
	endcase
end

always_ff @(negedge  i_clk or negedge  i_rst_n) begin //TODO: decide pos or neg edge
	if (!i_rst_n) begin
		state_r        <= 0;
		finish_r	   <= 0;
		daclrck_dly    <= i_daclrck;
		start_flag_r <= 0;
		sram_out <= 0;
		cur_data_r     <= 0;
		pre_data_tmp <= 0;

	end
	else begin
		state_r      <= state_w;
		finish_r	 <= finish_w;
		daclrck_dly  <= i_daclrck;
		start_flag_r <= start_flag_w;
		sram_out <= sram_addr_w;
		cur_data_r   <= cur_data_w;
		pre_data_tmp <= pre_data_w;
	end
end

always_ff @(negedge i_daclrck or negedge i_rst_n) begin
	if (!i_rst_n) begin
		sram_addr_r 	<= 0;
		pre_data_r 		<= 0;

		counter_r 		<= 0;
	end
	else begin
		sram_addr_r <= sram_addr_w;
		pre_data_r	<= pre_data_w;

		counter_r 	<= counter_w;
	end
end

endmodule