# Set the working dir, where all compiled Verilog goes.
vlib work

# Compile all verilog modules in ramtest.v to working dir;
# could also have multiple verilog files.
vlog src/constants.v src/rendering/square.v src/rendering/character.v src/rendering/render_rect.v src/parsing/char_to_int.v src/parsing/integer.v src/parsing/attribute.v src/parsing/element.v src/parsing/html.v

# Load simulation using mux as the top level simulation module.
vsim html_parser

# Log all signals and add some signals to waveform window.
log {/*}
# add wave {/*} would add all items in top level simulation module.
add wave {/*}

# input clock,
# input [`CHAR_BITES] char
# input enable,

# Reset
force {state_enable} 0
force {clock} 0 0, 1 1 -r 2
run 4ps
 
# Test <body background=3 ><p color=1 size=2 >test</p></body>
force {state_enable} 1


force {char} 00111100
run 2ps
force {char} 01100010
run 2ps
force {char} 01101111
run 2ps
force {char} 01100100
run 2ps
force {char} 01111001
run 2ps
force {char} 00100000
run 2ps
force {char} 01100010
run 2ps
force {char} 01100001
run 2ps
force {char} 01100011
run 2ps
force {char} 01101011
run 2ps
force {char} 01100111
run 2ps
force {char} 01110010
run 2ps
force {char} 01101111
run 2ps
force {char} 01110101
run 2ps
force {char} 01101110
run 2ps
force {char} 01100100
run 2ps
force {char} 00111101
run 2ps
force {char} 00110011
run 2ps
force {char} 00100000
run 2ps
force {char} 00111110
run 2ps
force {char} 00111100
run 2ps
force {char} 01110000
run 2ps
force {char} 00100000
run 2ps
force {char} 01100011
run 2ps
force {char} 01101111
run 2ps
force {char} 01101100
run 2ps
force {char} 01101111
run 2ps
force {char} 01110010
run 2ps
force {char} 00111101
run 2ps
force {char} 00110001
run 2ps
force {char} 00100000
run 2ps
force {char} 01110011
run 2ps
force {char} 01101001
run 2ps
force {char} 01111010
run 2ps
force {char} 01100101
run 2ps
force {char} 00111101
run 2ps
force {char} 00110010
run 2ps
force {char} 00100000
run 2ps
force {char} 00111110
run 2ps
force {char} 01110100
run 140ps
force {char} 01100101
run 2ps
force {char} 01110011
run 2ps
force {char} 01110100
run 2ps
force {char} 00111100
run 2ps
force {char} 00101111
run 2ps
force {char} 01110000
run 2ps
force {char} 00111110
run 2ps
force {char} 00111100
run 2ps
force {char} 00101111
run 2ps
force {char} 01100010
run 2ps
force {char} 01101111
run 2ps
force {char} 01100100
run 2ps
force {char} 01111001
run 2ps
force {char} 00111110 
run 2ps