`timescale 1 ps / 1 ps
/*
 * Outputs hard-coded HTML as a char stream.
 * For testing purposes only.
 */

module dummy2_reader(
	input state_enable,
	input clock,
	input [7:0] argument,
	input pause,

	output reg has_finished,
	output reg [`CHAR_BITES] char
);
	// test
	wire [`CHAR_BITES] foo [0:4];

	assign foo[0]  = "t";
	assign foo[1]  = "e";
	assign foo[2]  = "s";
	assign foo[3]  = "t";
	assign foo[4]  = "\0";

	reg [5:0] char_index = 0;
	
	initial char = 0;
	initial has_finished = 0;
	initial char_index = 0;

	always @(posedge clock or posedge pause) begin
		
		if(state_enable == 1) begin
			if(has_finished == 0 && pause == 0) begin
				if(char_index == 4) begin
					has_finished <= 1;
				end else begin
					char <= foo[char_index];
					char_index <= char_index + 1;
				end
			end
		end else begin
			char <= 0;
			has_finished <= 0;
			char_index <= 0;
		end
	end
endmodule
