/**
 * Library to generate 3D rotated squares patterns.
 */


// Example
for (y = [0:30:500]){
    translate([0,y])
    sqpattern(x=51+floor(y/30)*3, y=20, z=5, a=7, wall=2, center=true);
}
//sqpattern(x=100, y=20, z=5, a=5, wall=2, center=true);

/**
 * A 3D rotated squares pattern.
 *
 * x, y, z 
 *     width, length, height
 * a
 *     side length of square
 * wall
 *     thickness of the wall between two squares
 */
module sqpattern(x, y, z, a, wall, center=true)
{
    D = sqrt(2) * a;
    wall_prj = 2*wall * cos(45);
    step = D + wall_prj;
    
    // Note: if center=false, a rotated rect will be centered horizontally but not vertically
    
    // How many squares + projected walls fit into the first row? we wan't to center the first row horizontally
    num_full_x = floor(x / step);
    rem_x = x - num_full_x*step;
    initial_offset_x = (center ? -x/2 : 0) + rem_x/2;
    
    // Center pattern vertically:
    num_full_y = floor(y / step);
    rem_y = y - num_full_y * step;
    initial_offset_y = (center ? -y/2 : -D/2) + rem_y/2;

    // Draw in 2D first, then extrude (more accurate)
    linear_extrude(height=z, center=center)
    // Draw filled squares, subtract from a solid rectangle:
    difference()
    {
        square([x, y], center=center);
        for (offset_y = [-step : step : y+step], 
            offset_x = [-step : step : x+step])
        {
            // Current row/column
            translate([initial_offset_x + offset_x, initial_offset_y + offset_y])
            rotate([0, 0, 45])
            square(size=a, center=center);
            
            translate([initial_offset_x + offset_x - step/2, initial_offset_y + offset_y - step/2])
            rotate([0, 0, 45])
            square(size=a, center=center);
        }
    }
}