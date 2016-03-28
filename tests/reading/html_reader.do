vlib work
vlog src/constants.v src/reading/html_reader.v
vsim html_reader

log {/*}
add wave {/*}

# testing counter

force {state_enable} 0
force {clock} 0 0, 1 1 -r 2
run 5 ps

force {state_enable} 1
run 380 ps
