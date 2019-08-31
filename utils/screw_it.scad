
// Example
$fn=36;
translate([50, 0, 0])
screw_foot(20, 50, 5, 4.5, 7, 3);

countersunk_screw_cutout(16.5, 4, 4, 7.9, epsilon=1); // Spax 4x16

// Nut traps ("Hutkappe" fuer Sechskantschrauben)
module nut_trap(s, h, epsilon=0.1)
{
    // Compute the radius via equilateral triangles
    // height (i.e. s/2) = sqrt(3)/2 * side (i.e. the radius)
    cylinder(r = s / sqrt(3) + epsilon/2, h=h, $fn=6);
}
module nut_trap_m3(height, epsilon=0.1) { nut_trap(5.5, height, epsilon); }
module nut_trap_m4(height=3.2, epsilon=0.1) { nut_trap(7, height, epsilon); }
module nut_trap_m5(height, epsilon=0.1) { nut_trap(8, height, epsilon); }
module nut_trap_m6(height, epsilon=0.1) { nut_trap(10, height, epsilon); }
module nut_trap_m8(height, epsilon=0.1) { nut_trap(13, height, epsilon); }
module nut_trap_m10(height, epsilon=0.1) { nut_trap(17, height, epsilon); }

// Cutout for countersunk screws.
// Takes care of the top/bottom padding needed when subtracting shapes
module countersunk_screw_cutout(height_total, height_head, diameter_screw, diameter_head, , epsilon=1)
{
    // Requires OpenSCAD 2019.05 assert(height_head + 1 <= height_total, "Total height must be at least head + 1");
    $fn = 72;
    height_screw = height_total - height_head;
    translate([0, 0, -epsilon])
    cylinder(d=diameter_screw, h=height_screw+epsilon+height_head/2.0, center=false); // +height_head/2 to ensure connected shape
    
    if (epsilon > 0)
    {
        // Compute diameter for epsilon-padded height (similar triangles to the rescue)
        r1 = diameter_screw/2.0;
        r2 = diameter_head/2.0;
        r_ext = r1 + (height_head + epsilon) * (r2 - r1) / height_head;
        
        translate([0, 0, height_screw])
        cylinder(d1=diameter_screw, d2=2*r_ext, h=height_head+epsilon, center=false);
    }
    else
    {
        translate([0, 0, height_screw])
        cylinder(d1=diameter_screw, d2=diameter_head, h=height_head, center=false);
    }
}

// "Lasche" - simple extension for a model to tighten it via screws - has a rounded top + countersunk screw cutout
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
