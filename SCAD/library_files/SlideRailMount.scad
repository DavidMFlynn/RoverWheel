// ****************************************
// 12mm Slide Rail to 1" 8020 1010-Black Mounting
// Filename: SlideRailMount.scad
// Created: 2/19/2019
// Revision: 1.0
// Units: mm
// ****************************************

include <CommonStuffSAEmm.scad>

$fn=90;
IDXtra=0.2;
Overlap=0.05;

module SlideRailMount(H=31,W=20,L=35){
	BoltCL=25;
	RailSup_W=12; //13.8;
	
	difference(){
		union(){
			translate([-L/2,-W/2,0]) cube([L,W,12]);
			translate([-L/2,-RailSup_W/2,H-2]) cube([L,RailSup_W,2]);
			hull(){
				translate([-L/2,-W/2,11]) cube([L,W,1]);
				translate([-L/2,-RailSup_W/2,H-2]) cube([L,RailSup_W,0.2]);
			} // hull
		} // union
		
		
		translate([0,10,H]) rotate([90,0,0]) cylinder(d=12,h=20);
		
		translate([-BoltCL/2,0,H]) Bolt6Hole();
		translate([BoltCL/2,0,H]) Bolt6Hole();
		translate([0,0,15]) Bolt250ButtonHeadHole(depth=12,lHead=H);
		//translate([0,0,17.8]) Bolt250HeadHole(depth=11.5,lAccess=H);
	} // diff
	
} // SlideRailMount

SlideRailMount();