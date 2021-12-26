// Curved Text Library
// Brad Kartchner
//
// v 1.1 - 10 Dec 2021
//  Added the ability to generate inverted text (e.g. for the inside of rings)
//
// v 1.0 - 10 Dec 2021
//  Initial version



module curvedtextlib_vertical(text, size=10, font="Arial", halign="left", valign="baseline", $fn=$fn, r=1, d=undef, thickness=1, spacing=undef, degrees=undef, inverted=false)
{
    // Determine the diameter of the curve
    diameter = d != undef ? d : r*2;

    // Calculate the inner and outer diameters of the text, based on the thickness
    // Positive thickness values cause the text to extend beyond the given diameter
    // Negaitve thickness values cause the text to extend wihtin the given diameter
    inner_diameter = thickness >=0 
        ? diameter
        : diameter - abs(thickness)*2;
    outer_diameter = inner_diameter + abs(thickness)*2;

    // Determine how much to rotate each character
    assert(spacing != undef || degrees != undef, "Either \"spacing\" or \"degrees\" must be specified");
    degrees_per_char = spacing != undef
        ? 360 / ((diameter*PI) / (size*spacing))
        : degrees / (len(text)-1);

    // Determine the overall sweep of the text
    text_sweep = spacing != undef
        ? (len(text)-1) * degrees_per_char
        : degrees;

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
                z_rot = starting_angle + degrees_per_char * i * (inverted ? -1 : 1);
                
                rotate([0, 0, z_rot])
                rotate([90, 0, 0])
                linear_extrude(diameter)
                mirror([inverted ? 1 : 0, 0, 0])
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
