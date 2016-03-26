`timescale 1 ps / 1 ps

// counter counting from 0 to 15 starting when start_count is 1

module counter(
    input clk,              // clock
    input start_count,      // signal to start counting
    output reg counting,    // whether the clock is still counting
    output reg [3:0] result // resulting output
    );

    initial counting = 1'b1;
    initial result = 4'd15;

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
            end else begin
                result <= result + 4'd1;
            end
        end
    end
endmodule


