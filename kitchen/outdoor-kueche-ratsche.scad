use <../utils/screw_it.scad>

module rounded_stick(width, depth, height, rot180)
{
    r = width/2;
    union()
    {
        if (rot180)
        {
            translate([r, r, 0])
            cylinder(r=r, h=height);
            translate([0, r, 0])
            cube([width, depth-r, height]);
        }
        else
        {
            cube([width, depth-r, height]);
            translate([r, depth-r, 0])
            cylinder(r=r, h=height);
        }
    }
}

module cutout(num_ticks = 12, h=5, d=60, b=1, t=12)
{

difference()
{
    cylinder(h=h, d=d);

    union()
    {
        for (step = [0 : num_ticks-1])
        {
            rotate([0, 0, 360/num_ticks*step])
            // 0.2 to ensure enough overlap for slicing
            translate([-b/2, d_aussen/2-t-0.2, -1])
            rounded_stick(b, t+0.2, h+2, rot180=true);
        }
    }
}
}

module ratsche(h, d_wheel, d_cutout1, d_cutout2, b, l, num_ticks)
{
    echo("Ratsche, durchmesser = ", d_wheel);
    angle_step = 360/num_ticks;
    difference()
    {
        union()
        {
            cylinder(d=d_wheel, h=h);
            for (step = [0 : num_ticks-1])
            {
                rotate([0, 0, angle_step*step])
                translate([-b/2, d_wheel/2-0.2, 0])
                rounded_stick(b, l+0.2, h);
            }
        }
        // Raendelschraube Cutout
        translate([0, 0, -1])
        cylinder(h=h+2, d=d_cutout1);
        // Nagelstift Cutout
        dia = d_wheel+2*l+2;
        rotate([0, 0, angle_step/2])
        translate([0, 0, h/2])
        rotate([0, 90, 0])
        translate([0, 0, -dia/2])
        cylinder(d=d_cutout2, h=dia);
    }
}



nt_aussen = 4;
nt_innen = 16;
$fn = 36;


h_innen = 5;
// Auszen
b_aussen = 140;
padding_aussen = 7;
d_aussen = 50;
ratsche_aussen = 15;
ratsche_innen = 2;
ueberlapp = 0.5;
cutout1=8;
cutout2=2;
h_aussen=h_innen-1;

offset_x = b_aussen/2 - d_aussen/2 - padding_aussen;
echo("Abstand Rändelschrauben = ", 2*offset_x);


t_aussen = d_aussen + 2*padding_aussen;
translate([b_aussen/2, t_aussen/2, 0])
difference()
{
    union()
    {
        difference()
        {
            // Aussen-"Platte"
            translate([-b_aussen/2, -t_aussen/2, 0])
            cube([b_aussen, t_aussen, h_aussen/2]);

            // Cutouts fuer Innenteil
            translate([-offset_x, 0, -1])
            cutout(num_ticks=nt_aussen, h=h_aussen+2, d=d_aussen, b=2, t=ratsche_aussen);
            
            translate([offset_x, 0, -1])
            cutout(num_ticks=nt_aussen, h=h_aussen+2, d=d_aussen, b=2, t=ratsche_aussen);
        }
        //*/

        d_innen = d_aussen - 2 * (ratsche_aussen + ratsche_innen - ueberlapp);
        angle_step = 360/nt_innen;
        translate([-offset_x, 0, 0])
        rotate([0, 0, angle_step/2])
        ratsche(h=h_innen, d_wheel=d_innen, d_cutout1=cutout1, d_cutout2=cutout2, b=2.8, l=ratsche_innen, num_ticks=nt_innen);

        translate([offset_x, 0, 0])
        rotate([0, 0, angle_step/2])
        ratsche(h=h_innen, d_wheel=d_innen, d_cutout1=cutout1, d_cutout2=cutout2, b=2.8, l=ratsche_innen, num_ticks=nt_innen);
        
        cylinder(h=h_aussen, d=8);
        translate([-b_aussen/2+1.4*padding_aussen, t_aussen/2-1.4*padding_aussen, 0])
        cylinder(h=h_aussen, d=8);
        translate([-b_aussen/2+1.4*padding_aussen, -t_aussen/2+1.4*padding_aussen, 0])
        cylinder(h=h_aussen, d=8);
        translate([b_aussen/2-1.4*padding_aussen, t_aussen/2-1.4*padding_aussen, 0])
        cylinder(h=h_aussen, d=8);
        translate([b_aussen/2-1.4*padding_aussen, -t_aussen/2+1.4*padding_aussen, 0])
        cylinder(h=h_aussen, d=8);
        
        // manually add support material
        //touching the wheel:
        translate([offset_x-2, -t_aussen/2, 0])
        cube([4, padding_aussen+ratsche_aussen, 0.2]);
        translate([-offset_x-2, -t_aussen/2, 0])
        cube([4, padding_aussen+ratsche_aussen, 0.2]);

        // not touching the wheel
        x=4;
        y=padding_aussen+ratsche_aussen-1;
        translate([offset_x, 0, 0])
        for (i = [0 : 3])
        {
            rotate([0, 0, 90*i])
//            translate([offset_x-2, d_innen/2 + ratsche_innen, 0])
            translate([-x/2, -y/2+d_aussen/2-padding_aussen/2, 0]) 
            cube([x, y, 0.2]);
        }
        
        translate([-offset_x, 0, 0])
        for (i = [0 : 3])
        {
            rotate([0, 0, 90*i])
//            translate([offset_x-2, d_innen/2 + ratsche_innen, 0])
            translate([-x/2, -y/2+d_aussen/2-padding_aussen/2, 0]) 
            cube([x, y, 0.2]);
        }
/*translate([-offset_x-2, -t_aussen/2, 0])
cube([4, t_aussen, 0.2]);
translate([-b_aussen/2, -2, 0])
cube([b_aussen, 4, 0.2]);*/
    }
  
    translate([0, 0, -1])
    cylinder(h = h_aussen+2, d=4);
//    countersunk_screw_cutout(h_aussen, 4, 4, 7.9, epsilon=1);
    translate([-b_aussen/2+1.4*padding_aussen, t_aussen/2-1.4*padding_aussen, -1])
    cylinder(h = h_aussen+2, d=4);
    //countersunk_screw_cutout(h_aussen, 4, 4, 7.9, epsilon=1);
    translate([-b_aussen/2+1.4*padding_aussen, -t_aussen/2+1.4*padding_aussen, -1])
    cylinder(h = h_aussen+2, d=4);
    //countersunk_screw_cutout(h_aussen, 4, 4, 7.9, epsilon=1);
    translate([b_aussen/2-1.4*padding_aussen, t_aussen/2-1.4*padding_aussen, -1])
    cylinder(h = h_aussen+2, d=4);
    //countersunk_screw_cutout(h_aussen, 4, 4, 7.9, epsilon=1);
    translate([b_aussen/2-1.4*padding_aussen, -t_aussen/2+1.4*padding_aussen, -1])
    cylinder(h = h_aussen+2, d=4);
    //countersunk_screw_cutout(h_aussen, 4, 4, 7.9, epsilon=1);
}