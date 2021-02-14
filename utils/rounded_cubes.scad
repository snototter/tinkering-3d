/*
 * Cubes with rounded corners
 */
 
 // Examples
$fn = 360;
rounded_cube1(lx=50, ly=30, lz=3, r=10);


// Rounded corners on 1 side (x "end") of the cube:
module rounded_cube1(lx, ly, lz, r, center=false, mirror=false)
{
    assert(2*r <= ly);
    // Offsets if we should center the module:
    _tcx = center ? -lx/2 : 0;
    _tcy = center ? -ly/2 : 0;
    _tcz = center ? -lz/2 : 0;
        
    translate([_tcx, _tcy, _tcz])
    union()
    {
        _tmx1 = mirror ? r : 0;
        translate([_tmx1, 0, 0])
        cube([lx-r, ly, lz]);
        
        _tmx2 = mirror ? r : lx-r;
        translate([_tmx2, ly-r, 0])
        cylinder(h=lz, r=r);
        
        if (2*r < ly)
        {
            translate([_tmx2, r, 0])
            cylinder(h=lz, r=r);
            
            color("green")
            translate([0, r, 0])
            cube([lx, ly-2*r, lz]);
        }
    }
}
