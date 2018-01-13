// *************************************************
// Compound Helical Planetary Drive Unit Library
// David M. Flynn
// Filename: CompoundHelicalPlanetary.scad
// Created: 1/1/2018
// Rev: 1.1.2 1/10/2018
// Units: millimeters
// *************************************************
// History:
echo("Compound Helical Planetary Library 1.1.2");
// 1.1.2 1/10/2018 added 
// 1.1.1 1/9/2018 use Spline_Hole_d
// 1.1.0 1/1/2018 Made harringbone an option.
// 1.0.1 12/29/2017 Adjusted Gap, added Key=true to splines, split pinion.
// 1.0.0 12/27/2017 Copied from Compound Panetary Drive
// 1.0.0 6/16/2017 Copied from PlanetDrive.scad Rev 1.1.0
// *************************************************
// *** for Viewing ***
//ShowAllCompoundDrivePartsHelix(GearWidth=GearWidth);

//PlanetaryPitchA=280;
//PlanetaryPitchB=308;
//300:290.3225 = 45:45 = -44.9999:1, 15t 15t 14t, nPlanets=5
//300:275 = 54:57 = -85.5:1, 12t 21t,Pinion_a=0,nPlanets=3
//300:330 = 54:51 = 76.5:1, 12t 21t,Pinion_a=0,nPlanets=3
//280:308 = 54:51 = 76.5:1, 12t 21t,Pinion_a=0,nPlanets=3
//260:283.636 = 60:57 = 95.0014:1. 12t,24t,Pinion_a=360/Pinion_t/2,nPlanets=3

Spline_Gap=0.22; // 0.22 loose fit, 0.20 snug fit, 0.15 press fit
PlanetaryPitchA=300;
PlanetaryPitchB=290.3225;
BackLash=0.3;
//Pinion_t=12;
Pinion_t=15;
Pinion_a=0;
PlanetA_t=15;
PlanetB_t=14;
PlanetStack=2; // number of gears 2 or 3
nPlanets=5;
Pressure_a=22.5;
GearWidth=12;
//twist=200;
twist=0;

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

// *** for STL output ***
//CompoundDrivePinionHelix(Pitch=PlanetaryPitchA, PitchB=PlanetaryPitchB,nTeeth=Pinion_t,Thickness=GearWidth,bEndScrew=0, HB=false);
//CompoundIdlePinionHelix(Pitch=PlanetaryPitchA, PitchB=PlanetaryPitchB,nTeeth=Pinion_t,Thickness=GearWidth, HB=false);

//CompoundPlanetGearHelixA(Pitch=PlanetaryPitchA,nTeethA=PlanetA_t, PitchB=PlanetaryPitchB, nTeethB=PlanetB_t, Thickness=GearWidth, Offset_a=0, HB=false);
//CompoundPlanetGearHelixA(Pitch=PlanetaryPitchA,nTeethA=PlanetA_t, PitchB=PlanetaryPitchB, nTeethB=PlanetB_t, Thickness=GearWidth, Offset_a=PlanetB_a,HB=false);
//CompoundPlanetGearHelixA(Pitch=PlanetaryPitchA,nTeethA=PlanetA_t, PitchB=PlanetaryPitchB, nTeethB=PlanetB_t, Thickness=GearWidth, Offset_a=-PlanetB_a,HB=false);

//CompoundPlanetGearHelixB(Pitch=PlanetaryPitchA,nTeethA=PlanetA_t, PitchB=PlanetaryPitchB, nTeethB=PlanetB_t, Thickness=GearWidth, Offset_a=0, HB=false);
//CompoundPlanetGearHelixB(Pitch=PlanetaryPitchA,nTeethA=PlanetA_t, PitchB=PlanetaryPitchB, nTeethB=PlanetB_t, Thickness=GearWidth, Offset_a=PlanetB_a, HB=false);
//CompoundPlanetGearHelixB(Pitch=PlanetaryPitchA,nTeethA=PlanetA_t, PitchB=PlanetaryPitchB, nTeethB=PlanetB_t, Thickness=GearWidth, Offset_a=-PlanetB_a, HB=false);

//CompoundPlanetGearHelixC(Pitch=PlanetaryPitchA,nTeethA=PlanetA_t, PitchB=PlanetaryPitchB, nTeethB=PlanetB_t, Thickness=GearWidth, Offset_a=0, HB=false);
//CompoundPlanetGearHelixC(Pitch=PlanetaryPitchA,nTeethA=PlanetA_t, PitchB=PlanetaryPitchB, nTeethB=PlanetB_t, Thickness=GearWidth, Offset_a=PlanetB_a, HB=true);
//CompoundPlanetGearHelixC(Pitch=PlanetaryPitchA,nTeethA=PlanetA_t, PitchB=PlanetaryPitchB, nTeethB=PlanetB_t, Thickness=GearWidth, Offset_a=-PlanetB_a, HB=true);

//CompoundRingGearHelix(Pitch=PlanetaryPitchB, nTeeth=OutputRing_t, Thickness=GearWidth, twist=twist, HB=false);
// Input ring (stationary)
//CompoundRingGearHelix(Pitch=PlanetaryPitchA, nTeeth=InputRing_t, Thickness=GearWidth, twist=-twist, HB=false);
// Idle ring (free, alignment only, optional)
//CompoundRingGearHelix(Pitch=PlanetaryPitchA, nTeeth=InputRing_t, Thickness=GearWidth, twist=twist, HB=false);

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

include<CommonStuffSAE.scad> // This lib is in inches.

include<SplineLib.scad>
// SplineShaft(d=20,l=30,nSplines=Spline_nSplines,Spline_w=30,Hole=Spline_Hole_d,Key=false);
// SplineHole(d=20,l=20,nSplines=Spline_nSplines,Spline_w=30,Gap=IDXtra,Key=false);

// must be after last include so it doesn't get over ridden
$fn=90;
Overlap=0.05;
IDXtra=0.2;
$t=0.00;

module ShowAllCompoundDrivePartsHelix(GearWidth=GearWidth){
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
	
	
	rotate([0,0,PinionRA+Pinion_a])
		CompoundDrivePinionHelix(Pitch=PitchA, nTeeth=Pinion_t, Thickness=GearWidth, bEndScrew=0, HB=false);
	//translate([0,0,GearWidth*2+Overlap])
	//	CompoundIdlePinionHelix(Pitch=PitchA, PitchB=PitchB, nTeeth=Pinion_t, Thickness=GearWidth);
	
	for (j=[0:nPlanets-1])
	rotate([0,0,PlanetPosRA+360/nPlanets*j])translate([Planet_BC/2,0,0])rotate([0,0,PlanetRA]){
	//	CompoundPlanetGearHelixA(Pitch=PitchA,nTeethA=PlanetA_t, PitchB=PitchB, nTeethB=PlanetB_t, Thickness=GearWidth, Offset_a=PlanetB_a*j, HB=false);
		
		translate([0,0,GearWidth])
		CompoundPlanetGearHelixB(Pitch=PitchA,nTeethA=PlanetA_t, PitchB=PitchB, nTeethB=PlanetB_t, Thickness=GearWidth, Offset_a=PlanetB_a*j, HB=false);
		
		//translate([0,0,GearWidth*2])
		//CompoundPlanetGearHelixC(Pitch=PitchA,nTeethA=PlanetA_t, PitchB=PitchB, nTeethB=PlanetB_t, Thickness=GearWidth, Offset_a=PlanetB_a*j, HB=false);
	}
	
	// Top
	//translate([0,0,GearWidth*2]) rotate([0,0,360/InputRing_t/2])
	//	CompoundRingGearHelix(Pitch=PitchA, nTeeth=InputRing_t, Thickness=GearWidth, twist=twist, HB=false);
	
	// middle gear
	translate([0,0,GearWidth]) rotate([0,0,360/InputRing_t/2+OutputRingRA]) 
		CompoundRingGearHelix(Pitch=PitchB, nTeeth=OutputRing_t, Thickness=GearWidth, twist=twist, HB=false);

	//rotate([0,0,360/InputRing_t/2]) CompoundRingGearHelix(Pitch=PitchA, nTeeth=InputRing_t, Thickness=GearWidth, twist=-twist, HB=false);

} // ShowAllCompoundDrivePartsHelix

//ShowAllCompoundDrivePartsHelix(GearWidth=GearWidth);

module ShowAllCompoundDrivePartsWheel(GearWidth=GearWidth){
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
	
	
	translate([0,0,GearWidth])rotate([0,0,PinionRA+Pinion_a])
		CompoundDrivePinionHelix(Pitch=PitchA, nTeeth=Pinion_t, Thickness=GearWidth, bEndScrew=0, HB=false);
	
	for (j=[0:nPlanets-1])
	rotate([0,0,PlanetPosRA+360/nPlanets*j])translate([Planet_BC/2,0,0])rotate([0,0,PlanetRA]){
	
	
		CompoundPlanetGearHelixA(Pitch=PitchA,nTeethA=PlanetA_t, PitchB=PitchB, nTeethB=PlanetB_t, Thickness=GearWidth, Offset_a=PlanetB_a*j, HB=false, Spline_d=15, nSplines=5);
		
		translate([0,0,GearWidth])
		CompoundPlanetGearHelixB(Pitch=PitchA,nTeethA=PlanetA_t, PitchB=PitchB, nTeethB=PlanetB_t, Thickness=GearWidth, Offset_a=PlanetB_a*j, HB=false, Spline_d=15, nSplines=5);
		
		
	}
	
	
	// middle gear
	translate([0,0,GearWidth]) rotate([0,0,360/InputRing_t/2+OutputRingRA]) 
		CompoundRingGearHelix(Pitch=PitchB, nTeeth=OutputRing_t, Thickness=GearWidth, twist=twist, HB=false);

	rotate([0,0,360/InputRing_t/2]) CompoundRingGearHelix(Pitch=PitchA, nTeeth=InputRing_t, Thickness=GearWidth, twist=-twist, HB=false);

} // ShowAllCompoundDrivePartsWheel

//ShowAllCompoundDrivePartsWheel(GearWidth=GearWidth);

module CompoundRingGearHelix(Pitch=200, nTeeth=54, Thickness=GearWidth, twist=twist, HB=false){
	
	RingTeeth=nTeeth;
	
	echo(RingTeeth=RingTeeth);
	
	if (HB==true)
		translate([0,0,Thickness/2]){
		ring_gear(number_of_teeth=nTeeth,
			circular_pitch=Pitch, diametral_pitch=false,
			pressure_angle=Pressure_a,
			clearance = 0.4,
			gear_thickness=Thickness/2,
			rim_thickness=Thickness/2,
			rim_width=3.5,
			backlash=BackLash,
			twist=twist/nTeeth,
			involute_facets=0, // 1 = triangle, default is 5
			flat=false);
		mirror([0,0,1])
		ring_gear(number_of_teeth=nTeeth,
			circular_pitch=Pitch, diametral_pitch=false,
			pressure_angle=Pressure_a,
			clearance = 0.4,
			gear_thickness=Thickness/2,
			rim_thickness=Thickness/2,
			rim_width=3.5,
			backlash=BackLash,
			twist=twist/nTeeth,
			involute_facets=0, // 1 = triangle, default is 5
			flat=false);}
		else
			ring_gear(number_of_teeth=nTeeth,
			circular_pitch=Pitch, diametral_pitch=false,
			pressure_angle=Pressure_a,
			clearance = 0.4,
			gear_thickness=Thickness,
			rim_thickness=Thickness,
			rim_width=3.5,
			backlash=BackLash,
			twist=twist/nTeeth*2,
			involute_facets=0, // 1 = triangle, default is 5
			flat=false);
} // CompoundRingGearHelix

//CompoundRingGearHelix(Pitch=PlanetaryPitchA, nTeeth=InputRing_t, Thickness=GearWidth, twist=-twist, HB=false);

module CompoundDrivePinionHelix(Pitch=PlanetaryPitchA, PitchB=PlanetaryPitchB, nTeeth=13,Thickness=GearWidth, bEndScrew=0, HB=false, Hub_t=8,Hub_d=15){
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
	
	if (HB==true)
		translate([0,0,Thickness/2])
		difference(){
			if (bEndScrew==1 || PlanetStack==2){
			gear (number_of_teeth=nTeeth,
					circular_pitch=Pitch, diametral_pitch=false,
					pressure_angle=Pressure_a,
					clearance = 0.4,
					gear_thickness=Thickness/2,
					rim_thickness=Thickness/2,
					rim_width=5,
					hub_thickness=Thickness/2+Hub_t,
					hub_diameter=Hub_d,
					bore_diameter=Shaft_d,
					circles=0,
					backlash=BackLash,
					twist=twist/nTeeth,
					involute_facets=0,
					flat=false);
				mirror([0,0,1])
				gear (number_of_teeth=nTeeth,
					circular_pitch=Pitch, diametral_pitch=false,
					pressure_angle=Pressure_a,
					clearance = 0.4,
					gear_thickness=Thickness/2,
					rim_thickness=Thickness/2,
					rim_width=5,
					hub_thickness=Thickness/2,
					hub_diameter=Hub_d,
					bore_diameter=Shaft_d,
					circles=0,
					backlash=BackLash,
					twist=twist/nTeeth,
					involute_facets=0,
					flat=false);
			} else {
			gear (number_of_teeth=nTeeth,
					circular_pitch=Pitch, diametral_pitch=false,
					pressure_angle=Pressure_a,
					clearance = 0.4,
					gear_thickness=Thickness/2,
					rim_thickness=Thickness/2,
					rim_width=5,
					hub_thickness=Thickness/2,
					hub_diameter=Hub_d,
					bore_diameter=Shaft_d,
					circles=0,
					backlash=BackLash,
					twist=twist/nTeeth,
					involute_facets=0,
					flat=false);
				
				mirror([0,0,1])
				gear (number_of_teeth=nTeeth,
					circular_pitch=Pitch, diametral_pitch=false,
					pressure_angle=Pressure_a,
					clearance = 0.4,
					gear_thickness=Thickness/2,
					rim_thickness=Thickness/2,
					rim_width=5,
					hub_thickness=Thickness/2,
					hub_diameter=Hub_d,
					bore_diameter=Shaft_d,
					circles=0,
					backlash=BackLash,
					twist=twist/nTeeth,
					involute_facets=0,
					flat=false);					
			}
			
			if (bEndScrew==1 || PlanetStack==2)
			// Set screw
			translate([0,-Shaft_d*3/2,Thickness+4]) rotate([90,0,0]) scale(25.4)# Bolt8Hole();			
		} // diff
	else
		difference(){
			if (bEndScrew==1 || PlanetStack==2){
				rotate([180,0,0])
			gear (number_of_teeth=nTeeth,
					circular_pitch=Pitch, diametral_pitch=false,
					pressure_angle=Pressure_a,
					clearance = 0.4,
					gear_thickness=Thickness,
					rim_thickness=Thickness,
					rim_width=5,
					hub_thickness=Thickness+Hub_t,
					hub_diameter=Hub_d,
					bore_diameter=Shaft_d,
					circles=0,
					backlash=BackLash,
					twist=twist/nTeeth*2,
					involute_facets=0,
					flat=false);
				
			} else {
			gear (number_of_teeth=nTeeth,
					circular_pitch=Pitch, diametral_pitch=false,
					pressure_angle=Pressure_a,
					clearance = 0.4,
					gear_thickness=Thickness,
					rim_thickness=Thickness,
					rim_width=5,
					hub_thickness=Thickness,
					hub_diameter=Hub_d,
					bore_diameter=Shaft_d,
					circles=0,
					backlash=BackLash,
					twist=twist/nTeeth*2,
					involute_facets=0,
					flat=false);				
			}
			
			if (bEndScrew==1 || PlanetStack==2)
			// Set screw
			if (Hub_t>0)
			translate([0,0,-Thickness-Hub_t/2]) rotate([90,0,0]) scale(25.4) Bolt8Hole();
			
			
		} // diff

	if (PlanetStack>2)
	//center shaft
	translate([0,0,Thickness-Overlap])
	difference(){
		cylinder(r=root_radius-(Max_radiusB-Max_radius),h=Thickness+Overlap*2);
		
		// center hole
		translate([0,0,-Overlap])cylinder(d=Shaft_d+IDXtra,h=Thickness*2+Overlap*2);
		
		if (bEndScrew==0)
		// Set screw
		translate([0,0,3]) rotate([90,0,0]) scale(25.4) Bolt8Hole();
	} // diff
	
	if (PlanetStack>2)
	translate([0,0,Thickness*2])
		SplineShaft(d=10,l=Thickness,nSplines=3,Spline_w=30,Hole=0,Key=true);
	
} // CompoundDrivePinionHelix

//CompoundDrivePinionHelix(Pitch=PlanetaryPitchA, PitchB=PlanetaryPitchB,nTeeth=Pinion_t,Thickness=GearWidth,bEndScrew=0, HB=false);

module CompoundIdlePinionHelix(Pitch=PlanetaryPitchA, PitchB=PlanetaryPitchB, nTeeth=13,Thickness=GearWidth, HB=false){
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
	
	difference(){
		if (HB==true)
		translate([0,0,Thickness/2]){
			gear (number_of_teeth=nTeeth,
						circular_pitch=Pitch, diametral_pitch=false,
						pressure_angle=Pressure_a,
						clearance = 0.4,
						gear_thickness=Thickness/2,
						rim_thickness=Thickness/2,
						rim_width=5,
						hub_thickness=Thickness/2,
						hub_diameter=0,
						bore_diameter=Shaft_d,
						circles=0,
						backlash=BackLash,
						twist=twist/nTeeth,
						involute_facets=0,
						flat=false);
				mirror([0,0,1])
				gear (number_of_teeth=nTeeth,
						circular_pitch=Pitch, diametral_pitch=false,
						pressure_angle=Pressure_a,
						clearance = 0.4,
						gear_thickness=Thickness/2,
						rim_thickness=Thickness/2,
						rim_width=5,
						hub_thickness=Thickness/2,
						hub_diameter=0,
						bore_diameter=Shaft_d,
						circles=0,
						backlash=BackLash,
						twist=twist/nTeeth,
						involute_facets=0,
						flat=false);
				} // translate
		else
			gear (number_of_teeth=nTeeth,
						circular_pitch=Pitch, diametral_pitch=false,
						pressure_angle=Pressure_a,
						clearance = 0.4,
						gear_thickness=Thickness,
						rim_thickness=Thickness,
						rim_width=5,
						hub_thickness=Thickness,
						hub_diameter=0,
						bore_diameter=Shaft_d,
						circles=0,
						backlash=BackLash,
						twist=-twist/nTeeth*2,
						involute_facets=0,
						flat=false);
		
		translate([0,0,-Overlap])
			SplineHole(d=10,l=Thickness+Overlap*2,nSplines=3,Spline_w=30,Gap=0.2,Key=true);
	} // diff
	
} // CompoundDrivePinionHelix

//translate([0,0,GearWidth*2+Overlap])CompoundIdlePinionHelix(Pitch=PlanetaryPitchA, PitchB=PlanetaryPitchB,nTeeth=Pinion_t,Thickness=GearWidth,HB=false);

module CompoundPlanetGearHelixA(PitchA=PlanetaryPitchA, nTeethA=PlanetA_t,
						PitchB=PlanetaryPitchB, nTeethB=PlanetB_t, Thickness=GearWidth, Offset_a=0, HB=false,Spline_d=20,nSplines=6){
	
	
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
		if (HB==true)
		union()translate([0,0,Thickness/2]){
		gear (number_of_teeth=nTeethA,
			circular_pitch=PitchA, diametral_pitch=false,
			pressure_angle=Pressure_a,
			clearance = 0.2,
			gear_thickness=Thickness/2,
			rim_thickness=Thickness/2,
			rim_width=0,
			hub_thickness=Thickness/2,
			hub_diameter=0,
			bore_diameter=10+IDXtra*2,
			circles=0,
			backlash=BackLash,
			twist=-twist/nTeethA,
			involute_facets=0,
			flat=false);
			
		mirror([0,0,1])
		gear (number_of_teeth=nTeethA,
			circular_pitch=PitchA, diametral_pitch=false,
			pressure_angle=Pressure_a,
			clearance = 0.2,
			gear_thickness=Thickness/2,
			rim_thickness=Thickness/2,
			rim_width=0,
			hub_thickness=Thickness/2,
			hub_diameter=0,
			bore_diameter=10+IDXtra*2,
			circles=0,
			backlash=BackLash,
			twist=-twist/nTeethA,
			involute_facets=0,
			flat=false);
		} // union
		
		else
			gear (number_of_teeth=nTeethA,
				circular_pitch=PitchA, diametral_pitch=false,
				pressure_angle=Pressure_a,
				clearance = 0.2,
				gear_thickness=Thickness,
				rim_thickness=Thickness,
				rim_width=0,
				hub_thickness=Thickness,
				hub_diameter=0,
				bore_diameter=10+IDXtra*2,
				circles=0,
				backlash=BackLash,
				twist=-twist/nTeethA*2,
				involute_facets=0,
				flat=false);
		
		// Index mark
		translate([root_radiusA-2,0,-Overlap]) cylinder(r=1,h=1);		
	} // diff
	
		
			
	SplineShaft(d=Spline_d,l=Thickness*PlanetStack,nSplines=nSplines,Spline_w=30,Hole=Spline_Hole_d,Key=true);
	
} // CompoundPlanetGearHelixA

//CompoundPlanetGearHelixA(Pitch=PlanetaryPitchA,nTeethA=PlanetA_t, PitchB=PlanetaryPitchB, nTeethB=PlanetB_t, Thickness=GearWidth, Offset_a=PlanetB_a, HB=false,Spline_d=15,nSplines=5);


module CompoundPlanetGearHelixB(PitchA=PlanetaryPitchA, nTeethA=PlanetA_t,
						PitchB=PlanetaryPitchB, nTeethB=PlanetB_t, Thickness=GearWidth, Offset_a=0, HB=false,Spline_d=20,nSplines=6){
	
	
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

	
			
	//middle gear
	rotate([0,0,Offset_a])
	 difference(){
		 if (HB==true)
		 translate([0,0,Thickness/2]) 
		 union(){
		gear (number_of_teeth=nTeethB,
			circular_pitch=PitchB, diametral_pitch=false,
			pressure_angle=Pressure_a,
			clearance = 0.2,
			gear_thickness=Thickness/2,
			rim_thickness=Thickness/2,
			rim_width=0,
			hub_thickness=Thickness/2,
			hub_diameter=0,
			bore_diameter=10+IDXtra*2,
			circles=0,
			backlash=BackLash,
			twist=twist/nTeethB,
			involute_facets=0,
			flat=false);
			
		mirror([0,0,1])
		gear (number_of_teeth=nTeethB,
			circular_pitch=PitchB, diametral_pitch=false,
			pressure_angle=Pressure_a,
			clearance = 0.2,
			gear_thickness=Thickness/2,
			rim_thickness=Thickness/2,
			rim_width=0,
			hub_thickness=Thickness/2,
			hub_diameter=0,
			bore_diameter=10+IDXtra*2,
			circles=0,
			backlash=BackLash,
			twist=twist/nTeethB,
			involute_facets=0,
			flat=false);
		} // union
		
		else
		gear (number_of_teeth=nTeethB,
			circular_pitch=PitchB, diametral_pitch=false,
			pressure_angle=Pressure_a,
			clearance = 0.2,
			gear_thickness=Thickness,
			rim_thickness=Thickness,
			rim_width=0,
			hub_thickness=Thickness,
			hub_diameter=0,
			bore_diameter=10+IDXtra*2,
			circles=0,
			backlash=BackLash,
			twist=twist/nTeethB*2,
			involute_facets=0,
			flat=false);
		
		translate([0,0,-Overlap])
		SplineHole(d=Spline_d,l=Thickness+Overlap*2,nSplines=nSplines,Spline_w=30,Gap=Spline_Gap,Key=true);
	} // diff
	
} // CompoundPlanetGearHelixB

//CompoundPlanetGearHelixB(Pitch=PlanetaryPitchA,nTeethA=PlanetA_t, PitchB=PlanetaryPitchB, nTeethB=PlanetB_t, Thickness=GearWidth, Offset_a=PlanetB_a, HB=false, Spline_d=15, nSplines=5);

module CompoundPlanetGearHelixC(PitchA=PlanetaryPitchA, nTeethA=PlanetA_t,
						PitchB=PlanetaryPitchB, nTeethB=PlanetB_t, Thickness=GearWidth, Offset_a=0, HB=false){
	
	
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

	difference(){
		
		if (HB==true)
		translate([0,0,Thickness/2]) {
			gear (number_of_teeth=nTeethA,
				circular_pitch=PitchA, diametral_pitch=false,
				pressure_angle=Pressure_a,
				clearance = 0.2,
				gear_thickness=Thickness/2,
				rim_thickness=Thickness/2,
				rim_width=0,
				hub_thickness=Thickness/2,
				hub_diameter=0,
				bore_diameter=10+IDXtra*2,
				circles=0,
				backlash=BackLash,
				twist=-twist/nTeethA,
				involute_facets=0,
				flat=false);
			
			mirror([0,0,1])
			gear (number_of_teeth=nTeethA,
				circular_pitch=PitchA, diametral_pitch=false,
				pressure_angle=Pressure_a,
				clearance = 0.2,
				gear_thickness=Thickness/2,
				rim_thickness=Thickness/2,
				rim_width=0,
				hub_thickness=Thickness/2,
				hub_diameter=0,
				bore_diameter=10+IDXtra*2,
				circles=0,
				backlash=BackLash,
				twist=-twist/nTeethA,
				involute_facets=0,
				flat=false);}
		else
			gear (number_of_teeth=nTeethA,
				circular_pitch=PitchA, diametral_pitch=false,
				pressure_angle=Pressure_a,
				clearance = 0.2,
				gear_thickness=Thickness,
				rim_thickness=Thickness,
				rim_width=0,
				hub_thickness=Thickness,
				hub_diameter=0,
				bore_diameter=10+IDXtra*2,
				circles=0,
				backlash=BackLash,
				twist=twist/nTeethA*2,
				involute_facets=0,
				flat=false);
		
			translate([0,0,-Overlap])
		SplineHole(d=20,l=Thickness+Overlap*2,nSplines=6,Spline_w=30,Gap=0.22,Key=true);
	} // diff
		
	
} // CompoundPlanetGearHelixC

//CompoundPlanetGearHelixC(Pitch=PlanetaryPitchA,nTeethA=PlanetA_t, PitchB=PlanetaryPitchB, nTeethB=PlanetB_t, Thickness=GearWidth, Offset_a=PlanetB_a, HB=false);



















