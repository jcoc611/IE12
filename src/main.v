`timescale 1 ps / 1 ps

/*
 * the top level module connecting to the VGA
 */

module main(
		input CLOCK_50,						//	On Board 50 MHz
		input [3:0] KEY,
		// The ports below are for the VGA output.  Do not change.
		output VGA_CLK,						//	VGA Clock
		output VGA_HS,						//	VGA H_SYNC
		output VGA_VS,						//	VGA V_SYNC
		output VGA_BLANK_N,						//	VGA BLANK
		output VGA_SYNC_N,						//	VGA SYNC
		output	[9:0] VGA_R,						//	VGA Red[9:0]
		output	[9:0] VGA_G,						//	VGA Green[9:0]
		output	[9:0] VGA_B							//	VGA Blue[9:0]
	);

	wire resetn;
	assign resetn = KEY[0];

	// Create the colour, x, y and plot wires that are inputs to the controller.
	wire [`COLOR_BITES] colour;
	wire [`X_BITES] x;
	wire [`Y_BITES] y;
	wire plot;
	

	// Create an Instance of a VGA controller - there can be only one!
	// Define the number of colours as well as the initial background
	// image file (.MIF) for the controller.
	vga_adapter VGA(
			.resetn(resetn),
			.clock(CLOCK_50),
			.colour(colour),
			.x(x),
			.y(y),
			.plot(plot),
			/* Signals for the DAC to drive the monitor. */
			.VGA_R(VGA_R),
			.VGA_G(VGA_G),
			.VGA_B(VGA_B),
			.VGA_HS(VGA_HS),
			.VGA_VS(VGA_VS),
			.VGA_BLANK(VGA_BLANK_N),
			.VGA_SYNC(VGA_SYNC_N),
			.VGA_CLK(VGA_CLK));
		defparam VGA.RESOLUTION = "320x240";
		defparam VGA.MONOCHROME = "FALSE";
		defparam VGA.BITS_PER_COLOUR_CHANNEL = 1;
		defparam VGA.BACKGROUND_IMAGE = "white.mif";

	reg html_enable = 0;
	reg has_reset = 0;
	wire eof;

	always @(posedge CLOCK_50) begin
		if(has_reset) begin
			html_enable <= 1;
		end else begin
			html_enable <= 0;
			has_reset <= 1;
		end
	end

	wire [`CHAR_BITES] char;
	wire next_char;
	wire has_finished;

	html_parser htmlparse(
		char,
		html_enable,
		~html_enable,
		CLOCK_50,

		// Output
		next_char,
		has_finished,
		x,
		y,
		colour,
		plot
	);

	dummy_reader dummyread(
		next_char,
		CLOCK_50,

		eof,
		char
	);

endmodule
