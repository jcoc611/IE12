module integer_parser(
	input [`CHAR_BITES] char,
	input state_enable,
	input clock,

	output reg [`ATTRIBUTE_VAL_BITES] value,
	output reg has_finished
);
	wire [`ATTRIBUTE_VAL_BITES] char_val;

	char_to_int converter(
		char,
		char_val
	);

	always @(posedge clock) begin
		if(state_enable == 1) begin
			if(has_finished == 0) begin
				if(char == " ") begin
					has_finished <= 1;
				end else begin
					// Read digits
					value <= (value * 10) + char_val;	
				end
				
			end
		end else begin
			has_finished <= 0;
			value <= 0;
		end
	end
endmodule