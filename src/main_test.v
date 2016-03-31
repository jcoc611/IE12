`timescale 1 ps / 1 ps

/*
 * the top level module connecting to the VGA
 */
module main_test(
		input CLOCK_50
	);

	// Create the colour, x, y and plot wires that are inputs to the controller.
	wire [`COLOR_BITES] colour;
	wire [`X_BITES] x;
	wire [`Y_BITES] y;
	wire plot;
	

	reg att_enable = 0;
	reg has_reset = 0;

	always @(posedge CLOCK_50) begin
		if(has_reset) begin
			att_enable <= 1;
		end else begin
			att_enable <= 0;
			has_reset <= 1;
		end
	end

	wire [`CHAR_BITES] char;
	wire next_char;
	wire has_finished;

	html_parser htmlparse(
		char,
		att_enable,
		~att_enable,
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
