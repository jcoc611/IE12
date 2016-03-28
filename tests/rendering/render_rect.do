vlib work
vlog src/rendering/render_rect.v src/constants.v src/rendering/counter.v

vsim render_rect

log {/*}
add wave {/*}

# testing render_rect
# lets try and draw a 9 * 3 rect with background black
# and border cyan

# get clock running
force {clk} 0 0, 1 1 -r 2

# set the dimensions and other variables
force {origin_x} 9'b1
force {origin_y} 8'b1
force {width} 9'd9
force {height} 8'd3
force {back_color} 3'd0
force {border} 1
force {border_color} 3'd3

# set enable, to draw the rect a little into the time
force {enable} 1 10, 0 80
run 100 ps
