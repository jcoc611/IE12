`timescale 1 ns / 1 ns

module control(
    input clk,          // the clock to perform FSM transitions
    input resetn,       // the reset signal for the screen (~KEY input)

    input enable,         // the transition signal for the FSM (~KEY input)
    input draw,         // the draw signal for the FSM (~KEY input)

    output reg ld_x, ld_y,      // load signals for the x, y coord regs
    output reg start_count,      // signal to start counting to draw the box
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
            S_LOAD_X: next_state = enable ? S_WAIT_X : S_LOAD_X;
            S_WAIT_X: next_state = enable ? S_WAIT_X : S_LOAD_Y;
            S_LOAD_Y: next_state = enable ? S_WAIT_Y : S_LOAD_Y;
            S_WAIT_Y: next_state = enable ? S_WAIT_Y : S_WAIT_DRAW;
            S_WAIT_DRAW: next_state = draw ? S_DRAW : S_WAIT_DRAW;
            S_DRAW: next_state = S_LOAD_X;
        default: next_state = S_LOAD_X;
        endcase
    end     // state_table

    // output signals to datapath
    always@(*) begin: enable_signals
        ld_x = 1'b0;
        ld_y = 1'b0;
        start_count = 1'b0;

        case (current_state)
            S_LOAD_X: ld_x = 1'b1;
            S_LOAD_Y: ld_y = 1'b1;
            S_DRAW: start_count = 1'b1;
        endcase
    end     // enable_signals

    // change signals according to clock cycle
    always@(posedge clk) begin: state_FFs
        current_state <= resetn ? next_state : S_LOAD_X;
    end // state_FFs
endmodule
