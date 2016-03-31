`timescale 1 ps / 1 ps
/** Simple test file for integers. */

module integer_test(
	input clock
);
	wire [`CHAR_BITES] char;
	wire next_char;
	wire has_finished;
	wire [`ATTRIBUTE_VAL_BITES] value;

	wire eof;

	reg true = 1;
	reg false = 0;	
	integer_parser intparse(
		char,
		true,				// Active enable
		false,				// Sync reset
		clock,

		next_char,			// Finished processing current char?
		has_finished,			// Finished processing stream?
		value
	);

	integer_char_stream s(
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
module integer_char_stream(
	input state_enable,
	input clock,

	output reg has_finished,
	output reg [`CHAR_BITES] char
);
	// <body><p color=1 size=2 >test</p></body>
	wire [`CHAR_BITES] foo [0:40];

	assign foo[0]  = "1";
	assign foo[1]  = "2";
	assign foo[2]  = "3";
	assign foo[3]  = "4";
	assign foo[4]  = "5";
	assign foo[5]  = "6";
	assign foo[6]  = "7";
	assign foo[7]  = "\0";


	reg [5:0] char_index = 0;
	reg has_char = 0;
	
	initial char = 0;
	initial has_finished = 0;
	initial char_index = 0;

	always @(posedge clock) begin
		if(state_enable == 1 && has_char == 0) begin
			has_char <= 1;
			char_index <= char_index + 1;
			if(char_index == 7) begin
				has_finished <= 1;
			end else begin				
				char <= foo[char_index];
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
