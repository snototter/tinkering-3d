use <../utils/common_carvings.scad>

h_ts = 24;
h_ts1 = 5;
h_ts2 = 10;

d_ts = 40;
thickness_lock = 2;


w_lock = 13;
//h_lock = h_ts2;

h_transition = 15; // going from d_ts to d_suction

h_suction = 40;
d_suction1 = 33.3;//32+0.9; // make it a bit tighter (33 yields a corrupt stl, for whatever reason) 33.1 is too big
d_suction2 = 31.7; // top end

$fn = 72;

ts_suction_adapter(h_ts, h_ts1, h_ts2, d_ts, thickness_lock, w_lock, h_transition, h_suction, d_suction1, d_suction2);

// D(iameter cylinder)
// H(eight cylinder)
// W(idth cube)
// num_cubes
module intersection_cylinder_cubes(D, H, W, num_cubes)
{
    angle = 360 / num_cubes;
    translate([0, 0, H/2])
    intersection()
    {
        cylinder(d = D, h = H, center = true);   
        for (i = [0 : 1 : num_cubes-1])
        {
            rotate([0, 0, i*angle])
            translate([D/2, 0, 0])
            cube([D, W, H+2], center = true);
        }
    }
}

module lock_negative(d_ts_lock, h_ts, h_ts1, h_ts2, thickness_lock, w_lock)
{
    translate([0, 0, -1]) // we make the "lock dive" a little longer to cut it out without defect meshes
    intersection_cylinder_cubes(d_ts_lock, h_ts - h_ts1 + 1, w_lock, 3);
    angle = 2*atan(w_lock / d_ts_lock);
    
    translate([0, 0, h_ts - h_ts1 - h_ts2])
    union()
    {
        rotate([0, 0, angle])
        intersection_cylinder_cubes(d_ts_lock, h_ts2, w_lock, 3);
        // The next one is extra, because we like to err on the safe side
        rotate([0, 0, angle+10])
        intersection_cylinder_cubes(d_ts_lock, h_ts2, w_lock, 3);
    }
}

module ts_suction_adapter(h_ts, h_ts1, h_ts2, d_ts, thickness_lock, w_lock, h_transition, h_suction, d_suction1, d_suction2)
{
    // Relative values
    d_ts_lock = d_ts + 2*thickness_lock + 1;
    d_ts_outer = d_ts_lock + 2*2;
    d_suction_inner1 = d_suction1 - thickness_lock - 1.5;
    d_suction_inner2 = d_suction2 - thickness_lock - 1.5;
    
    // TS55
    union()
    {
        difference()
        {
            cylinder(d = d_ts_outer, h = h_ts, center=false);
            
            // Lock cut out
            lock_negative(d_ts_lock, h_ts, h_ts1, h_ts2, thickness_lock, w_lock);
            translate([0, 0, -1])
            cylinder(d = d_ts, h = h_ts + 2, center = false);
        }
        
        // TODO proper rotation!
    /*    translate([d_ts_outer/2-1, 0, 0])
        rotate([90, 0, 30])
        linear_extrude(1.5)
        text("L", scale=1.5, halign="center");
      */  
       
        
        // Transition / Rejuvenation
        translate([0, 0, h_ts])
        rejuvenating_pipe(d_ts_outer, d_suction1, d_ts, d_suction_inner1, h_transition, center=false);
        
        // Suction adapter
        translate([0, 0, h_ts + h_transition])
        rejuvenating_pipe(d_suction1, d_suction2, d_suction_inner1, d_suction_inner2, h_suction, center=false);
        //pipe(d_suction1, d_suction_inner1, h_suction, center=false);
    }
}

