/**
 * Converts an ASCII character into an integer.
 * @param {ASCII} char The character to convert.
 * @output {int} int The numerical value of this character, or zero.
 */
module char_to_int(
	input [`CHAR_BITES] char,
	output reg [`ATTRIBUTE_VAL_BITES] int
);
	always @(*) begin
		if(char > 47 && char < 58) begin
			int = char - 48;
		end else begin
			int = 0;
		end
	end
endmodule