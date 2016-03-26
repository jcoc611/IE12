#cd ../..

# Set the working dir, where all compiled Verilog goes.
vlib work

# Compile all verilog modules in ramtest.v to working dir;
# could also have multiple verilog files.
vlog src/constants.v src/char_decoder.v src/rendering/square.v src/rendering/character.v

# Load simulation using mux as the top level simulation module.
vsim character_renderer

# Log all signals and add some signals to waveform window.
log {/*}
# add wave {/*} would add all items in top level simulation module.
add wave {/*}


# Let renderer reset
force {char} 1000001
force {origin_x} 0
force {origin_y} 0
force {size} 1
force {state_enabled} 0
force {clock} 1 0, 0 5 -r 10
run 20ns

# Render 3x3 square at (0,0)
force {state_enabled} 1
force {clock} 1 0, 0 5 -r 10
run 100ns
