vlib work
vlog src/counter.v
vsim counter

log {/*}
add wave {/*}

# testing counter

force {clk} 0 0, 1 10 -r 20
# get clock running

# test condition - start_count is 1 for one clock cycle and 0 for rest
force {start_count} 1 0, 0 30
run 340 ns

force {start_count} 0
run 60 ns


# start_count is always 1 throughout
force {start_count} 1
run 600 ns


force {start_count} 0
run 60 ns

# test condition - start_count is 1 for many intervals over cycle
force {start_count} 1 0, 0 20 -r 40
run 800 ns



