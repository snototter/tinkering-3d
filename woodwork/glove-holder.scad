use <../utils/pattern_honeycomb.scad>
use <../utils/polygons.scad>
use <../utils/screw_it.scad>

// Set to true if you change the dimensions: this will show the final box with extruded screw cylinders (allowing you to adjust the screw_placeholders within the body() module!)
DEBUG=false;
COMBED_BODY=false;
module honeycombed_wall(x, y, z, diameter_comb, wall_comb, margin_x, margin_y)
{
    difference()
    {
        cube([x, y, z], center=true);
        
        hcx = x - 2*margin_x;
        hcy = y - 2*margin_y;
        hcz = z + 2;
        honeycomb_pattern(x=hcx, y=hcy, z=z+2, diameter_comb=diameter_comb, wall=wall_comb, center=true, negative=true);    
    }
}

function rect_size(x1, y1, x2, y2) = [x2-x1, y2-y1];

function front_angle(depth1, depth2, height) = atan2((depth2-depth1), height);

module honeycombed_polygon(points_xy, z, diameter_comb, wall_comb, margin)
{    
    min_x = minx(points_xy);
    max_x = maxx(points_xy);
    min_y = miny(points_xy);
    max_y = maxy(points_xy);
    sz = rect_size(min_x, min_y, max_x, max_y);
    
    linear_extrude(height=z, center=true)
    //translate([-sz[0]/2, -sz[1]/2])
    union()
    {
        difference()
        {
            offset(delta=-(margin-1)) // slightly larger carved area, as we'll combine it with the margin (below), so leave some room for rounding issues...
            polygon(points=points_xy, convexity=1);
            honeycomb_pattern2d(sz[0], sz[1], diameter_comb, wall_comb, center=false, negative=true);
        }
        difference()
        {
            polygon(points=points_xy, convexity=1);
            offset(delta=-margin)
            polygon(points=points_xy, convexity=1);
        }
    }
}

module connector(x, y, z, negative=true)
{
    // Negative for subtracting from the body,
    // Positive for the printed part, is slightly smaller
    if (negative)
    {
        translate([0, 0, z/2])
        cube([x, y, z], center=true);
    }
    else
    {
        offset=0.5;
        connector(x-offset, y-offset, z-offset, true);
    }
}

module connectors(front_width, front_height, wall_thickness, margin_x, margin_y, tilt_angle, negative)
{
    // Thickness = 60% off wall
    X = 0.6*wall_thickness;
    
    union()
    {
        // Left
        translate([-front_width/2+wall_thickness/2, 0])
        connector(X, front_height/2, min(margin_x, margin_y), negative);
        
        // Right
        translate([front_width/2-wall_thickness/2, 0])
        connector(X, front_height/2, min(margin_x, margin_y), negative);
        
        // Bottom
        translate([0, -front_height/2+wall_thickness/2+0.3, 0])
        rotate([tilt_angle, 0, 0])
        rotate([0, 0, 90])
        connector(X, front_width/2, min(margin_x, margin_y), negative);
    }
}

module front_wall(width, height, wall_thickness, margin_x, margin_y, label_width, label_height, honeycomb_dia, honeycomb_wall, tilt_angle)
{
    union()
    {
        translate([0, 0, wall_thickness/2])
        honeycombed_wall(x=width, y=height, z=wall_thickness, diameter_comb=honeycomb_dia, wall_comb=honeycomb_wall, margin_x=margin_x, margin_y=margin_y);
        
        translate([0, 0.15*height, wall_thickness/2])
        cube([label_width, label_height, wall_thickness], center=true);
        
        connectors(width, height, wall_thickness, margin_x, margin_y, tilt_angle, false);
    }
}

module sidewall_combed(width, depth1, depth2, height, wall_thickness, margin_x, margin_y, honeycomb_dia, honeycomb_wall)
{
    side_corners = [[0, 0], [depth1, 0], [depth2, height], [0, height]];
    angle = front_angle(depth1, depth2, height);
    rotate([0, -90, 0])
    honeycombed_polygon(side_corners, wall_thickness, honeycomb_dia, honeycomb_wall, max(margin_x, margin_y));
}

module sidewall_solid(width, depth1, depth2, height, wall_thickness)
{
    side_corners = [[0, 0], [depth1, 0], [depth2, height], [0, height]];
    angle = front_angle(depth1, depth2, height);
    rotate([0, -90, 0])
    linear_extrude(height=wall_thickness, center=true)
    {
        polygon(points=side_corners, convexity=1);
    }
}

module screw_placeholder(diameter, wall_thickness)
{
    $fn = 36;
    countersunk_screw_cutout(5, 4, diameter, 2*diameter, epsilon=1);
}

module body(width, depth1, depth2, height, wall_thickness, margin_x, margin_y, honeycomb_dia, honeycomb_wall, back_height1, back_height2, tilt_angle, front_length, screw_dia1, screw_dia2)
{
    difference()
    {
        union()
        {
            // Left wall
            translate([wall_thickness/2.0, 0, 0])
            if (COMBED_BODY)
            {
                sidewall_combed(width, depth1, depth2, height, wall_thickness, margin_x, margin_y, honeycomb_dia, honeycomb_wall);
            }
            else
            {
                sidewall_solid(width, depth1, depth2, height, wall_thickness);
            }
            
            // Right wall
            translate([width-wall_thickness/2.0, 0, 0])
            if (COMBED_BODY)
            {
                sidewall_combed(width, depth1, depth2, height, wall_thickness, margin_x, margin_y, honeycomb_dia, honeycomb_wall);
            }
            else
            {
                sidewall_solid(width, depth1, depth2, height, wall_thickness);
            }
            
            // Floor
            floor_corners = [[0, 0], [width, 0], [width, depth1], [0, depth1]];
            translate([0, wall_thickness/2.0, 0])
            rotate([90, 0, 0])
            if (COMBED_BODY)
            {
                honeycombed_polygon(floor_corners, wall_thickness, honeycomb_dia, honeycomb_wall, max(margin_x, margin_y));
            }
            else
            {
                linear_extrude(height=wall_thickness, center=true)
                {
                    polygon(points=floor_corners, convexity=1);
                }
            }
            
            // Back top
            difference()
            {
                translate([0, height-back_height1, 0])
                cube([width, back_height1, wall_thickness], center=false);
                
                translate([width*0.15, height-back_height1/2.0-2.5, 0])
                screw_placeholder(screw_dia1, wall_thickness);
                translate([width*0.85, height-back_height1/2.0-2.5, 0])
                screw_placeholder(screw_dia1, wall_thickness);
            }
            
            if (DEBUG)
            {
                $fn = 72;
                // Show cylinder where the screw should be to align honeycomb pattern with screw cutouts
                translate([width*0.15, height-back_height1/2.0-2.5, -10])
                #cylinder(d=diameter, h=wall_thickness+70, center=false);
                translate([width*0.85, height-back_height1/2.0-2.5, -10])
                #cylinder(d=diameter, h=wall_thickness+70, center=false);
            }
            //TODO sidewall solid!
            
            
            // Back bottom
            difference()
            {
                cube([width, back_height2, wall_thickness], center=false);

                translate([width/2.0, back_height2/2.0 + 4, 0])
                screw_placeholder(screw_dia1, wall_thickness);
            }
            if (DEBUG)
            {
                $fn = 72;
                translate([width/2.0, back_height2/2.0 + 4, -10])
                #cylinder(d=diameter, h=wall_thickness+70, center=false);
            }
        }
        
        // Transform the front wall connector cutouts into place
        translate([0, 0, depth1])
        rotate([tilt_angle, 0, 0])
        translate([width/2.0, front_length/2.0, wall_thickness])
        rotate([0, 180, 0])
        connectors(width, front_length, wall_thickness, margin_x, margin_y, tilt_angle, true);
    }
}

module glove_holder(width=90, depth1=20, depth2=40, height=110, wall_thickness=2.5,
    margin_x=6, margin_y=6,
    honeycomb_diameter=7, honeycomb_wall_thickness=3,
    label_width=60, label_height=15,
    back_height1=25, back_height2=22)
{
    screw_dia1 = 4;
    screw_dia2 = 8;
    part_distance = 5;
    
    // Compute values
    depth_offset = depth2 - depth1;
    L = sqrt(height*height + depth_offset*depth_offset);
    tilt_angle = front_angle(depth1, depth2, height);
    
    // Separate front (will be glued on)
    translate([width*1.5 + part_distance, L/2.0, 0])
    front_wall(width, L, wall_thickness, margin_x, margin_y, label_width, label_height, honeycomb_diameter, honeycomb_wall_thickness, tilt_angle);
    
    
    // Next to it the body:
    body(width, depth1, depth2, height, wall_thickness, margin_x, margin_y, honeycomb_diameter, honeycomb_wall_thickness, back_height1, back_height2,
        tilt_angle, L, screw_dia1, screw_dia2);
    
    
    if (DEBUG)
    {
        // Show a dummy front properly aligned with the body
        translate([0, 0, depth1+2])
        rotate([tilt_angle, 0, 0])
        translate([width/2.0, L/2.0, wall_thickness])
        rotate([0, 180, 0])
        %front_wall(width, L, wall_thickness, margin_x, margin_y, label_width, label_height, honeycomb_diameter, honeycomb_wall_thickness, tilt_angle);
    }
}

glove_holder();