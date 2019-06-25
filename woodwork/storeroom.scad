// Regale Abstellkammer

shelf_height = 2000;

shoes_depth = 330;
shoes_width = 430;
shoes_radius = 50;
shoes_doorshroud = [90, 110];

main_depth = shoes_width;
main_length = 1000;
main_corner = [298, 300];
depth_main = 400;

back_depth = 330;
back_width = 550;

height_wood = 15;

// Schluesselbrett
keyboard_width = 200;

// Metallschiene
rack_offset = 130;
rack_width = 18;
rack_depth = 12; // Wand <--> Front
rack_height = 2000;


with_divider = true;
with_keyboard = true;
with_door = false;


// [w]idth, [h]eight, [d]epth
module rack(w, h, d)
{
    color_racks = [150/255, 60/255, 200/255];
    translate([0, 0, h/2])
    color(color_racks)
    cube(size=[w, d, h], center=true);
}


// [s]pacing between racks
// [w]idth, [h]eight, [d]epth of a single rack
module racks(s, w, h, d)
{
    translate([0, -d/2, 0])
    {
        rack(w=w, h=h, d=d);
        
        translate([s, 0, 0])
        rack(w=w, h=h, d=d);
    }
}


// [r]adius of rounded corner
// [w]idth of shelf
// [l]ength (or depth) of shelf
// [h]eight of shelf
// [cwl] width of cut out (bottom left)
// [cll] length of cut out (bottom left)
// [cwr, clr] top right cut out
module shoeshelf(r, w, l, h, cwl, cll, cwr, clr)
{
    color_shoes = [200/255, 100/255, 0/255];
    color(color_shoes)
    
    difference()
    {
        hull()
        {
            cube(size=[w/10, l/10, h]);
            translate([0, l*9/10, 0])
            cube(size=[w/10, l/10, h]);
            translate([w*9/10, l*9/10, 0])
            cube(size=[w/10, l/10, h]);
            translate([w-r, r, 0])
            cylinder(r=r, h=h);
        }
        
        translate([-1, -1, -1])
        cube(size=[cwl+1, cll+1, h+2], center=false);
        
        translate([w-cwr, l-clr, -1])
        cube(size=[cwr+1, clr+1, h+2], center=false);
    }
}

// [w]idth
// [l]ength
// [h]eight
// [cw] width of corner (visible)
// [cl] length of corner (visible)
module mainshelf(w, l, h, cw, cl)
{
    color("brown")
    difference()
    {
        cube(size=[w, l, h], center=false);
        
        translate([cw, l-cl, -1])
        cube(size=[w-cw+1, cl+1, h+2], center=false);
    }
}


module backshelf(w, h, l)
{
    color("blue")
    cube(size=[w, l, h], center=false);
}


module keyhook(r=5, l=30, h=25)
{
    color("black")
    //hull()
    {
        rotate([0, 90, 0])
        cylinder(r=r, h=l);
        
        translate([l-r, 0, r])
        cylinder(r=r, h=h);
    }
}


// Shoe shelfs
for (h=[300:300:rack_height])
{
    translate([0, 0, h])
    shoeshelf(r=shoes_radius, w=shoes_width, l=shoes_depth, h=height_wood, cwl=shoes_doorshroud[0], cll=shoes_doorshroud[1], cwr=height_wood, clr=keyboard_width);
}


// Key board
if (with_keyboard)
{
    translate([shoes_width-height_wood, shoes_depth-keyboard_width, 0])
    {
        cube(size=[height_wood, keyboard_width, shelf_height], center=false);

        // Decorate by some key hooks
        for (row = [1200:200:1700])
        {
            for (col = [50:60:199])
            {
                translate([18, col, row])
                keyhook();
            }
        }
    }
}


// Rails for shoe shelf
translate([100, 300, rack_offset])
racks(s=150, w=rack_width, h=rack_height, d=rack_depth);


// Divider
if (with_divider)
{
    translate([0, shoes_depth, 0])
    cube(size=[shoes_width, height_wood, shelf_height], center=false);
}


// Main shelf
for (h=[300, 600, 1200, 1500, 1785])
{
    translate([0, shoes_depth+height_wood, h])
    mainshelf(w=main_depth, l=main_length, h=height_wood, cw=main_corner[0], cl=main_corner[1]);
}


// Rails for main shelf
translate([0, 500, rack_offset])
rotate([0, 0, 90])
racks(s=400, w=rack_width, h=rack_height, d=rack_depth);

// Back shelf
for (h=[1200, 1500, 1785])
{
    translate([main_depth, shoes_depth + height_wood + main_length - main_corner[1] - back_depth, h])
    backshelf(w=back_width, l=back_depth, h=height_wood);
}

// Rails for back shelf
translate([500, shoes_depth + height_wood + main_length - main_corner[1], rack_offset])
racks(s=150, w=rack_width, h=rack_height, d=rack_depth);

if (with_door)
{
    color("black", 0.6)
    union()
    {
        translate([0, -40, 0])
        cube(size=[90, 150, 1900], center=false);//TODO door height?????
        
        translate([800+90, -40, 0])
        cube(size=[90, 150, 1900], center=false);
        
        translate([0, -40, 1900])
        cube(size=[800+90+90, 150, 150], center=false);
    }
    
    // left wall
    color("grey", 0.6)
    translate([-20, 110, 0])
    cube(size=[20, 1245, 2600], center=false);
    
    // back corner
    color("grey", 0.6)
    translate([-20, 110+1245, 0])
    cube(size=[20+20+300, 20, 2600], center=false);
    // right wall
    color("grey", 0.6)
    translate([800+90+90, 110, 0])
    cube(size=[20, 965, 2600], center=false);
}