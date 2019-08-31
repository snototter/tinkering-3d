
// Ratsche fuer Spielzeugherd

$fn = 144;

lochabstand_herd_fixierung = 24.3;
difference()
{
    
    union()
    {
        // Grundplatte
        cylinder(d=35, h=1.7);
        
        // Knaufauflage
        cylinder(d=13, h=4.2);
        
        // Halterungen am Herd
        translate([lochabstand_herd_fixierung/2, 0, 0])
        cylinder(d=7, h=8.4);
        translate([-lochabstand_herd_fixierung/2, 0, 0])
        cylinder(d=7, h=8.4);
        
        translate([0, 17.5-1-2, 0])
        cylinder(d=4, h=8);
        
        h_rattle = 8-1.7-2;
        l_rattle = 9;
        translate([0, 6.5+l_rattle/2, h_rattle/2+1.7+2])
        #cube([1, l_rattle, h_rattle], center=true);
        
    }
    
    // Schraubenausbuchtung fuer Knauf
    translate([0, 0, -1])
    cylinder(d=10, h=2.5+1);
    
    // Loch in der Mitte
    translate([0, 0, -1])
    cylinder(d=6, h=10);
    
    // Halterungen am Herd (Lochabstand 24.3)
    translate([lochabstand_herd_fixierung/2, 0, -1])
    cylinder(d=2.4, h=10);
    
    translate([-lochabstand_herd_fixierung/2, 0, -1])
    cylinder(d=2.4, h=10);
    
    // Aussparung fuer Ratsche
    t_rattle_cutout = 1;
    translate([0, 6.5-t_rattle_cutout/2, 5+1.7])
    cube([70, t_rattle_cutout, 10], center=true);
    
    
}