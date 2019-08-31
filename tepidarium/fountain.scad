/* Stand for the fountain in our tepidarium */
$fn = 72;
diameter=103;//95;
h_feet = 47;
h_base = 7;

module base(diameter)
{
hull()
    {
        circle(r = diameter/2);
        translate([0, 23])
        circle(r = diameter/2);
    }
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




difference()
{
    // Platform for the fountain (stone), extrude full body and carve away later
    difference()
    {
        linear_extrude(height = h_base+h_feet)
        {
            translate([0, diameter/2])
            base(diameter);
        }
        
        translate([0, 0, h_base])
        linear_extrude(height = h_base+h_feet)
        {
            translate([0, diameter/2])
            scale(v = [0.5, 0.5])
            base(diameter);
        }
    }
    
    // Carve away pump
    translate([-5, 63, -1])
    rotate([0, 0, 35])
    union()
    {
        cylinder(d=15, h=80);
        translate([-15/2, -15/2, 0])
        cube([45, 50, 70]);
    }
    
    // Carve away light
    dlight = 35;
    translate([0, 38+dlight/2, -1])
    cylinder(d=dlight, h=80);
    
    // Carve away cables for pump
    translate([-35, 105, h_base+h_feet-25])
    rotate([0, 0, 35])
    cutout(26, 30, 6, 80);
    
    // Carve away ultrasound fog machine...
    translate([30, 50, h_base])
    rotate([0, 0, 75])
    cutout(h_feet+1, h_feet, 6, 50);
    
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

}

// Light plug (so we can adjust its z position inside the fountain stone)
translate([0, -14, 0])
difference()
{
    light_cable_width = 3.5;
    cylinder(d1=18, d2=16, h=15);

    translate([-light_cable_width/2, 0, -1])
    cube([light_cable_width, 10, 17]); 
}
/*translate([0, diameter/2])
linear_extrude(height = 46)
{
    difference()
    {
        base(diameter);
        scale(v = [0.8, 0.8])
        base(diameter);
    }
}*/

/*difference()
{
    linear_extrude(height = 5)
    {
        translate([0, diameter/2])
        base(diameter);
    }

    // Pump cutout
    translate([-3, 65, -1])
    rotate([0, 0, 35])
    union()
    {
        cylinder(d=15, h=80);
        translate([-15/2, -15/2, 0])
        cube([42, 47, 70]);
    }
}