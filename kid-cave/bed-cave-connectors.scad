// Measure posts: a, b
Atop = 55.5; // mm - due to printing, this is actually the bottom, i.e. bed (yeah, confusion!)
Btop = 55.5; // mm

Abottom = 54; // mm - this will be the top, i.e. cave
Bbottom = 54;

Hmid = 4; // height of center plate
Htop = 6; // height of top (before it reaches the wooden connectors of the bed)
Hbottom = 8;
H = Htop + Hbottom + Hmid; // mm
R = 6; // corner radius
border = 4; // thickness of outer walls
FN=36; // number of faces to approximate circles

Dscrew = 4; // screw in the middle (to fix it onto the cave)
Rscrew = Dscrew/2.0; // screw radius
RscrewHat = 8.1;
module Basis()
{
    difference()
    {
        Amax = max(Abottom, Atop);
        Amin = min(Abottom, Atop);
        Bmax = max(Bbottom, Btop);
        Bmin = min(Bbottom, Btop);
        
        roundedRect([Amax+2*border, Bmax+2*border, H], R, $fn=FN);
        
        union()
        {
            // Carving top
            translate([0,0,Hbottom+Hmid])
            roundedRect([Atop, Btop, Htop + border], R, $fn=FN);
            
            // Carving bottom
            translate([0,0,-border])
            roundedRect([Abottom, Bbottom, Hbottom + border], R, $fn=FN);
            
            ///////// Cut outs of the middle plate:
            // Bottom-left
            translate([-Amin/4, -Bmin/4, -border])
            roundedRect([Amin/4, Bmin/4, H+2*border], R, $fn=FN);
            // Bottom-right
            translate([Amin/4, -Bmin/4, -border])
            roundedRect([Amin/4, Bmin/4, H+2*border], R, $fn=FN);
            // Top-right
            translate([Amin/4, Bmin/4, -border])
            roundedRect([Amin/4, Bmin/4, H+2*border], R, $fn=FN);
            // Top-left
            translate([-Amin/4, Bmin/4, -border])
            roundedRect([Amin/4, Bmin/4, H+2*border], R, $fn=FN);
            
            // Screw
            cylinder(h=H+2*border, r=Rscrew, $fn=FN, center=true);
            // TODO cones - abmessen!
            translate([0,0,Hbottom+Hmid/2])
            cylinder(h=Hmid/2+1, r1=Rscrew, r2=RscrewHat, $fn=FN, center=false);
            // cylinder(r1=,r2=)...
        }
    }
}

// size - [x,y,z]
// radius - radius of corners
module roundedRect(size, radius)
{
	x = size[0];
	y = size[1];
	z = size[2];

	linear_extrude(height=z)
	hull()
	{
		// place 4 circles in the corners, with the given radius
		translate([(-x/2)+(radius), (-y/2)+(radius), 0])
		circle(r=radius);
	
		translate([(x/2)-(radius), (-y/2)+(radius), 0])
		circle(r=radius);
	
		translate([(-x/2)+(radius), (y/2)-(radius), 0])
		circle(r=radius);
	
		translate([(x/2)-(radius), (y/2)-(radius), 0])
		circle(r=radius);
	}
}

module HoleConnector(width, wall, height_hole, hole_diameter, num_faces=36) 
{
    translate([0,0,height_hole/2])
    difference()
    {
        union()
        {
            cube([width, wall, height_hole], true);

            translate([0, 0, height_hole/2.0])
            {
                rotate([90,0,0])
                cylinder(h=wall, r=width/2.0, center=true, $fn=num_faces);
            }
        }
        translate([0, 0, height_hole/2.0])
        rotate([90,0,0])
        cylinder(h=wall+2, d=hole_diameter, center=true, $fn=num_faces);
    }
}

module Cutout(D, H, W_cutout, W_border, wall, num_faces=120)
{
    w=W_cutout+2*W_border;
    translate([0,0,H/2])
    union()
    {
        difference()
        {
            cube([w, wall, H], true);
            
            translate([0,0,w/2+H/2-(H-D)])
            rotate([90,0,0])
            cylinder(h=wall+2, d=w, center=true, $fn=num_faces);
        }
        translate([W_cutout/2+W_border/2,0,0])
        cube([W_border, wall, H], true);
        
        translate([-(W_cutout/2+W_border/2),0,0])
        cube([W_border, wall, H], true);
    }
}



module front_left()
{
    union(){
        Basis();

        center_top=Hbottom+Hmid;
        H=18;
        D=6;
        W_cutout=27.5;
        W_cutout_border=8;
        translate([0,(Atop+border)/2,center_top])
        Cutout(D, H, W_cutout, W_cutout_border, border);
        
        
        cube_width=30;
        cube_height=19;
        hole_diameter=10;
        num_faces=60;
        translate([(Atop+border)/2, 0, center_top])
        rotate([0,0,90])
        HoleConnector(cube_width, border, cube_height, hole_diameter, num_faces);
    }
}

module front_right()
{
    union(){
        Basis();

        center_top=Hbottom+Hmid;
        H=18;
        D=6;
        W_cutout=27.5;
        W_cutout_border=8;
        translate([0,(Atop+border)/2,center_top])
        Cutout(D, H, W_cutout, W_cutout_border, border);
        
        
        cube_width=30;
        cube_height=19;
        hole_diameter=10;
        num_faces=60;
        translate([-(Atop+border)/2, 0, center_top])
        rotate([0,0,90])
        HoleConnector(cube_width, border, cube_height, hole_diameter, num_faces);
    }
}


module back_left()
{
    union(){
        Basis();

        center_top=Hbottom+Hmid;
        H=18;
        D=6;
        W_cutout=27.8;
        W_cutout_border=8;
        translate([0,-(Atop+border)/2,center_top])
        Cutout(D, H, W_cutout, W_cutout_border, border);
            
        translate([-(Atop+border)/2,0,center_top])
        rotate([0,0,90])
        Cutout(D, H, W_cutout, W_cutout_border, border);
        
        cube_width=30;
        cube_height=19;
        hole_diameter=10;
        num_faces=60;
        translate([(Atop+border)/2, 0, center_top])
        rotate([0,0,90])
        HoleConnector(cube_width, border, cube_height, hole_diameter, num_faces);
    }
}


module back_right()
{
    union(){
        Basis();

        center_top=Hbottom+Hmid;
        H=18;
        D=6;
        W_cutout=27.8;
        W_cutout_border=8;
        translate([0,-(Atop+border)/2,center_top])
        Cutout(D, H, W_cutout, W_cutout_border, border);
            
        translate([-(Atop+border)/2,0,center_top])
        rotate([0,0,90])
        Cutout(D, H, W_cutout, W_cutout_border, border);
        
        cube_width=30;
        cube_height=19;
        hole_diameter=10;
        num_faces=60;
        translate([0, (Atop+border)/2, center_top])
        HoleConnector(cube_width, border, cube_height, hole_diameter, num_faces);
    }
}
//front_left();
//back_left();
//back_right();
front_right();