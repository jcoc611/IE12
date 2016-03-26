# Set the working dir, where all compiled Verilog goes.
vlib work

# Compile all verilog modules in ramtest.v to working dir;
# could also have multiple verilog files.
vlog src/constants.v src/parsing/char_to_int.v

# Load simulation using mux as the top level simulation module.
vsim char_to_int

# Log all signals and add some signals to waveform window.
log {/*}
# add wave {/*} would add all items in top level simulation module.
add wave {/*}


# Test 0 - 9
force {char} 110000
run 10ms

force {char} 110001
run 10ms

force {char} 110010
run 10ms

force {char} 110011
run 10ms

force {char} 110100
run 10ms

force {char} 110101
run 10ms

force {char} 110110
run 10ms

force {char} 110111
run 10ms

force {char} 111000
run 10ms

force {char} 111001
run 10ms

# Test off bounds (below and above)
force {char} 100000
run 10ms

force {char} 111010
run 10ms
