
// Example
$fn=36;
translate([50, 0, 0])
screw_foot(20, 50, 5, 4.5, 7, 3);

module screw_foot(width, length, height, diameter_screw, diameter_countersunk, height_countersunk)
{
    cube_length = length - width / 2;
    difference()
    {
        union()
        {
            cube([width, cube_length, height], center=false);
            translate([width/2, cube_length, 0])
            cylinder(d=width, h=height, center=false);
        }

        translate([width/2, cube_length, -1])
        cylinder(d=diameter_screw, h=height+2, center=false);
            
        // New diameter via similar triangles (potentially shorter side is d_countersunk-d_screw)
        s = (height_countersunk+1) / height_countersunk * (diameter_countersunk-diameter_screw);
        d_top = diameter_screw + s;

        translate([width/2, cube_length, height-height_countersunk])
        cylinder(d1=diameter_screw, d2=d_top, h=height_countersunk+1, center=false);
    }
}
