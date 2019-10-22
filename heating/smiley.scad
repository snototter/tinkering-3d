$fn = 6;
module smiley()
{
    translate([-9, 9, 0])
    cylinder(d = 10, h = 10);

    translate([9, 9, 0])
    cylinder(d = 10, h = 10);


    //cylinder(d = 6, h = 10);

    for (i = [-45:2:45])
    {
        rotate([0, 0, i])
        translate([0, -15, 0])
        cylinder(d = 6, h = 10);
    }

    for (i = [-15:1:305])
    {
        rotate([0, 0, i])
        translate([0, 27, 0])
        cylinder(d = 2, h = 10);
    }


    // Haare
    translate([-3, 27, 0])
    rotate([0, 0, 20])
    cube([2, 12, 10]);

    translate([1, 27, 0])
    rotate([0, 0, -15])
    cube([2, 8, 10]);
}
smiley();