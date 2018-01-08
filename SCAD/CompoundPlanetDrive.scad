// *************************************************
// Compound Planetary Drive Unit Library
// David M. Flynn
// Filename: CompoundPlanetDrive.scad
// Created: 6/16/2017
// Rev: 1.0.0 6/16/2017
// Units: millimeters
// *************************************************
// History:
// 1.0.0 6/16/2017 Copied from PlanetDrive.scad Rev 1.1.0
// *************************************************
// *** for Viewing ***
//ShowAllPlanetDriveParts(Pitch=300, nTeeth=21,nTeethPinion=12, Stages=3,GearWidth=10);
//ShowAllCompoundDriveParts(GearWidth=GearWidth);

PlanetaryPitchA=280;
PlanetaryPitchB=308;
//300:275 = 54:57 = -85.5:1, 12t 21t,Pinion_a=0,nPlanets=3
//300:330 = 54:51 = 76.5:1, 12t 21t,Pinion_a=0,nPlanets=3
//280:308 = 54:51 = 76.5:1, 12t 21t,Pinion_a=0,nPlanets=3
//260:283.636 = 60:57 = 95.0014:1. 12t,24t,Pinion_a=360/Pinion_t/2,nPlanets=3

BackLash=0.3;
Pinion_t=12;
Pinion_a=0;
PlanetA_t=21;
PlanetB_t=21;
nPlanets=3;
// 54 PlanetA_t*2 + Pinion_t
InputRing_t=PlanetA_t*2 + Pinion_t; 
// PlanetA_t*2 + Pinion_t - (PlanetA_t - PlanetB_t*2) 53
OutputRing_t=(PlanetA_t*PlanetaryPitchA/180 + PlanetB_t*PlanetaryPitchB/180 + Pinion_t*PlanetaryPitchA/180)*180/PlanetaryPitchB; 
Shaft_d=5;
PlanetB_a=0;

echo(InputRing_t=InputRing_t);
echo(OutputRing_t=OutputRing_t);
Ratio=OutputRing_t*PlanetaryPitchB/180/((InputRing_t*PlanetaryPitchA/180  / (PlanetA_t*PlanetaryPitchA/180) * (PlanetB_t*PlanetaryPitchB/180)-OutputRing_t*PlanetaryPitchB/180))*(InputRing_t/Pinion_t);
	echo(Ratio=Ratio);
	
// *** Routines ***
// DrivePlateBolts(Pitch=PlanetaryPitchA,nTeeth=PlanetA_t, nTeethPinion=Pinion_t) "child";

// *** for STL output ***
//	CompoundDrivePinion(Pitch=PlanetaryPitchA,PitchB=PlanetaryPitchB, nTeeth=Pinion_t, Thickness=GearWidth);
//  CompoundPlanetGear(PitchA=PlanetaryPitchA,nTeethA=PlanetA_t,PitchB=PlanetaryPitchB, nTeethB=PlanetB_t, Thickness=GearWidth, Offset_a=0);
//  CompoundPlanetGear(PitchA=PlanetaryPitchA,nTeethA=PlanetA_t,PitchB=PlanetaryPitchB, nTeethB=PlanetB_t, Thickness=GearWidth, Offset_a=PlanetB_a);
//  CompoundPlanetGear(PitchA=PlanetaryPitchA,nTeethA=PlanetA_t,PitchB=PlanetaryPitchB, nTeethB=PlanetB_t, Thickness=GearWidth, Offset_a=-PlanetB_a);

//	CompoundRingGear(Pitch=PlanetaryPitchA, nTeeth=InputRing_t, Thickness=GearWidth+1);
//	CompoundRingGear(Pitch=PlanetaryPitchB, nTeeth=OutputRing_t, Thickness=GearWidth+1);

//  CompoundPlanetPlate(Pitch=PlanetaryPitchA,nTeethA=PlanetA_t,nTeethP=Pinion_t,Thickness=GearWidth,IsPinionSide=0);
//  CompoundPlanetPlate(Pitch=PlanetaryPitchA,nTeethA=PlanetA_t,nTeethP=Pinion_t,Thickness=GearWidth,IsPinionSide=1);

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


Pressure_a=24;
GearWidth=8;
DrivePlateXtra_d=12;
TaperLen=5;
MidGearXtra=TaperLen*2;

include<CommonStuffSAE.scad>

$fn=90;
Overlap=0.05;
IDXtra=0.2;
$t=0.00;

module ShowAllCompoundDriveParts(GearWidth=GearWidth){
	PitchA=PlanetaryPitchA;
	PitchB=PlanetaryPitchB;
	Planet_BC=Pinion_t*PitchA/180 + PlanetA_t*PitchA/180;
	Ratio=OutputRing_t*PitchB/180/((InputRing_t*PitchA/180  / (PlanetA_t*PitchA/180) * (PlanetB_t*PitchB/180)-OutputRing_t*PitchB/180))*(InputRing_t/Pinion_t);
	echo(Ratio=Ratio);
	PinionRA=$t*Ratio*360;// 76.5r
	PlanetPosRA=PinionRA/((InputRing_t/Pinion_t)+(InputRing_t/Pinion_t));//  29.7r /(InputRing_t/Pinion_t); // 2.57 4.5
	PlanetRA=-PlanetPosRA-PlanetPosRA*((InputRing_t/PlanetA_t));
	OutputRingRA=-360*$t;
	
	//PlanetA_t=21;
	//PlanetB_t=20;
	//InputRing_t=54; // PlanetA_t*2 + Pinion_t
	//OutputRing_t=53; // PlanetA_t*2 + Pinion_t - (PlanetA_t - PlanetB_t*2)
	//Pinion_t=12;
	//PlanetB_a=12;
	
	
	rotate([0,0,PinionRA+Pinion_a])CompoundDrivePinion(Pitch=PitchA, nTeeth=Pinion_t, Thickness=GearWidth);
	
	for (j=[0:nPlanets-1])
	rotate([0,0,PlanetPosRA+360/nPlanets*j])translate([Planet_BC/2,0,0])rotate([0,0,PlanetRA])
		CompoundPlanetGear(Pitch=PitchA,nTeethA=PlanetA_t, PitchB=PitchB, nTeethB=PlanetB_t, Thickness=GearWidth, Offset_a=PlanetB_a*j);
	
	/*
	rotate([0,0,120+PlanetPosRA]) translate([Planet_BC/2,0,0]) rotate([0,0,360/PlanetA_t*7+PlanetRA])
		CompoundPlanetGear(Pitch=PitchA,nTeethA=PlanetA_t, PitchB=PitchB, nTeethB=PlanetB_t, Thickness=GearWidth, Offset_a=PlanetB_a);
	
	rotate([0,0,-120+PlanetPosRA]) translate([Planet_BC/2,0,0]) rotate([0,0,360/PlanetA_t*-7+PlanetRA])
		CompoundPlanetGear(Pitch=PitchA,nTeethA=PlanetA_t, PitchB=PitchB, nTeethB=PlanetB_t, Thickness=GearWidth, Offset_a=-PlanetB_a);
		*/
	
	translate([0,0,GearWidth*2+TaperLen*2+MidGearXtra]) rotate([0,0,360/InputRing_t/2]) CompoundRingGear(Pitch=PitchA, nTeeth=InputRing_t, Thickness=GearWidth+1);
	
	// middle gear
	translate([0,0,GearWidth+TaperLen+MidGearXtra/2]) rotate([0,0,360/InputRing_t/2+OutputRingRA]) 
		CompoundRingGear(Pitch=PitchB, nTeeth=OutputRing_t, Thickness=GearWidth+1);

	//translate([0,0,-1]) rotate([0,0,360/InputRing_t/2]) CompoundRingGear(Pitch=PitchA, nTeeth=InputRing_t, Thickness=GearWidth+1);
/*	

	translate([0,0,-4])CompoundPlanetPlate(Pitch=PlanetaryPitch,nTeethA=PlanetA_t,nTeethP=Pinion_t,Thickness=GearWidth,IsPinionSide=1);
	
	translate([0,0,GearWidth*2+4.1]) rotate([180,0,0])CompoundPlanetPlate(Pitch=PlanetaryPitch,nTeethA=PlanetA_t,nTeethP=Pinion_t,Thickness=GearWidth,IsPinionSide=0);
	*/
} // ShowAllCompoundDriveParts

//ShowAllCompoundDriveParts();

module ShowAllPlanetDriveParts(Pitch=200, nTeeth=15, nTeethPinion=15, Stages=2, GearWidth=10){
	pitch_diameter  =  (nTeeth * Pitch / 180) * 2 + nTeethPinion * Pitch / 180;
	RingTeeth=pitch_diameter * 180 / Pitch;
	Ratio=pow(RingTeeth/nTeethPinion,Stages);
	echo(Ratio=Ratio);
	
	translate([0,0,1]) rotate([0,0,$t*360])DrivePinion(Pitch=Pitch, nTeeth=nTeethPinion,Thickness=GearWidth);
	
	//translate([0,0,(Stages-1)*(-GearWidth-5-0.5)]) rotate([0,0,360/(RingTeeth)/2]) 
		//RingGear(Pitch=Pitch, nTeeth=nTeeth,nTeethPinion=nTeethPinion, Thickness=(Stages-1)*(GearWidth+5+0.5)+GearWidth+1);
	
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

//ShowAllPlanetDriveParts(Pitch=300, nTeeth=12);

module BearingPost(Thickness=GearWidth){
	difference(){
		cylinder(d=10,h=Thickness);
		translate([0,0,Thickness]) scale(25.4) Bolt6HeadHole();
	} // diff
}// BearingPost

module CompoundRingGear(Pitch=200, nTeeth=54, Thickness=GearWidth+1){
	
	RingTeeth=nTeeth;
	
	echo(RingTeeth=RingTeeth);
	
	ring_gear(number_of_teeth=nTeeth,
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
} // CompoundRingGear

//CompoundRingGear(Pitch=PlanetaryPitch, nTeeth=OutputRing_t, Thickness=GearWidth+1);

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

module CompoundDrivePinion(Pitch=PlanetaryPitchA, PitchB=PlanetaryPitchB, nTeeth=13,Thickness=GearWidth,bEndScrew=0){
	// Pitch diameter: Diameter of pitch circle.
	pitch_diameter  =  nTeeth * Pitch / 180;
	pitch_radius = pitch_diameter/2;
	
	pitch_diameterB  =  nTeeth * PitchB / 180;
	pitch_radiusB = pitch_diameterB/2;
	
	// Diametrial pitch: Number of teeth per unit length.
	pitch_diametrial = nTeeth / pitch_diameter;
	pitch_diametrialB = nTeeth / pitch_diameterB;
	
	// Root diameter: Diameter of bottom of tooth spaces.
	root_radius = pitch_radius-(1/pitch_diametrial + 0.2);
	Max_radius = pitch_radius+(1/pitch_diametrial + 0.2);
	Max_radiusB = pitch_radiusB+(1/pitch_diametrialB + 0.6);
	
	translate([0,0,Thickness*2+TaperLen+MidGearXtra])
	difference(){
		if (bEndScrew==1)
		gear (number_of_teeth=nTeeth,
				circular_pitch=Pitch, diametral_pitch=false,
				pressure_angle=Pressure_a,
				clearance = 0.4,
				gear_thickness=Thickness+TaperLen,
				rim_thickness=Thickness+TaperLen,
				rim_width=5,
				hub_thickness=Thickness+TaperLen+8,
				hub_diameter=Shaft_d*3,
				bore_diameter=Shaft_d,
				circles=0,
				backlash=BackLash,
				twist=0,
				involute_facets=0,
				flat=false);
		else 
		gear (number_of_teeth=nTeeth,
				circular_pitch=Pitch, diametral_pitch=false,
				pressure_angle=Pressure_a,
				clearance = 0.4,
				gear_thickness=Thickness+TaperLen,
				rim_thickness=Thickness+TaperLen,
				rim_width=5,
				hub_thickness=Thickness+TaperLen,
				hub_diameter=Shaft_d*3,
				bore_diameter=Shaft_d,
				circles=0,
				backlash=BackLash,
				twist=0,
				involute_facets=0,
				flat=false);
		
		if (bEndScrew==1)
		// Set screw
		translate([0,-Shaft_d*3/2,Thickness+TaperLen+4]) rotate([90,0,0]) scale(25.4) Bolt8Hole();
		
		difference(){
				translate([0,0,-Overlap]) cylinder(r=Max_radius+1,TaperLen);
				translate([0,0,-Overlap]) cylinder(r1=root_radius-(Max_radiusB-Max_radius),r2=Max_radius,h=TaperLen+Overlap*2);
			 } // diff
	} // diff
	
	translate([0,0,Thickness+TaperLen-Overlap])
	difference(){
		cylinder(r=root_radius-(Max_radiusB-Max_radius),h=Thickness+MidGearXtra+Overlap*2);
		
		// center hole
		translate([0,0,-Overlap])cylinder(d=Shaft_d+IDXtra,h=Thickness*2+TaperLen*2+MidGearXtra+Overlap*2);
		
		if (bEndScrew==0)
		// Set screw
		translate([0,0,Thickness+MidGearXtra-2]) rotate([90,0,0]) scale(25.4) Bolt8Hole();
	} // diff
	
	
	difference(){
	gear (number_of_teeth=nTeeth,
				circular_pitch=Pitch, diametral_pitch=false,
				pressure_angle=Pressure_a,
				clearance = 0.4,
				gear_thickness=Thickness+TaperLen,
				rim_thickness=Thickness+TaperLen,
				rim_width=5,
				hub_thickness=Thickness+TaperLen,
				hub_diameter=0,
				bore_diameter=Shaft_d,
				circles=0,
				backlash=BackLash,
				twist=0,
				involute_facets=0,
				flat=false);
	difference(){
			translate([0,0,Thickness]) cylinder(r=Max_radius+1,TaperLen+Overlap);
			translate([0,0,Thickness-Overlap]) cylinder(r1=Max_radius,r2=root_radius-(Max_radiusB-Max_radius),h=TaperLen+Overlap*2);
			
		} // diff
	} // diff
	
} // CompoundDrivePinion

//CompoundDrivePinion(Pitch=300,nTeeth=12,Thickness=GearWidth,bEndScrew=0);

module DrivePinion(Pitch=200, nTeeth=13,Thickness=GearWidth){
	
	
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
		translate([0,-Shaft_d*3/2,Thickness+4]) rotate([90,0,0]) scale(25.4) Bolt8Hole();
		
	} // diff
} // DrivePinion

//translate([0,0,1]) DrivePinion();
ShoulderBoltHeadClearance_d=9;

module CompoundPlanetGear(PitchA=PlanetaryPitchA, nTeethA=PlanetA_t,
						PitchB=PlanetaryPitchB, nTeethB=PlanetB_t, Thickness=GearWidth, Offset_a=0){
	
	
	// Pitch diameter: Diameter of pitch circle.
	pitch_diameterA  =  nTeethA * PitchA / 180;
	pitch_radiusA = pitch_diameterA/2;
	pitch_diameterB  =  nTeethB * PitchB / 180;
	pitch_radiusB = pitch_diameterB/2;

	// Diametrial pitch: Number of teeth per unit length.
	pitch_diametrialA = nTeethA / pitch_diameterA;
	pitch_diametrialB = nTeethB / pitch_diameterB;

	// Root diameter: Diameter of bottom of tooth spaces.
	root_radiusA = pitch_radiusA-(1/pitch_diametrialA + 0.2);
	Max_radiusA = pitch_radiusA+(1/pitch_diametrialA + 0.2);
	root_radiusB = pitch_radiusB-(1/pitch_diametrialB + 0.2);
	Max_radiusB = pitch_radiusB+(1/pitch_diametrialB + 0.2);

	// bottom gear
	difference(){
		gear (number_of_teeth=nTeethA,
			circular_pitch=PitchA, diametral_pitch=false,
			pressure_angle=Pressure_a,
			clearance = 0.2,
			gear_thickness=Thickness+TaperLen,
			rim_thickness=Thickness+TaperLen,
			rim_width=0,
			hub_thickness=Thickness+TaperLen,
			hub_diameter=0,
			bore_diameter=10+IDXtra*2,
			circles=0,
			backlash=BackLash,
			twist=0,
			involute_facets=0,
			flat=false);
		
		// Index mark
		translate([root_radiusA-2,0,-Overlap]) cylinder(r=1,h=1);
		
		difference(){
			translate([0,0,Thickness]) cylinder(r=Max_radiusA+1,TaperLen+Overlap);
			translate([0,0,Thickness-Overlap]) cylinder(r1=Max_radiusA,r2=root_radiusB,h=TaperLen+Overlap*2);
			
		} // diff
		
	} // diff
			
			
	translate([0,0,Thickness+TaperLen-Overlap])
	difference(){
		cylinder(r=root_radiusB,h=1+Overlap*2);
		translate([0,0,-Overlap]) cylinder(d=10+IDXtra*2,h=2);
	} // diff
	
	translate([0,0,Thickness*2+TaperLen+MidGearXtra-Overlap])
	difference(){
		cylinder(r=root_radiusB,h=1+Overlap*2);
		translate([0,0,-Overlap]) cylinder(d=10+IDXtra*2,h=2);
	} // diff
	/**/
	//middle gear
	translate([0,0,Thickness+TaperLen]) rotate([0,0,Offset_a])
	 difference(){
		gear (number_of_teeth=nTeethB,
			circular_pitch=PitchB, diametral_pitch=false,
			pressure_angle=Pressure_a,
			clearance = 0.2,
			gear_thickness=Thickness+MidGearXtra,
			rim_thickness=Thickness+MidGearXtra,
			rim_width=0,
			hub_thickness=Thickness+MidGearXtra,
			hub_diameter=0,
			bore_diameter=10+IDXtra*2,
			circles=0,
			backlash=BackLash,
			twist=0,
			involute_facets=0,
			flat=false);
			
		  difference(){
			translate([0,0,-Overlap]) cylinder(r=Max_radiusB+1,TaperLen);
			translate([0,0,-Overlap]) cylinder(r2=Max_radiusB,r1=root_radiusB,h=TaperLen+Overlap*2);
		 } // diff
		 
		 difference(){
			translate([0,0,Thickness+MidGearXtra-TaperLen]) cylinder(r=Max_radiusB+1,TaperLen+Overlap);
			translate([0,0,Thickness+MidGearXtra-TaperLen-Overlap]) cylinder(r1=Max_radiusB,r2=root_radiusB,h=TaperLen+Overlap*2);
		 } // diff
			
		} // diff
	
		//Top gear
		translate([0,0,Thickness*2+MidGearXtra+TaperLen]) 
		 difference(){
			gear (number_of_teeth=nTeethA,
			circular_pitch=PitchA, diametral_pitch=false,
			pressure_angle=Pressure_a,
			clearance = 0.2,
			gear_thickness=Thickness+TaperLen,
			rim_thickness=Thickness+TaperLen,
			rim_width=0,
			hub_thickness=Thickness+TaperLen,
			hub_diameter=0,
			bore_diameter=10+IDXtra*2,
			circles=0,
			backlash=BackLash,
			twist=0,
			involute_facets=0,
			flat=false);
				
			
		
			  difference(){
				translate([0,0,-Overlap]) cylinder(r=Max_radiusA+1,TaperLen);
				translate([0,0,-Overlap]) cylinder(r1=root_radiusB,r2=Max_radiusA,h=TaperLen+Overlap*2);
			 } // diff
			 
			
				
			} // diff
		
	// sholder bolt head
	//color("Red")cylinder(d=7.2,h=8);
} // CompoundPlanetGear

//CompoundPlanetGear(Pitch=300,nTeethA=PlanetA_t, nTeethB=PlanetB_t, Thickness=GearWidth, Offset_a=0);

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

module CompoundPlanetPlate(Pitch=PlanetaryPitch,nTeethA=PlanetA_t,nTeethP=Pinion_t,Thickness=GearWidth,IsPinionSide=0){
	Plate_t=3;
	Plate_d=Pitch*nTeethA/180 + Pitch*nTeethP/180 +DrivePlateXtra_d; // planet gear pitch dia + pinion gear pitch dia + DrivePlateXtra_d
	echo(Plate_d);
	
	Post_h=Plate_t+Thickness+1;

	difference(){
		union(){
			cylinder(d=Plate_d,h=Plate_t);
			DrivePlateBolts(Pitch=Pitch,nTeeth=PlanetA_t, nTeethPinion=nTeethP) cylinder(d=10,h=Post_h);
			if (IsPinionSide==0) cylinder(d=15,h=Post_h);
		}
		
		// platet gear mounting bolts
		if (IsPinionSide==1){
			translate([0,0,-Overlap])cylinder(d=Shaft_d*3+1,h=Plate_t+Overlap*2);
			DrivePlateBolts(Pitch=Pitch,nTeeth=PlanetA_t, nTeethPinion=nTeethP) rotate([180,0,0])scale(25.4) Bolt4HeadHole(lDepth=Post_h/25.4);
		}else{
			translate([0,0,Post_h]) DrivePlateBolts(Pitch=Pitch,nTeeth=PlanetA_t, nTeethPinion=nTeethP) scale(25.4) Bolt4Hole(depth=Post_h/25.4);
			translate([0,0,-Overlap])cylinder(d=Shaft_d+1,h=Post_h+Overlap*2);
		}
	} // diff
	
}// CompoundPlanetPlate

//CompoundPlanetPlate(Pitch=PlanetaryPitch,nTeethA=PlanetA_t,nTeethP=Pinion_t,Thickness=GearWidth,IsPinionSide=0);

module PinionPlate(Pitch=200, nTeeth=15, nTeethPinion=15, Thickness=GearWidth){
	Plate_t=5;
	Plate_d=Pitch*nTeeth/180 + Pitch*nTeethPinion/180 +DrivePlateXtra_d; // planet gear pitch dia + pinion gear pitch dia + DrivePlateXtra_d
	echo(Plate_d);
	

	difference(){
		cylinder(d=Plate_d,h=Plate_t);
		
		// platet gear mounting bolts
		translate([0,0,Plate_t]) DrivePlateBolts(Pitch=Pitch,nTeeth=nTeeth, nTeethPinion=nTeethPinion) scale(25.4) Bolt6Hole();
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

//translate([0,0,0]) rotate([180,0,0]) PinionPlate();
//translate([0,0,-8-5-1]) for(j=[0:2]) rotate([0,0,j*120]) translate([14.64,0,0]) PlanetGear();

module DrivePlateBolts(Pitch=200,nTeeth=13, nTeethPinion=15){
	PlanetPos_r=Pitch*nTeeth/360 + Pitch*nTeethPinion/360;

	for (j=[0:2]) rotate([0,0,j*120]) translate([PlanetPos_r,0,0]) children();
} // DrivePlateBolts

module DrivePlate(Pitch=200,nTeeth=13, nTeethPinion=15){
	Plate_t=5;
	Plate_d=Pitch*nTeeth/180 + Pitch*nTeethPinion/180 +DrivePlateXtra_d; // planet gear pitch dia + pinion gear pitch dia + DrivePlateXtra_d
	
	difference(){
		cylinder(d=Plate_d,h=Plate_t);
		
		translate([0,0,Plate_t]) DrivePlateBolts(Pitch=Pitch,nTeeth=nTeeth, nTeethPinion=nTeethPinion) scale(25.4) Bolt6Hole();
		//for (j=[0:2]) rotate([0,0,j*120]) translate([PlanetPos_r,0,Plate_t]) 
		
		
	} // diff
} // DrivePlate

//translate([0,0,-8-5-1-5]) DrivePlate();




























