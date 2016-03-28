`timescale 1 ps / 1 ps
/*
 *Module to draw rectangles of any dimension on any location
 * in the 320x240 screen. Rectangles can have borders and
 * different background colors.
 */

module render_rect
	(
		input clk,						  //  On Board 50 MHz

        // all these signals are high active
        input enable,                     // the 1 means start drawing, when 0 means reset to start state

        // rect attributes
        input [`X_BITES] origin_x,             //  the origin x of rect
        input [`Y_BITES] origin_y,             //  the origin y of rect

        input [`X_BITES] width,                //  the width (x) of rect
        input [`Y_BITES] height,               //  the height (y) of rect

        input [`COLOR_BITES] back_color,           //  background color
        input border,                     //  high active border signal
        input [`COLOR_BITES] border_color,         //  border color

        output done,                      // done signal, 0 means not done, 1 means done, stays at 1 until enable reset

        output [`COLOR_BITES] color_stream,     // output color stream
        output [`X_BITES] x_stream,         // the stream output for x coords
        output [`Y_BITES] y_stream,         // the stream output for y coords
        output writeEn                // write enable for the VGA
);

    // Init datapath
	datapath dp(clk, enable, origin_x, origin_y, width, height, back_color, border, border_color, done, color_stream, x_stream, y_stream, writeEn);
endmodule

module datapath(
    input clk,
    input enable,                   // enable / ~resetn

    input [`X_BITES] origin_x,
    input [`Y_BITES] origin_y,
    input [`X_BITES] width,
    input [`Y_BITES] height,

    input [`COLOR_BITES] back_color,
    input  border,
    input [`COLOR_BITES] border_color,

    output reg done,

    output reg [`COLOR_BITES] color_stream,
    output reg [`X_BITES] x_stream,
    output reg [`Y_BITES] y_stream,
    output writeEn
);

    wire [`X_Y_PRODUCT_BITES] offset;

    reg start_signal = 0;

    // when enable turns on, start signal is set to 1
    always @(posedge enable) begin
            start_signal <= 1;
    end

    // on the next clk edge it is put back to 0
    always@(posedge clk) begin
        if (start_signal) start_signal <= 0;
    end

    // counter should not be fed in enable
    wire [`X_Y_PRODUCT_BITES] limit = width * height;
    // input clk,              // clock
    // input start_count,      // signal to start counting
    // input [`X_Y_PRODUCT_BITES] limit,         // the number to count upto
    // output reg counting,    // whether the clock is still counting
    // output reg [`X_Y_PRODUCT_BITES] result // resulting output
    counter c0(clk, start_signal, limit, writeEn, offset);

    // load the output registers
    always@(*) begin
        if (!enable) begin
            x_stream = origin_x;
            y_stream = origin_y;
            color_stream = border ? border_color : back_color;
            done = 0;
        end else begin
            // enable is on, start drawing the square
            x_stream = origin_x + (offset % width);
            y_stream = origin_y + (offset / width);

            if (border) begin
                // border offsets only occur when
                color_stream = ((((offset % width) == 9'b0) || ((offset % width) == width - 1) || ((offset / width) == 8'b0) || ((offset / width) == height - 1)) ? border_color : back_color);
            end else begin
                color_stream = back_color;
            end
            // setting screen boundary limits
            x_stream = (x_stream >= 9'd320) ? 9'd319 : x_stream;
            // writeEn is handled by counter
            done = ~writeEn;
        end
    end
endmodule
