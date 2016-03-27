
module attribute_parser(
	input [`CHAR_BITES] char,
	input state_enable,
	input clock,

	output reg has_finished,
	output reg [`ATTRIBUTE_TYPE_BITES] out_type,
	output reg [`ATTRIBUTE_VAL_BITES] out_value
);
	/** Character previously read. */
	reg [`CHAR_BITES] state_last_char = 0;
	reg state_type_found = 0;
	reg state_equals = 0;

	wire int_state_finished;
	wire [`ATTRIBUTE_VAL_BITES] int_value;
	reg int_state_enable = 0;

	integer_parser p(
		char,
		int_state_enable,
		clock,

		int_value,
		int_state_finished
	);

	always @(posedge clock) begin
		if(state_enable == 1) begin
			if(has_finished == 0) begin
				if(state_equals == 1) begin
					// Reading value
					// For now, only reads int
					if(int_state_enable == 0) begin
						int_state_enable <= 1;
					end else begin
						if(int_state_finished == 1) begin
							out_value <= int_value;
							has_finished <= 1;
						end
					end
				end else begin
					// Reading type
					if(state_type_found == 1) begin
						// Ignore everything until =
						if(char == "=") begin
							state_equals <= 1;
							int_state_enable <= 1;
						end
					end else begin
						// Determine type
						state_type_found <= 1;
						case (char)
							// Color
							"c": out_type <= 0;
							// Size
							"i": out_type <= 1;
							// Width
							"w": out_type <= 2;
							// Height
							"e": out_type <= 3;
							// src : href
							"r": out_type <= (state_last_char == "s")? 4 : 5;
							// bg, padding, margin
							"a": begin
								if(state_last_char == "b") begin
									// Background
									out_type <= 6;	
								end else if(state_last_char == "p") begin
									// Padding
									out_type <= 7;
								end else begin
									// Margin
									out_type <= 8;
								end
							end
							// border: position
							"o": out_type <= (state_last_char == "b")? 9: 10;
							default: state_type_found <= 0;
						endcase
						state_last_char <= char;
					end
				end
			end
		end else begin
			state_last_char <= 0;
			has_finished <= 0;
			out_type <= 0;
			out_value <= 0;
			state_type_found <= 0;
			state_equals <= 0;
		end
	end
endmodule