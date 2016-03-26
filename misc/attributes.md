# Supported Attributes
All attributes must be in lower case.

## Text
A `<p></p>` element.
* **color**: a *3-bit* text color.
* **size**: the size (multiple) of the text. Should be an int.

## Block
A `<div></div>` element.
* **width** the integer width in pixels for this block.
* **height** the integer height in pixels for this block.
* **background** a *3-bit* color for the background of this block.
* (extra) **padding** the int pixels of padding of this block.
* (extra) **border** the size and color of a border for this block.
* (extra) **margin** the margin of this block, in int pixels.
* (extra) **position** the absolute position of this block.

## Image
A `<img />` element.
* **src** the source of the image.

## Link
A `<a></a>` element.
* **href** the destination page of the link.