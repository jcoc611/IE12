`timescale 1 ps / 1 ps
/**
 * Converts an ASCII character into an integer.
 *
 * @param {ASCII} char The character to convert.
 * @output {int} int The numerical value of this character, or zero.
 */
module char_to_int(
	input [`CHAR_BITES] char,
	output reg [`ATTRIBUTE_VAL_BITES] int_out
);
	always @(*) begin
		if (char > 47 && char < 58) begin
			int_out = char - 48;
		end else begin
			int_out = 0;
		end
	end
endmodule
