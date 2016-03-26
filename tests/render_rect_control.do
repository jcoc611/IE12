vlib work
vlog src/render_rect_control.v
vsim control

log {/*}
add wave {/*}

# testing control

# get clock running
force {clk} 0 0, 1 10 -r 20

# don't reset
force {resetn} 0

# alternate the enable signal
force {enable} 0 0, 1 20 -r 40

# draw signal is on later
force {draw} 0 0, 0 200
force {draw} 1 200, 0 240
run 240 ns
