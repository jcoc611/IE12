// Part 2 skeleton
`include "counter.v"

module part2
	(
		CLOCK_50,						//	On Board 50 MHz
        KEY,                            // KEY[3] load, KEY[1] is draw, KEY[0] reset
        SW,                             // SW[8:0] is used to give width and height
		// The ports below are for the VGA output.  Do not change.
		VGA_CLK,   						//	VGA Clock
		VGA_HS,							//	VGA H_SYNC
		VGA_VS,							//	VGA V_SYNC
		VGA_BLANK,						//	VGA BLANK
		VGA_SYNC,						//	VGA SYNC
		VGA_R,   						//	VGA Red[9:0]
		VGA_G,	 						//	VGA Green[9:0]
		VGA_B   						//	VGA Blue[9:0]
	);

	input			CLOCK_50;				//	50 MHz
	input   [9:0]   SW;
	input   [3:0]   KEY;

	// Declare your inputs and outputs here
	// Do not change the following outputs
	output			VGA_CLK;   				//	VGA Clock
	output			VGA_HS;					//	VGA H_SYNC
	output			VGA_VS;					//	VGA V_SYNC
	output			VGA_BLANK;				//	VGA BLANK
	output			VGA_SYNC;				//	VGA SYNC
	output	[9:0]	VGA_R;   				//	VGA Red[9:0]
	output	[9:0]	VGA_G;	 				//	VGA Green[9:0]
	output	[9:0]	VGA_B;   				//	VGA Blue[9:0]

	wire resetn;
	assign resetn = KEY[0];

	// Create the colour, x, y and writeEn wires that are inputs to the controller.
	wire [2:0] colour;
	wire [7:0] x;
	wire [6:0] y;
	wire writeEn;

	// Create an Instance of a VGA controller - there can be only one!
	// Define the number of colours as well as the initial background
	// image file (.MIF) for the controller.
	vga_adapter VGA(
			.resetn(resetn),
			.clock(CLOCK_50),
			.colour(colour),
			.x(x),
			.y(y),
			.plot(writeEn),
			/* Signals for the DAC to drive the monitor. */
			.VGA_R(VGA_R),
			.VGA_G(VGA_G),
			.VGA_B(VGA_B),
			.VGA_HS(VGA_HS),
			.VGA_VS(VGA_VS),
			.VGA_BLANK(VGA_BLANK),
			.VGA_SYNC(VGA_SYNC),
			.VGA_CLK(VGA_CLK));
		defparam VGA.RESOLUTION = "320x240";
		defparam VGA.MONOCHROME = "FALSE";
		defparam VGA.BITS_PER_COLOUR_CHANNEL = 1;
		defparam VGA.BACKGROUND_IMAGE = "black.mif";
			
	// Put your code here. Your code should produce signals x,y,colour and writeEn/plot
	// for the VGA controller, in addition to any other functionality your design may require.
    
    wire [8:0] width;
    wire [7:0] height;
    wire draw_signal, dummy1,

    // Instansiate datapath
    datapath d0(
        .clk(CLOCK_50),
        .resetn(~resetn),
        .enable(draw_signal),
        .data_in(SW[9:0]),

        .origin_x(9'd15),
        .origin_y(8'd15),
        .load_width(width),
        .load_height(height),

        .back_color(3'b111),
        .border(1),
        .border_color(3'b100),

        .done(dummy1),
        .color_stream(colour),
        .x_stream(x),
        .y_stream(y),
        .writeEn(writeEn)
    );

    // Instansiate FSM control
    control c0(
    	.clk(CLOCK_50),
    	.resetn(~resetn),
    	.go(~KEY[3]),
    	.draw(~KEY[1]),

    	.load_width(width),
    	.load_height(height),
    	.writeEn(draw_signal)
    );

endmodule

module control
	(
		input clk,
		input resetn,
		input go,
		input draw,

		output reg load_width,
		output reg load_height,
		output reg writeEn
	);

	reg [2:0] current_state, next_state;

	localparam 	LOAD_WIDTH 	= 2'd0,
				LOAD_HEIGHT 	= 2'd1,
				DRAW 	= 2'd2;

	// Next state logic aka our state table
    always@(*) begin: state_table
    	case (current_state)
                LOAD_WIDTH: next_state = go ? LOAD_HEIGHT : LOAD_WIDTH;
                LOAD_HEIGHT: next_state = draw ? DRAW : LOAD_HEIGHT;
                DRAW: next_state = LOAD_WIDTH;
            default:     next_state = LOAD_WIDTH;
        endcase
    end // state_table

    // Output logic aka all of our datapath control signals
    always @(*) begin: enable_signals
        // By default make all our signals 0
        load_width = 1'b0;
        load_height = 1'b0;
       	writeEn = 1'b0;

        case (current_state)
            LOAD_WIDTH: begin
                load_width = 1'b1;
                end
            LOAD_HEIGHT: begin
                load_height = 1'b1;
                end
           	DRAW: begin
                writeEn = 1'b1;
                end
        endcase
    end // enable_signals

    // current_state registers
    always@(posedge clk)
    begin: state_FFs
        if (resetn)
            current_state <= LOAD_WIDTH;
        else
            current_state <= next_state;
    end // state_FFS

endmodule

module datapath(
    input clk,
    input resetn,
    input enable,
    input [9:0] data_in,

    input [8:0] origin_x,
    input [7:0] origin_y,
    input load_width,
    input load_height,

    input [2:0] back_color,
    input  border,
    input [2:0] border_color,

    output reg done,
    output reg [2:0] color_stream,
    output reg [8:0] x_stream,
    output reg [7:0] y_stream,
    output writeEn
);

    wire [16:0] offset;         // offset of counter

    reg [8:0] width;            // holds value from the SW
    reg [7:0] height;

    // load the values in
    always @(*) begin
        if (resetn) begin
            done = 0;
            color_stream = 0;
            x_stream = 0;
            y_stream = 0;
            writeEn = 0;

            width = 0;
            height = 0;

        end else begin
            if (load_width == 1) begin
                width = data_in[8:0];
            end
            if (load_height == 1) begin
                height = data_in[7:0];
            end
            // load the output registers
            if (is_started == 1) begin
                // enable is on, start drawing the square
                x_stream = origin_x + (offset % width);
                y_stream = origin_y + (offset / width);

                if (border) begin
                    // border offsets only occur when
                    color_stream = ((((offset % width) == 9'b0) || ((offset % width) == width - 1) || ((offset / width) == 8'b0) || ((offset / width) == height - 1)) ? border_color : back_color);
                end else begin
                    color_stream = back_color;
                end
                // setting screen boundary limits
                x_stream = (x_stream >= 9'd320) ? 9'd319 : x_stream;
                // writeEn is handled by counter
                done = ~writeEn;
            end
        end
    end


    // when enable turns on, start signal is set to 1
    // on the next clk edge it is put back to 0
    reg start_signal = 0;
    reg is_started = 0;

    always @(posedge clk) begin
        if (resetn) begin
            is_started <= 0;
            start_signal <= 0;
        end else begin
            if (enable && is_started == 0) begin
                start_signal <= 1;
                is_started <= 1;
            end else begin
                start_signal <= 0;
            end
        end
    end

    // counter should not be fed in enable
    wire [16:0] limit = width * height;
    /* clk              clock
     * start_count      (pulse) signal to start counting
     * limits           the number to count up to
     *
     * counting         whether the clock currently counting
     * result           resulting output
     */
    counter c0(clk, start_signal, limit, writeEn, offset);

endmodule
