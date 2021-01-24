$fn=72;
d1 = 40;
d2 = 45;
h = 13.6;

h_target = 20;

d_top = d1+2 * ((d2-d1)/2.0 / h) * h_target;
cylinder(d1=40, d2=d_top, h=h_target);

w = d2*0.75;
l = 3;
translate([-w/2, -l/2, h_target])
cube([w, l, 15]);