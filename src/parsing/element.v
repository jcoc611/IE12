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
	input [`CHAR_BITES] char, 											// char stream
	input state_enable,															// enable / ~reset
	input clock,																		// global clock

	output reg has_finished,												// has finished flag
	output reg [`ELE_TAG_BITES] element_tag,				// int representation of element tag
	output reg is_closing_tag, // 0 means opening tag, 1 is closing tag </div>

	output reg has_attribute, /** 1 when outputting attribute k/v */
	output [`ATTRIBUTE_TYPE_BITES] attribute_type, 		// attribute type
	output [`ATTRIBUTE_VAL_BITES] attribute_value 		// attribute value
);
	reg state_tag_found = 0; 					// flag to know if tag type has been found
	reg state_tag_finished = 0; 			// flag to know if we have finished parsing tag

	/** Attribute parser state vars. */
	reg attribute_state_enable = 0;
	wire attribute_state_finished;

	attribute_parser p(
		char,
		attribute_state_enable,
		clock,

		attribute_state_finished,
		attribute_type,
		attribute_value
	);
 // or attribute_state_finished
	always @(posedge clock) begin
		if (state_enable == 1) begin
			if (has_finished == 0) begin
				if (state_tag_found == 1) begin
					if (state_tag_finished == 1) begin
						// Reading attributes until a >
						if (attribute_state_enable == 1) begin
							if (char == ">") begin
								// We have finished
								attribute_state_enable <= 0;
								has_finished <= 1;
							end else if (attribute_state_finished == 1) begin
								// Done reading an attribute, output
								has_attribute <= 1;
								attribute_state_enable <= 0; 		// read the next attribute
							end
						end else begin
							// Skip whitespace until next attribute
							has_attribute <= 0;
							if (char != " ")
								if (char == ">") begin
									// We have finished
									has_finished <= 1;
								end else
									attribute_state_enable <= 1;
						end
					end else begin
						// Reading tag, but already know type
						// So we will ignore everything until a space
						if (char == " ") begin
							state_tag_finished <= 1;
							attribute_state_enable <= 1; 			// start reading attributes
						end
					end
				end else begin
					// Still figuring out what type/tag the element is
					state_tag_found <= 1;
					case(char)
						"/": begin
							state_tag_found <= 0;
							is_closing_tag <= 1;
						end
						// div
						"d": element_tag <= `TAG_DIV;
						// p(aragraph)
						"p": element_tag <= `TAG_P;
						// body
						"b": element_tag <= `TAG_BODY;
						// a (link)
						"a": element_tag <= `TAG_A;
						// i(mage)
						"i": element_tag <= `TAG_IMG;
						default: state_tag_found <= 0;
					endcase
				end
			end
		end else begin
			// reset
			has_finished <= 0;
			element_tag <= 0;
			is_closing_tag <= 0;
			state_tag_found <= 0;
			state_tag_finished <= 0;

			attribute_state_enable <= 0;
			has_attribute <= 0;
		end
	end
endmodule
