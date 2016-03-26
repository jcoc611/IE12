vlib work
vlog src/render_rect_control.v
vsim control

log {/*}
add wave {/*}

# testing control

# get clock running
force {clk} 0 0, 1 10 -r 20

# reset initially
force {resetn} 1 0, 0 20

# change the load signal from 0 to 1 to 0 to 1
force {enable} 0
run 50 ns

force {enable} 0 5, 1 15 -r 20
run 80 ns

# start the counting for one clock cycle
force {draw} 1 0, 0 20
run 80 ns


# buffer
force {enable} 0
force {draw} 0
run 100 ns

# test if reset works
force {enable} 0 0, 1 20 -r 40
force {resetn} 0 0, 1 50
run 80 ns

