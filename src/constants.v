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
`define COLOR_MAX_BIT 3
`define ELE_TAG_MAX_BIT 5
`define FONT_INDEX_MAX_BIT 8
`define ATTRIBUTE_TYPE_MAX_BIT 5
`define ATTRIBUTE_VAL_MAX_BIT 10
`define FONT_MAX_BIT (`FONT_WIDTH * `FONT_HEIGHT)

/**
 * Some rendering bites.
 */
`define SQUARE_BITES 5:0
`define X_BITES `X_MAX_BIT-1:0
`define Y_BITES `Y_MAX_BIT-1:0
`define CHAR_BITES `CHAR_MAX_BIT-1:0
`define FONT_BITES `FONT_MAX_BIT-1:0
`define COLOR_BITES `COLOR_MAX_BIT-1:0
`define ELE_TAG_BITES `ELE_TAG_MAX_BIT-1:0
`define ATTRIBUTE_TYPE_BITES `ATTRIBUTE_TYPE_MAX_BIT-1:0
`define ATTRIBUTE_VAL_BITES `ATTRIBUTE_VAL_MAX_BIT-1:0
`define FONT_INDEX_BITES `FONT_INDEX_MAX_BIT-1:0
`define X_Y_PRODUCT_BITES 16:0

/**
 * Constants for attribute types.
 */
`define ATT_COLOR 0
`define ATT_SIZE 1
`define ATT_WIDTH 2
`define ATT_HEIGHT 3
`define ATT_SRC 4
`define ATT_HREF 5
`define ATT_BG 6
`define ATT_PADDING 7
`define ATT_MARGIN 8
`define ATT_BORDER 9
`define ATT_POSITION 10
