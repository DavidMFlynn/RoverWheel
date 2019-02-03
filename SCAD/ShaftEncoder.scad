// ***************************************************************
// Shaft Angle Encoder Housing
// Filename: ShaftEncoder.scad
// by: David M. Flynn
// Created: 12/21/2018
// Revision: 1.1.0 1/5/2018
// units: mm
// ***************************************************************
// Notes:
//  Housing for Enc1 pcb.
//  Shaft must be 6mm and extend 8.5mm from the mounting surface.
//  For IntegratedBase() the shaft should extend 5mm beyond the surface.
// ***************************************************************
// History:
echo("ShaftEncoder 1.1.0");
// 1.1.0 1/5/2018 Added IntegratedBase();, Enc1IntegratedShaftHole(Dia=6.35, Height=10);
// 1.0.0 12/21/2018 First Code
// ***************************************************************
//  ***** for STL output *****
// rotate([180,0,0]) Cover();
// MagnetHolder();
// Base();
// ***************************************************************
//  ***** Routines ******
// IntegratedBase(); // Used to add an encoder base to a robot joint cover plate.
// Enc1IntegratedShaftHole(Dia=6.35, Height=10);
// PCB_Holes() Bolt2Hole();
// PCB_Enc1();
// ***************************************************************
//  ***** for Viewing *****
// ViewAll();
// ***************************************************************

include<CommonStuffSAEmm.scad>

Overlap=0.05;
IDXtra=0.2;
$fn=90;

// PCB data
Enc1_PCB_x=0.8*25.4;
Enc1_PCB_y=0.7*25.4;
Enc1_PCB_CL_x=0.425*25.4;
Enc1_PCB_CL_y=0.325*25.4;
Enc1_PCB_Hole_y=0.25*25.4;

// Disc magnet
SE_Magnet_OD=6;
SE_Magnet_h=2.5;

// Cover dimensions
SE_Cover_OD=32;
SE_Cover_ID=29;
SE_Cover_h=18;
SE_MountingHole_BC=SE_Cover_ID-10;


module ViewAll(){
	MagnetHolder();
	translate([0,0,-SE_Cover_h+4.5-Overlap]) Base();
	Cover(Cut=true);
} // ViewAll

//ViewAll();

module PCB_Holes(){
	translate([0,Enc1_PCB_Hole_y,0]) children();
	translate([0,-Enc1_PCB_Hole_y,0]) children();
} // PCB_Holes

module PCB_Enc1(){
	// chip
	translate([-3,-3,0]) cube([6,6,1]);
	// J1
	translate([-Enc1_PCB_CL_x+0.575*25.4, -Enc1_PCB_CL_y,1+1.6]) cube([0.2*25.4,0.7*25.4,12]);
	// J2
	translate([-Enc1_PCB_CL_x-0.025*25.4, -Enc1_PCB_CL_y+(0.475-0.4)*25.4,1+1.6]) cube([0.3*25.4,0.5*25.4,12]);
	// PCB
	difference(){
		translate([-Enc1_PCB_CL_x,-Enc1_PCB_CL_y,1]) cube([Enc1_PCB_x,Enc1_PCB_y,1.6]);
		PCB_Holes() cylinder(d=2,h=3);
	} // diff
} // PCB_Enc1

//PCB_Enc1();


module MagnetHolder(){
	M_Holder_len=12;
	Shaft_OD=6;
	
	difference(){
		translate([0,0,-1-M_Holder_len]) cylinder(d=8.8,h=M_Holder_len);
		
		translate([0,0,-1-SE_Magnet_h]) cylinder(d=SE_Magnet_OD+IDXtra,h=SE_Magnet_h+Overlap);
		translate([0,0,-1-M_Holder_len-Overlap]) cylinder(d=Shaft_OD+IDXtra,h=M_Holder_len-SE_Magnet_h-1);
		translate([0,0,-1-M_Holder_len-Overlap]) cylinder(d=Shaft_OD-1,h=M_Holder_len);
	} // diff
	
} // MagnetHolder

//MagnetHolder();


module Cover(Cut=false){
	
	
	translate([0,0,1]) PCB_Holes() cylinder(d=2,h=4);
	
	translate([0,0,2.6]) PCB_Holes() cylinder(d=6,h=2.4);
	
	difference(){
		translate([0,0,-SE_Cover_h+6]) cylinder(d=SE_Cover_OD,h=SE_Cover_h);
		
		translate([0,0,-SE_Cover_h+6-Overlap])  cylinder(d=SE_Cover_ID,h=SE_Cover_h-2);
		
		// for cutaway view
		if (Cut==true)
		translate([0,0,-SE_Cover_h+6-Overlap]) cube([50,50,50]);
		
		PCB_Enc1();
	} // diff
	
	// Keying pin locator
	difference(){
		hull(){
			translate([-3,SE_Cover_ID/2-2,-SE_Cover_h+6+1.7]) cube([6,3,2]);
			translate([0,SE_Cover_ID/2+0.1,-SE_Cover_h+6+1.7+6]) cylinder(d=0.1,h=0.1);
		} // hull
		translate([0,SE_Cover_ID/2-2,-SE_Cover_h+6+1.7-Overlap]) cylinder(d=3+IDXtra,h=6);
	} // diff
	
	if (Cut==true) color("Red") PCB_Enc1();
} // Cover

//Cover();

module Base(){
	difference(){
		union(){
			cylinder(d=SE_Cover_OD,h=1.5);
			cylinder(d=SE_Cover_ID,h=3);
		} // union
		
		// center hole
		translate([0,0,-Overlap]) cylinder(d=10,h=3+Overlap*2);
		
		// bolts
		translate([SE_MountingHole_BC/2,0,3]) Bolt4ClearHole();
		translate([-SE_MountingHole_BC/2,0,3]) Bolt4ClearHole();
	} // diff
	
	// keying pin
	translate([0,SE_Cover_ID/2-2,3-Overlap]) cylinder(d=3,h=2);
} // Base

//translate([0,0,-SE_Cover_h+4.5-Overlap]) Base();

module Enc1IntegratedShaftHole(Dia=6.35, Height=10){
	translate([0,0,-Height-1.5]) cylinder(d=Dia, h=Height+Overlap);
	translate([0,0,-1.5-Overlap]) cylinder(d=10,h=3+Overlap*2);
	
} // Enc1IntegratedShaftHole

//Enc1IntegratedShaftHole(Dia=6.35, Height=10);

module IntegratedBase(){
	translate([0,0,-1.5]){
	difference(){
		union(){
			cylinder(d=SE_Cover_OD,h=1.5);
			cylinder(d=SE_Cover_ID,h=3);
		} // union
		
		// center hole
		translate([0,0,-Overlap]) cylinder(d=10,h=3+Overlap*2);
		
		// bolts
		//translate([SE_MountingHole_BC/2,0,3]) Bolt4ClearHole();
		//translate([-SE_MountingHole_BC/2,0,3]) Bolt4ClearHole();
	} // diff
	
	// keying pin
	translate([0,SE_Cover_ID/2-2,3-Overlap]) cylinder(d=3,h=2);
}
} // IntegratedBase

//IntegratedBase();




















