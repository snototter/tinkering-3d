/* Spice Caddy
 * Inspired by https://www.thingiverse.com/thing:2169799/files, needed parametrization for my large spice bags.
 */
 
use <../utils/pattern_squares.scad>
module divider_border(border, height)
{
    square(size=[border/2, h1], center=false);

    r2 = border/2;
    intersection()
    {
        translate([border/2, 0])
        square(size=[border/2, h1], center=false);

        translate([border-r2, h1-r2])
        circle(r=r2, center=true);
    }

    translate([border/2, 0])
    square(size=[border/2, h1-r2], center=false);
}

module divider(w1, w2, h1, h2, wall)
{
    border = (w1-w2)/2; // TODO assert border > r2

    // Draw in 2D, then extrude
    translate([0, wall, 0])
    rotate([90, 0, 0])
    linear_extrude(height=wall, center=false)
    {
        // Left border
        divider_border(border, h1);

        // Right border
        translate([w1, 0])  // not w1-border due to mirroring
        mirror([1, 0])
        divider_border(border, h1);

        // Bottom up
        difference()
        {
            r = w2/2;
            square(size=[w1, h1-h2+r/2], center=false);
            translate([w1/2, (h1-h2)+r/2])
            scale([1, 0.5])
            circle(r=r, center=true);
        }
    }
}
 
module side_wall(w, h, wall, margin, square_size, square_wall)
{
    // Left
    cube([wall, margin, h], center=false);
    // Right
    translate([0, w-margin, 0])
    cube([wall, margin, h], center=false);
    // Bottom
    cube([wall, w, margin], center=false);
    // Top
    translate([0, 0, h-margin])
    cube([wall, w, margin], center=false);

    translate([wall/2, w/2, h/2])
    rotate([0, 90, 0])
    sqpattern(h-2*margin, w-2*margin, wall, square_size, square_wall, center=true);
}

module caddy(w1, w2, h1, h2, length, num_side_walls, wall, side_wall_margin, side_wall_square_size, side_wall_square_wall)
{
    // Floor
    cube([w1, length, wall], center=false);

    // Walls
    wall_length = length/num_side_walls;
    for (i=[1:1:num_side_walls])
    {
        translate([0, (i-1)*wall_length, 0])
        side_wall(wall_length, h1, wall, side_wall_margin, side_wall_square_size, side_wall_square_wall);

        translate([w1-wall, (i-1)*wall_length, 0])
        side_wall(wall_length, h1, wall, side_wall_margin, side_wall_square_size, side_wall_square_wall);

        if (i < num_side_walls)
        {
            translate([0, i*wall_length-wall/2, 0])
            divider(w1, w2, h1, h2, wall);
        }
    }
    // Front/Back
    divider(w1, w2, h1, h2, wall);
    translate([0, length-wall, 0])
    divider(w1, w2, h1, h2, wall);
} 
 
 // The original tea bag caddy:
 /*wall=2.4;
length=180;
w1=70;
h1=60;

num_side_walls = 3;

w2=w1-2*18;
h2=h1-12;

side_wall_margin=5;
side_wall_square_wall=4;
side_wall_square_size=9;
$fn = 72;
caddy(w1, w2, h1, h2, length, num_side_walls, wall, side_wall_margin, side_wall_square_size, side_wall_square_wall);
*/ 
 
 // Spices (+2cm hoehe;
wall=2.4;
w1 = 124+2*wall; // TODO nachmessen; TODO schmaelstes messen
w2 = w1 - 2*24;
length = 180;

h1 = 80;
h2 = h1 - 20;

num_side_walls = 3; 

side_wall_margin=5;
side_wall_square_wall=4;
side_wall_square_size=10;
$fn = 72;
caddy(w1, w2, h1, h2, length, num_side_walls, wall, side_wall_margin, side_wall_square_size, side_wall_square_wall);
 
