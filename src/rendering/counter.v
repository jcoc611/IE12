`timescale 1 ps / 1 ps

/* counter counting from 0 to limit starting when start_count is pulsed to 1 */

module counter(
	input clk,              					// clock
	input start_count,      					// signal to start counting
	input [`X_Y_PRODUCT_BITES] limit, // the number to count upto
	output reg has_finished,    					// whether the clock is still counting
	output reg [`X_Y_PRODUCT_BITES] result // resulting output
	);

	reg counting = 0;
	initial result = 17'b0;

	initial has_finished = 0;

	always @(*) begin
		if(start_count) begin
			counting = 1;
		end else if(result + 1'b1 == limit) begin
			counting = 0;
		end
		has_finished = (result + 1'b1 == limit);
	end

	always @(posedge clk) begin
		if (counting) begin
			result <= result + 1'b1;
		end else begin
			result <= 0;
		end
	end
endmodule


