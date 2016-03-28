# Set the working dir, where all compiled Verilog goes.
vlib work

# Compile all verilog modules in ramtest.v to working dir;
# could also have multiple verilog files.
vlog src/constants.v src/parsing/char_to_int.v src/parsing/integer.v src/parsing/attribute.v src/parsing/element.v

# Load simulation using mux as the top level simulation module.
vsim element_parser

# Log all signals and add some signals to waveform window.
log {/*}
# add wave {/*} would add all items in top level simulation module.
add wave {/*}

# input [`CHAR_BITES] char,
# input state_enable,
# input clock,

# Reset
force {state_enable} 0
force {clock} 0 0, 1 1 -r 2
run 4ps
 
# Test div width=120 height=32 >
force {state_enable} 1

force {char} 01100100
run 2ps
force {char} 01101001
run 2ps
force {char} 01110110
run 2ps
force {char} 00100000
run 2ps
force {char} 01110111
run 2ps
force {char} 01101001
run 2ps
force {char} 01100100
run 2ps
force {char} 01110100
run 2ps
force {char} 01101000
run 2ps
force {char} 00111101
run 2ps
force {char} 00110001
run 2ps
force {char} 00110010
run 2ps
force {char} 00110000
run 2ps
force {char} 00100000
run 2ps
force {char} 01101000
run 2ps
force {char} 01100101
run 2ps
force {char} 01101001
run 2ps
force {char} 01100111
run 2ps
force {char} 01101000
run 2ps
force {char} 01110100
run 2ps
force {char} 00111101
run 2ps
force {char} 00110011
run 2ps
force {char} 00110010
run 2ps
force {char} 00100000 
run 2ps
force {char} 00111110 
run 2ps
