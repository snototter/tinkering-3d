use <../utils/pattern_honeycomb.scad>

$fn = 72;
module cornered_cylinder(d, h, corner1=true, corner2=true, corner3=true, corner4=true)
{
    r = d/2;
    union()
    {
        cylinder(d=d, h=h);
        if (corner1) {
            translate([-r, 0, 0])
            cube([r, r, h]);
        }
        if (corner2) {
            translate([-r, -r, 0])
            cube([r, r, h]);
        }
        if (corner3) {
            translate([0, -r, 0])
            cube([r, r, h]);
        }
        if (corner4) {
            cube([r, r, h]);
        }
    }
}
//cornered_cylinder(d=8, h=20, corner1=false);
epsilon = 0.2;
height_connectors = 10;
thickness = 3; // Wandstärke
width = 160; // x
length = 160; // y
height = 15*2+27;


module cover()
{
    cover_thickness = 2;
    cover_epsilon = epsilon + 0.1;
    cover_connector_height = 9.6;
    
    union()
    {
        translate([-thickness, -thickness, 0])
        cube([width+2*thickness, length+2*thickness, cover_thickness]);
        
        // Stützen für Abdeckung
        translate([4+cover_epsilon, 4+cover_epsilon, cover_thickness])
        cornered_cylinder(d=8, h=cover_connector_height, corner4=false);
        translate([4+cover_epsilon, length-4-cover_epsilon, cover_thickness])
        cornered_cylinder(d=8, h=cover_connector_height, corner3=false);
        translate([width-4-cover_epsilon, length-4-cover_epsilon, cover_thickness])
        cornered_cylinder(d=8, h=cover_connector_height, corner2=false);
        translate([width-4-cover_epsilon, 4+cover_epsilon, cover_thickness])
        cornered_cylinder(d=8, h=cover_connector_height, corner1=false);
        
        // Border - bottom
        translate([cover_epsilon, cover_epsilon, cover_thickness])
        cube([width-2*cover_epsilon, cover_thickness, 4]);
        
        // Border - top
        translate([cover_epsilon, length-cover_thickness-cover_epsilon, cover_thickness])
        cube([width-2*cover_epsilon, cover_thickness, 4]);
        
        // Border - left
        translate([cover_epsilon, cover_epsilon, cover_thickness])
        cube([cover_thickness, length-2*cover_epsilon, 4]);
        
        // Border - right
        translate([width-cover_thickness-cover_epsilon, cover_epsilon, cover_thickness])
        cube([cover_thickness, length-2*cover_epsilon, 4]);
        
        //TODO
        //Kaltgerätestecker
        translate([width-cover_epsilon, 8+cover_epsilon, cover_thickness])
        cube([thickness+cover_epsilon, 48-2*cover_epsilon, 14.4]);
        // Bohrloch KGS
        translate([width-6, 28, cover_thickness])
        cube([6, 10, 14.4]);
        // Rückhalt KGS
        translate([width-cover_thickness-cover_epsilon, cover_epsilon, cover_thickness])
        cube([cover_thickness, 63, cover_connector_height]);
    }
}

translate([width+30, 0, 0])
cover();

module base()
{
    difference()
    {
        union()
        {
            // Grundplatte
            cube([width, length, thickness]);

            // Wand links (Kaltgerätestecker)
            translate([-thickness, 0, 0])
            cube([thickness, length, height+thickness]);

            // Wand rechts (Antenne)
            translate([width, 0, 0])
            cube([thickness, length, height+thickness]);

            // Wand oben
            translate([-thickness, length, 0])
            cube([width+2*thickness, thickness, height+thickness]);

            // Wand unten
            translate([-thickness, -thickness, 0])
            cube([width+2*thickness, thickness, height+thickness]);

            // Stütze für Kaltgerätestecker
            translate([0, 0, thickness])
            cube([6, 48+8, 15]);
            
            // Stütze für 433
            translate([width-10-16, length-10-62, thickness])
            cube([16, 32, 6]);
            
            // TODO remove dummy pi board
            //translate([10, length-10-56, thickness+10])
            //#cube([85, 56, 20]);
            
            // Stützen für Pi
            translate([15+3.5, length-10-3.5, thickness])
            #cylinder(d=7, h=10);
            
            translate([15+3.5+58, length-10-3.5, thickness])
            #cylinder(d=7, h=10);
            
            translate([15+3.5, length-10-3.5-49, thickness])
            #cylinder(d=7, h=10);
            
            translate([15+3.5+58, length-10-3.5-49, thickness])
            #cylinder(d=7, h=10);
            
            // Stützen für Abdeckung
            translate([thickness, thickness, thickness])
            cornered_cylinder(d=8, h=height-height_connectors-epsilon, corner4=false);
            translate([thickness, length-thickness, thickness])
            cornered_cylinder(d=8, h=height-height_connectors-epsilon, corner3=false);
            translate([width-thickness, length-thickness, thickness])
            cornered_cylinder(d=8, h=height-height_connectors-epsilon, corner2=false);
            translate([width-thickness, thickness, thickness])
            cornered_cylinder(d=8, h=height-height_connectors-epsilon, corner1=false);
        }
        
        // Lüftung links
        hc_length = 30+18;
        translate([-2, length-47, hc_length/2+thickness])
        rotate([90, 0, 90])
        honeycomb_pattern(length-30-60, hc_length, thickness+2, 7, 3, center=true, negative=true);
        
        // Lüftung rechts
        translate([-2+width+thickness, 25+10, hc_length/2+thickness])
        rotate([90, 0, 90])
        honeycomb_pattern(50, hc_length, thickness+2, 7, 3, center=true, negative=true);

        // Aussparung für Kaltgerätestecker
        //translate([-thickness-1, 8, thickness+15])
        //cube([thickness+2, 48, 27]);
        translate([-thickness-1, 8, thickness+15])
        cube([thickness+2, 48, height]);

        // Löcher für Netzteil
        translate([width-15-10, 25+10, -1])
        cylinder(d=3, h=thickness+2);

        translate([width-15-10-38.5, 25+10, -1])
        cylinder(d=3, h=thickness+2);
    }
}
base();