
$fn = 72;

module schutzkappe()
{
    d1 = 5;
    d2 = 9;
    thickness = 2;
    l1 = 8;
    l2 = 20;
    l3 = 15;
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

schutzkappe();
translate([14, 0, 0])
schutzkappe();
translate([-14, 0, 0])
schutzkappe();
/*
// Krampl
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
*/