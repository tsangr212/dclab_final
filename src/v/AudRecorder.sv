module AudRecorder(
	input i_rst_n, 
	input i_clk,
	input i_lrc,
	input i_start,
	input i_pause,
	input i_stop,
	input i_data,
    input [15:0] i_music_total,
	output [19:0] o_address,
	output [15:0] o_data
);

localparam S_IDLE = 2'd0;
localparam S_LRC = 2'd1;
localparam S_DATA = 2'd2;
localparam S_ADDR = 2'd3;

logic lrc_r, lrc_w;
logic [1:0] state_r, state_w;
logic [3:0] counter_r, counter_w;
logic [15:0] data_r, data_w;
logic [19:0] addr_r, addr_w;

assign o_data = data_r;
assign o_address = addr_r;

always_comb begin //state

    lrc_w = i_lrc;
    state_w = state_r;
    data_w = data_r;
    addr_w = addr_r;
    if(i_pause) state_w = S_IDLE;
    if(i_stop) begin
        state_w = S_IDLE;
        addr_w = 0;
    end

    case (state_r)
        S_IDLE: begin
            if(i_start) state_w = S_ADDR;
        end 
        S_ADDR: begin
            //state_w = S_ADDR;
            addr_w = addr_r + 20'd1; 
        end
    endcase
end

always_ff @( negedge i_lrc or negedge i_rst_n ) begin
    if(!i_rst_n) begin
        lrc_r <= 0;
        state_r <= S_IDLE;
        counter_r <= 0;
        data_r <= 0;
        addr_r <= 0;
    end
    else begin
        lrc_r <= lrc_w;
        state_r <= state_w;
        counter_r <= counter_w;
        data_r <= i_music_total;
        addr_r <= addr_w;
    end
end
endmodule