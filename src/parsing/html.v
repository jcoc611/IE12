`timescale 1 ps / 1 ps

/*
 * Module for parsing HTML
 */
module html_parser(
	input clock,
	input [`CHAR_BITES] char,
	input state_enable, 					// enable / ~reset

	output reg [`X_BITES] out_x,
	output reg [`Y_BITES] out_y,
	output reg [`COLOR_BITES] out_color,
	output reg out_pause,
	output reg plot
);

	initial out_pause = 0;

	/** Text State */
	// inputs
	reg text_enable = 0;
	reg [`COLOR_BITES] text_color = 7;
	reg [`ATTRIBUTE_VAL_BITES] text_size = 1;
	reg [`X_BITES] text_x = 0;
	reg [`Y_BITES] text_y = 0;
	reg [`X_BITES] text_padding = 0;

	// outputs
	wire [`X_BITES] text_out_x;
	wire [`Y_BITES] text_out_y;
	wire text_out_plot;
	wire text_out_finished;

	/** rect State */
	// inputs
	reg rect_enable = 0;
	reg [`X_BITES] rect_x = 0;
	reg [`Y_BITES] rect_y = 0;
	reg [`X_BITES] rect_width = 0;
	reg [`Y_BITES] rect_height = 0;
	reg [`X_BITES] rect_margin = 0;
	reg rect_has_border = 0;
	reg [`COLOR_BITES] rect_border_color = 0;
	reg [`COLOR_BITES] rect_background_color = 0;
	
	/** temp states */
	reg [`COLOR_BITES] temp_text_color = 7;
	reg [`ATTRIBUTE_VAL_BITES] temp_text_size = 1;
	reg [`X_BITES] temp_text_x = 0;
	reg [`Y_BITES] temp_text_y = 0;
	reg [`X_BITES] temp_text_padding = 0;
	reg [`X_BITES] temp_rect_x = 0;
	reg [`Y_BITES] temp_rect_y = 0;
	reg [`X_BITES] temp_rect_width = 0;
	reg [`Y_BITES] temp_rect_height = 0;
	reg [`X_BITES] temp_rect_margin = 0;
	reg temp_rect_has_border = 0;
	reg [`COLOR_BITES] temp_rect_border_color = 0;
	reg [`COLOR_BITES] temp_rect_background_color = 0;

	// outputs
	wire [`X_BITES] rect_out_x;
	wire [`Y_BITES] rect_out_y;
	wire [`COLOR_BITES] rect_out_color;
	wire rect_out_plot;
	wire rect_out_finished;

	/** Element parser state vars */
	// input
	reg element_enable = 0;

	// outputs
	wire element_out_finished;
	wire [`ELE_TAG_BITES] element_out_tag;
	wire element_out_is_closing;
	wire element_out_has_attribute;
	wire [`ATTRIBUTE_TYPE_BITES] element_out_attribute_type;
	wire [`ATTRIBUTE_VAL_BITES] element_out_attribute_value;

	element_parser ep(
		char,
		element_enable,
		clock,

		element_out_finished,
		element_out_tag,
		element_out_is_closing,

		element_out_has_attribute,
		element_out_attribute_type,
		element_out_attribute_value
	);

	character_renderer cr(
		clock,
		char,
		text_x,
		text_y,
		text_size,
		text_enable,

		text_out_x,
		text_out_y,
		text_out_plot,
		text_out_finished
	);

	render_rect rr(
		clock,

		// all these signals are high active
		rect_enable,

		// rect attributes
		rect_x,             //  the origin x of rect
		rect_y,             //  the origin y of rect

		rect_width,                //  the width (x) of rect
		rect_height,               //  the height (y) of rect

		rect_background_color,           //  background color
		rect_has_border,                     //  high active border signal
		rect_border_color,         //  border color

		rect_out_finished,                      // done signal, 0 means not done, 1 means done, stays at 1 until enable reset

		rect_out_color,     // output color stream
		rect_out_x,         // the stream output for x coords
		rect_out_y,         // the stream output for y coords
		rect_out_plot       // write enable for the VGA
	);

	/** 
	 * Multiplexer data path for
	 * selecting streams to output.
	 */
	always @(*) begin
		if(rect_enable == 1) begin
			out_x = rect_out_x;
			out_y = rect_out_y;
			plot = rect_out_plot;
			out_color = rect_out_color;
		end else if(text_enable == 1) begin
			out_x = text_out_x;
			out_y = text_out_y;
			plot = text_out_plot;
			out_color = text_color;
		end else begin
			out_x = 0;
			out_y = 0;
			plot = 0;
			out_color = 0;
		end
	end

	/**
	 * Pathways for pausing stream.
	 * Easier to react faster.
	 */
	always @(*) begin
		if(text_enable == 1) begin
			out_pause = 1;
		end else if(rect_enable == 1) begin	
			out_pause = 1;
		end else begin
			out_pause = 0;
		end
	end
	
	always @(*) begin
		if(element_enable && char == ">") begin
		// Reset
					if(element_out_is_closing) begin
						 if(element_out_tag == `TAG_P) begin
							text_x = 0;
							text_y = text_y + (text_size * `FONT_HEIGHT);
							rect_x = rect_margin;
							rect_y = text_y + rect_margin;

							text_color = 0;
							text_size = 1;
							text_padding = 0;
						 end else if (element_out_tag == `TAG_DIV) begin
							text_x = text_padding;
							text_y = text_y + rect_margin;
							rect_x = 0;
							rect_y = rect_y + rect_height;

							rect_width = 0;
							rect_height = 0;
							rect_margin = 0;
							rect_background_color = 0;
							rect_has_border = 0;
							rect_border_color = 0;
						 end
					end else begin
						 if(element_out_tag == `TAG_BODY) begin
							 rect_x = 0;
							 rect_y = 0;
							 rect_width = `SCREEN_WIDTH;
							 rect_height = `SCREEN_HEIGHT;
						 end else if (element_out_tag == `TAG_DIV) begin
							 rect_x = temp_rect_x;
							 rect_y = temp_rect_y;
							 rect_width = temp_rect_width;
							 rect_height = temp_rect_height;
						 end
						 text_x = temp_text_x;
						 text_y = temp_text_y;
						 text_color = temp_text_color;
						 text_size = temp_text_size;
						 text_padding = temp_text_padding;
					end
		end
	end

	// or posedge text_out_finished or posedge rect_out_finished or posedge element_out_finished
	always @(posedge clock) begin
		if (state_enable) begin
			if (element_enable) begin
				// Reading attribute k/v pairs
				if (element_out_finished) begin
					element_enable <= 0;
					// If element is block
					// then pause, draw rect
					// else continue reading
					
					if (element_out_is_closing == 0) begin
						 if(element_out_tag == `TAG_BODY) begin
							 
							 rect_enable <= 1;
						 end else if (element_out_tag == `TAG_DIV) begin
							 
							 rect_enable <= 1;
						 end
						
					end
				end else begin
					if (element_out_has_attribute) begin
						// Read attribute
						case (element_out_attribute_type)
							`ATT_COLOR: temp_text_color <= element_out_attribute_value[`COLOR_BITES];
							`ATT_SIZE: temp_text_size <= element_out_attribute_value;
							`ATT_WIDTH: temp_rect_width <= element_out_attribute_value[`X_BITES];
							`ATT_HEIGHT: temp_rect_height <= element_out_attribute_value[`Y_BITES];
							// `ATT_SRC: 
							// `ATT_HREF: 
							`ATT_BG: temp_rect_background_color <= element_out_attribute_value[`COLOR_BITES];
							`ATT_PADDING: begin
								temp_text_padding <= element_out_attribute_value[`X_BITES];
								temp_text_x <= text_x + text_padding;
								temp_text_y <= text_y + text_padding[`Y_BITES];
							end
							`ATT_MARGIN: begin
								temp_rect_margin <= element_out_attribute_value[`X_BITES];
								temp_rect_x <= rect_x + rect_margin;
								temp_rect_y <= rect_y + rect_margin[`Y_BITES];
							end
							`ATT_BORDER: begin
								temp_rect_has_border <= 1;
								temp_rect_border_color <= element_out_attribute_value[`COLOR_BITES];
							end
							// `ATT_POSITION:
						endcase
					end
				end
			end else begin
				// if (out_pause) begin
					if(text_enable == 1 && text_out_finished == 1) begin
						text_enable <= 0;
						temp_text_x <= text_x + `FONT_WIDTH + `FONT_KERNING;
					end else if (rect_enable && rect_out_finished) begin
						rect_enable <= 0;
					end else if(char == "<") begin
						text_enable <= 0;
						element_enable <= 1;
					end else if(rect_enable == 0) begin
						// Reading text
						text_enable <= 1;
					end
				// end
			end
		end else begin
			// Done drawing
			rect_enable <= 0;
			text_enable <= 0;
		end
	end
endmodule
