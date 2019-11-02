
$fn = 72;


d1 = 5;
d2 = 9;
thickness = 2;
l1 = 8;
l2 = 20;
l3 = 15;
module schutzkappe()
{
    difference()
    {
        cylinder(d=d2+1.5*thickness, h=thickness+l1+l2+l3);
        // Subtract:
        translate([0, 0, thickness])
        union()
        {
            cylinder(d=d1, h=l1+1);
            translate([0, 0, l1])
            cylinder(d1=d1, d2=d2, h=l2);
            translate([0, 0, l1+l2-0.01])
            cylinder(d=d2, h=l3+1);
        }
    }   
}

// Halterung
module aufbewahrung()
{
    drawing_offset_z = 0;
    a = (d2-2)/sqrt(2);
    l = l3-5;
    wall_connector_a = 10;
    wall_connector_l = 20;
    translate([-a/2, 0, drawing_offset_z])
    cube([a, l+0.1, a]);
    translate([-a/2-14, 0, drawing_offset_z])
    cube([a, l+0.1, a]);
    translate([-a/2+14, 0, drawing_offset_z])
    cube([a, l+0.1, a]);
    w = 28+a;
    translate([-w/2, l, drawing_offset_z])
    cube([w, a, a]); 
    translate([-wall_connector_a/2, l+1, drawing_offset_z])
    cube([wall_connector_a, wall_connector_l, wall_connector_a]);
}

// Krampl
module krampl()
{
    kd1=2;
    kd2=8.4;
    kl1=20;
    kl2 = 25;

    translate([0, 0, l1-2])
    union()
    {
        cylinder(d1=kd1, d2=kd2, h=kl1);
        translate([0, 0, kl1])
        cylinder(d=kd2, h=kl2);
    }
}


schutzkappe();
translate([18, 0, 0])
schutzkappe();
translate([-18, 0, 0])
schutzkappe();

//aufbewahrung();
//krampl();