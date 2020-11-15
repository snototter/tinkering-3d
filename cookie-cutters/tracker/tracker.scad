// Cookie Cutter: Skye

$fn = 144;
diameter_head=40;
base_plate_height=6;
face_height=8;
diameter_base=diameter_head + 10;
cutter_thickness=0.4*4;

union()
{
    // Base plate
    cylinder(h=base_plate_height, d=diameter_base);

    // Cutter
    cutter_height=base_plate_height++3;
    cylinder(h=cutter_height, d=diameter_base);

    // Dog face
    linear_extrude(height=base_plate_height+face_height)
    translate([0, -2, 0])
    resize([0, diameter_head], auto=true)
    import("retraced.svg", convexity=2, center=true, dpi=72);
    //import("tracker-thicker.dxf", convexity=10, center=true, dpi=72);
}