`timescale 1 ps / 1 ps
/**
 * Parses an XML element tag.
 *
 * NOTES:
 * - This circuit should be invoked AFTER the opening < is read.
 *    (Thus, the first character read by this circuit should NOT be
 *    the < character, but the next one).
 * - This circuit parses the element tag until a > character is read.
 *    Thus, the element content is NOT parsed by this circuit.
 */
module element_parser(
	input [`CHAR_BITES] char,
	input enable,
	input reset,
	input clock,

	/** Basic std output. */
	output reg next_char,
	output reg has_finished,								// has finished flag
	output [`ELE_TAG_BITES] element_tag,					// int representation of element tag
	output is_closing_tag,								// 0 means opening tag, 1 is closing tag </div>

	/** Attribute stream output. */
	output has_attribute,								// If HTML parser should read attribute
	output [`ATTRIBUTE_TYPE_BITES] attribute_type,				// attribute type
	output [`ATTRIBUTE_VAL_BITES] attribute_value				// attribute value
);
	/** Tag parsing */
	reg tag_enable;
	wire tag_next_char;
	wire tag_has_finished;

	element_tag_parser tagparser(
		char,
		tag_enable,
		reset,
		clock,

		tag_next_char,
		tag_has_finished,
		element_tag,
		is_closing_tag
	);

	/** Attribute parser state vars. */
	reg att_enable;
	reg att_reset;
	wire att_next_char;

	attribute_parser p(
		char,
		att_enable,
		att_reset,
		clock,

		att_next_char,
		has_attribute,
		attribute_type,
		attribute_value
	);

	reg idle_next_char;

	always @(*) begin
		if (tag_enable) begin
			next_char = tag_next_char;
		end else if(att_enable) begin
			next_char = att_next_char;
		end else begin
			next_char = idle_next_char;
		end
	end

	reg has_reached_end;	// Different from has_finished.
				// basically has_finished is true when both
				// has_reach_end is true
				// and attribute parser is off/done
	
	always @(posedge clock) begin
		if(reset) begin
			tag_enable <= 0;
			att_enable <= 0;
			has_reached_end <= 0;
			att_reset <= 1;
			idle_next_char <= 0;
			has_finished <= 0;
		end else if (enable && !has_reached_end) begin
			if(char == ">") begin
				has_reached_end <= 1;
			end else if (tag_has_finished) begin
				// Tag finished, Reading attributes until a >
				tag_enable <= 0;

				if (att_enable && has_attribute) begin
					// We have an attribute to be read,
					// lets leave it for a clock cycle
					att_enable <= 0;
					idle_next_char <= 0;
				end else if(!att_enable && !att_reset) begin
					att_reset <= 1;
				end

				if(att_reset) begin
					if(idle_next_char) begin
						idle_next_char <= 0;
						if(char != " ") begin
							att_reset <= 0;
							att_enable <= 1;
						end
					end else begin
						idle_next_char <= 1;
					end
				end

			end else begin
				// Still figuring out what type/tag the element is
				tag_enable <= 1;
			end
		end else if(has_reached_end && !has_finished) begin
			if(!att_enable || has_attribute) begin
				has_finished <= 1;
			end
		end
	end
endmodule

module element_tag_parser(
	input [`CHAR_BITES] char,
	input enable,
	input reset,
	input clock,

	output reg next_char,
	output reg has_finished,
	output reg [`ATTRIBUTE_TYPE_BITES] out_tag,
	output reg is_closing_tag
);
	reg tag_found = 0;

	always @(posedge clock) begin
		if (enable) begin
			if(!has_finished) begin
				if(char == " ") begin
					has_finished <= 1;
				end else if(!next_char) begin
					if(!tag_found)  begin
						// Determine tag
						tag_found <= 1;
						case(char)
							"/": begin
								tag_found <= 0;
								is_closing_tag <= 1;
							end
							// div
							"d": out_tag <= `TAG_DIV;
							// p(aragraph)
							"p": out_tag <= `TAG_P;
							// body
							"b": out_tag <= `TAG_BODY;
							// a (link)
							"a": out_tag <= `TAG_A;
							// i(mage)
							"i": out_tag <= `TAG_IMG;
							default: tag_found <= 0;
						endcase
					end

					next_char <= 1;
				end else begin
					// Wait for new char
					next_char <= 0;
				end
			end
		end else if (reset) begin
			next_char <= 1;
			out_tag <= 0;
			has_finished <= 0;
			is_closing_tag <= 0;
			tag_found <= 0;
		end
	end
endmodule