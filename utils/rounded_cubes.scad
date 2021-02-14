/*
 * Cubes with rounded corners
 */
 
 // Examples
$fn = 360;
rounded_cube1(lx=50, ly=30, lz=3, r=10);


// Rounded corners on 1 side (x "end") of the cube:
module rounded_cube1(lx, ly, lz, r, center=false)
{
    assert(2*r <= ly);
    _tx = center ? -lx/2 : 0;
    _ty = center ? -ly/2 : 0;
    _tz = center ? -lz/2 : 0;
    
    translate([_tx, _ty, _tz])
    union()
    {
        cube([lx-r, ly, lz]);
        
        translate([lx-r, ly-r, 0])
        cylinder(h=lz, r=r);
        
        if (2*r < ly)
        {
            translate([lx-r, r, 0])
            cylinder(h=lz, r=r);
            
            color("green")
            translate([0, r, 0])
            cube([lx, ly-2*r, lz]);
        }
    }
}
