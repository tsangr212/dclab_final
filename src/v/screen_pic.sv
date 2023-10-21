module pic(
    input wire vga_clk ,
    input wire sys_rst_n ,
    input wire [9:0] pix_x ,
    input wire [9:0] pix_y ,
    output wire [7:0] o_r,
    output wire [7:0] o_g,
    output wire [7:0] o_b
);

    parameter H_VALID = 10'd640 ,V_VALID = 10'd480 ;
    parameter H_PIC = 10'd600 ,W_PIC = 10'd100 ,PIC_SIZE= 16'd60000 ;

    wire rd_en ;
    wire [23:0] pic_data ;
    reg [15:0] rom_addr ;
    reg pic_valid ;
    reg [15:0] pix_data ;

    // assign rd_en = (((pix_x >= (((H_VALID - H_PIC)/2) - 1'b1))
    // && (pix_x < (((H_VALID - H_PIC)/2) + H_PIC - 1'b1)))
    // &&((pix_y >= 0)
    // && ((pix_y <  W_PIC))));

    assign  rd_en = (((pix_x >= (((H_VALID - H_PIC)/2) - 1'b1))
                    && (pix_x < (((H_VALID - H_PIC)/2) + H_PIC - 1'b1))) 
                    &&((pix_y >= ((V_VALID - W_PIC)/2))
                    && ((pix_y < (((V_VALID - W_PIC)/2) + W_PIC)))));

    always@(posedge vga_clk or negedge sys_rst_n) begin
        if(sys_rst_n == 1'b0) pic_valid <= 1'b1;
        else pic_valid <= rd_en;
    end

    assign o_r = (pic_valid == 1'b1) ? pic_data[23:16] : 0;
    assign o_g = (pic_valid == 1'b1) ? pic_data[15:8] : 0;
    assign o_b = (pic_valid == 1'b1) ? pic_data[7:0] : 0;

    always@(posedge vga_clk or negedge sys_rst_n) begin
        if(sys_rst_n == 1'b0) rom_addr <= 16'd0;
        else if(rom_addr == (PIC_SIZE - 1'b1)) rom_addr <= 16'd0;
        else if(rd_en == 1'b1) rom_addr <= rom_addr + 1'b1;
    end

    rom2 rom_pic_inst (
        .address (rom_addr ),
        .clock (vga_clk ),
        .rden (rd_en ),
        .q (pic_data )
    );
endmodule