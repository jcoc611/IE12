`timescale 1 ps / 1 ps

/*
 * Module for parsing HTML
 */
module html_parser(
	input [`CHAR_BITES] char,
	input enable,
	input reset,
	input clock,

	output reg next_char,
	output reg has_finished,	
	output reg [`X_BITES] out_x,
	output reg [`Y_BITES] out_y,
	output reg [`COLOR_BITES] out_color,
	output reg plot
);

	/** Element parser state vars */
	// input
	reg element_enable;
	reg element_reset;

	// outputs
	wire element_out_next_char;
	wire element_out_finished;
	wire [`ELE_TAG_BITES] element_out_tag;
	wire element_out_is_closing;

	wire element_out_has_attribute;
	wire [`ATTRIBUTE_TYPE_BITES] element_out_attribute_type;
	wire [`ATTRIBUTE_VAL_BITES] element_out_attribute_value;

	element_parser ep(
		char,
		element_enable,
		element_reset,
		clock,

		// Outputs
		element_out_next_char,
		element_out_finished,
		element_out_tag,
		element_out_is_closing,

		element_out_has_attribute,
		element_out_attribute_type,
		element_out_attribute_value
	);

	/** Text State */
	// inputs
	reg text_enable;
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

	/** rect State */
	// inputs
	reg rect_enable;
	reg [`X_BITES] rect_x;
	reg [`Y_BITES] rect_y;
	reg [`X_BITES] rect_width;
	reg [`Y_BITES] rect_height;
	reg [`X_BITES] rect_margin;
	reg rect_has_border;
	reg [`COLOR_BITES] rect_border_color;
	reg [`COLOR_BITES] rect_background_color;

	// outputs
	wire [`X_BITES] rect_out_x;
	wire [`Y_BITES] rect_out_y;
	wire [`COLOR_BITES] rect_out_color;
	wire rect_out_plot;
	wire rect_out_finished;

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

	reg idle_next_char;

	/** Datapath for next character signals. */
	always @(*) begin
		if(element_enable) begin
			next_char = element_out_next_char;
		end else begin
			next_char = idle_next_char;
		end
	end

	always @(posedge clock) begin
		if(reset) begin
			/** Element defaults.*/
			element_enable <= 0;
			element_reset <= 1;

			/** Rect defaults. */
			rect_enable <= 0;
			rect_x <= 0;
			rect_y <= 0;
			rect_width <= 0;
			rect_height <= 0;
			rect_margin <= 0;
			rect_has_border <= 0;
			rect_border_color <= 0;
			rect_background_color <= 0;

			/** Text defaults. */
			text_enable <= 0;
			text_color <= 7;
			text_size <= 1;
			text_x <= 0;
			text_y <= 0;
			text_padding <= 0;

			/** Other defaults. */
			idle_next_char <= 0;
			has_finished <= 0;
		end else if(enable) begin
			if(element_enable) begin
				if(element_out_has_attribute) begin
					// Read attribute
					case (element_out_attribute_type)
						`ATT_COLOR:	text_color <= element_out_attribute_value[`COLOR_BITES];
						`ATT_SIZE:	text_size <= element_out_attribute_value;
						`ATT_WIDTH:	rect_width <= element_out_attribute_value[`X_BITES];
						`ATT_HEIGHT:	rect_height <= element_out_attribute_value[`Y_BITES];
						`ATT_BG:	rect_background_color <= element_out_attribute_value[`COLOR_BITES];
						`ATT_PADDING: begin
							text_padding <= element_out_attribute_value[`X_BITES];
							text_x <= text_x + text_padding;
							text_y <= text_y + text_padding[`Y_BITES];
						end
						`ATT_MARGIN: begin
							rect_margin <= element_out_attribute_value[`X_BITES];
							rect_x <= rect_x + rect_margin;
							rect_y <= rect_y + rect_margin[`Y_BITES];
						end
						`ATT_BORDER: begin
							rect_has_border <= 1;
							rect_border_color <= element_out_attribute_value[`COLOR_BITES];
						end
						// Not implemented yet
						// `ATT_POSITION:
						// `ATT_SRC: 
						// `ATT_HREF: 
					endcase
				end
				if(element_out_finished) begin
					// Element ended, draw whateva
					element_enable <= 0;

					if(element_out_is_closing) begin
						if(element_out_tag == `TAG_P) begin
							// </p>
							text_x <= 0;
							text_y <= text_y + (text_size * `FONT_HEIGHT);
							rect_x <= rect_margin;
							rect_y <= text_y + + (text_size * `FONT_HEIGHT) + rect_margin[`Y_BITES];

							text_color <= 0;
							text_size <= 1;
							text_padding <= 0;
						end else if (element_out_tag == `TAG_DIV) begin
							// </div>
							text_x <= text_padding;
							text_y <= text_y + rect_margin[`Y_BITES];
							rect_x <= 0;
							rect_y <= rect_y + rect_height;

							rect_width <= 0;
							rect_height <= 0;
							rect_margin <= 0;
							rect_background_color <= 0;
							rect_has_border <= 0;
							rect_border_color <= 0;
						end

						// Not drawing anything, so
						element_reset <= 1;
					end else begin
						if(element_out_tag == `TAG_BODY) begin
							// <body ...>
							rect_x <= 0;
							rect_y <= 0;
							rect_width <= `SCREEN_WIDTH;
							rect_height <= `SCREEN_HEIGHT;
							rect_enable <= 1;
						end else if (element_out_tag == `TAG_DIV) begin
							// <div ...>
							rect_enable <= 1;
						end else begin
							// A text tag, such as
							// <p ...>
							// So not drawing anything here:
							element_reset <= 1;
						end
					end
				end
			end else if(element_reset) begin
				idle_next_char <= 1;
				element_reset <= 0;
			end else if(rect_enable && rect_out_finished) begin
				rect_enable <= 0;
				element_reset <= 1;
			end else if(text_enable && text_out_finished) begin
				text_enable <= 0;
				text_x <= text_x + (text_size * `FONT_WIDTH) + `FONT_KERNING;
				idle_next_char <= 1;
			end else if(!idle_next_char) begin
				if(char == "<") begin
					// Reading element
					element_enable <= 1;
				end else if(char != ">") begin
					text_enable <= 1;
				end
			end else begin
				idle_next_char <= 0;
			end
		end
	end
endmodule
