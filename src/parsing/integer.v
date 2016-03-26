module integer_parser(
	input [`CHAR_BITES] char,
	input state_enable,
	input clock,

	output reg [`ATTRIBUTE_TYPE_BITES] value,
	output reg has_finished
);
	always @(posedge clock) begin
		if(state_enable == 1) begin
			if(has_finished == 0) begin
				// Read digits
				value => (value * 4'd10) + char;
			end
		end else begin
			has_finished <= 0;
			value <= 0;
		end
	end
endmodule