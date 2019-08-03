use <../utils/pattern_honeycomb.scad>
use <../utils/polygons.scad>

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
    //linear_extrude(height=z)
    
    //offset(delta=-margin)
   // polygon(points=points_xy, convexity=1);
    //honeycomb_pattern2d(
    /*for (i = [0 : 1 : len(points_xy)-1])
    {
        echo("point");
        echo(points_xy[i]);
        echo(minx(points_xy));
        echo(miny(points_xy));
        echo(maxx(points_xy));
        echo(maxy(points_xy));
    }*/
    //bounding_rect(points_xy);
    
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

module front_wall(width, height, wall_thickness, margin_x, margin_y, height, label_width, label_height)
{
    union()
    {
        //TODO comp height from angle!
        translate([0, 0, wall_thickness/2])
        honeycombed_wall(x=width, y=height, z=wall_thickness, diameter_comb=7, wall_comb=2, margin_x=margin_x, margin_y=margin_y);
        
        translate([0, 0.2*height, wall_thickness/2])
        cube([label_width, label_height, wall_thickness], center=true);
    }
}

module glove_holder(width=90, depth1=15, depth2=30, height=60, wall_thickness=1, margin_x=7, margin_y=5)
//module glove_holder(width=90, depth1=15, depth2=15, height=60, wall_thickness=1, margin_x=7, margin_y=5)
{
    // Make separate body and bottom (prefer glue over support issues)
    // Body -------------------------------------------------
    // Front wall
    label_width= 55; //TODO
    label_height = 12; //TODO
    
    hc_diameter = 7;
    hc_wall = 2;
    side_corners = [[0, 0], [depth1, 0], [depth2, height], [0, height]];
    angle = front_angle(depth1, depth2, height);
    length_tilted = distance2d_pts(side_corners[1], side_corners[2]) + wall_thickness;
    
    //honeycombed_polygon(side_corners, wall_thickness, hc_diameter, hc_wall, min(margin_x, margin_y));
    
    /////// Front wall with label
    translate([0, height/2, 0])
    front_wall(width, length_tilted, wall_thickness, margin_x, margin_y, height, label_width, label_height);
    
    translate([-(width/2-wall_thickness/2), 0, 0])
    rotate([angle, 0, 0])
    //TODO bodenplatte hier einfuegen
    translate([0, 0, depth1])
    rotate([0, 90, 0])
    honeycombed_polygon(side_corners, wall_thickness, hc_diameter, hc_wall, min(margin_x, margin_y));
    
    // Obere Abdeckung (Dummy fuer Cropping)
    translate([-width/2, height, 0])
    rotate([angle, 0, 0])
    cube([width, wall_thickness, depth2], center=false);
    
}



glove_holder();