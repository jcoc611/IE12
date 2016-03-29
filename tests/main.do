# Set the working dir, where all compiled Verilog goes.
vlib work

# Compile all verilog modules in ramtest.v to working dir;
# could also have multiple verilog files.
vlog src/constants.v src/char_decoder.v src/vga_adapter/vga_controller.v src/vga_adapter/vga_address_translator.v src/vga_adapter/vga_adapter.v src/parsing/char_to_int.v src/parsing/integer.v src/parsing/attribute.v src/parsing/element.v src/parsing/html.v src/reading/dummy.v src/rendering/counter.v src/rendering/square.v src/rendering/render_rect.v src/rendering/character.v

# Load simulation using mux as the top level simulation module.
vsim main

# Log all signals and add some signals to waveform window.
log {/*}
# add wave {/*} would add all items in top level simulation module.
add wave {/*}


# TEST EVERYTHING
run 10ms