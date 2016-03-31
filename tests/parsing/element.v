`timescale 1 ps / 1 ps
/** Simple test file for integers. */

module element_test(
	input clock
);
	wire [`CHAR_BITES] char;
	wire next_char;
	wire has_finished;
	wire [`ELE_TAG_BITES] tag;
	wire is_closing_tag;
	wire [`ATTRIBUTE_VAL_BITES] value;

	wire has_attribute;
	wire [`ATTRIBUTE_TYPE_BITES] attribute_type;				// attribute type
	wire [`ATTRIBUTE_VAL_BITES] attribute_value;

	wire eof;

	reg att_enable = 0;
	reg has_reset = 0;

	always @(posedge clock) begin
		if(has_reset) begin
			att_enable <= 1;
		end else begin
			att_enable <= 0;
			has_reset <= 1;
		end
	end

	element_parser eleparse(
		char,
		att_enable,
		~att_enable,
		clock,

		next_char,
		has_finished,
		tag,
		is_closing_tag,

		has_attribute,
		attribute_type,
		attribute_value
	);

	element_char_stream s(
		next_char,
		clock,

		eof,
		char
	);
endmodule


/*
 * Outputs hard-coded HTML as a char stream.
 * For testing purposes only.
 */
module element_char_stream(
	input state_enable,
	input clock,

	output reg has_finished,
	output reg [`CHAR_BITES] char
);
	// <p size=68>
	wire [`CHAR_BITES] foo [0:40];

	assign foo[0]  = "<"; // Not actually used
	assign foo[1]  = "p";
	assign foo[2]  = " ";
	assign foo[3]  = "s";
	assign foo[4]  = "i";
	assign foo[5]  = "z";
	assign foo[6]  = "e";
	assign foo[7]  = "=";
	assign foo[8]  = "6";
	assign foo[9]  = "8";
	assign foo[10]  = ">";
	assign foo[11]  = "\0";


	reg [5:0] char_index = 1;
	reg has_char = 0;
	
	initial char = 0;
	initial has_finished = 0;

	always @(posedge clock) begin
		if(state_enable == 1 && has_char == 0) begin
			has_char <= 1;
			
			if(char_index == 11) begin
				has_finished <= 1;
			end else begin				
				char <= foo[char_index];
				char_index <= char_index + 1;
			end
		end else if(state_enable == 0) begin
			has_char <= 0;
		end
	end

	// TODO Add reset
	// char <= 0;
	// has_finished <= 0;
	// char_index <= 0;
endmodule
