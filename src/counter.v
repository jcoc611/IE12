`timescale 1 ns / 1 ns

// counter counting from 0 to 15 starting when start_count is 1

module counter(
	input clk,              // clock
	input start_count,      // signal to start counting
	output reg counting,    // whether the clock is still counting
	output reg [3:0] result // resulting output
	);

	initial counting = 1'b0;
	initial result = 4'd0;

	always@(posedge clk) begin
		if (start_count) begin
			counting <= 1'b1;
		end
	end

	always@(posedge clk) begin
		if (counting) begin
			if (result == 4'd15) begin
				counting <= 1'b0;
				result <= 4'd0;
			end else if (start_count) begin
				// result = 0
			end else begin
				result <= result + 4'd1;
			end
		end
	end
endmodule
// TODO: change render_rect to give writeEn out from counter, not FSM,
// otherwise infinite looping occurs
// TODO: also change the ns back to ps after testing


