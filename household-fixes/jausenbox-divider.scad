breite = 111.5;
hoehe1 = 25;
hoehe2 = 15;
hoehe3 = 20;
wandstaerke = 1.2;

// Trennwand unten
cube([breite, hoehe1, wandstaerke]);

translate([15, hoehe1, 0])
cube([breite-2*15, hoehe2, wandstaerke]);

// Rundungen unten
translate([15+1, hoehe1-1, 0])
cylinder(r=15, h=wandstaerke);

translate([breite-15-1, hoehe1-1, 0])
cylinder(r=15, h=wandstaerke);


// Trennwand oben
translate([15, -hoehe3, 0])
cube([breite-2*15, hoehe3, wandstaerke]);

// Rundungen oben
translate([0, -hoehe3+15+1, 0])
cube([2*15, 2*15, wandstaerke]);
translate([15+1, -hoehe3+15+1, 0])
cylinder(r=15, h=wandstaerke);

translate([breite-15, -hoehe3+15+1, 0])
cube([15, 2*15, wandstaerke]);
translate([breite-15-1, -hoehe3+15+1, 0])
cylinder(r=15, h=wandstaerke);


// Halterungen
cube([wandstaerke, hoehe1, 10.5]);
translate([breite-wandstaerke, 0, 0])
cube([wandstaerke, hoehe1, 10.5]);

