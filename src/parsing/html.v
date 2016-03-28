module html_parser(
	input clock,
	input [`CHAR_BITES] char,
	input enable, 					// enable / ~reset

	output [`X_BITES] out_x,
	output [`Y_BITES] out_y,
	output [`COLOR_BITES] out_color,
	output reg plot
);

	/** Text State */
	// inputs
	reg text_enable = 0;
	reg [`COLOR_BITES] text_color = 0;
	reg [`ATTRIBUTE_VAL_BITES] text_size = 1;
	reg [`X_BITES] text_x = 0;
	reg [`Y_BITES] text_y = 0;

	// outputs
	wire [`X_BITES] text_out_x;
	wire [`Y_BITES] text_out_y;
	wire text_out_plot;
	wire text_out_finished;

	/** rect State */
	// inputs
	reg rect_enable = 0;
	reg [`X_BITES] tate_rect_x = 0;
	reg [`Y_BITES] tate_rect_y = 0;
	reg [`X_BITES] rect_width = 0;
	reg [`Y_BITES] rect_height = 0;
	reg rect_has_border = 0;
	reg [`COLOR_BITES] rect_border_color;
	reg [`COLOR_BITES] rect_background_color = 0;

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
			out_x <= rect_out_x;
			out_y <= rect_out_y;
			plot <= rect_out_plot;
			out_color <= rect_out_color;
		end else if(text_enable == 1) begin
			out_x <= text_out_x;
			out_y <= text_out_y;
			plot <= text_out_plot;
			out_color <= text_color;
		end else begin
			out_x <= 0;
			out_y <= 0;
			plot <= 0;
			out_color <= 0;
		end
	end

	always (posedge clock or text_out_finished
		                  or rect_out_finished
		                  or element_out_finished) begin
		if (enable == 1) begin
			if (element_enable == 1) begin
				// Reading attribute k/v pairs
			end else begin
				if(char == "<") begin
					element_enable <= 1;
				end else begin
					// Reading text
					text_enable <= 1;
				end
			end
		end else begin
			// Done drawing
			rect_enable <= 0;
			text_enable <= 0;
		end
	end
endmodule
