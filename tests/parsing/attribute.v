`timescale 1 ps / 1 ps
/** Simple test file for integers. */

module attribute_test(
	input clock
);
	wire [`CHAR_BITES] char;
	wire next_char;
	wire has_finished;
	wire [`ATTRIBUTE_VAL_BITES] value;
	wire [`ATTRIBUTE_TYPE_BITES] type;

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

	attribute_parser attparse(
		char,
		att_enable,
		~att_enable,
		clock,

		next_char,
		has_finished,
		type,
		value
	);

	attribute_char_stream s(
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
module attribute_char_stream(
	input state_enable,
	input clock,

	output reg has_finished,
	output reg [`CHAR_BITES] char
);
	// size=68 
	wire [`CHAR_BITES] foo [0:40];

	assign foo[0]  = "s";
	assign foo[1]  = "i";
	assign foo[2]  = "z";
	assign foo[3]  = "e";
	assign foo[4]  = "=";
	assign foo[5]  = "6";
	assign foo[6]  = "8";
	assign foo[7]  = " ";
	assign foo[8]  = "\0";


	reg [5:0] char_index = 0;
	reg has_char = 0;
	
	initial char = 0;
	initial has_finished = 0;
	initial char_index = 0;

	always @(posedge clock) begin
		if(state_enable == 1 && has_char == 0) begin
			has_char <= 1;
			char_index <= char_index + 1;
			if(char_index == 8) begin
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
