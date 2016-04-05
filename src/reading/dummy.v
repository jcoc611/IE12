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
	wire [`CHAR_BITES] foo [0:109];

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
	assign foo[38]  = "T";
	assign foo[39]  = "H";
	assign foo[40]  = "A";
	assign foo[41]  = "N";
	assign foo[42]  = "K";
	assign foo[43]  = "S";
	assign foo[44]  = "<";
	assign foo[45]  = "/";
	assign foo[46]  = "p";
	assign foo[47]  = ">";
	assign foo[48]  = "<";
	assign foo[49]  = "p";
	assign foo[50]  = " ";
	assign foo[51]  = "c";
	assign foo[52]  = "o";
	assign foo[53]  = "l";
	assign foo[54]  = "o";
	assign foo[55]  = "r";
	assign foo[56]  = "=";
	assign foo[57]  = "2";
	assign foo[58]  = ">";
	assign foo[59]  = "B";
	assign foo[60]  = "E";
	assign foo[61]  = "S";
	assign foo[62]  = "T";
	assign foo[63]  = " ";
	assign foo[64]  = "T";
	assign foo[65]  = "A";
	assign foo[66]  = "<";
	assign foo[67]  = "/";
	assign foo[68]  = "p";
	assign foo[69]  = ">";
	assign foo[70]  = "<";
	assign foo[71]  = "p";
	assign foo[72]  = " ";
	assign foo[73]  = "c";
	assign foo[74]  = "o";
	assign foo[75]  = "l";
	assign foo[76]  = "o";
	assign foo[77]  = "r";
	assign foo[78]  = "=";
	assign foo[79]  = "3";
	assign foo[80]  = " ";
	assign foo[81]  = "s";
	assign foo[82]  = "i";
	assign foo[83]  = "z";
	assign foo[84]  = "e";
	assign foo[85]  = "=";
	assign foo[86]  = "1";
	assign foo[87]  = " ";
	assign foo[88]  = ">";
	assign foo[89]  = "S";
	assign foo[90]  = "R";
	assign foo[91]  = " ";
	assign foo[92]  = "a";
	assign foo[93]  = "n";
	assign foo[94]  = "d";
	assign foo[95]  = " ";
	assign foo[96]  = "J";
	assign foo[97]  = "C";
	assign foo[98]  = "<";
	assign foo[99]  = "/";
	assign foo[100]  = "p";
	assign foo[101]  = ">";	
	assign foo[102]  = "<";
	assign foo[103]  = "/";
	assign foo[104]  = "b";
	assign foo[105]  = "o";
	assign foo[106]  = "d";
	assign foo[107]  = "y";
	assign foo[108]  = ">";
	assign foo[109]  = "\0";


	reg [10:0] char_index = 0;
	reg has_char = 0;
	
	initial char = 0;
	initial has_finished = 0;

	always @(posedge clock) begin
		if(state_enable == 1 && has_char == 0) begin
			has_char <= 1;
			
			if(char_index == 109) begin
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