`timescale 1 ps / 1 ps
/*
 * Module to draw rectangles of any dimension on any location
 * in the 320x240 screen. Rectangles can have borders and
 * different background colors.
 *
 * TODO: do we have to wait one clock cycle, after giving an (X, Y) output
 * pixel value?
 */

module render_rect
	(
		input clock,					// On Board 50 MHz

		// all these signals are high active
		input enable,					// the 1 means start drawing, when 0 means reset to start state

		// rect attributes
		input [`X_BITES] origin_x,			//  the origin x of rect
		input [`Y_BITES] origin_y,			//  the origin y of rect

		input [`X_BITES] width,				//  the width (x) of rect
		input [`Y_BITES] height,				//  the height (y) of rect

		input [`COLOR_BITES] back_color,		//  background color
		input border,					//  high active border signal
		input [`COLOR_BITES] border_color,		//  border color

		output reg done,				// done signal, 0 means not done, 1 means done, stays at 1 until enable reset

		output reg [`COLOR_BITES] color_stream,	// output color stream
		output reg [`X_BITES] x_stream,		// the stream output for x coords
		output reg [`Y_BITES] y_stream,		// the stream output for y coords
		output writeEn					// write enable for the VGA
);
	wire [`X_Y_PRODUCT_BITES] offset;

	// counter should not be fed in enable
	wire [`X_Y_PRODUCT_BITES] limit = width * height;
	/* clock              clock
	 * start_count      (pulse) signal to start counting
	 * limits           the number to count up to
	 *
	 * counting         whether the clock currently counting
	 * result           resulting output
	 */
	wire has_finished;
	counter c0(clock, enable, limit, has_finished, offset);
	assign writeEn = ~has_finished;

	// load the output registers
	always@(*) begin
		if (!enable) begin
			x_stream = 0;
			y_stream = 0;
			color_stream = 0;
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
			done = has_finished;
		end
	end
endmodule
