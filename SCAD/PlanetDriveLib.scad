// *************************************************
// Planetary Drive Unit Library
// David M. Flynn
// Filename: PlanetDriveLib.scad
// Created: 1/7/2017
// Rev: 1.1.2 6/25/2018
// Units: millimeters
// *************************************************
// History:
echo("PanetaryDriveLib 1.1.2");
// 1.1.2 6/25/2018 Corrected include
// 1.1.1 6/24/2018 Code cleanup. Lib version.
// 1.1.0 6/15/2017 Pinion teeth and parameters. DrivePinion set screw.
// 1.0.1 4/1/2017 Added DrivePlateBolts
// 1.0.0 1/7/2017 first code
// *************************************************
// *** for Viewing ***
//ShowAllPlanetDriveParts(Pitch=300, nTeeth=21,nTeethPinion=12, Stages=3,GearWidth=10);

// *** Routines ***
// DrivePlateBolts(Pitch=200,nTeeth=13, nTeethPinion=15) "child";
// function DrivePlateBC(Pitch=200,nTeeth=13, nTeethPinion=15)

// *** for STL output ***
//	DrivePinion(Pitch=PlanetaryPitch, nTeeth=12, Thickness=GearWidth);
//	RingGear(Pitch=PlanetaryPitch, nTeeth=12, nTeethPinion=15, Thickness=GearWidth*2+5+1);
//	PlanetGear(Pitch=PlanetaryPitch, nTeeth=12, Thickness=GearWidth, SholderBolt=0); // Print 3 per Stage
//  BearingPost(Thickness=GearWidth); // Print 3 per Stage
//	PinionPlate(Pitch=PlanetaryPitch, nTeeth=12, nTeethPinion=15, Thickness=GearWidth);
//	DrivePlate(Pitch=PlanetaryPitch, nTeeth=12, nTeethPinion=15);
// *************************************************
include<ring_gear.scad>
/*
ring_gear(number_of_teeth=60,
	circular_pitch=400, diametral_pitch=false,
	pressure_angle=28,
	clearance = 0.2,
	gear_thickness=5,
	rim_thickness=0,
	rim_width=5,
	backlash=0,
	twist=0,
	involute_facets=0, // 1 = triangle, default is 5
	flat=false);
/**/

include<involute_gears.scad>
/*
gear (
	number_of_teeth=15,
	circular_pitch=false, diametral_pitch=false,
	pressure_angle=28,
	clearance = 0.2,
	gear_thickness=5,
	rim_thickness=8,
	rim_width=5,
	hub_thickness=10,
	hub_diameter=15,
	bore_diameter=5,
	circles=0,
	backlash=0,
	twist=0,
	involute_facets=0,
	flat=false);
/**/



include<CommonStuffSAEmm.scad>

// Override these constants
$fn=90;
Overlap=0.05;
IDXtra=0.2;

PlanetaryPitch=260;
BackLash=0.4;
Pressure_a=24;
GearWidth=8;
DrivePlateXtra_d=12;
ShoulderBoltHeadClearance_d=9;

module ShowAllPlanetDriveParts(Pitch=PlanetaryPitch, nTeeth=15, nTeethPinion=15, Stages=2, GearWidth=10){
	pitch_diameter  =  (nTeeth * Pitch / 180) * 2 + nTeethPinion * Pitch / 180;
	RingTeeth=pitch_diameter * 180 / Pitch;
	Ratio=pow(RingTeeth/nTeethPinion,Stages);
	echo(Ratio=Ratio);
	//+180/nTeethPinion
	translate([0,0,1]) rotate([0,0,$t*360]) DrivePinion(Pitch=Pitch, nTeeth=nTeethPinion,Thickness=GearWidth);
	
	translate([0,0,(Stages-1)*(-GearWidth-5-0.5)]) rotate([0,0,360/(RingTeeth)/2]) 
		RingGear(Pitch=Pitch, nTeeth=nTeeth,nTeethPinion=nTeethPinion, Thickness=(Stages-1)*(GearWidth+5+0.5)+GearWidth+1);
	
	if (Stages>1)
	for (k=[0:Stages-2]) translate([0,0,k*(-GearWidth-5-0.5)]){
		for(j=[0:2]) rotate([0,0,j*120]) translate([Pitch*nTeeth/360+Pitch*nTeethPinion/360,0,0]){
			rotate([0,0,-$t*360*nTeethPinion/nTeeth])PlanetGear(Pitch=Pitch, nTeeth=nTeeth,Thickness=GearWidth);
			BearingPost(Thickness=GearWidth);}
		
		translate([0,0,0]) rotate([180,0,0]) PinionPlate(Pitch=Pitch, nTeeth=nTeeth,nTeethPinion=nTeethPinion,Thickness=GearWidth);
	}
		
	translate([0,0,(Stages-1)*(-GearWidth-5-0.5)]) for(j=[0:2]) rotate([0,0,j*120]) translate([Pitch*nTeeth/360+Pitch*nTeethPinion/360,0,0]){
		PlanetGear(Pitch=Pitch, nTeeth=nTeeth,Thickness=GearWidth);
		BearingPost(Thickness=GearWidth);}

	translate([0,0,(Stages-1)*(-GearWidth-5-0.5)-5]) DrivePlate(Pitch=Pitch, nTeeth=nTeeth, nTeethPinion=nTeethPinion);
} // ShowAllPlanetDriveParts

//ShowAllPlanetDriveParts(Pitch=PlanetaryPitch, nTeeth=15);

module BearingPost(Thickness=GearWidth){
	difference(){
		cylinder(d=10,h=Thickness);
		translate([0,0,Thickness]) Bolt6HeadHole();
	} // diff
}// BearingPost


module RingGear(Pitch=200, nTeeth=15, nTeethPinion=15, Thickness=GearWidth*2+5+1){
	pitch_diameter  =  (nTeeth * Pitch / 180) * 2 + nTeethPinion * Pitch / 180;
	RingTeeth=pitch_diameter * 180 / Pitch;
	
	echo(RingTeeth=RingTeeth);
	
	ring_gear(number_of_teeth=RingTeeth,
		circular_pitch=Pitch, diametral_pitch=false,
		pressure_angle=Pressure_a,
		clearance = 0.4,
		gear_thickness=Thickness,
		rim_thickness=Thickness,
		rim_width=3.5,
		backlash=BackLash,
		twist=0,
		involute_facets=0, // 1 = triangle, default is 5
		flat=false);
} // RingGear

//translate([0,0,-GearWidth-5-1])rotate([0,0,360/45/2]) 
//RingGear(Pitch=290, nTeeth=12);


module DrivePinion(Pitch=200, nTeeth=13,Thickness=GearWidth){
	Shaft_d=5;
	
	difference(){
		
		gear (number_of_teeth=nTeeth,
				circular_pitch=Pitch, diametral_pitch=false,
				pressure_angle=Pressure_a,
				clearance = 0.4,
				gear_thickness=Thickness,
				rim_thickness=Thickness,
				rim_width=5,
				hub_thickness=Thickness+8,
				hub_diameter=Shaft_d*3,
				bore_diameter=Shaft_d,
				circles=0,
				backlash=BackLash,
				twist=0,
				involute_facets=0,
				flat=false);
		// Set screw
		translate([0,-Shaft_d*3/2,Thickness+4]) rotate([90,0,0]) Bolt8Hole();
		
	} // diff
} // DrivePinion

//translate([0,0,1]) DrivePinion();


module PlanetGear(Pitch=300,nTeeth=12,Thickness=GearWidth, SholderBolt=0){
	
	
	// Pitch diameter: Diameter of pitch circle.
	pitch_diameter  =  nTeeth * Pitch / 180;
	pitch_radius = pitch_diameter/2;

	// Diametrial pitch: Number of teeth per unit length.
	pitch_diametrial = nTeeth / pitch_diameter;

	// Root diameter: Diameter of bottom of tooth spaces.
	root_radius = pitch_radius-(1/pitch_diametrial + 0.2);


	if (SholderBolt==1){
	gear (number_of_teeth=nTeeth,
			circular_pitch=Pitch, diametral_pitch=false,
			pressure_angle=Pressure_a,
			clearance = 0.2,
			gear_thickness=5,
			rim_thickness=Thickness,
			rim_width=root_radius-ShoulderBoltHeadClearance_d/2,
			hub_thickness=5,
			hub_diameter=0,
			bore_diameter=4,
			circles=0,
			backlash=BackLash,
			twist=0,
			involute_facets=0,
			flat=false);
	}else{
		gear (number_of_teeth=nTeeth,
			circular_pitch=Pitch, diametral_pitch=false,
			pressure_angle=Pressure_a,
			clearance = 0.2,
			gear_thickness=Thickness,
			rim_thickness=Thickness,
			rim_width=root_radius-ShoulderBoltHeadClearance_d/2,
			hub_thickness=Thickness,
			hub_diameter=0,
			bore_diameter=10+IDXtra*2,
			circles=0,
			backlash=BackLash,
			twist=0,
			involute_facets=0,
			flat=false);
	}
	
	// sholder bolt head
	//color("Red")cylinder(d=7.2,h=8);
} // PlanetGear

//for(j=[0:2]) rotate([0,0,j*120]) translate([14.64,0,0]) PlanetGear();

module PinionPlate(Pitch=200, nTeeth=15, nTeethPinion=15, Thickness=GearWidth){
	Plate_t=5;
	Plate_d=Pitch*nTeeth/180 + Pitch*nTeethPinion/180 +DrivePlateXtra_d; // planet gear pitch dia + pinion gear pitch dia + DrivePlateXtra_d
	echo(Plate_d=Plate_d);
	

	difference(){
		cylinder(d=Plate_d,h=Plate_t);
		
		// platet gear mounting bolts
		translate([0,0,Plate_t]) DrivePlateBolts(Pitch=Pitch,nTeeth=nTeeth, nTeethPinion=nTeethPinion) Bolt6Hole();
	} // diff
	
	translate([0,0,Plate_t-Overlap])
	gear(number_of_teeth=nTeeth,
			circular_pitch=Pitch, diametral_pitch=false,
			pressure_angle=20,
			clearance = 0.2,
			gear_thickness=Thickness,
			rim_thickness=Thickness,
			rim_width=5,
			hub_thickness=Thickness,
			hub_diameter=0,
			bore_diameter=0,
			circles=0,
			backlash=BackLash,
			twist=0,
			involute_facets=0,
			flat=false);
	
}// PinionPlate

//translate([0,0,0]) rotate([180,0,0])PinionPlate();
//translate([0,0,-8-5-1]) for(j=[0:2]) rotate([0,0,j*120]) translate([14.64,0,0]) PlanetGear();

function DrivePlateBC(Pitch=200,nTeeth=13, nTeethPinion=15) = Pitch*nTeeth/180 + Pitch*nTeethPinion/180;

module DrivePlateBolts(Pitch=200,nTeeth=13, nTeethPinion=15){
	PlanetPos_r=DrivePlateBC(Pitch=Pitch,nTeeth=nTeeth, nTeethPinion=nTeethPinion)/2;

	for (j=[0:2]) rotate([0,0,j*120]) translate([PlanetPos_r,0,0]) children();
} // DrivePlateBolts

module DrivePlate(Pitch=200,nTeeth=13, nTeethPinion=15){
	Plate_t=5;
	Plate_d=Pitch*nTeeth/180 + Pitch*nTeethPinion/180 +DrivePlateXtra_d; // planet gear pitch dia + pinion gear pitch dia + DrivePlateXtra_d
	
	difference(){
		cylinder(d=Plate_d,h=Plate_t);
		
		translate([0,0,Plate_t]) DrivePlateBolts(Pitch=Pitch,nTeeth=nTeeth, nTeethPinion=nTeethPinion) Bolt6Hole();
		//for (j=[0:2]) rotate([0,0,j*120]) translate([PlanetPos_r,0,Plate_t]) 
		
		
	} // diff
} // DrivePlate

//translate([0,0,-8-5-1-5]) DrivePlate();




























