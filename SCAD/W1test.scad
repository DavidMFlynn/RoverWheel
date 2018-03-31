
$fn=90;
Overlap=0.05;

module Rim(){
difference(){
	scale([3,1,1]) sphere(d=180);
	
	scale([3,1,1]) sphere(d=176);
	
	translate([70,-100,-100]) cube([200,200,200]);
	mirror([1,0,0])translate([70,-100,-100]) cube([200,200,200]);
} // diff

	hull(){
		rotate([-5,0,0])translate([-15,0,89]) cylinder(d1=4,d2=2,h=3);
		rotate([5,0,0])translate([15,0,89]) cylinder(d1=4,d2=2,h=3);
	} // hull
	hull(){
		rotate([-5,0,0])translate([45,0,88]) cylinder(d1=4,d2=2,h=3);
		rotate([5,0,0])translate([15,0,89]) cylinder(d1=4,d2=2,h=3);
	} // hull
	hull(){
		rotate([-5,0,0])translate([45,0,88]) cylinder(d1=4,d2=2,h=3);
		rotate([5,0,0])translate([65,0,86.5]) cylinder(d1=4,d2=2,h=3);
	} // hull
} // Rim

Rim();

Hub_d=40;
Hub_l=30;
Spoke_w=1;
Spoke_l=55;
nSpokes=4;
translate([-70,0,0]) rotate([0,90,0]) cylinder(d=Hub_d,h=Hub_l);
for (j=[0:nSpokes-1]){
translate([-70,0,0]) rotate([360/nSpokes*j,0,0]) translate([0,-Spoke_w/2,Hub_d/2-Overlap]) cube([Hub_l,Spoke_w,Spoke_l+Overlap*2]);
difference(){
	translate([-70,0,0]) rotate([360/nSpokes*j,0,0]) translate([0,-5,Hub_d/2+Spoke_l]) rotate([0,90,0]) cylinder(d=10+Spoke_w,h=Hub_l);
	
	translate([-70-Overlap,0,0]) rotate([360/nSpokes*j,0,0]) translate([0,-5,Hub_d/2+Spoke_l]) rotate([0,90,0]) cylinder(d=10-Spoke_w,h=Hub_l+Overlap*2);
	translate([-70-Overlap,0,0]) rotate([360/nSpokes*j,0,0]) translate([0,-5,Hub_d/2+Spoke_l]) rotate([0,90,0]){
		translate([0,-Overlap,0])rotate([0,0,0])cube([10,10,Hub_l+Overlap*2]);
		translate([-Overlap,0,0])rotate([0,0,-90])cube([10,10,Hub_l+Overlap*2]);
		rotate([0,0,180])cube([10,10,Hub_l+Overlap*2]);
	}
} // diff

translate([-70,0,0]) rotate([360/nSpokes*j,0,0]) translate([0,-Spoke_w/2,Hub_d/2+Spoke_l+5]) cube([Hub_l,10+Overlap*2,Spoke_w]);

} // for