`timescale 1 ps / 1 ps
/**
 * Renders a square of a given size.
 */
module square_renderer(
	input                    clock,
	input      [`X_BITES] origin_x,
	input      [`Y_BITES] origin_y,
	input [`ATTRIBUTE_VAL_BITES]     size,
	input            state_enabled,

	output     [`X_BITES] out_x,
	output     [`Y_BITES] out_y,
	output               has_finished
);
	/** The state variable that indicates whether the process has completed */
	reg state_finished;

	/** The pixel being drawn. */
	reg [`X_BITES] current_x;
	reg [`Y_BITES] current_y;

	// Initialize regs
	initial state_finished = 0;

	always @(posedge clock) begin
		if (state_enabled == 1) begin
			if(current_x - origin_x + 1 == size) begin
				// Finished row
				if(current_y - origin_y  + 1 == size) begin
					// Finished drawing square
					state_finished <= 1;
				end else begin
					// Draw next row
					current_x <= origin_x;
					current_y <= current_y + 1;
				end
			end else begin
				// Draw next pixel in row
				current_x <= current_x + 1;
			end
		end else begin
			state_finished <= 0;
			current_x <= origin_x;
			current_y <= origin_y;
		end
	end

	assign has_finished = state_finished;
	assign out_x = current_x;
	assign out_y = current_y;
endmodule
