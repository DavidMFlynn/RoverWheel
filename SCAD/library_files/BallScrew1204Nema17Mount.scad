// ****************************************
// 12mm Ball Screw to Nema 17 Stepper
// Filename: BallScrew1204Nema17Mount.scad
// Created: 2/23/2019
// Revision: 1.1 3/2/2019
// Units: mm
// ****************************************
//  ***** History *****
// 1.1 3/2/2019 Added SideMount
// 1.0 2/23/2019  First code
// ****************************************
//  ***** for STL output *****
// rotate([-90,0,0]) MountB10ToNema17();
// NutMount(Height=21.3);
// SideMount();
// rotate([180,0,0]) SideIdleMount();
// ****************************************
//  ***** for Viewing *****
// ViewAll();
// ****************************************

include <CommonStuffSAEmm.scad>

$fn=90;
IDXtra=0.2;
Overlap=0.05;

FaceToFace_y=52;
	BoltCL_x=46;
	BoltCL_z=15;
	Wall_t=6;

module ViewAll(){
	SideIdleMount();
	translate([30,40,42]) rotate([-90,0,0]) NutMount(Height=21.3);
	translate([30,80,12.7]) SideMount();
	translate([30,90,48]) MountB10ToNema17();
} // ViewAll

module NutMount(Height=24.7){
	Thickness=25.4;
	BoltSpace_y=0.475*25.4;
	BoltSpace_x=2*25.4;
	
	difference(){
		union(){
			cylinder(d=42,h=Thickness);
			translate([-21,-Height,0]) cube([42,Height,Thickness]);
			translate([-32,-Height,0]) cube([64,12,Thickness]);
		} // union
		
		// center hole
		translate([0,0,-Overlap]) cylinder(d=23,h=Thickness+Overlap*2);
		
		// Screw access
		hull(){
			translate([0,0,-Overlap]) cylinder(d=14,h=Thickness+Overlap*2);
			translate([0,30,-Overlap]) cylinder(d=14,h=Thickness+Overlap*2);
		} // hull
		
		translate([0,0,Thickness]) for (j=[0:2]) rotate([0,0,45*j-45]){
			translate([16,0,0]) Bolt8Hole();
			translate([-16,0,0]) Bolt8Hole();
		}

		// trim bottom
		translate([-21,15.5,-Overlap]) cube([42,10,Thickness+Overlap*2]);
		
		
		translate([-BoltSpace_x/2,-Height+12,Thickness/2-BoltSpace_y/2]) rotate([-90,0,0]) Bolt8HeadHole(depth=12, lAccess=12);
		translate([BoltSpace_x/2,-Height+12,Thickness/2-BoltSpace_y/2]) rotate([-90,0,0]) Bolt8HeadHole(depth=12, lAccess=12);
		translate([-BoltSpace_x/2,-Height+12,Thickness/2+BoltSpace_y/2]) rotate([-90,0,0]) Bolt8HeadHole(depth=12, lAccess=12);
		translate([BoltSpace_x/2,-Height+12,Thickness/2+BoltSpace_y/2]) rotate([-90,0,0]) Bolt8HeadHole(depth=12, lAccess=12);
	} // diff
} // NutMount

//NutMount(Height=21.3);

module SideIdleMount(){
	// Mounts Lead screw idle bearing block to side of 8020 1010 extrusion
	
	FaceToFace=37;
	BBLock_t=20;
	BBlock_w=60;
	BB10_BoltSpacing=46;
	EndExtra=15;
	Extrusion=25.4;
	
	HeadXtra=17;
	
	module Gusset(){
		hull(){
			translate([0,6.35,0]) cylinder(d=10,h=Extrusion);
			translate([0,FaceToFace,Extrusion-5]) rotate([90,0,0]) cylinder(d=10,h=0.01);
		} // hull
	} //Gusset
	
	difference(){
		union(){
			cube([BBlock_w,12.7,Extrusion]);
			translate([0,0,Extrusion-10]) cube([BBlock_w,FaceToFace,10]);
			
			// gussets
			translate([BBlock_w/2+11,0,0]) Gusset();
			translate([BBlock_w/2-11,0,0]) Gusset();
		} // union
		
		// Bearing block mounting bolts
		translate([BBlock_w/2+BB10_BoltSpacing/2,FaceToFace-BBLock_t/2,Extrusion]) Bolt250Hole();
		translate([BBlock_w/2-BB10_BoltSpacing/2,FaceToFace-BBLock_t/2,Extrusion]) Bolt250Hole();
		
		// Extrision mounting
		translate([BBlock_w/2,5+Bolt250_BtnHead_h,Extrusion/2]){
		translate([0,0,0]) rotate([-90,0,0]) Bolt250ButtonHeadHole(depth=12,lHead=HeadXtra);
		translate([BBlock_w/2-8,0,0]) rotate([-90,0,0]) Bolt250ButtonHeadHole(depth=12,lHead=HeadXtra);
		translate([-BBlock_w/2+8,0,0]) rotate([-90,0,0]) Bolt250ButtonHeadHole(depth=12,lHead=HeadXtra);}
	} // diff
} // SideIdleMount

//rotate([180,0,0]) SideIdleMount();

module SideMount(){
	// Mounts Lead screw bearing block to side of 8020 1010 extrusion
	
	BB10_BoltSpacing=46;
	EndExtra=15;
	
	difference(){
		cube([BB10_BoltSpacing+EndExtra*2,12.7,25.4],center=true);
		
		// Bearing block mounting bolts
		translate([-BB10_BoltSpacing/2,0,12.7]) Bolt250Hole();
		translate([BB10_BoltSpacing/2,0,12.7]) Bolt250Hole();
		
		// Extrision mounting
		translate([0,12.7/2,0]) rotate([-90,0,0]) Bolt250ButtonHeadHole();
		translate([BB10_BoltSpacing/2+8,12.7/2,0]) rotate([-90,0,0]) Bolt250ButtonHeadHole();
		translate([-BB10_BoltSpacing/2-8,12.7/2,0]) rotate([-90,0,0]) Bolt250ButtonHeadHole();
	} // diff
} // SideMount

//SideMount();

module BBSideMount(H=12){
	
	difference(){
		union(){
			translate([-BoltCL_x/2-Wall_t,0,-BoltCL_z-Wall_t]) cube([Wall_t*2,H,BoltCL_z+Wall_t*2]);
			translate([BoltCL_x/2-Wall_t,0,-BoltCL_z-Wall_t]) cube([Wall_t*2,H,BoltCL_z+Wall_t*2]);
		} // union
		
		// Bolts
		translate([-BoltCL_x/2,0,0]) rotate([90,0,0]) Bolt8Hole();
		translate([BoltCL_x/2,0,0]) rotate([90,0,0]) Bolt8Hole();
		translate([-BoltCL_x/2,0,-BoltCL_z]) rotate([90,0,0]) Bolt8Hole();
		translate([BoltCL_x/2,0,-BoltCL_z]) rotate([90,0,0]) Bolt8Hole();

	} // diff
	
} // BBSideMount

//BBSideMount();

module Mema17Bolts(H=10){
	BC_d=44;
	
	// Bolts
	for (j=[0:3]) rotate([0,90*j+45,0])
		translate([BC_d/2,H,0]) rotate([-90,0,0]) children();
} // Mema17Bolts

module Nema17Face(H=1){
	W1=42.5;
	W2=34;
	H1_d=22;
	
	
	difference(){
		hull(){
			translate([-W1/2,0,-W2/2]) cube([W1,H,W2]);
			translate([-W2/2,0,-W1/2]) cube([W2,H,W1]);
		} // hull
		
		// center hole
		translate([0,-Overlap,0]) rotate([-90,0,0]) cylinder(d=H1_d+IDXtra,h=H+Overlap*2);
	} // diff
} // Nema17Face

//translate([0,FaceToFace_y,0]) rotate([0,0,180]) Nema17Face(H=10);

module MountB10ToNema17(){
	BBSideMount(H=12);
	
	translate([0,FaceToFace_y,0]) rotate([0,0,180]) 
	difference(){
		union(){
			Nema17Face(H=10);
			
			hull(){
				translate([0,9,0]) Nema17Face(H=1);
				translate([0,FaceToFace_y-12]) translate([-BoltCL_x/2-Wall_t,0,-BoltCL_z-Wall_t]) cube([Wall_t*2,0.1,BoltCL_z+Wall_t*2]);
			} //hull
			hull(){
				translate([0,9,0]) Nema17Face(H=1);
				translate([0,FaceToFace_y-12]) translate([BoltCL_x/2-Wall_t,0,-BoltCL_z-Wall_t]) cube([Wall_t*2,0.1,BoltCL_z+Wall_t*2]);
			} //hull
		} // union
		
		Mema17Bolts() Bolt4ButtonHeadHole(depth=12, lHead=120);
		
		translate([0,5,0]) rotate([-90,0,0]) cylinder(d=BoltCL_x-Wall_t*2,h=60);
		
		hull(){
			translate([0,25,-30]) cylinder(d=30,h=60);
			translate([0,FaceToFace_y-12,-30]) cylinder(d=BoltCL_x-Wall_t*2,h=60);
		} // hull
	} // diff
	
} // MountB10ToNema17

//rotate([-90,0,0]) MountB10ToNema17();


































