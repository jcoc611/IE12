cd ../..

# Set the working dir, where all compiled Verilog goes.
vlib work

# Compile all verilog modules in ramtest.v to working dir;
# could also have multiple verilog files.
vlog src/rendering/square.v

# Load simulation using mux as the top level simulation module.
vsim square_renderer

# Log all signals and add some signals to waveform window.
log {/*}
# add wave {/*} would add all items in top level simulation module.
add wave {/*}


# Let renderer reset
force {origin_x} 0
force {origin_y} 0
force {size} 0
force {state_enabled} 0
run 10ns

# Render 3x3 square at (0,0)
force {size} 3
force {state_enabled} 1
run 100ns
