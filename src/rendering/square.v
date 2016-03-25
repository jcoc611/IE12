/**
 * Renders a square of a given size.
 */
module super_pixel(
	input      [X_BITES] origin_x,
	input      [Y_BITES] origin_y,
	input [SQUARE_BITES] size,

	output     [X_BITES] out_x,
	output     [X_BITES] out_y,
	output               has_finished
);
	reg state_finished;
	initial state_finished = 0;

	
endmodule