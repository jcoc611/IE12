`timescale 1 ps / 1 ps
/*
 * Parses integers provided through HTML attributes.
 *
 * NOTE: ATTRIBUTE_VAL_BITES is 10 bits to hold all attributes
 * of any tag
 * @param char character stream
 * @param enable signal to enable the circuit enable / ~reset
 * @param clock
 * @output value of the character stream returned
 * @output has_finished signal
 */

module integer_parser(
	input [`CHAR_BITES] char,
	input enable,				// Active enable
	input reset,				// Sync reset
	input clock,

	output reg next_char,			// Finished processing current char?
	output reg has_finished,			// Finished processing stream?
	output reg [`ATTRIBUTE_VAL_BITES] value
);
	wire [`ATTRIBUTE_VAL_BITES] char_val;

	/** Initial values. */
	initial has_finished = 0;
	initial value = 0;

	/** This converter is a datapath. */
	char_to_int converter(
		char,
		char_val
	);

	always @(posedge clock) begin
		if (enable) begin
			if (char == " " || char == ">") begin
				has_finished <= 1;
			end else if(!next_char) begin
				// Read digits, ask for new char
				value <= (value * 10'd10) + char_val;
				next_char <= 1;
			end else begin
				// Wait for new char
				next_char <= 0;
			end
		end else if(reset) begin
			has_finished <= 0;
			value <= 0;
		end
	end
endmodule
