# Set the working dir, where all compiled Verilog goes.
vlib work

# Compile all verilog modules in ramtest.v to working dir;
# could also have multiple verilog files.
vlog src/constants.v src/parsing/char_to_int.v src/parsing/integer.v src/parsing/attribute.v tests/parsing/attribute.v

# Load simulation using mux as the top level simulation module.
vsim attribute_test

# Log all signals and add some signals to waveform window.
log -r {/*}
# add wave {/*} would add all items in top level simulation module.
add wave {/*}


# Run test
force {clock} 0 0, 1 1 -r 2
run 60ps
