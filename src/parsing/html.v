module html_parser(
	input clock,
	input [`CHAR_BITES] char,


);
	/** Text State */
	reg [`COLOR_BITES] state_text_color = 0;
	reg [`ATTRIBUTE_VAL_BITES] state_text_size = 1;
	reg [`X_BITES] state_text_x = 0;
	reg [`Y_BITES] state_text_y = 0;

	/** Block State */
	reg [`COLOR_BITES] state_block_color = 0;
	reg [`X_BITES] state_block_x = 0;
	reg [`Y_BITES] state_block_y = 0;
	reg [`X_BITES] state_size_w = 0;
	reg [`Y_BITES] state_size_h = 0;

	
endmodule