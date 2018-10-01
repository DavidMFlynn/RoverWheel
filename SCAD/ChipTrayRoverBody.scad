// ********************************
// Rover Body using Chip Trays
// Filename: ChipTrayRoverBody.scad
// Created: 8/7/2018
// Revision: 1.1.0 9/29/2018
// units: mm
// ********************************
// History
// 1.1.0 9/29/2018 added BottomSuport
// 1.0.0 8/7/2018 First code
// ********************************
// for STL output
//
// rotate([180,0,0]) BottomSuport();
// BottomSuportCap();
// ********************************
//
include<CommonStuffSAEmm.scad>

$fn=90;
Overlap=0.05;
IDXtra=0.2;

ChipTray_EdgeChanel=7.8;
ChipTray_x=136;
ChipTray_y=315;

module BottomSuport(){
	Sup_Len=178;
	
	
	difference(){
		hull(){
			translate([0,-Sup_Len/2,10]) cube([ChipTray_EdgeChanel,Sup_Len,5]);
			translate([0,-25,0]) cube([ChipTray_EdgeChanel,50,1]);
		} // hull
		
		// tube sattle
		translate([-Overlap,0,0]) rotate([0,90,0]) cylinder(d=12.7,h=ChipTray_EdgeChanel+Overlap*2);
		
		// Bolt holes
		translate([ChipTray_EdgeChanel/2,-15,0]) rotate([180,0,0]) Bolt4Hole(depth=10);
		translate([ChipTray_EdgeChanel/2,15,0]) rotate([180,0,0]) Bolt4Hole(depth=10);
		
		// Chip Tray bolt holes
		for (j=[0:2])
		{
			translate([ChipTray_EdgeChanel/2,21+27.5*j,15]) Bolt4Hole(depth=10);
			mirror([0,1,0]) translate([ChipTray_EdgeChanel/2,21+27.5*j,15]) Bolt4Hole(depth=10);
		}
		
		// Notches
		for (j=[0:3])
			translate([-Overlap,-15-27.5+27.5*j,11.7]) cube([ChipTray_EdgeChanel+Overlap*2,2.5,3.5]);
	} // diff
} // BottomSuport

//BottomSuport();

module BottomSuportCap(){
	difference(){
		union(){
			translate([0,-20,0]) cube([ChipTray_EdgeChanel,40,6]);
			rotate([0,90,0]) cylinder(d=12.7*2,h=ChipTray_EdgeChanel);
		} // union
		
		// remove bottom
		translate([-Overlap,-20,-20]) cube([ChipTray_EdgeChanel+Overlap*2,40,20]);
		
		// tube sattle
		translate([-Overlap,0,0]) rotate([0,90,0]) cylinder(d=12.7,h=ChipTray_EdgeChanel+Overlap*2);
		
		// Bolt holes
		translate([ChipTray_EdgeChanel/2,-15,10]) Bolt4HeadHole();
		translate([ChipTray_EdgeChanel/2,15,10]) Bolt4HeadHole();
		
	} // diff
} // BottomSuportCap

//BottomSuportCap();

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

//ChipTrayEdge();


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