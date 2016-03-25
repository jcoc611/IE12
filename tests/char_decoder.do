cd ..

# Set the working dir, where all compiled Verilog goes.
vlib work

# Compile all verilog modules in ramtest.v to working dir;
# could also have multiple verilog files.
vlog src/char_decoder.v

# Load simulation using mux as the top level simulation module.
vsim char_decoder

# Log all signals and add some signals to waveform window.
log {/*}
# add wave {/*} would add all items in top level simulation module.
add wave {/*}


# Test undefined chars
force {char} 7'b0100001
run 20ms

# Test known char (A)
force {char} 7'b1000001
run 20ms

# Test char outside bounds (\0)
force {char} 7'b0000000
run 20ms
