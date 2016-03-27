`timescale 1 ns / 1 ns
// TODO: change back to ps
`include "counter.v"

/* Module to draw rectangles of any dimension on any location
 * in the 320x240 screen. Rectangles can have borders and
 * different background colors.
*/

module render_rect
	(
		input clk,						  //  On Board 50 MHz

        // all these signals are high active
        input enable,                     // the 1 means start drawing, when 0 means reset to start state

        // rect attributes
        input [8:0] origin_x,             //  the origin x of rect
        input [7:0] origin_y,             //  the origin y of rect

        input [8:0] width,                //  the width (x) of rect
        input [7:0] height,               //  the height (y) of rect

        input [2:0] back_color,           //  background color
        input border,                     //  high active border signal
        input [2:0] border_color,         //  border color

        output done,                      // done signal, 0 means not done, 1 means done, stays at 1 until enable reset

        output reg [2:0] color_stream     // output color stream
        output reg [8:0] x_stream         // the stream output for x coords
        output reg [7:0] y_stream         // the stream output for y coords
        output reg writeEn                // write enable for the VGA
	);

    // Init datapath
	datapath dp(clk, enable, origin_x, origin_y, width, height, back_color, border, border_color, done, color_stream, x_stream, y_stream, writeEn);
endmodule

module datapath(
    input clk,
    input enable,                   // enable / ~resetn

    input [8:0] origin_x,
    input [7:0] origin_y,
    input [8:0] width,
    input [7:0] height,

    input [2:0] back_color,
    input  border,
    input [2:0] border_color,

    output reg done,

    output reg [2:0] color_stream,
    output reg [8:0] x_stream,
    output reg [7:0] y_stream
    output reg writeEn
    );

    wire [16:0] offset;
    counter c0(clk, enable, width * height, writeEn, offset);
    // load the output registers
    always@(*) begin
        if (!enable) begin
            x_stream = origin_x;
            y_stream = origin_y;
            color_stream = border ? border_color : back_color;
            writeEn = 0;
            done = 0;
        end else begin
            // enable is on, start drawing the square
            if (border) begin
                // border offsets only occur when
                x_stream = origin_x + ((((offset % width) == 9'b0) || ((offset % width) == width - 1) || ((offset / width) == 8'b0) || ((offset / width) == height - 1)) ? offset % width : 9'b0);
                y_stream = origin_y + ((((offset % width) == 9'b0) || ((offset % width) == width - 1) || ((offset / width) == 8'b0) || ((offset / width) == height - 1)) ? offset / width : 8'b0);
                color_stream = ((((offset % width) == 9'b0) || ((offset % width) == width - 1) || ((offset / width) == 8'b0) || ((offset / width) == height - 1)) ? border_color : back_color);
            end else begin
                x_stream = origin_x + (offset % width);
                y_stream = origin_y + (offset / width);
                color_stream = back_color;
            end

            x_stream = (x_stream >= 9'd320) ? 9'd319 : x_stream;
            y_stream = (y_stream >= 9'd240) ? 9'd239 : y_stream;
            // writeEn is handled by counter
            done = ~writeEn;
        end
    end
endmodule
