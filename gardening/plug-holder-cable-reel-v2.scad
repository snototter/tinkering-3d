$fn=36;

module kabelfuehrung(length, dia=2.5)
{
    translate([0, 0, dia/2])
    rotate([90, 0, 0])
    cylinder(d=dia, h=length, center=true);
    translate([-dia/2, -length/2, -1])
    cube([dia, length, dia/2+1]);
}

module seitenwand(breite=5)
{
    union()
    {
        cube([breite, 33.5, 10]);
        translate([1, 0, 0])
        cube([breite-2, 33.5, 11]);

        translate([1, 33.5/2, 10])
        rotate([90, 0, 0])
        cylinder(d=2, h=33.5, center=true);

        translate([breite-1, 33.5/2, 10])
        rotate([90, 0, 0])
        cylinder(d=2, h=33.5, center=true);
    }
}

//kabelfuehrung(length=30);

//seitenwand();

// Grundplatte
h_base = 4;
b_base = 37;
l_base = 45;

module schrauben_ausbuchtung(h, d=4.4)
{   
    translate([0, 0, -1])
    cylinder(d = d, h = h+2);
}
    
difference()
{
    union()
    {
        cube([b_base, l_base, h_base]); 

        translate([0, 0, h_base])
        union()
        {
            seitenwand(breite=6);
            translate([b_base-6, 0, 0])
            seitenwand(breite=6);
        }
    }

    lk1 = b_base+2;
    translate([lk1/2-1, 33.5/2, 0])
    rotate([0, 0, 90])
    kabelfuehrung(length=lk1);
    
    lk2 = h_base + 10 + 4;
    translate([0, 33.5/2, lk2/2-2])
    rotate([90, 0, 90])
    kabelfuehrung(length=lk2);
    
    translate([b_base, 33.5/2, lk2/2-2])
    rotate([90, 0, 270])
    kabelfuehrung(length=lk2);
    
    
    
    translate([b_base/2, 12, 0])
    rotate([0, 0, 21])
    union()
    {
        translate([0, 28, 0])
        schrauben_ausbuchtung(h=h_base);
        schrauben_ausbuchtung(h=h_base);
    }
}