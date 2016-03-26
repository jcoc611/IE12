module char_to_int(
	input [`CHAR_BITES] char,
	output reg [`ATTRIBUTE_TYPE_BITES] int
);
	always @(*) begin
		if(char > 47 && char < 58) begin
			int = char - 48;
		end else begin
			int = 0;
		end
	end
endmodule