vlib work
vlog src/constants.v src/reading/html_reader.v
vsim html_reader

log {/*}
add wave {/*}

# testing html reader

force {clock} 0 0, 1 1 -r 2

# test case 1, enable is always 1 not paused
force {state_enable} 1
force {pause} 0
run 100 ps

force {pause} 1
run 50ps

force {pause} 0
run 300ps
