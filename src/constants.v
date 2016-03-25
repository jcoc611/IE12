/**
 * Constant values used throughout the project.
 * Mostly macro definitions.
 */

/** 
 * The number of bites required to represent
 * x and y coordinates in our screen.
 * Depends on screen size.
 */
`define X_MAX_BIT 9
`define Y_MAX_BIT 8

/**
 * Some rendering bites.
 */
`define X_BITES X_MAX_BIT-1:0
`define Y_BITES Y_MAX_BIT-1:0
`define SQUARE_BITES 5:0