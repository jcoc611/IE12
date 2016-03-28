`timescale 1 ps / 1 ps
/*
 * Outputs hard-coded HTML as a char stream.
 * For testing purposes only.
 */

module dummy_reader(
	input state_enable,
	input clock,
	input [7:0] argument,
	input pause,

	output reg has_finished,
	output reg [`CHAR_BITES] char
);
	// <body><p color=1 size=2 >test</p></body>
	wire [`CHAR_BITES] foo [0:40];

	assign foo[0]  = "<";
	assign foo[1]  = "b";
	assign foo[2]  = "o";
	assign foo[3]  = "d";
	assign foo[4]  = "y";
	assign foo[5]  = ">";
	assign foo[6]  = "<";
	assign foo[7]  = "p";
	assign foo[8]  = " ";
	assign foo[9]  = "c";
	assign foo[10]  = "o";
	assign foo[11]  = "l";
	assign foo[12]  = "o";
	assign foo[13]  = "r";
	assign foo[14]  = "=";
	assign foo[15]  = "1";
	assign foo[16]  = " ";
	assign foo[17]  = "s";
	assign foo[18]  = "i";
	assign foo[19]  = "z";
	assign foo[20]  = "e";
	assign foo[21]  = "=";
	assign foo[22]  = "2";
	assign foo[23]  = " ";
	assign foo[24]  = ">";
	assign foo[25]  = "t";
	assign foo[26]  = "e";
	assign foo[27]  = "s";
	assign foo[28]  = "t";
	assign foo[29]  = "<";
	assign foo[30]  = "/";
	assign foo[31]  = "p";
	assign foo[32]  = ">";
	assign foo[33]  = "<";
	assign foo[34]  = "/";
	assign foo[35]  = "b";
	assign foo[36]  = "o";
	assign foo[37]  = "d";
	assign foo[38]  = "y";
	assign foo[39]  = ">";
	assign foo[40]  = "\0";

	reg [5:0] char_index = 0;

	always @(posedge clock) begin
		if(state_enable == 1) begin
			if(has_finished == 0 && pause == 0) begin
				if(char_index == 40) begin
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
