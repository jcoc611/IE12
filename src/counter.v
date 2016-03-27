`timescale 1 ns / 1 ns

// counter counting from 0 to limit starting when start_count is 1

module counter(
	input clk,              // clock
	input start_count,      // signal to start counting
	input [16:0] limit, 		// the number to count upto
	output reg counting,    // whether the clock is still counting
	output reg [16:0] result // resulting output
	);

	initial counting = 1'b0;
	initial result = 17'b0;

	always@(posedge clk) begin
		if (start_count) begin
			counting <= 1'b1;
		end
	end

	always@(posedge clk) begin
		if (counting) begin
			if (result == limit) begin
				counting <= 1'b0;
				result <= 17'b0;
			end else if (start_count) begin
				// result = 0
			end else begin
				result <= result + 1'b1;
			end
		end
	end
endmodule


