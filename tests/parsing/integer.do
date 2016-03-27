# Set the working dir, where all compiled Verilog goes.
vlib work

# Compile all verilog modules in ramtest.v to working dir;
# could also have multiple verilog files.
vlog src/constants.v src/parsing/char_to_int.v src/parsing/integer.v

# Load simulation using mux as the top level simulation module.
vsim integer_parser

# Log all signals and add some signals to waveform window.
log {/*}
# add wave {/*} would add all items in top level simulation module.
add wave {/*}

# Reset
force {state_enable} 0
force {clock} 0 0, 1 1 -r 2
run 4ps


# Test 12345
force {state_enable} 1
force {char} 110001
run 2ps

force {char} 110010
run 2ps

force {char} 110011
run 2ps

force {char} 110100
run 2ps

force {char} 110101
run 2ps