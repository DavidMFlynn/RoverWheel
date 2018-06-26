// **************************************************
// The fifth degree of freedom, roll.
// David M. Flynn
// Filename: FifthDoF.scad
// Created: 6/26/2018
// Rev: 1.0d1 6/25/2018
// Units: millimeters
// **************************************************
// History:
// 1.0d1 6/25/2018 First code.
// **************************************************
// Notes:
// **************************************************
// ***** for STL output *****
//OutputTubeBearing();
// OuterRacePart2();
//OutsideRace(BallCircle_d=Tube_BC, Race_OD=SmallRace_d, Ball_d=Ball_d, Race_w=5, nBolts=6, RaceBoltInset=RaceBoltInset, PreLoadAdj=0.00, myFn=360) Bolt4ClearHole();
//rotate([180,0,0])TheRing();
// PlanetGear(Pitch=PlanetaryPitch, nTeeth=nPlanetTeeth, Thickness=GearWidth, SholderBolt=1);
//PinionPlate2();
//SunGear();
// **************************************************
// ***** for Viewing *****
//
// **************************************************

include<SG90ServoLib.scad>
include<involute_gears.scad>
include<TubeConnectorLib.scad>
include<CommonStuffSAEmm.scad>
include<BearingLib.scad>
include<PlanetDriveLib.scad>

$fn=90;
IDXtra=0.2;
Overlap=0.05;

//Ball_d=9.525; // 0.375"
Ball_d=7.9375; // 0.3125"
RaceBoltInset=3.5;
Tube_d=19.05; // 3/4"
Tube_BC=Tube_d+6+Ball_d; // Ball Circle of bearings

PlanetaryPitch=260;
BackLash=0.4;
Pressure_a=24;
GearWidth=8;
DrivePlateXtra_d=10;
ShoulderBoltHeadClearance_d=9;
nPlanetTeeth=12;
nSunTeeth=12;
SmallRace_d=Tube_BC+Ball_d+2+RaceBoltInset*4;

LargeRace_d=63;
InnerRace_l=Ball_d*3+6;
RingGear_h=GearWidth*2+5+1;

echo(Tube_BC=Tube_BC);
echo(SmallRace_d=SmallRace_d);

module CutAway(){
	translate([0,-100,-50]) cube([100,100,100]);
} // CutAway

module ShowFifthDoF(){
	
	//*
	difference(){
		translate([0,0,Ball_d/2+6+Ball_d*2+5+Overlap*2])
			rotate([180,0,22.5])
				color("Brown")OutsideRace(BallCircle_d=Tube_BC, Race_OD=SmallRace_d, Ball_d=Ball_d, 
							Race_w=5, nBolts=8,RaceBoltInset=RaceBoltInset,PreLoadAdj=0.00, myFn=90)
					Bolt4ClearHole();
		CutAway();
	} // diff
	/**/
	
	//*
	difference(){
		color("Tan")OutputTubeBearing();
		CutAway();
	} // diff
	/**/
	
	//*
	difference(){
		translate([0,0,6+Overlap]) color("Silver") OuterRacePart2();
		CutAway();
	} // diff
	/**/
	
	difference(){
		translate([0,0,-RingGear_h])TheRing();
		CutAway();
	} // diff
	
	color("Blue")
	for (j=[0:2]) rotate([0,0,120*j])
		translate([DrivePlateBC(Pitch=PlanetaryPitch, nTeeth=nPlanetTeeth, nTeethPinion=nSunTeeth)/2,0,0])
			rotate([180,0,180/nPlanetTeeth])PlanetGear(Pitch=PlanetaryPitch, nTeeth=nPlanetTeeth, Thickness=GearWidth, SholderBolt=1);
	
	color("Blue")
	translate([0,0,-GearWidth-5-0.6])
	for (j=[0:2]) rotate([0,0,120*j])
		translate([DrivePlateBC(Pitch=PlanetaryPitch, nTeeth=nPlanetTeeth, nTeethPinion=nSunTeeth)/2,0,0])
			rotate([180,0,180/nPlanetTeeth])PlanetGear(Pitch=PlanetaryPitch, nTeeth=nPlanetTeeth, Thickness=GearWidth, SholderBolt=1);
	
	translate([0,0,-GearWidth-5-0.5]) color("Green") PinionPlate2();
	
	translate([0,0,-GearWidth*2-5-1]) color("Orange")SunGear();
	
} // ShowFifthDoF

ShowFifthDoF();

//PlanetGear(Pitch=PlanetaryPitch, nTeeth=nPlanetTeeth, Thickness=GearWidth, SholderBolt=1);

//OutsideRace(BallCircle_d=Tube_BC, Race_OD=SmallRace_d, Ball_d=Ball_d, Race_w=5, nBolts=6, RaceBoltInset=RaceBoltInset, PreLoadAdj=0.00, myFn=360) Bolt4ClearHole();


//translate([0,0,Ball_d/2+6+Ball_d*2+5])rotate([180,0,0])OutsideRace(BallCircle_d=Tube_BC, Race_OD=SmallRace_d, Ball_d=Ball_d, Race_w=5, nBolts=6, RaceBoltInset=RaceBoltInset, PreLoadAdj=0.00, myFn=90) Bolt4ClearHole();

module SunGear(){
	
	
	difference(){
		union(){
			translate([0,0,-Overlap])
		gear (number_of_teeth=nSunTeeth,
				circular_pitch=PlanetaryPitch, diametral_pitch=false,
				pressure_angle=Pressure_a,
				clearance = 0.4,
				gear_thickness=GearWidth,
				rim_thickness=GearWidth,
				rim_width=5,
				hub_thickness=GearWidth,
				hub_diameter=0,
				bore_diameter=0,
				circles=0,
				backlash=BackLash,
				twist=0,
				involute_facets=0,
				flat=false);
			
			translate([0,0,-GearWidth])
			gear (number_of_teeth=24,
				circular_pitch=PlanetaryPitch, diametral_pitch=false,
				pressure_angle=Pressure_a,
				clearance = 0.4,
				gear_thickness=GearWidth,
				rim_thickness=GearWidth,
				rim_width=5,
				hub_thickness=GearWidth,
				hub_diameter=0,
				bore_diameter=0,
				circles=0,
				backlash=BackLash,
				twist=0,
				involute_facets=0,
				flat=false);
		} // union
		
		translate([0,0,-GearWidth-Overlap]) cylinder(d=0.257*25.4+IDXtra,h=GearWidth*2+Overlap*2);
		
	} // diff
	
} // SunGear

//SunGear();

module OutputTubeBearing(myFN=90){
	
	
	
	translate([0,0,5])TubeEnd(TubeOD=Tube_d,Wall_t=0.84,Hole_d=6.35, Stop_l=5, GlueAllowance=0.40);
	
	difference(){
		union(){
			cylinder(d=DrivePlateBC(Pitch=PlanetaryPitch,nTeeth=nPlanetTeeth, nTeethPinion=nSunTeeth)+8,h=5);
			cylinder(d=Tube_d+8,h=InnerRace_l);
			translate([0,0,InnerRace_l-Overlap])cylinder(d1=Tube_d+8,d2=Tube_d+3,h=4);
		} // union
		
		// center hole
		translate([0,0,5]) cylinder(d=Tube_d+IDXtra*2,h=InnerRace_l+4);
		translate([0,0,-Overlap]) cylinder(d=6.35,h=6);
		
		translate([0,0,Ball_d/2+6]) BallTrack(BallCircle_d=Tube_BC, Ball_d=Ball_d, myFn=myFN);
		translate([0,0,Ball_d/2+6+Ball_d*2]) BallTrack(BallCircle_d=Tube_BC, Ball_d=Ball_d, myFn=myFN);
		
	    translate([0,0,5]) DrivePlateBolts(Pitch=PlanetaryPitch,nTeeth=nPlanetTeeth, nTeethPinion=nSunTeeth) Bolt6Hole();
		
	} // diff
	
} // OutputTubeBearing

//OutputTubeBearing();

module PinionPlate2(){
	difference(){
		PinionPlate(Pitch=PlanetaryPitch, nTeeth=nPlanetTeeth, nTeethPinion=nSunTeeth, Thickness=GearWidth);
		translate([0,0,-Overlap]) cylinder(d=0.257*25.4+IDXtra,h=5+GearWidth+Overlap*2);
	} // diff
} // PinionPlate2

//translate([0,0,-20])PinionPlate2();

module OuterRacePart2(myFn=90){
	
	translate([0,0,Ball_d/2+Ball_d*2-10]) difference(){
		rotate([0,0,22.5])
		OutsideRace(BallCircle_d=Tube_BC, Race_OD=SmallRace_d, Ball_d=Ball_d, Race_w=10, nBolts=8, RaceBoltInset=RaceBoltInset, PreLoadAdj=0.00, myFn=myFn)		 Bolt4Hole();
		OutideRaceBoltPattern(Race_OD=LargeRace_d,nBolts=8,RaceBoltInset=RaceBoltInset) translate([0,0,2])Bolt4HeadHole();
	}
	
	translate([0,0,Ball_d/2+6])rotate([180,0,0])OutsideRace(BallCircle_d=Tube_BC, Race_OD=LargeRace_d, Ball_d=Ball_d, Race_w=6, nBolts=8, RaceBoltInset=RaceBoltInset, PreLoadAdj=0.00, myFn=myFn) Bolt4HeadHole();
	
} // OuterRacePart2

//translate([0,0,6+Overlap]) OuterRacePart2();

module TheRing(myFn=90){
	
	translate([0,0,RingGear_h+6])
		OutsideRace(BallCircle_d=Tube_BC, Race_OD=LargeRace_d, Ball_d=Ball_d, Race_w=4, nBolts=8, RaceBoltInset=RaceBoltInset, PreLoadAdj=0.00, myFn=myFn) Bolt4Hole();
	
	/*
	difference(){
		translate([0,0,RingGear_h+0.5-Overlap]) cylinder(d=LargeRace_d,h=5.5+Overlap*2);
		
		translate([0,0,RingGear_h+0.5-Overlap*2]) cylinder(d=LargeRace_d-6,h=5.5+Overlap*4);
		
		translate([0,0,RingGear_h+0.5-Overlap])
			OutideRaceBoltPattern(Race_OD=LargeRace_d,nBolts=8,RaceBoltInset=RaceBoltInset)
				rotate([180,0,0]) Bolt4Hole();
	} // diff
	*/
	nBolts=8;
	difference(){
	 union(){
		 RingGear(Pitch=PlanetaryPitch, nTeeth=nPlanetTeeth, nTeethPinion=nSunTeeth, Thickness=RingGear_h+6.5);
		 
		 difference(){
			 cylinder(d=LargeRace_d,h=RingGear_h+6.5);
			 translate([0,0,-Overlap])cylinder(d=LargeRace_d-5,h=RingGear_h+6.5+Overlap*2);
		 } // diff
		 
		 
		 
		for (j=[0:nBolts-1]) rotate([0,0,360/nBolts*j]) translate([LargeRace_d/2,0,0]) 
			{
				cylinder(d=7,h=8);
				translate([0,0,8]) sphere(d=7);
			} // union
			
		} // union
		
		// top bolt holes
		translate([0,0,RingGear_h+0.5-Overlap])
			OutideRaceBoltPattern(Race_OD=LargeRace_d,nBolts=8,RaceBoltInset=RaceBoltInset)
				rotate([180,0,0]) Bolt4Hole();
		
		// bottom bolt holes
		for (j=[0:nBolts-1]) rotate([0,0,360/nBolts*j]) translate([LargeRace_d/2,0,0]) 
			rotate([180,0,0]) Bolt4Hole(depth=8);
		
	} // diff
} // TheRing

//translate([0,0,-RingGear_h])TheRing();




































