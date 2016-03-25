/**
 * Constant values used throughout the project.
 * Mostly macro definitions.
 */

/**
 * Some font settings.
 */
`define FONT_WIDTH 8
`define FONT_HEIGHT 16

/** 
 * The number of bites required to represent
 * x and y coordinates in our screen.
 * Depends on screen size.
 */
`define X_MAX_BIT 9
`define Y_MAX_BIT 8
`define CHAR_MAX_BIT 7
`define FONT_MAX_BIT (`FONT_WIDTH * `FONT_HEIGHT)

/**
 * Some rendering bites.
 */
`define X_BITES `X_MAX_BIT-1:0
`define Y_BITES `Y_MAX_BIT-1:0
`define CHAR_BITES `CHAR_MAX_BIT-1:0
`define FONT_BITES `FONT_MAX_BIT-1:0
`define SQUARE_BITES 5:0