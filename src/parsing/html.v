module html_parser(
	input clock,
	input [`CHAR_BITES] char,
	input enable,

	output [`X_BITES] out_x,
	output [`Y_BITES] out_y,
	output [`COLOR_BITES] out_color,
	output reg plot
);

	/** Text State */
	reg state_text_enable = 0;
	reg [`COLOR_BITES] state_text_color = 0;
	reg [`ATTRIBUTE_VAL_BITES] state_text_size = 1;
	reg [`X_BITES] state_text_x = 0;
	reg [`Y_BITES] state_text_y = 0;
	wire [`X_BITES] out_text_x;
	wire [`Y_BITES] out_text_y;
	wire out_text_plot;
	wire out_text_finished;

	/** rect State */
	reg state_rect_enable = 0;
	reg [`COLOR_BITES] state_rect_background = 0;
	reg [`X_BITES] state_rect_x = 0;
	reg [`Y_BITES] state_rect_y = 0;
	reg [`X_BITES] state_rect_w = 0;
	reg [`Y_BITES] state_rect_h = 0;
	reg rect_has_border = 0;
	reg [`COLOR_BITES] rect_border_color;
	wire [`X_BITES] out_rect_x;
	wire [`Y_BITES] out_rect_y;
	wire [`COLOR_BITES] out_rect_color;
	wire out_rect_plot;
	wire out_rect_finished;

	/** Element parser state vars */
	reg state_element_enable = 0;
	wire state_element_finished;

	wire [`ELE_TAG_BITES] element_tag;
	wire element_is_closing;

	wire element_has_attribute;
	wire [`ATTRIBUTE_TYPE_BITES] element_attribute_type;
	wire [`ATTRIBUTE_VAL_BITES] element_attribute_value;

	element_parser ep(
		char,
		state_element_enable,
		clock,

		state_element_finished,
		element_tag,
		element_is_closing,

		element_has_attribute,
		element_attribute_type,
		element_attribute_value
	);

	character_renderer cr(
		clock,
		char,
		state_text_x,
		state_text_y,
		state_text_size,
		state_text_enable,

		out_text_x,
		out_text_y,
		out_text_plot,
		out_text_finished     
	);

	render_rect rr(
		clock,

        // all these signals are high active
        state_rect_enable,

        // rect attributes
        state_rect_x,             //  the origin x of rect
        state_rect_y,             //  the origin y of rect

        state_rect_w,                //  the width (x) of rect
        state_rect_h,               //  the height (y) of rect

        state_rect_background,           //  background color
        rect_has_border,                     //  high active border signal
        rect_border_color,         //  border color

        out_rect_finished,                      // done signal, 0 means not done, 1 means done, stays at 1 until enable reset

        out_rect_color,     // output color stream
        out_rect_x,         // the stream output for x coords
        out_rect_y,         // the stream output for y coords
        out_rect_plot       // write enable for the VGA
	);

	/** 
	 * Multiplexer data path for
	 * selecting streams to output.
	 */
	always @(*) begin
		if(state_rect_enable == 1) begin
			out_x <= out_rect_x;
			out_y <= out_rect_y;
			plot <= out_rect_plot;
			out_color <= out_rect_color;
		end else if(state_text_enable == 1) begin
			out_x <= out_text_x;
			out_y <= out_text_y;
			plot <= out_text_plot;
			out_color <= state_text_color;
		end else begin
			out_x <= 0;
			out_y <= 0;
			plot <= 0;
			out_color <= 0;
		end
	end

	always (posedge clock or out_text_finished 
		                  or out_rect_finished
		                  or state_element_finished) begin
		if (enable == 1) begin
			if (state_element_enable == 1) begin
				// Reading attribute k/v pairs
			end else begin
				if(char == "<") begin
					state_element_enable <= 1;
				end else begin
					// Reading text
					state_text_enable <= 1;
				end
			end
		end else begin
			// Done drawing
			state_rect_enable <= 0;
			state_text_enable <= 0;
		end
	end
endmodule