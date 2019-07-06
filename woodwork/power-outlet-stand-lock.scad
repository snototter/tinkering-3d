//4.2 innen


d_inner = 4.5;
d_outer = d_inner+2*2;

h_wood = 31;
h_lock = 4;

length_lock = 42-d_outer; // from center to center, so it's actually length+d_outer long!
$fn=36;
difference()
{
    union()
    {
        hull()
        {
            cylinder(d=d_outer, h=h_lock, center=false);
            translate([0, length_lock, 0])
            cylinder(d=d_outer, h=h_lock, center=false);
        }
        
        cylinder(d=d_outer, h=h_lock+h_wood, center=false);
    }
    
    translate([0, 0, -1])
    cylinder(d=d_inner, h=h_lock+h_wood+2, center=false);
}