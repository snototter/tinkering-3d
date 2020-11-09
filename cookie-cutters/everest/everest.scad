// Cookie Cutter: Skye

$fn = 144;
diameter_head=40;
base_plate_height=6;
face_height=8;
diameter_base=diameter_head + 6;
cutter_thickness=1.2;

union()
{
    // Base plate
    difference()
    {
        // Base plate
        cylinder(h=base_plate_height, d=diameter_base);
        // Punch hole
        translate([0, 12, -0.1])
        cylinder(h=base_plate_height+0.2, d=19.2);
    }

    // Cutter
    cutter_height=base_plate_height+face_height+3;
    difference()
    {
        cylinder(h=cutter_height, d=diameter_base);
        translate([0, 0, -0.1])
        cylinder(h=cutter_height+0.2, d=diameter_base-2*cutter_thickness);
    }

    // Dog face
    linear_extrude(height=base_plate_height+face_height)
    translate([0, -2, 0])
    resize([0.8*diameter_head, 0], auto=true)
    import("everest.svg", convexity=10, center=true, dpi=72);
}