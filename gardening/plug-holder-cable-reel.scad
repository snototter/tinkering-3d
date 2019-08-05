wall_thickness = 3;

plug_w_top = 23.2;
plug_w_bottom = 22.0;
plug_h = 30;
length = 30;

diameter_screw = 4+0.4;


//points2d = [[
//polygon(points=points_xy, convexity=1);
$fn = 72;

WTH = wall_thickness/2.0;
W = wall_thickness*2.0 + plug_w_top;
H = plug_h + wall_thickness;
OB = (plug_w_top - plug_w_bottom)/2.0;

difference()
{
    // Extruded 2D "U" shape
    linear_extrude(height=length)
    union()
    {
        translate([WTH, H-WTH])
        circle(d=wall_thickness);

        translate([W-WTH, H-WTH])
        circle(d=wall_thickness);

        points2d = [[0,0], 
            [W,0], 
            [W,H-WTH], 
            [W-wall_thickness, H-WTH],
            [wall_thickness+OB+plug_w_bottom, wall_thickness], // bottom
            [wall_thickness+OB, wall_thickness],
            [wall_thickness, H-WTH],
            [0, H-WTH]
            ];
        polygon(points=points2d, convexity=1);
    }

    // Hole for the screw
    translate([W/2.0, WTH, length/2.0])
    rotate([90,0,0])
    cylinder(d=diameter_screw, h=wall_thickness+2, center=true);
}