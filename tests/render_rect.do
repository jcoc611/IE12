vlib work
vlog src/render_rect.v
vsim render_rect

log {/*}
add wave {/*}

# testing render_rect
# lets try and draw a 8 * 4 rect with background white
# and border red

# get clock running
force {clk} 0 0, 1 10 -r 20

# set the dimensions and other variables
force {origin_x} 9'b0
force {origin_y} 8'b0
force {width} 9'd4
force {height} 8'd8
force {back_color} 3'd7
force {border} 1
force {border_color} 3'd4

# set enable, to draw the rect a little into the time
force {enable} 1 50, 0 800
run 900 ns
