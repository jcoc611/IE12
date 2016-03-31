# Set the working dir, where all compiled Verilog goes.
vlib work

# Compile all verilog modules in ramtest.v to working dir;
# could also have multiple verilog files.
vlog src/constants.v src/parsing/char_to_int.v src/parsing/integer.v tests/parsing/integer.v

# Load simulation using mux as the top level simulation module.
vsim integer_test

# Log all signals and add some signals to waveform window.
log {/*}
# add wave {/*} would add all items in top level simulation module.
add wave {/*}


# Test 12345
force {clock} 0 0, 1 1 -r 2
run 50ps
