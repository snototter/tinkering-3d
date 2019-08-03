/**
 * Library to generate centered 3D honeycomb patterns.
 *
 * Inspired from https://www.thingiverse.com/thing:2484395
 */


// Example
for (y = [0:30:500]){
    translate([0,y])
    honeycomb_pattern(x=21+floor(y/30), y=20, z=5, diameter_comb=7, wall=2, center=true);
}


// Hexagon, a 2D primitive.
module hexagon(diameter)
{
    circle(d=diameter, $fn=6);
}


module _draw_honeycombs(initial_offset_x, x, initial_offset_y, y, step_x, step_y, diameter_comb)
{
    union()
    {
        for (offset_y = [0 : step_y : y+step_y], 
            offset_x = [0 : step_x : x+step_x])
        {
            // Current row/column
            translate([offset_x + initial_offset_x, offset_y + initial_offset_y])
            hexagon(diameter_comb);
            // The row/column before (our loop makes an additional iteration, so we'll cover everything!)
            //translate([offset_x + initial_offset_x - diameter_comb*3/4 - wall_x, offset_y + initial_offset_y])
            translate([offset_x + initial_offset_x - step_x/2, offset_y + initial_offset_y - step_y/2])
            hexagon(diameter_comb);
        }
    }
}

/**
 * A centered 2D honeycomb pattern.
 *
 * x, y
 *     width, length
 * diameter_comb
 *     diameter of a single comb (i.e. size of the hole)
 * wall
 *     thickness of the wall between two combs
 * negative
 *     set to true if you want to subtract the combs yourself (maybe from a custom shape)
 */
module honeycomb_pattern2d(x, y, diameter_comb, wall, center=true, negative=false)
{
    /**
     * Note: The following visualization is optimized for the OpenSCAD editor.
     * D = diameter_comb:
     *     _______
     *    /        / \
     *   /        /   \
     *  /        /     \
     * /        / D    \
     * \       /       /
     *  \     /       /
     *   \   /       /
     *    \ /_____/
     *        
     *         D
     * |-------------------|
     *
     *
     * S = short_diameter_comb:
     *     _______
     *    /     |   \
     *   /   S  |    \
     *   \      |    /
     *    \ ___|__/
     *
     *
     * wall_x ("projection" of wall thickness onto x-axis):
     *
     *     ______
     *    /        \
     *   /          \
     *   \          /   _______
     *    \ _____/    /        \
     *                /          \
     *             |----|
     *               wall_x
     */ 
    
    short_diameter_comb = diameter_comb * cos(30);
    wall_x = wall * cos(30);
    
    step_y = short_diameter_comb + wall;
    step_x = diameter_comb*3/2 + 2*wall_x;

    // We want to center the cut-out:
    // How many combs would we fit into the first row? Use the unfilled space as offset to center horizontally:
    num_full_x = floor(x / step_x);
    rem_x = x - num_full_x*step_x;
    initial_offset_x = (center ? -x/2 : 0) + rem_x/2;
    
    // Center pattern vertically:
    num_full_y = floor(y / step_y);
    rem_y = y - num_full_y * step_y;
    initial_offset_y = (center ? -y/2 : 0) + rem_y/2;

    if (negative)
    {
        intersection()
        {
            square([x, y], center=center);
            _draw_honeycombs(initial_offset_x, x, initial_offset_y, y, step_x, step_y, diameter_comb);
        }
    }
    else
    {
        // Draw filled hexagons, subtract from a solid rectangle:
        difference()
        {
            square([x, y], center=center);
            _draw_honeycombs(initial_offset_x, x, initial_offset_y, y, step_x, step_y, diameter_comb);
        }
    }
}

/**
 * A centered 3D honeycomb pattern.
 *
 * x, y, z 
 *     width, length, height
 * diameter_comb
 *     diameter of a single comb (i.e. size of the hole)
 * wall
 *     thickness of the wall between two combs
 * negative
 *     set to true if you want to subtract the combs yourself (maybe from a custom shape)
 */
module honeycomb_pattern(x, y, z, diameter_comb, wall, center=true, negative=false)
{
    // Draw in 2D first, then extrude (more accurate)
    linear_extrude(height=z, center=center)
    honeycomb_pattern2d(x, y, diameter_comb, wall, center, negative);
}