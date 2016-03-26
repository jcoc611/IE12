`timescale 1 ns / 1 ns
`include "counter.v"

module datapath(
    input clk,          // clock
    input resetn,       // resetn (~KEY)

    input [6:0] data_in, // input X, Y coordinates

    input ld_x, ld_y,    // wether to load x and y into registers
    input start_count,  // start counting signal

    output reg [7:0] r_x, // the result x register
    output reg [6:0] r_y,  // the result y register
    output writeEn     // signal to VGA to draw or not, given by counter
    // note color is directly passed to the VGA by other modules
    );

    reg [7:0] x;        // storage for input x
    reg [6:0] y;        // storage for input y

    // load the registers
    always@(*) begin
        count_signal = start_count;

        if (resetn) begin
            x = 8'b0;
            y = 7'b0;
        end else begin
            if (ld_x)
                x = {1'b0, data_in};
            if (ld_y)
                y = data_in;
        end
    end

    wire [3:0] offset;

    counter c0(clk, start_count, writeEn, offset);

    // output result registers
    always@(posedge clk) begin
        if (resetn) begin
            r_x <= 8'b0;
            r_y <= 7'b0;
        end
        else begin
            r_x = x + offset[1:0];
            r_y = y + offset[3:2];
        end
    end
endmodule
