// *************************************************
// Compound Helical Planetary Drive Unit Library
// David M. Flynn
// Filename: CompoundHelicalPlanetary.scad
// Created: 1/1/2018
// Rev: 1.2.0 6/9/2018
// Units: millimeters
// *************************************************
// Notes:
//  SunGear_t/nPlanets MUST be an integer.
//  InputRing_t/nPlanets MUST be an integer.
//
// *************************************************
// History:
echo("Compound Helical Planetary Library 1.2.0");
// 1.2.0 6/9/2018 Did some cleanup.
// 1.1.9 4/17/2018 Added RimWidth as a parameter
// 1.1.8 4/15/2018 Math notes.
// 1.1.7 4/12/2018 Spling dia. fix.
// 1.1.6 2/26/2018 Recalculated ratios
// 1.1.5 2/10/2018 Added 188:1 variant and Spline_a to planet B.
// 1.1.4 2/2/2018 Went metric on bolts lib.
// 1.1.3 1/23/2018 fixed ratio calculator
// 1.1.2 1/10/2018 added notes
// 1.1.1 1/9/2018 use Spline_Hole_d
// 1.1.0 1/1/2018 Made harringbone an option.
// 1.0.1 12/29/2017 Adjusted Gap, added Key=true to splines, split pinion.
// 1.0.0 12/27/2017 Copied from Compound Panetary Drive
// 1.0.0 6/16/2017 Copied from PlanetDrive.scad Rev 1.1.0
// *************************************************
// *** for Viewing ***
//ShowCHPData(); // show the numbers
//ShowAllCompoundDrivePartsHelix(ShowB=true,GearWidth=GearWidth);

//PlanetaryPitchA=280;
//PlanetaryPitchB=308;
//280:308 = 54:51 = 93.5:1, 12t 21t 21t,Pinion_a=0,nPlanets=3
/*
PlanetaryPitchA=280;
PlanetaryPitchB=308;
SunGear_t=12;
PlanetA_t=21;
PlanetB_t=21;
nPlanets=3;
/**/
//260:283.636 = 60:57 = 114:1. 12t,24t,24t,Pinion_a=360/SunGear_t/2,nPlanets=3
/*
PlanetaryPitchA=260;
PlanetaryPitchB=283.636;
SunGear_t=12;
PlanetA_t=24;
PlanetB_t=24;
nPlanets=3;
/**/
//300:290.3225 = 45:47 = 188:1, 15t 15t 16t, nPlanets=5
/*
PlanetaryPitchA=300;
PlanetaryPitchB=290.3225;
SunGear_t=15;
PlanetA_t=15;
PlanetB_t=16;
nPlanets=5;
/**/
//260:251.0344 = 42:44 = 176:1, 14t 14t 15t, nPlanets=5
/*
PlanetaryPitchA=260;
PlanetaryPitchB=251.0344;
kSpline_d=14;
SunGear_t=14;
PlanetA_t=14;
PlanetB_t=15;
PlanetB_a=0;
nPlanets=2;
/**/
//260:260 = 36:37 = 74:1, 12t 12t 13t, nPlanets=5
/*
PlanetaryPitchA=280;
PlanetaryPitchB=280;
kSpline_d=14;
SunGear_t=12;
PlanetA_t=12;
PlanetB_t=13;
PlanetB_a=0;
nPlanets=3;
/**/
//300:290.3225 = 45:45 = -60:1, 15t 15t 14t, nPlanets=5
/*
PlanetaryPitchA=300;
PlanetaryPitchB=290.3225;
SunGear_t=15;
PlanetA_t=15;
PlanetB_t=14;
nPlanets=5;
/**/

//44:48 = 21:1, 16t 14t 18t, nPlanets=4
/*
PlanetaryPitchA=300;
PlanetaryPitchB=300;
SunGear_t=16;
PlanetA_t=14;
PlanetB_t=18;
nPlanets=4;
kSpline_d=15;
/**/

//300:330 = 54:51 = 53.9:1, 12t 21t 21t,Pinion_a=0,nPlanets=3
/*
PlanetaryPitchA=280;
PlanetaryPitchB=330;
SunGear_t=12;
PlanetA_t=21;
PlanetB_t=21;
nPlanets=3;
/**/
//300:275 = 54:57 = -104.5:1, 12t 21t 21t,Pinion_a=0,nPlanets=3
/*
PlanetaryPitchA=300;
PlanetaryPitchB=275;
SunGear_t=12;
PlanetA_t=21;
PlanetB_t=21;
nPlanets=3;
/**/



Spline_Gap=0.22; // 0.22 loose fit, 0.20 snug fit, 0.15 press fit

knSplines=3;
BackLash=0.3;
//SunGear_t=12;
Pinion_a=0;
PlanetStack=2; // number of gears 2 or 3
Pressure_a=22.5;
GearWidth=12;
//twist=200;
twist=0;

// 54 PlanetA_t*2 + SunGear_t
function InputRing_t() = PlanetA_t*2 + SunGear_t; 
function OutputRing_t() = floor((PlanetA_t*PlanetaryPitchA/180 + PlanetB_t*PlanetaryPitchB/180 + SunGear_t*PlanetaryPitchA/180)*180/PlanetaryPitchB);

Shaft_d=5;
//PlanetB_a=0;

module ShowCHPData(){
	
// PlanetA_t*2 + SunGear_t - (PlanetA_t - PlanetB_t*2) 53
OutputRing_tc=(PlanetA_t*PlanetaryPitchA/180 + PlanetB_t*PlanetaryPitchB/180 + SunGear_t*PlanetaryPitchA/180)*180/PlanetaryPitchB;

echo(InputRing_t=InputRing_t());
echo(OutputRing_tc=OutputRing_tc);
echo(OutputRing_t=OutputRing_t());

Sun_Pd=SunGear_t*PlanetaryPitchA/180;
echo(Sun_Pd=Sun_Pd);
PlanetA_Pd=PlanetA_t*PlanetaryPitchA/180;
echo(PlanetA_Pd=PlanetA_Pd);
RingA_Pd=InputRing_t()*PlanetaryPitchA/180;
echo(RingA_Pd=RingA_Pd);
PlanetB_Pd=PlanetB_t*PlanetaryPitchB/180;
echo(PlanetB_Pd=PlanetB_Pd);
RingB_Pd=OutputRing_t()*PlanetaryPitchB/180;
echo(RingB_Pd=RingB_Pd);


// from wikapedia
Ns=SunGear_t;
Npa=PlanetA_t;
Npb=PlanetB_t;
Nra=InputRing_t();
Nrb=OutputRing_t();
Ws=1000;
Wra=0;
Wc= (Ns*Ws + Nra*Wra)/(Ns + Nra);
//echo(Wc=Wc);
Wpa= (Ns*Ws - (Nra - Npa) * Wc) / Npa;
Wpb = Wpa; // common shaft
Wrb= (Npb*Wpb - (Nrb - Npb) * Wc) / Nrb;
Ratio= Ws/Wrb;
	
echo(Ratio=Ratio);
	
}
//ShowCHPData();
// *** Routines ***

// *** for STL output ***
//CompoundDrivePinionHelix(Pitch=PlanetaryPitchA, PitchB=PlanetaryPitchB,nTeeth=SunGear_t,Thickness=GearWidth,bEndScrew=0, HB=false);
//CompoundIdlePinionHelix(Pitch=PlanetaryPitchA, PitchB=PlanetaryPitchB,nTeeth=SunGear_t,Thickness=GearWidth, HB=false);

//CompoundPlanetGearHelixA(Pitch=PlanetaryPitchA,nTeethA=PlanetA_t, PitchB=PlanetaryPitchB, nTeethB=PlanetB_t, Thickness=GearWidth, Offset_a=0, HB=false);
//CompoundPlanetGearHelixA(Pitch=PlanetaryPitchA,nTeethA=PlanetA_t, PitchB=PlanetaryPitchB, nTeethB=PlanetB_t, Thickness=GearWidth, Offset_a=PlanetB_a,HB=false);
//CompoundPlanetGearHelixA(Pitch=PlanetaryPitchA,nTeethA=PlanetA_t, PitchB=PlanetaryPitchB, nTeethB=PlanetB_t, Thickness=GearWidth, Offset_a=-PlanetB_a,HB=false);

//CompoundPlanetGearHelixB(Pitch=PlanetaryPitchA,nTeethA=PlanetA_t, PitchB=PlanetaryPitchB, nTeethB=PlanetB_t, Thickness=GearWidth, Offset_a=0, HB=false,Spline_a=0);
//CompoundPlanetGearHelixB(Pitch=PlanetaryPitchA,nTeethA=PlanetA_t, PitchB=PlanetaryPitchB, nTeethB=PlanetB_t, Thickness=GearWidth, Offset_a=PlanetB_a, HB=false,Spline_a=0);
//CompoundPlanetGearHelixB(Pitch=PlanetaryPitchA,nTeethA=PlanetA_t, PitchB=PlanetaryPitchB, nTeethB=PlanetB_t, Thickness=GearWidth, Offset_a=-PlanetB_a, HB=false,Spline_a=0);

//CompoundPlanetGearHelixC(Pitch=PlanetaryPitchA,nTeethA=PlanetA_t, PitchB=PlanetaryPitchB, nTeethB=PlanetB_t, Thickness=GearWidth, Offset_a=0, HB=false);
//CompoundPlanetGearHelixC(Pitch=PlanetaryPitchA,nTeethA=PlanetA_t, PitchB=PlanetaryPitchB, nTeethB=PlanetB_t, Thickness=GearWidth, Offset_a=PlanetB_a, HB=true);
//CompoundPlanetGearHelixC(Pitch=PlanetaryPitchA,nTeethA=PlanetA_t, PitchB=PlanetaryPitchB, nTeethB=PlanetB_t, Thickness=GearWidth, Offset_a=-PlanetB_a, HB=true);

//CompoundRingGearHelix(Pitch=PlanetaryPitchB, nTeeth=OutputRing_t(), Thickness=GearWidth, twist=twist, HB=false, RimWidth=3.5);
// Input ring (stationary)
//CompoundRingGearHelix(Pitch=PlanetaryPitchA, nTeeth=InputRing_t(), Thickness=GearWidth, twist=-twist, HB=false, RimWidth=3.5);
// Idle ring (free, alignment only, optional)
//CompoundRingGearHelix(Pitch=PlanetaryPitchA, nTeeth=InputRing_t(), Thickness=GearWidth, twist=twist, HB=false, RimWidth=3.5);

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

include<CommonStuffSAEmm.scad> // This lib is in inches.

include<SplineLib.scad>
// SplineShaft(d=20,l=30,nSplines=Spline_nSplines,Spline_w=30,Hole=Spline_Hole_d,Key=false);
// SplineHole(d=20,l=20,nSplines=Spline_nSplines,Spline_w=30,Gap=IDXtra,Key=false);

// must be after last include so it doesn't get over ridden
$fn=90;
Overlap=0.05;
IDXtra=0.2;
$t=0.00;



module ShowAllCompoundDrivePartsHelix(ShowB=false,GearWidth=GearWidth){
	PitchA=PlanetaryPitchA;
	PitchB=PlanetaryPitchB;
	Planet_BC=SunGear_t*PitchA/180 + PlanetA_t*PitchA/180;
	//Ratio=OutputRing_t()*PitchB/180/((InputRing_t()*PitchA/180  / (PlanetA_t*PitchA/180) * (PlanetB_t*PitchB/180)-OutputRing_t()*PitchB/180))*(InputRing_t()/SunGear_t);
	//echo(Ratio=Ratio);
	PinionRA=$t*Ratio*360;// 76.5r
	PlanetPosRA=PinionRA/((InputRing_t()/SunGear_t)+(InputRing_t()/SunGear_t));//  29.7r /(InputRing_t()/SunGear_t); // 2.57 4.5
	PlanetRA=-PlanetPosRA-PlanetPosRA*((InputRing_t()/PlanetA_t));
	OutputRingRA=-360*$t;
	
	//PlanetA_t=21;
	//PlanetB_t=20;
	//InputRing_t()=54; // PlanetA_t*2 + SunGear_t
	//OutputRing_t=53; // PlanetA_t*2 + SunGear_t - (PlanetA_t - PlanetB_t*2)
	//SunGear_t=12;
	//PlanetB_a=0;
	PlanetB_a=2*360/PlanetB_t/nPlanets; //*((360/nPlanets)/(360/OutputRing_t()));
	
	//PlanetB_a=4.9; // OutputRing_t = 8.1818°/tooth, 72°/planet, PlanetB_t = 24°/tooth
	echo(PlanetB_a=PlanetB_a);
	PlanetA_a=0;
	//echo(PlanetA_a=PlanetA_a);
	Pinion_a= ((PlanetA_t/2)!=floor(PlanetA_t/2)) ?  0 : (180/SunGear_t);
	//Pinion_a=0;
	echo(Pinion_a=Pinion_a);
	
	// sun gear
	translate([0,0,GearWidth])rotate([0,0,PinionRA+Pinion_a])
		CompoundDrivePinionHelix(Pitch=PitchA, nTeeth=SunGear_t, Thickness=GearWidth, bEndScrew=0, HB=false);
	//translate([0,0,GearWidth*2+Overlap])
	//	CompoundIdlePinionHelix(Pitch=PitchA, PitchB=PitchB, nTeeth=SunGear_t, Thickness=GearWidth);
	
	for (j=[0:nPlanets-1])
	  rotate([0,0,PlanetPosRA+360/nPlanets*j]) translate([Planet_BC/2,0,0]) {
		
		CompoundPlanetGearHelixA(Pitch=PitchA,nTeethA=PlanetA_t, PitchB=PitchB, nTeethB=PlanetB_t, Thickness=GearWidth, HB=false);
		
		if (ShowB==true){
			RotB=180/OutputRing_t()*(OutputRing_t()/nPlanets*j);
			translate([0,0,GearWidth]) //rotate([0,0,360/nPlanets*j])
				CompoundPlanetGearHelixB(PitchA=PitchA, nTeethA=PlanetA_t,
								PitchB=PitchB, nTeethB=PlanetB_t, 
								Thickness=GearWidth, Offset_a=0,
								HB=false,Spline_d=kSpline_d,
								nSplines=knSplines,Spline_a=0);
		 }
		//translate([0,0,GearWidth*2])
		//CompoundPlanetGearHelixC(Pitch=PitchA,nTeethA=PlanetA_t, PitchB=PitchB, nTeethB=PlanetB_t, Thickness=GearWidth, Offset_a=PlanetB_a*j, HB=false);
	  }
	
	// Ring Gear C
	//translate([0,0,GearWidth*2]) rotate([0,0,180/InputRing_t()])
	//	CompoundRingGearHelix(Pitch=PitchA, nTeeth=InputRing_t(), Thickness=GearWidth, twist=twist, HB=false);
	
	// Ring Gear B
	if (ShowB==true)
	translate([0,0,GearWidth]) rotate([0,0,180/OutputRing_t()+OutputRingRA]) 
		CompoundRingGearHelix(Pitch=PitchB, nTeeth=OutputRing_t(), Thickness=GearWidth, twist=twist, HB=false);

	// Ring Gear A
	rotate([0,0,180/InputRing_t()]) CompoundRingGearHelix(Pitch=PitchA, nTeeth=InputRing_t(), Thickness=GearWidth, twist=-twist, HB=false);

} // ShowAllCompoundDrivePartsHelix

//ShowAllCompoundDrivePartsHelix(GearWidth=GearWidth);

module ShowAllCompoundDrivePartsWheel(GearWidth=GearWidth){
	PitchA=PlanetaryPitchA;
	PitchB=PlanetaryPitchB;
	Planet_BC=SunGear_t*PitchA/180 + PlanetA_t*PitchA/180;
	Ratio=OutputRing_t()*PitchB/180/((InputRing_t()*PitchA/180  / (PlanetA_t*PitchA/180) * (PlanetB_t*PitchB/180)-OutputRing_t()*PitchB/180))*(InputRing_t()/SunGear_t);
	echo(Ratio=Ratio);
	PinionRA=$t*Ratio*360;// 76.5r
	PlanetPosRA=PinionRA/((InputRing_t()/SunGear_t)+(InputRing_t()/SunGear_t));//  29.7r /(InputRing_t()/SunGear_t); // 2.57 4.5
	PlanetRA=-PlanetPosRA-PlanetPosRA*((InputRing_t()/PlanetA_t));
	OutputRingRA=-360*$t;
	
	//PlanetA_t=21;
	//PlanetB_t=20;
	//InputRing_t()=54; // PlanetA_t*2 + SunGear_t
	//OutputRing_t=53; // PlanetA_t*2 + SunGear_t - (PlanetA_t - PlanetB_t*2)
	//SunGear_t=12;
	//PlanetB_a=12;
	
	
	translate([0,0,GearWidth])rotate([0,0,PinionRA+Pinion_a])
		CompoundDrivePinionHelix(Pitch=PitchA, nTeeth=SunGear_t, Thickness=GearWidth, bEndScrew=0, HB=false);
	
	for (j=[0:nPlanets-1])
	rotate([0,0,PlanetPosRA+360/nPlanets*j])translate([Planet_BC/2,0,0])rotate([0,0,PlanetRA]){
	
	
		CompoundPlanetGearHelixA(Pitch=PitchA,nTeethA=PlanetA_t, PitchB=PitchB, nTeethB=PlanetB_t, Thickness=GearWidth, Offset_a=PlanetB_a*j, HB=false, Spline_d=15, nSplines=5);
		
		translate([0,0,GearWidth])
		CompoundPlanetGearHelixB(Pitch=PitchA,nTeethA=PlanetA_t, PitchB=PitchB, nTeethB=PlanetB_t, Thickness=GearWidth, Offset_a=PlanetB_a*j, HB=false, Spline_d=15, nSplines=5);
		
		
	}
	
	
	// middle gear
	translate([0,0,GearWidth]) rotate([0,0,360/InputRing_t()/2+OutputRingRA]) 
		CompoundRingGearHelix(Pitch=PitchB, nTeeth=OutputRing_t(), Thickness=GearWidth, twist=twist, HB=false);

	rotate([0,0,360/InputRing_t()/2]) CompoundRingGearHelix(Pitch=PitchA, nTeeth=InputRing_t(), Thickness=GearWidth, twist=-twist, HB=false);

} // ShowAllCompoundDrivePartsWheel

//ShowAllCompoundDrivePartsWheel(GearWidth=GearWidth);

module CompoundRingGearHelix(Pitch=200, nTeeth=54, Thickness=GearWidth, twist=twist, HB=false, RimWidth=3.5){
	
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
			rim_width=RimWidth,
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
			rim_width=RimWidth,
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
			rim_width=RimWidth,
			backlash=BackLash,
			twist=twist/nTeeth*2,
			involute_facets=0, // 1 = triangle, default is 5
			flat=false);
} // CompoundRingGearHelix

//CompoundRingGearHelix(Pitch=PlanetaryPitchA, nTeeth=InputRing_t(), Thickness=GearWidth, twist=-twist, HB=false);

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
			translate([0,-Shaft_d*3/2,Thickness+4]) rotate([90,0,0]) Bolt8Hole();			
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
			translate([0,0,-Thickness-Hub_t/2]) rotate([90,0,0]) Bolt8Hole();
			
			
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
		translate([0,0,3]) rotate([90,0,0]) Bolt8Hole();
	} // diff
	
	if (PlanetStack>2)
	translate([0,0,Thickness*2])
		SplineShaft(d=10,l=Thickness,nSplines=3,Spline_w=30,Hole=0,Key=true);
	
} // CompoundDrivePinionHelix

//CompoundDrivePinionHelix(Pitch=PlanetaryPitchA, PitchB=PlanetaryPitchB,nTeeth=SunGear_t,Thickness=GearWidth,bEndScrew=0, HB=false);

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

//translate([0,0,GearWidth*2+Overlap])CompoundIdlePinionHelix(Pitch=PlanetaryPitchA, PitchB=PlanetaryPitchB,nTeeth=SunGear_t,Thickness=GearWidth,HB=false);

module CompoundPlanetGearHelixA(PitchA=PlanetaryPitchA, nTeethA=PlanetA_t,
						PitchB=PlanetaryPitchB, nTeethB=PlanetB_t, Thickness=GearWidth, HB=false,Spline_d=kSpline_d,nSplines=knSplines){
	
	
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
			bore_diameter=Spline_Hole_d,
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
			bore_diameter=Spline_Hole_d,
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
				bore_diameter=Spline_Hole_d,
				circles=0,
				backlash=BackLash,
				twist=-twist/nTeethA*2,
				involute_facets=0,
				flat=false);
		
		// Index mark
		translate([root_radiusA-2,0,-Overlap]) cylinder(r=1,h=1);		
	} // diff
	
		
			
	translate([0,0,Thickness-Overlap])SplineShaft(d=Spline_d,l=Thickness*(PlanetStack-1)+Overlap,nSplines=nSplines,Spline_w=30,Hole=Spline_Hole_d,Key=true);
	
} // CompoundPlanetGearHelixA

//CompoundPlanetGearHelixA(Pitch=PlanetaryPitchA,nTeethA=PlanetA_t, PitchB=PlanetaryPitchB, nTeethB=PlanetB_t, Thickness=GearWidth, Offset_a=PlanetB_a, HB=false,Spline_d=15,nSplines=5);


module CompoundPlanetGearHelixB(PitchA=PlanetaryPitchA, nTeethA=PlanetA_t,
						PitchB=PlanetaryPitchB, nTeethB=PlanetB_t, Thickness=GearWidth, Offset_a=0, HB=false,Spline_d=kSpline_d,nSplines=knSplines,Spline_a=0){
	
	
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
		
		translate([0,0,-Overlap]) rotate([0,0,Spline_a])
		SplineHole(d=Spline_d,l=Thickness+Overlap*2,nSplines=nSplines,Spline_w=30,Gap=Spline_Gap,Key=true);
	} // diff
	
} // CompoundPlanetGearHelixB

//CompoundPlanetGearHelixB(Pitch=PlanetaryPitchA,nTeethA=PlanetA_t, PitchB=PlanetaryPitchB, nTeethB=PlanetB_t, Thickness=GearWidth, Offset_a=PlanetB_a, HB=false, Spline_d=15, nSplines=5);

module CompoundPlanetGearHelixC(PitchA=PlanetaryPitchA, nTeethA=PlanetA_t,
						PitchB=PlanetaryPitchB, nTeethB=PlanetB_t, Thickness=GearWidth, Offset_a=0, HB=false,Spline_d=kSpline_d,nSplines=knSplines,Spline_a=0){
	
	
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
		SplineHole(d=Spline_d,l=Thickness+Overlap*2,nSplines=nSplines,Spline_w=30,Gap=0.22,Key=true);
	} // diff
		
	
} // CompoundPlanetGearHelixC

//CompoundPlanetGearHelixC(Pitch=PlanetaryPitchA,nTeethA=PlanetA_t, PitchB=PlanetaryPitchB, nTeethB=PlanetB_t, Thickness=GearWidth, Offset_a=PlanetB_a, HB=false);




















