// ********************************
// Rover Body using Chip Trays
// Filename: ChipTrayRoverBody.scad
// Created: 8/7/2018
// Revision: 1.0.0 8/7/2018
// units: mm
// ********************************

$fn=90;
Overlap=0.05;
IDXtra=0.2;

module ChipTrayEdge(){
	CTLock_y=24;
	CTLock_e=4;
	CTLockInner_x=6.6;
	translate([0,-CTLock_y/2,0]){
	cube([CTLock_e,CTLock_y,2]);
	translate([-2,0,2-Overlap]) cube([CTLockInner_x-1.4,CTLock_y,1.4]);
	translate([-2,0,3.2]) cube([CTLockInner_x,CTLock_y,1.4]);
	}
} // ChipTrayEdge

ChipTrayEdge();

ChipTray_x=136;
ChipTray_y=315;

module ChipTray(){
	difference(){
		union(){
			cube([ChipTray_x,ChipTray_y,6.3],center=true);
			translate([0,0,0.6+Overlap]) cube([ChipTray_x-4,ChipTray_y-4,7.65],center=true);
		} // union
		
		translate([0,0,-7.65/2+1.2-Overlap]) cube([ChipTray_x-4,ChipTray_y-4,1.2+Overlap],center=true);
	} // diff
} // ChipTray 

nSides=4;

//for (J=[0:nSides-1]) rotate([0,360/nSides*J+180,0]) translate([0,0,-ChipTray_x/2-10])
//	ChipTray();


module ViewBody(){
	
} // ViewBody

//ViewBody();