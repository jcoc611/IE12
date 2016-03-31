`timescale 1 ps / 1 ps
/**
 * Parses an XML attribute.
 *
 * @param {ASCII} char 				A character stream.
 * @param {boolean} state_enable 			Enable/~Reset
 * @param {boolean} clock 				The global clock.
 *
 * @output {boolean} has_finished 			Whether this circuit is done.
 * @output {AttributeType (int)} out_type 		The type of attribute. (Ex, width). See constants.v
 * @output {AttributeVal} out_value 			The value of the attribute. Type depends on the attribute type.
 */
module attribute_parser(
	input [`CHAR_BITES] char,
	input enable,
	input reset,
	input clock,

	output reg next_char,
	output reg has_finished,
	output [`ATTRIBUTE_TYPE_BITES] out_type,
	output [`ATTRIBUTE_VAL_BITES] out_value
);
	reg att_enable;
	wire att_next_char;
	wire type_found;

	attribute_type_parser attparser(
		char,
		att_enable,
		reset,
		clock,

		att_next_char,
		type_found,
		out_type
	);

	wire int_next_char;
	wire int_finished;
	reg int_enable;

	integer_parser p(
		char,
		int_enable,
		reset,
		clock,

		int_next_char,
		int_finished,
		out_value
	);

	always @(*) begin
		if(int_enable)
			next_char = int_next_char;
		else
			next_char = att_next_char;
	end

	always @(posedge clock) begin
		if (enable && !has_finished) begin
			if (!att_enable && !int_enable) begin
				att_enable <= 1;
			end else if (att_enable) begin
				// Reading type
				if(type_found) begin
					att_enable <= 0;
					int_enable <= 1;
				end
			end else if (int_finished) begin
				has_finished <= 1;
			end
		end else if(reset) begin
			// reset
			int_enable <= 0;
			att_enable <= 0;
			has_finished <= 0;
		end
	end
endmodule

module attribute_type_parser(
	input [`CHAR_BITES] char,
	input enable,
	input reset,
	input clock,

	output reg next_char,
	output reg has_finished,
	output reg [`ATTRIBUTE_TYPE_BITES] out_type
);

	reg [ `CHAR_BITES] state_last_char = 0;
	reg state_type_found = 0;

	always @(posedge clock) begin
		if (enable) begin
			if(!has_finished) begin
				if(char == "=") begin
					has_finished <= 1;
				end else if(!next_char) begin
					if(!state_type_found)  begin
						// Determine type
						state_type_found <= 1;
						case (char)
							// Color
							"c": out_type <= `ATT_COLOR;
							// Size
							"i": out_type <= `ATT_SIZE;
							// Width
							"w": out_type <= `ATT_WIDTH;
							// Height
							"e": out_type <= `ATT_HEIGHT;
							// src : href
							"r": out_type <= (state_last_char == "s")? `ATT_SRC : `ATT_HREF;
							// bg, padding, margin
							"a": begin
								if (state_last_char == "b") begin
									// Background
									out_type <= `ATT_BG;
								end else if (state_last_char == "p") begin
									// Padding
									out_type <= `ATT_PADDING;
								end else begin
									// Margin
									out_type <= `ATT_MARGIN;
								end
							end
							// border: position
							"o": out_type <= (state_last_char == "b")? `ATT_BORDER: `ATT_POSITION;
							default: state_type_found <= 0;
						endcase
						state_last_char <= char;
					end

					next_char <= 1;
				end else begin
					// Wait for new char
					next_char <= 0;
				end
			end
		end else if (reset) begin
			next_char <= 1;
			out_type <= 0;
			has_finished <= 0;
			state_last_char <= 0;
			state_type_found <= 0;
		end
	end
endmodule