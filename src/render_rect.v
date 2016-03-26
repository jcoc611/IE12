`timescale 1 ps / 1 ps
`include "counter.v"

module render_rect
	(
		CLOCK_50,						//	On Board 50 MHz
		// Your inputs and outputs here
        KEY,
        SW,
		// VGA output ports
		VGA_CLK,   						//	VGA Clock
		VGA_HS,							//	VGA H_SYNC
		VGA_VS,							//	VGA V_SYNC
		VGA_BLANK_N,						//	VGA BLANK
		VGA_SYNC_N,						//	VGA SYNC
		VGA_R,   						//	VGA Red[9:0]
		VGA_G,	 						//	VGA Green[9:0]
		VGA_B   						//	VGA Blue[9:0]
	);

    // --------------------------------------------------------
	input			CLOCK_50;				//	50 MHz
	input   [9:0]   SW;
	input   [3:0]   KEY;

	// Do not change the following outputs
	output			VGA_CLK;   				//	VGA Clock
	output			VGA_HS;					//	VGA H_SYNC
	output			VGA_VS;					//	VGA V_SYNC
	output			VGA_BLANK;				//	VGA BLANK
	output			VGA_SYNC;				//	VGA SYNC
	output	[9:0]	VGA_R;   				//	VGA Red[9:0]
	output	[9:0]	VGA_G;	 				//	VGA Green[9:0]
	output	[9:0]	VGA_B;   				//	VGA Blue[9:0]
    // --------------------------------------------------------

	wire resetn;
	assign resetn = ~KEY[0];
    assign load = ~KEY[3];
    assign draw = ~KEY[1];

	wire [2:0] colour;          // 3 bit colors for dislay
	wire [7:0] x;               // x coord to draw
	wire [6:0] y;               // y coord to draw
	wire writeEn;               // draw enable signal

	// Define the number of colours and memory initialization file (.MIF)
	// to draw background
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
		defparam VGA.RESOLUTION = "160x120";
		defparam VGA.MONOCHROME = "FALSE";
		defparam VGA.BITS_PER_COLOUR_CHANNEL = 1;
		defparam VGA.BACKGROUND_IMAGE = "white.mif";

	// Put your code here. Your code should produce signals x,y, colour and writeEn/plot
	// for the VGA controller, in addition to any other functionality your design may require.

    wire ld_x, ld_y, drawing, start_count;

    // Instansiate datapath
	datapath d0(CLOCK_50, resetn, SW[6:0], ld_x, ld_y, start_count, x, y, drawing);

    // Instansiate FSM control
    control c0(CLOCK_50, resetn, load, draw, drawing, ld_x, ld_y, start_count, writeEn);

    assign color = SW[9:7];

endmodule

module control(
    input clk,          // the clock to perform FSM transitions
    input resetn,       // the reset signal for the screen (~KEY input)
    input load,         // the transition signal for the FSM (~KEY input)
    input draw,         // the draw signal for the FSM (~KEY input)
    input drawing      // signal from counter counting

    output reg ld_x, ld_y,      // load signals for the x, y coord regs
    output reg start_count      // signal to start counting to draw the box
    output reg writeEn          // signal to VGA to draw or not
    );
    // we have a total of 6 states
    reg [2:0] current_state, next_state;

    localparam  S_LOAD_X    = 3'd0,
                S_WAIT_X    = 3'd1,
                S_LOAD_Y    = 3'd2,
                S_WAIT_Y    = 3'd3,
                S_WAIT_DRAW = 3'd4,
                S_DRAW      = 3'd5;

    // sequential state transition function
    always@(*) begin: state_table
        case (current_state)
            S_LOAD_X: next_state = load ? S_WAIT_X : S_LOAD_X;
            S_WAIT_X: next_state = load ? S_WAIT_X : S_LOAD_Y;
            S_LOAD_Y: next_state = load ? S_WAIT_Y : S_LOAD_Y;
            S_WAIT_Y: next_state = load ? S_WAIT_Y : S_WAIT_DRAW;
            S_WAIT_DRAW: next_state = draw ? S_DRAW : S_WAIT_DRAW;
            S_DRAW: next_state = drawing ? S_DRAW: S_LOAD_X;
        default: next_state = S_LOAD_X;
        endcase
    end     // state_table

    // output signals to datapath
    always@(*) begin: enable_signals
        ld_x = 1'b0;
        ld_y = 1'b0;
        start_count = 1'b0;
        writeEn = 1'b0;

        case (current_state)
            S_LOAD_X: ld_x = 1'b1;
            S_LOAD_Y: ld_y = 1'b1;
            S_DRAW: begin
                start_count = 1'b1;
                writeEn = 1'b1;
            end
        endcase
    end     // enable_signals

    // change signals according to clock cycle
    always@(posedge clk) begin: state_FFs
        current_state <= resetn ? next_state : S_LOAD_X;
    end // state_FFs
endmodule

module datapath(
    input clk,          // clock
    input resetn,       // resetn (~KEY)

    input [6:0] data_in, // input X, Y coordinates

    input ld_x, ld_y    // wether to load x and y into registers
    input start_count,  // start counting signal

    output reg [7:0] r_x, // the result x register
    output reg [6:0] r_y,  // the result y register
    output counting     // if the counter inside is  counting
    // note writeEn and color are directly passed to the VGA by other modules
    );

    reg [7:0] x;
    reg [6:0] y;
    reg count_signal;

    // load the registers
    always@(posedge clk) begin
        count_signal <= start_count;

        if (resetn) begin
            x <= 8'b0;
            y <= 7'b0;
        end else begin
            if (ld_x)
                x <= {1'b0, data_in};
            if (ld_y)
                y <= data_in;
        end
    end

    wire [3:0] offset;

    counter c0(clk, count_signal, counting, offset);

    // output result registers
    always@(posedge clk) begin
        if (resetn) begin
            r_x <= 8'b0;
            r_y <= 7'b0;
        end
        else begin
            r_x = x + offset[1:0];
            r_y = y + offset[1:0];
        end
    end


endmodule
