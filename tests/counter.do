vlib work
vlog src/counter.v
vsim counter

log {/*}
add wave {/*}

# testing counter

force {clk} 0 0, 1 10 -r 20
# get clock running

force {limit} 17'd30
# count 0 - 29

# test condition - start_count is 1 for one clock cycle and 0 for rest
force {start_count} 1 0, 0 20
run 620 ns

# buffer
force {start_count} 0
run 100 ns


# start_count is always 1 throughout
force {start_count} 1
run 620 ns


# buffer
force {start_count} 0
run 100 ns

# test condition - start_count is 1 for many intervals over cycle
force {start_count} 1 0, 0 20 -r 40
run 620 ns



