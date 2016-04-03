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

	always @(posedge clk) begin
		if (counting) begin
			if(result + 1'b1 == limit) begin
				counting <= 0;
				has_finished <= 1;
			end else begin
				result <= result + 1'b1;	
			end
		end else begin
			result <= 0;
			has_finished <= 0;
			counting <= start_count;
		end
	end
endmodule


