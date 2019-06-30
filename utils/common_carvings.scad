/*
 * Geometric primitives I had to carve several times, e.g. a carved truncated cone, a carved cylinder (i.e. a pipe).
 *
 */
 
 // Examples
$fn = 72;
pipe(10, 9, 20, false);

translate([12, 0, 0])
rejuvenating_pipe(10, 7, 9, 6, 12, false);
 
module pipe(d_out, d_in, h, center=true)
{
    difference()
    {
        cylinder(d=d_out, h=h, center=center);
        translate([0, 0, center ? 0 : -1])
        cylinder(d=d_in, h=h+2, center=center);
    }
}


// A rejuvenating pipe is a carved truncated cone (German: ausgehoehlter Kegelstumpf)
module rejuvenating_pipe(d1_out, d2_out, d1_in, d2_in, h, center=true)
{
    // The cut out must be larger to avoid corrupt meshes, so similar triangles to the rescue!
    r1_old = d1_in/2;
    r2_old = d2_in/2;
    rem = (h + 1) * (r1_old - r2_old) / h;
    r2_new = r1_old - rem;
    r1_new = rem + r2_old;
 
    difference()
    {
        cylinder(d1=d1_out, d2=d2_out, h=h, center=center);
 
        translate([0, 0, center ? 0 : -1])
        cylinder(r1=r1_new, r2=r2_new, h=h+2, center=center);
    }
}

