# curved_text
An initial stab at a library for curving text in OpenSCAD.  

This is a very simplistic method of producing curved text.  It doesn't preserve letter spacing, for instance, but may be sufficient for most needs.  

Although I've used this in a couple of projects, I haven't done a lot of in-depth testing on it.  It needs a lot of improvement and refinement, but I've moved on to a more rubust (and, unfortunately, MUCH slower) general geometry curving library.  It can be found here: [curve_lib](https://github.com/kartchnb/curve_lib).

Currently, only one module is available, `curvedtextlib_cylinder`, which curves text into a cylindrical shape.  The module takes the following parameters:

* `text`:

   The text string to generate.  
   
   Note that, due to the way the text is generated, not all fonts will work correctly.  Specifically, I've had issues with fonts where consecutive 'characters' are printed over previous ones.
   
* `size`:

   Specifies the size of the text to generate (defaults to 10).
   
   This operates the same as the `size` parameter of OpenSCAD's `text` module.
   
* `font`:

   Specifies the font to use to generate the text (defaults to "Arial").
   
* `halign`:

   The horizontal alignment of the text (defaults to "left").  
   
   This is a string that is sent directly to OpenSCAD's `text` module.

* `valign`:

   The vertical alignment of the text (defaults to "baseline").  
   
   This is a string that is sent directly to OpenSCAD's `text` module.
   
* `$fn`:

   Can be used to override the global `$fn` value (optional).
   
   This can be specified to change the quality of the generated text.
   
* `r` or `d`:

   specifies the radius or diameter of the curved text (defaults to radius of 1).
  
   Only one of these values should be specified.
 
* `thickness`:

   The amount to extrude the text (defaults to 1).
   
* `spacing` or `degrees`:

   Determines the spacing of characters in the text.  
   
   Providing a value for `spacing` results in letters being spaced that many units apart. The letter spacing won't change if the radius/diameter of the curve is changed
   
   Providing a value for 'degrees' results in letters being spaced that many degrees apart.  The letter spacing will grow and shrink along with the radius/diameter.
   
* `reverse`:

   Controls whether the text is generated in reverse (defaults to false).

   
