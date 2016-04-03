`timescale 1 ps / 1 ps
/**
 * Renders an ASCII character.
 */

module character_renderer(
	input                    clock,
	input   [`CHAR_BITES]     char,
	input      [`X_BITES] origin_x,
	input      [`Y_BITES] origin_y,
	input [`ATTRIBUTE_VAL_BITES]     size,
	input            state_enabled,

	output    [`X_BITES] out_x,
	output    [`Y_BITES] out_y,
	output reg          is_drawing,
	output reg        has_finished
);

	reg [`FONT_INDEX_BITES] state_pixel_index = 0;
	reg state_init_square = 0;

	/** Initialize registries. */
	initial has_finished = 0;
	initial is_drawing = 0;

	reg square_state_enabled = 0;
	reg [`X_BITES] square_origin_x;
	reg [`Y_BITES] square_origin_y;
	wire square_state_finished;

	square_renderer sq(
		clock,
		square_origin_x,
		square_origin_y,
		size,
		square_state_enabled,

		out_x,
		out_y,
		square_state_finished
	);

	wire [`FONT_BITES] decoder_pixels;

	char_decoder cd(
		char,
		decoder_pixels
	);

	always @(posedge clock) begin
		if(state_enabled == 1) begin
			if(state_pixel_index == `FONT_MAX_BIT) begin
				// We are done drawing char
				has_finished <= 1;
			end else begin
				// Still pixels to go
				if(state_init_square == 1) begin
					state_init_square <= 0;
					square_state_enabled <= 1;
					is_drawing <= 1;
				end else begin
					if(square_state_enabled == 1) begin
						if(square_state_finished == 1) begin
							square_state_enabled <= 0;
							state_pixel_index <= state_pixel_index + 1'b1;
						end
					end else begin
						if(decoder_pixels[`FONT_MAX_BIT - state_pixel_index] == 1) begin
							// Figure out origin for next pixel
							square_origin_x <= origin_x + (size * (state_pixel_index % `FONT_WIDTH));
							square_origin_y <= origin_y + (size * (state_pixel_index / `FONT_WIDTH));
							state_init_square <= 1;
							
						end else begin
							state_pixel_index <= state_pixel_index + 1'b1;
							is_drawing <= 0;
						end
	 				end	
				end
				
			end
		end else begin
			square_origin_x <= origin_x;
			square_origin_y <= origin_y;
			square_state_enabled <= 0;
			state_pixel_index <= 0;
			has_finished <= 0;
			is_drawing <= 0;
		end
	end
endmodule
