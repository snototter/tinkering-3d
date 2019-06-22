laenge = 150;
rohrdurchmesser = 52; // 51.2/3
dicke = 2;
laschenabstand_wand = 60;
winkel = 20;
//gefaelle = 10;
FN=72;



module abflussbahn(laenge, rohrdurchmesser, dicke, winkel, laschenabstand_wand, gefaelle=0, FN=36)
{
    breite = rohrdurchmesser + 2*dicke;
    offset_x=breite/2-dicke/2;
    offset_y=offset_x * tan(winkel);
    hypo = sqrt(offset_x*offset_x + offset_y*offset_y);
    
    translate([0,0,laenge/2])
    //rotate([gefaelle, 0, 0])
    union()
    {
        // Mitte
        cylinder(h=laenge, d=dicke, center=true, $fn=FN);
        // Links
        translate([-offset_x, offset_y, 0])
        cylinder(h=laenge, d=dicke, center=true, $fn=FN);

        translate([-offset_x/2, offset_y/2,0])
        rotate([0,0,-winkel])
        cube([hypo, dicke, laenge], center=true);

        // Rechts
        translate([offset_x, offset_y, 0])
        cylinder(h=laenge, d=dicke, center=true, $fn=FN);

        translate([offset_x/2, offset_y/2,0])
        rotate([0,0,winkel])
        cube([hypo, dicke, laenge], center=true);
        
        // Laschen oben
        lasche_breite=10;
        lasche_hoehe=20;
        lasche_loch=5;
          // links
        translate([-offset_x, offset_y, laenge/2-lasche_breite/2-laschenabstand_wand])
        //rotate([gefaelle,0,0])
        lasche(lasche_breite, lasche_hoehe, dicke, lasche_loch, FN);
          // rechts
        translate([offset_x, offset_y, laenge/2-lasche_breite/2-laschenabstand_wand])
        lasche(lasche_breite, lasche_hoehe, dicke, lasche_loch, FN);
        
        // Laschen unten
          // links
        translate([-offset_x, offset_y, -laenge/2+lasche_breite/2])
        //rotate([gefaelle,0,0])
        lasche(lasche_breite, lasche_hoehe, dicke, lasche_loch, FN);
          // rechts
        translate([offset_x, offset_y, -laenge/2+lasche_breite/2])
        lasche(lasche_breite, lasche_hoehe, dicke, lasche_loch, FN);
    }
}

module lasche(breite, hoehe, dicke, aussparung, FN=36)
{
    hc = hoehe-breite/2;
    rotate([90,0,90])
    translate([hc/2,0,0])
    difference()
    {
        union()
        {
            cube([hc, breite, dicke], center=true);
            
            translate([hc/2, 0, 0])
            cylinder(h=dicke, d=breite, center=true, $fn=FN);
        }
        
        translate([hc/2, 0, 0])
        cylinder(h=dicke+5, d=aussparung, center=true, $fn=FN);
    }
}

abflussbahn(laenge, rohrdurchmesser, dicke, winkel, laschenabstand_wand, FN=FN);
//lasche(20, 50, dicke, 20/2, FN);
