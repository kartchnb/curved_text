// Curved Text Library
// Brad Kartchner
//
// v 2.0 - 13 Mar 2022
//  Changed the name of the cylindrical curved text function to match my curve_lib library.
//  
// v 1.2 - 7 Mar 2022
//  Modified to properly handle zero-length strings
//  Minor code changes to use is_undef()
//
// v 1.1 - 10 Dec 2021
//  Added the ability to generate inverted text (e.g. for the inside of rings)
//
// v 1.0 - 10 Dec 2021
//  Initial version



module curvedtextlib_cylinder(text, size=10, font="Arial", halign="left", valign="baseline", $fn=$fn, r=1, d=undef, thickness=1, spacing=undef, degrees=undef, reverse=false)
{
    // Don't process empty text
    if (len(text) > 0)
    {
        // Determine the diameter of the curve
        diameter = is_undef(d) ? r*2 : d;

        // Calculate the inner and outer diameters of the text, based on the thickness
        // Positive thickness values cause the text to extend beyond the given diameter
        // Negaitve thickness values cause the text to extend wihtin the given diameter
        inner_diameter = thickness >=0 
            ? diameter
            : diameter - abs(thickness)*2;
        outer_diameter = inner_diameter + abs(thickness)*2;

        // Determine how much to rotate each character
        assert(!is_undef(spacing) || !is_undef(degrees), "Either \"spacing\" or \"degrees\" must be specified");
        degrees_per_char = is_undef(spacing)
            ? degrees / (len(text)-1)
            : 360 / ((diameter*PI) / (size*spacing));

        // Determine the overall sweep of the text
        text_sweep = is_undef(spacing)
            ? degrees
            : (len(text)-1) * degrees_per_char;

        // Determine the starting angle of the text
        starting_angle = 
            halign == "left" ? 0 :
            halign == "right" ? -text_sweep :
            -text_sweep / 2;        
        
        intersection()
        {
            union()
            {
                // Extrude each character radiating from the center of the curved text
                for (i = [0: len(text) - 1])
                {
                    char = text[i];
                    z_rot = starting_angle + degrees_per_char * i * (reverse ? -1 : 1);
                    
                    rotate([0, 0, z_rot])
                    rotate([90, 0, 0])
                    linear_extrude(diameter)
                    mirror([reverse ? 1 : 0, 0, 0])
                        text(char, font=font, size=size, halign=halign, valign=valign, $fn=$fn);
                }
            }

            difference()
            {
                // Slice off everything extending outside the diameter of the text
                translate([0, 0, -size*2])
                    cylinder(d=outer_diameter, h=size*4);

                // Slice off everything within the diameter of the text
                translate([0, 0, -size*2])
                    cylinder(d=inner_diameter, h=size*4);
            }
        }
    }
}
