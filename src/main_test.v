`timescale 1 ps / 1 ps

/*
 * the top level module connecting to the VGA
 */

module main
	(
		CLOCK_50,						//	On Board 50 MHz
		KEY,
		// The ports below are for the VGA output.  Do not change.
		VGA_CLK,   						//	VGA Clock
		VGA_HS,							//	VGA H_SYNC
		VGA_VS,							//	VGA V_SYNC
		VGA_BLANK,						//	VGA BLANK
		VGA_SYNC,						//	VGA SYNC
		VGA_R,   						//	VGA Red[9:0]
		VGA_G,	 						//	VGA Green[9:0]
		VGA_B   						//	VGA Blue[9:0]
	);

	input			CLOCK_50;				//	50 MHz
	input 	[3:0] KEY;
	// Do not change the following outputs
	output			VGA_CLK;   				//	VGA Clock
	output			VGA_HS;					//	VGA H_SYNC
	output			VGA_VS;					//	VGA V_SYNC
	output			VGA_BLANK;				//	VGA BLANK
	output			VGA_SYNC;				//	VGA SYNC
	output	[9:0]	VGA_R;   				//	VGA Red[9:0]
	output	[9:0]	VGA_G;	 				//	VGA Green[9:0]
	output	[9:0]	VGA_B;   				//	VGA Blue[9:0]

	wire resetn;
	assign resetn = KEY[0];

	// Create the colour, x, y and writeEn wires that are inputs to the controller.
	wire [`COLOR_BITES] colour;
	wire [`X_BITES] x;
	wire [`Y_BITES] y;
	wire parser_plot;
	
	reg CLOCK_25 = 0;
	reg writeEn = 0;
	
	always @(posedge CLOCK_50) begin
		CLOCK_25 <= ~CLOCK_25;
		if(CLOCK_25 == 1) begin
			writeEn <= parser_plot;
		end else begin
			writeEn <= 0;
		end
	end

	

		wire [`CHAR_BITES] char; 		// char stream wire
		wire has_finished_connection;
		wire has_not_finished_connection = ~has_finished_connection;
		wire pause_connection;

		html_parser hp(
			CLOCK_25,
			char,
			has_not_finished_connection,

			x,
			y,
			colour,
			pause_connection, 		// pause signal to reader
			parser_plot
		);

	dummy2_reader dr(
	  1'b1, 										// enable / ~reset
	  CLOCK_25,                 // clock
	  1'b0,
	  pause_connection,

	  has_finished_connection,  // has it finished?
	  char             					// output char stream
	);

endmodule
