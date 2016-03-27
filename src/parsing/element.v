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
	input state_enable,
	input clock,

	output reg has_finished,
	output reg [`ELE_TAG_BITES] element_tag,
	output reg element_type, /** 0 - start (<div>), 1 - end (</did>) */

	output reg has_attribute, /** 1 when outputting attribute k/v */
	output [`ATTRIBUTE_TYPE_BITES] attribute_type,
	output [`ATTRIBUTE_VAL_BITES] attribute_value
);
	reg state_tag_found = 0;
	reg state_tag_finished = 0;

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

	always @(posedge clock) begin
		if(state_enable == 1) begin
			if(has_finished == 0) begin
				if(state_tag_found == 1) begin
					if(state_tag_finished == 1) begin
						// Reading attributes until a >
						if(attribute_state_enable == 1) begin
							if(char == ">") begin
								// We have finished
								attribute_state_enable <= 0;
								has_finished <= 1;
							end else if(attribute_state_finished == 1) begin
								// Done reading an attribute, output
								has_attribute <= 1;
								attribute_state_enable <= 0;
							end
						end else begin
							// Skip whitespace until next attribute
							has_attribute <= 0;
							if(char != " ")
								if(char == ">") begin
									// We have finished
									has_finished <= 1;
								end else
									attribute_state_enable <= 1;
						end
					end else begin
						// Reading tag, but already know type
						// So we will ignore everything until a space
						if(char == " ") begin
							state_tag_finished <= 1;
							attribute_state_enable <= 1;
						end
					end
				end else begin
					// Still figuring out what type/tag the element is
					state_tag_found <= 1;
					case(char)
						"/": begin
							state_tag_found <= 0;
							element_type <= 1;
						end
						// div
						"d": element_tag <= 0;
						// p(aragraph)
						"p": element_tag <= 1;
						// body
						"b": element_tag <= 2;
						// a (link)
						"a": element_tag <= 3;
						// i(mage)
						"i": element_tag <= 4;
						default: state_tag_found <= 0;
					endcase
				end
			end
		end else begin
			has_finished <= 0;
			element_tag <= 0;
			element_type <= 0;
			state_tag_found <= 0;
			state_tag_finished <= 0;

			attribute_state_enable <= 0;
			has_attribute <= 0;
		end
	end
endmodule