`timescale 1 ps / 1 ps
/*
 * Outputs hard-coded HTML as a char stream.
 * For testing purposes only.
 */
module dummy_reader(
	input state_enable,
	input clock,

	output reg has_finished,
	output reg [`CHAR_BITES] char
);
	// <body><p color=1 size=2 >test</p></body>
	wire [`CHAR_BITES] foo [0:53];

	assign foo[0]  = "<"; // Not actually used
	assign foo[1]  = "b";
	assign foo[2]  = "o";
	assign foo[3]  = "d";
	assign foo[4]  = "y";
	assign foo[5]  = " ";
	assign foo[6]  = "b";
	assign foo[7]  = "a";
	assign foo[8]  = "c";
	assign foo[9]  = "k";
	assign foo[10]  = "g";
	assign foo[11]  = "r";
	assign foo[12]  = "o";
	assign foo[13]  = "u";
	assign foo[14]  = "n";
	assign foo[15]  = "d";
	assign foo[16]  = "=";
	assign foo[17]  = "7";
	assign foo[18]  = ">";
	assign foo[19]  = "<";
	assign foo[20]  = "p";
	assign foo[21]  = " ";
	assign foo[22]  = "c";
	assign foo[23]  = "o";
	assign foo[24]  = "l";
	assign foo[25]  = "o";
	assign foo[26]  = "r";
	assign foo[27]  = "=";
	assign foo[28]  = "0";
	assign foo[29]  = " ";
	assign foo[30]  = "s";
	assign foo[31]  = "i";
	assign foo[32]  = "z";
	assign foo[33]  = "e";
	assign foo[34]  = "=";
	assign foo[35]  = "2";
	assign foo[36]  = " ";
	assign foo[37]  = ">";
	assign foo[38]  = "t";
	assign foo[39]  = "e";
	assign foo[40]  = "s";
	assign foo[41]  = "t";
	assign foo[42]  = "<";
	assign foo[43]  = "/";
	assign foo[44]  = "p";
	assign foo[45]  = ">";
	assign foo[46]  = "<";
	assign foo[47]  = "/";
	assign foo[48]  = "b";
	assign foo[49]  = "o";
	assign foo[50]  = "d";
	assign foo[51]  = "y";
	assign foo[52]  = ">";
	assign foo[53]  = "\0";


	reg [5:0] char_index = 0;
	reg has_char = 0;
	
	initial char = 0;
	initial has_finished = 0;

	always @(posedge clock) begin
		if(state_enable == 1 && has_char == 0) begin
			has_char <= 1;
			
			if(char_index == 53) begin
				has_finished <= 1;
			end else begin				
				char <= foo[char_index];
				char_index <= char_index + 1'b1;
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