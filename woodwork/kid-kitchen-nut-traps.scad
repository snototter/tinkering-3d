use <../utils/screw_it.scad>

module trap(thickness=1.5,
    dia_shim = 12 + 1.0,
    height_shim = 1.1+0.3,
    height_nut = 3.2 + 0.5,
    height_screw = 6.8)
{
    $fn=144;

    H = height_screw+thickness;
    translate([0, 0, H/2])
    rotate([180, 0, 0])
    translate([0, 0, -H/2])
    difference()
    {
        cylinder(d=dia_shim + 2*thickness, h=H);
        
        union()
        {
            translate([0, 0, height_shim-0.1])
            nut_trap_m4(height_nut+0.1);
            translate([0, 0, -0.1])
            cylinder(d=dia_shim, h = height_shim +0.1);
            
            cylinder(d=4.75, h = height_screw);
        }
    }
}

module trap_hook(thickness_trap=1.5,
    dia_shim = 12 + 1.0,
    height_shim = 1.1 +0.3,
    height_nut = 3.2 + 0.5,
    height_screw = 6.8,
    hook_width = 0.5,
    hook_length = 12,
    hook_thickness = 3)
{
    $fn=144;

    trap(thickness_trap, dia_shim, height_shim, height_nut, height_screw);
    
    dia_outer = dia_shim+2*thickness_trap;
    width_hook = hook_width*dia_outer;
    cube_offset = hook_length+dia_outer/2-width_hook/2;
    translate([-width_hook/2, 0, 0])
    cube([width_hook, cube_offset, hook_thickness]); //TODO
    
    translate([0, cube_offset, 0])
    cylinder(d=width_hook, h=hook_thickness);
}

//translate([20, 0, 0])
trap();

//trap_hook(height_screw = 8.8, hook_width=0.75, hook_length=12);