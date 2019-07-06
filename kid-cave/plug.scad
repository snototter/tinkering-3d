// Plug to hold down the cave connectors
use <../third_party/helix_extrude/helix_extrude.scad>

module cave_plug(plug_length_inside = 40,
    plug_length_outside = 4, // includes plug_cone_length_outside, thus must be > 2mm!
    plug_cone_length_outside = 2,
    plug_diameter_inside = 9.5,
    plug_diameter_outside = 18,
    screw_pitch = 2, // > 0 -> helix, <= 0 -> solid
    $fn=36)
{
    union()
    {
        // Flat outer part
        h2 = plug_cone_length_outside;
        h1 = plug_length_outside - h2;
        translate([0, 0, h1/2])
        cylinder(h=h1, d=plug_diameter_outside, center=true);
        // Cone
        translate([0, 0, h1+h2/2])
        cylinder(h=h2, d1=plug_diameter_outside, d2=plug_diameter_inside, center=true);
        // Helix inside
        translate([0, 0, plug_length_outside])
        {
            if (screw_pitch > 0)
            {
                iso_bolt(diameter=plug_diameter_inside, pitch=screw_pitch, length=plug_length_inside, internal=false);
            }
            else
            {
                translate([0, 0, plug_length_inside/2])
                cylinder(h = plug_length_inside, d=plug_diameter_inside, center=true);
            }
        }
    }
}

cave_plug(plug_length_inside=23.5, plug_cone_length_outside=2, plug_diameter_inside = 9.7, screw_pitch=2, $fn=36); // dia_inside=9.7 for front-left (needs to be a bit tighter, others are fine at 9.5)