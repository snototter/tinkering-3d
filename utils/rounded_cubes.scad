/*
 * Cubes with rounded corners
 */
 
 // Examples
$fn = 360;
rounded_cube1(lx=50, ly=30, lz=3, r=10);

//rounded_cube1(lx=50, ly=30, lz=3, r=10, mirror=true);

//// Radius larger than length in x direction
//rounded_cube1(lx=8, ly=30, lz=3, r=10);

translate([0, 40, 0])
rounded_cube2(lx=50, ly=30, lz=3, r=10);


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
        
        
        // Intersect the union'd cylinders with a "full-size" cube to
        // allow r > lx
        intersection()
        {
            cube([lx, ly, lz]);
            
            union()
            {
                _tmx2 = mirror ? r : lx-r;
                translate([_tmx2, ly-r, 0])
                cylinder(h=lz, r=r);
                
                if (2*r < ly)
                {
                    translate([_tmx2, r, 0])
                    cylinder(h=lz, r=r);
                    
                    translate([0, r, 0])
                    cube([lx, ly-2*r, lz]);
                }
            }
        }
    }
}

// All corners on the xy plane are rounded:
module rounded_cube2(lx, ly, lz, r, center=false)
{
    intersection()
    {
        rounded_cube1(lx, ly, lz, r, center);
        rounded_cube1(lx, ly, lz, r, center, mirror=true);
    }
}
