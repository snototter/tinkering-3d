/* Stand for the fountain in our tepidarium 
v1 - quick hack, night session
v2 - adjust cutouts
v3 - circular base plate (the ultrasonic mist blower is too strong and needs a top cover) + bottom cover with connectors + 2 separate STLs for printing
*/
$fn = 72;
diameter=120;//103;
diameter_extended= 145;//125+36/83*49;
h_feet = 47;
h_base = 5;
BOTTOM = false;
MIST_CUTOUTS = false;

module base(diameter)
{
//    translate([0, 3+diameter/2]) 
    circle(d=diameter);
/*hull()
    {
        circle(r = diameter/2);
        translate([0, 23])
        circle(r = diameter/2);
    }*/
}

module cutout(h, w, r, thickness)
{
    translate([r-w/2, thickness/2, r])
    {
        hull()
        {
            rotate([90, 0, 0])
            cylinder(r=r, h=thickness);
            translate([w-2*r, 0, 0])
            rotate([90, 0, 0])
            cylinder(r=r, h=thickness);
            
            translate([-r, -thickness, 0])
            cube([w, thickness, h-r], center=false);
        }
    }
}

module rcube(xyz, r)
{
    a = xyz[0];
    b = xyz[1];
    h = xyz[2];
    
    hull()
    {
        translate([-a/2+r, -b/2+r, 0])
        cylinder(r=r, h=h);
        
        translate([a/2-r, -b/2+r, 0])
        cylinder(r=r, h=h);
        
        translate([-a/2+r, b/2-r, 0])
        cylinder(r=r, h=h);
        
        translate([a/2-r, b/2-r, 0])
        cylinder(r=r, h=h);
    }
}

if (BOTTOM)
{
    // Bottom plate with connectors
    union()
    {
        linear_extrude(height = 2)
        {
            translate([0, 3+diameter/2])
            base(diameter);
        }
        
        translate([20, 15, 2])
        cylinder(d=6, h=10);
        
        translate([-27, 108, 2])
        cylinder(d=6, h=10);
    }
    
    // Light plug (so we can adjust its z position inside the fountain stone)
    translate([0, -14, 0])
    difference()
    {
        douter=22;
        height=18;
        light_cable_width = 3.45;
        cylinder(d1=douter, d2=16, h=height);

        translate([-light_cable_width/2, 0, -1])
        cube([light_cable_width, douter/2+1, height+2]); 
    }
}
else
{
    difference()
    {
        // Platform for the fountain (stone), extrude full body and carve away later
        difference()
        {
            union()
            {
                linear_extrude(height = h_base)
                {
                    translate([0, 3+diameter/2])
                    base(diameter_extended);
                }
                linear_extrude(height = h_base+h_feet)
                {
                    translate([0, 3+diameter/2])
                    base(diameter);
                }
            }
                
            translate([0, 0, h_base])
            linear_extrude(height = h_base+h_feet)
            {
                translate([0, 3+diameter/2])
                scale(v = [0.6, 0.6])
                base(diameter);
            }
        }
        
        // Carve holes for light and pump
        translate([0, 25+65/2, -1])
        rcube([35, 65, h_base+h_feet+2], 10);
        
        // Carve away cables for pump
        translate([-24.5, 115, h_base+h_feet-25])
        cutout(26, 15, 6, 40);
        
        // Carve away pump
        translate([-52/2+20, 115-52/2, h_base])
        rcube([52, 52, h_feet+1], 10);
        
        // Carve away ultrasound fog machine...
        translate([20, 50, h_base])
        rotate([0, 0, 90])
        cutout(h_feet+1, h_feet+5, 6, 50);
        
        // Cutouts for water flow
        w_cutout = 18;
        translate([0, 150/2-1, h_base])
        cutout(h_feet+1, w_cutout, 6, 150);
        
        translate([0, 31, h_base])
        rotate([0, 0, 90])
        cutout(h_feet+1, w_cutout, 6, 150);
        
        translate([0, 115/2+w_cutout/4, h_base])
        rotate([0, 0, 90])
        cutout(h_feet+1, w_cutout, 6, 150);

        translate([0, 115-31+w_cutout/2, h_base])
        rotate([0, 0, 90])
        cutout(h_feet+1, w_cutout, 6, 150);
        
        // Carve away connectors
        translate([-20, 15, h_base])
        cylinder(d=6.1, h=h_feet+1);
        
        translate([27, 108, h_base])
        cylinder(d=6.1, h=h_feet+1);
        
        
        // Mist cut outs
        if (MIST_CUTOUTS)
        {
            translate([0, 3+diameter/2, 0])
            union()
            {
                dia_hole = 8;
                angle_step = 360 / 12;
                for (angle = [0 : angle_step : 359])
                {
                    //translate([diameter2/2-dia_hole/2-2, 0, -1])
                    rotate([0, 0, angle])
                    translate([diameter/2+dia_hole/2, 0, -1])
                    cylinder(d=dia_hole, h=h_base+h_feet+2);


                }
            }
        }
    }
}