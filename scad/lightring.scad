$fn = 64;
diam = 150;
led = 5.3;
thick = 2;

difference() {
    union() {
        cylinder(d=diam, h=thick, $fn=64);
        difference() { cylinder(d=diam, h=thick+1, $fn=64); cylinder(d=diam-2, h=thick+2, $fn=64); }
        difference() { cylinder(d=diam-20+2, h=thick+1, $fn=64); cylinder(d=diam-20, h=thick+2, $fn=64); }
        for (angle = [0:60:359]) {
            rotate([0,0,angle]) translate([-(diam-10)/2,0,]) cylinder(d=led+2, h=thick+.5);
        }
    }
    translate([0,0,-.5]) cylinder(d=diam-20, h=thick+1, $fn=64);
    for (angle = [0:60:359]) {
        rotate([0,0,angle]) translate([-(diam-10)/2,0,-.5]) cylinder(d=led, h=thick+2);
    }
}

for (angle = [0:120:359]) {
    rotate([0,0,angle]) translate([-10/2,diam/2-2.2,0]) difference() {
        union() {
            cube([10,2,10]);
            translate([0,0,10]) cube([10,10,1]);
            translate([10/2,10,10]) cylinder(d=10, h=1);
        }
        translate([10/2,10,10-.5]) cylinder(d=4, h=2);
    }
}


for (angle = [15:30:359]) {
    rotate([0,0,angle]) translate([diam/2-5,0,thick-.01]) intersection() {
        scale([1,1,1]) rotate([90,0,0]) difference() {
            cylinder(d=10, h=4, center=true);
            cylinder(d=8, h=5, center=true);
        }
        translate([-5,-5,0])cube([10,10,10]);
    }
}
    