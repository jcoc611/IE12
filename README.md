# IE12
A oh-so-terrible HTML rendering engine implemented for
DE1-SoC (C5SEMA5F31C6).

Capable of rendering **p**, **div**, **h1** tags following a static layout.

# How it works
HTML to render is provided through a char array (Verilog wire) in `src/reading/dummy.v`. Parsing modules in `src/parsing` parse over the HTML as a language in a Finite State Machine (this is done intentionally, we know that HTML is not regular) and sets rendering flags used by the Rendering module to render text character with the correct size, color and shape etc. Finally the `src/rendering` module renders the atomic HTML elements onto the VGA.

# Attributes currently supported
- width
- height
- color
- size
- border

# Sample Output On VGA
I know the picture is horrible to say in the least. We could not screen grab from the VGA.



# High Level Circuit Design for this project

# Bugs we encountered
We required all the code in our project to operate in a synchronous manner, following the on board 50MHz clock; more often than not different intercommunicating modules would be off by one clock cycle or activate on different edges on the clock.

For example, this is what happened when our parsing module was not communicating properly with the rendering module.



Another frequent bug involved the MIF (Memory Intialization File) not "working" properly with the VGA adapter module, resulting in the following instead of a complete white background.


This issue was resolved by changing some critical parameter inside the VGA adapter file.

