vlib work
vlog src/render_rect_datapath.v
vsim datapath

log {/*}
add wave {/*}

# testing datapath

# get clock running
force {clk} 0 0, 1 10 -r 20

# don't reset
force {resetn} 0

# feed x data in 15, y in 32 at 100
force {data_in} 7'b0001111 0, 7'b0100000 100
# ld_x is 1 for one clock cycle

force {ld_x} 1 40, 0 60

# ld_y is 1 for one clock cycle

force {ld_y} 1 120, 0 140

# start_count is 0
force {start_count} 0

run 200 ns

# remain at 0 forever
force {data_in} 7'b0
force {start_count} 0

run 40 ns

# change the values of data in to 0
# start_count is 1 for one clock cycle

force {start_count} 1 20, 0 40

run 400 ns
