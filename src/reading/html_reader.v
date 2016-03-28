`timescale 1 ps / 1 ps
/*
 * reads the file index.html in the same directory
 * as this source file and outputs its char stream.
 * For other modules to use.
 */
module html_reader(
  input state_enable,                       // enable / ~reset
  input clock,                              // clock

  output reg has_finished,                  // has it finished?
  output reg [`CHAR_BITES] char             // output char stream
);

integer file, c;           // file to read, character

file = $fopenr("index.html");

always@(clock) begin
  if (state_enable) begin
    if (has_finished == 0) begin
      if (c == `EOF) begin
        has_finished <= 1;
      end
      // read chars and check for eof
      c <= $fgetc(file);
    end
  end else begin
    // reset
    char <= 0;
    has_finished = 0;
  end
end

always@(c) begin
  char = c[`CHAR_BITES];
end
endmodule
