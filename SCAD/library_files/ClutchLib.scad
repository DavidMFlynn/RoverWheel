// ***********************************************
// Clutch Library
// Filename:ClutchLib.scad
// By: David M. Flynn
// Licence: GPLv3
// Created: 4/13/2019
// Revision: 1.0.2 4/14/2019
// Units: mm
// **********************************************
// History:
//  1.0.2 4/14/2019 Fixes.
//  1.0.1 4/13/2019 Added InnerHolderBoltCircle.
//  1.0.0 4/13/2019 First code.
// **********************************************
// Notes:
//
//  This clutch was designed to be used on a desk lamp style arm joint.
//
//  Shoulder bolts (6 Req.) 5/32" Dia x 1/2" w/ #6-32 thread
//  Springs (6 Req.) 5/32" I.D. x 3/8" Compression spring
//  An air cylinder or other accuator mounts to the InnerHolder
//   and pushes on the TensionPlate to release the clutch.
//  The 2 things this clutch connects mount to:
//   the outside of the OuterHolder,
//   and the back of the InnerHolder.
//
// **********************************************
//   ***** for STL output *****
//
//  TensionPlate();
//  OuterHolder();
//  rotate([180,0,0]) InnerHolder();
//  InnerPlate();
//  OuterPlate();
//
// **********************************************
//  ***** for Viewing *****
//
//  ShowClutchExpanded();
//
// **********************************************
//  ***** the modules *****
//
// OuterPlate(D=Clutch_OD,L=Plate_t,nSplines=nOuterSplines,ID=Clutch_ID+1);
// InnerPlate(D=Clutch_OD-5,ID=Clutch_ID,L=Plate_t,nSplines=nInnerSpines);
// InnerHolder(D=Clutch_ID,OD=Clutch_OD+6,Width=ClutchThickness,nSplines=nInnerSpines);
// InnerHolder(D=Clutch_ID,OD=Clutch_OD-5,Width=ClutchThickness,nSplines=nInnerSpines); // Floats the OuterHolder
// TensionPlate(D=Clutch_OD-5, ID=Clutch_ID);
// OuterHolder(D=Clutch_OD,Width=ClutchThickness,nSplines=nOuterSplines,ID=Clutch_ID+1,EndPlate=true);
// OuterHolder(D=Clutch_OD,Width=ClutchThickness,nSplines=nOuterSplines,ID=Clutch_ID+1,EndPlate=false); // Floating OuterHolder
// 
// InnerHolderBoltCircle(D=Clutch_ID) children();
// **********************************************

include<SplineLib.scad>
include<CommonStuffSAEmm.scad>

echo("ClutchLib Rev 1.0.2");

Overlap=0.05;
//$fn=24; // makes renering faster
$fn=90; // standard value, bigger is better
IDXtra=0.2;

// Clutch parameters, override these values
Clutch_OD=60; // O.D. of the spline housing is 6mm more
Clutch_ID=40; // I.D. of inner plate splines
nInnerSpines=12;
nOuterSplines=20;
Plate_t=1.2; // The thickness of 4 3D-printed layers.
nPlates=4; // 2 is minimum, more plates equals more grip for the spring force.
ClutchThickness=nPlates*Plate_t; // combined thickness of all plates
ShoulderBolt_d=5/32*25.4+IDXtra; // holds the TensionPlate on
Spring_d=0.24*25.4+IDXtra; // pocket for springs

module ShowClutchAssy(){
	//translate([0,0,1.7]) color("Tan") TensionPlate();
	
	translate([0,0,2.1]) rotate([180,0,0]) color("LightBlue") OuterHolder(EndPlate=false);
	
	
	//translate([0,0,-ClutchThickness+(Plate_t+Overlap)*4]) color("Gray") OuterPlate();
	//translate([0,0,-ClutchThickness+(Plate_t+Overlap)*3]) color("Orange") InnerPlate();
	//translate([0,0,-ClutchThickness+(Plate_t+Overlap)*2]) color("Gray") OuterPlate();
	//translate([0,0,-ClutchThickness+(Plate_t+Overlap)]) color("Orange") InnerPlate();
	
	//translate([0,0,-ClutchThickness]) color("Gray") OuterPlate();
	
	
	translate([0,0,1.5]) rotate([180,0,0]) color("Silver")
		//InnerHolder(D=Clutch_ID,OD=Clutch_OD+6,Width=ClutchThickness,nSplines=nInnerSpines);
		InnerHolder(D=Clutch_ID,OD=Clutch_OD-5,Width=ClutchThickness,nSplines=nInnerSpines);
} // ShowClutchAssy

//ShowClutchAssy();

module ShowClutchExpanded(){
	
	translate([10,0,0]) color("Tan") TensionPlate();
	
	translate([-10,0,60]) rotate([180,0,0]) color("LightBlue") OuterHolder();
	
	translate([10,0,36]) color("Orange") InnerPlate();
	
	translate([-10,0,26]) color("Gray") OuterPlate();
	
	translate([10,0,16]) color("Orange") InnerPlate();
	
	translate([-10,0,6]) color("Gray") OuterPlate();
	
	translate([10,0,0]) rotate([180,0,0]) color("Silver") InnerHolder();
	
} // ShowClutchExpanded

//ShowClutchExpanded();

module OuterPlate(D=Clutch_OD,L=Plate_t,nSplines=nOuterSplines,ID=Clutch_ID+1){
	SplineShaft(d=D,l=L,nSplines=nSplines,Spline_w=180/nSplines,Hole=ID,Key=false);
} // OuterPlate

//translate([0,0,1.4]) OuterPlate();

module InnerPlate(D=Clutch_OD-5,ID=Clutch_ID,L=Plate_t,nSplines=nInnerSpines){
	difference(){
		cylinder(d=D,h=L);
		
		translate([0,0,-Overlap])
			SplineHole(d=ID,l=L+Overlap*2,nSplines=nSplines,Spline_w=180/nSplines,Gap=IDXtra,Key=false);
	} // diff
} // InnerPlate

//translate([0,0,Overlap]) InnerPlate();

module InnerHolderBoltCircle(D=Clutch_ID){
	nBolts=6;
	
	for (j=[0:nBolts-1]) rotate([0,0,360/nBolts*j]) translate([D/2-6,0,0]) children();
} // InnerHolderBoltCircle

//InnerHolderBoltCircle();

module InnerHolder(D=Clutch_ID,OD=Clutch_OD+6,Width=ClutchThickness,nSplines=nInnerSpines){
	
	
	difference(){
		union(){
			SplineShaft(d=D,l=Width+1.5+Overlap,nSplines=nSplines,Spline_w=180/nSplines,Hole=0,Key=false);
			translate([0,0,Width+1.5]) cylinder(d=OD,h=3);
		} // union
		
		
		InnerHolderBoltCircle(D=D)	rotate([180,0,0]) Bolt6Hole(depth=Width+4.5);
		
		translate([0,0,-Overlap]) cylinder(d=6,h=Width+4.5+Overlap*2);
	} // diff	
} // InnerHolder

//translate([0,0,-1.5]) InnerHolder();

module TensionPlate(D=Clutch_OD-5, ID=Clutch_ID){
	
	difference(){
		union(){
			cylinder(d=D,h=3+Overlap);
			translate([0,0,3]) cylinder(d1=D,d2=ID,h=3);
		} // union
		
		translate([0,0,-Overlap]) InnerHolderBoltCircle(D=ID)
		{
			cylinder(d=ShoulderBolt_d,h=7);
			translate([0,0,3]) cylinder(d=Spring_d,h=7);
		}
		
	} // diff
} // TensionPlate

//translate([0,0,-0.2]) rotate([180,0,0]) TensionPlate();


module OuterHolder(D=Clutch_OD,Width=ClutchThickness,nSplines=nOuterSplines,ID=Clutch_ID+1, EndPlate=true){
	EndPlateOffset = EndPlate==true ? 2 : -Overlap;
	
	difference(){
		cylinder(d=D+6,h=Width+2);
		
		translate([0,0,EndPlateOffset]) 
			SplineHole(d=D,l=Width+3,nSplines=nSplines,Spline_w=180/nSplines,Gap=IDXtra,Key=false);
		
		// inner hole
		translate([0,0,-Overlap]) cylinder(d=ID+IDXtra,h=Width+2+Overlap);
	} // diff
} // OuterHolder

//translate([0,0,-2-Overlap]) OuterHolder();






























