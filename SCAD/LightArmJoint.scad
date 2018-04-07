// **************************************************
// Light Arm Joint
// David M. Flynn
// Filename: LightArmJoint.scad
// Created: 4/6/2018
// Rev: 1.0.0 4/6/2018
// Units: millimeters
// **************************************************
// History:
// 1.0.0 4/6/2018 First code
// **************************************************
// Notes:
//
// **************************************************
// for STL output
//  PlanetA();
//  for (j=[0:nPlanets-1]) rotate([180,0,360/nPlanets*j]) translate([30,0,0]) PlanetB(nB=j);
// BallSpacer(BallCircle_d=BallCircle_d,Ball_d=Ball_d,nBalls=16);
// RW_OutsideRace(myFn=360);
// RW_InsideRace(myFn=360);
// RingGearA(myFn=360);
// RingGearB(myFn=360);
// PlanetCarrierA();
//PlanetCarrierB(EndRace=false, myFn=360);
//PlanetCarrierB(EndRace=true, myFn=360);

// **************************************************
// for viewing

include<TubeConnectorLib.scad>
include<CompoundHelicalPlanetary.scad>
include<CommonStuffSAEmm.scad>
include<BearingLib.scad>
// InsideRace(BallCircle_d=60, Race_ID=34, Ball_d=9.525, Race_w=5, nBolts=8, RaceBoltInset=BL_RaceBoltInset, myFn=360) Bolt4ClearHole();
// InsideRace(BallCircle_d=60, Race_ID=34, Ball_d=9.525, Race_w=5, nBolts=8, RaceBoltInset=BL_RaceBoltInset, myFn=360) Bolt4HeadHole();
// OutsideRace(BallCircle_d=60, Race_OD=86, Ball_d=9.525, Race_w=7, nBolts=8, RaceBoltInset=BL_RaceBoltInset, myFn=360) Bolt4ClearHole();
// OutsideRace(BallCircle_d=60, Race_OD=86, Ball_d=9.525, Race_w=5, nBolts=8, RaceBoltInset=BL_RaceBoltInset, myFn=360) Bolt4Hole();
// InsideRaceBoltPattern(Race_ID=50, nBolts=8, RaceBoltInset=BL_RaceBoltInset) Bolt4HeadHole();
// OutideRaceBoltPattern(Race_OD=150, nBolts=8, RaceBoltInset=BL_RaceBoltInset) Bolt4HeadHole();
// BallSpacer(BallCircle_d=60,Ball_d=9.525,nBalls=12);
// InsideRaceBoltPattern(Race_ID=50,nBolts=8,RaceBoltInset=BL_RaceBoltInset);
// OutideRaceBoltPattern(Race_OD=150,nBolts=8,RaceBoltInset=BL_RaceBoltInset);
// BallTrack(BallCircle_d=100, Ball_d=9.525, myFn=360);

$fn=90;
IDXtra=0.2;
Overlap=0.05;

Spline_Hole_d=6.35+IDXtra; // for a 1/4" standoff
Spline_Gap=0.20; // 0.22 loose fit, 0.20 snug fit, 0.15 press fit

PlanetaryPitchA=300;
PlanetaryPitchB=290.3225;
BackLash=0.5; // 0.3 works but is tight
SunGear_t=15;
SunGear_a=0;
//InputRing_t=45; calculated value from CompoundHelicalPlanetary.scad
//OutputRing_t=47; calculated value from CompoundHelicalPlanetary.scad
PlanetA_t=15;
//PlanetB_t=14; // -60:1 ratio
PlanetB_t=16; // 188:1 ratio
PlanetStack=2; // number of gears 2 or 3
nPlanets=5;
Pressure_a=24; //22.5;
GearWidth=9;
twist=0; // set to 0 for straight gears, 200 for helical gears

Race_w=5;
Ball_d=9.525; // 0.375"
RaceBoltInset=3.5;
BallCircle_d=114;
Race_OD=BallCircle_d+26;
echo(Race_OD=Race_OD);
Race_ID=88;


PlanetClearance=1; // cut-away 1mm of teeth

module RoundRect(X=1,Y=1,H=0.2,R=0.2){
	hull(){
		translate([-X/2+R,-Y/2+R,-H/2]) cylinder(r=R,h=H);
		translate([X/2-R,-Y/2+R,-H/2]) cylinder(r=R,h=H);
		translate([-X/2+R,Y/2-R,-H/2]) cylinder(r=R,h=H);
		translate([X/2-R,Y/2-R,-H/2]) cylinder(r=R,h=H);
	} // hull
} //RoundRect

module ShowMyBalls(BallCircle_d=BallCircle_d, nBalls=12){
	for (j=[0:nBalls-1]) rotate([0,0,360/nBalls*j]) translate([BallCircle_d/2,0,0]) sphere(d=Ball_d-Overlap*2);
} // ShowMyBalls

module RingGearA(myFn=90){
	
	nBolts=8;
	
	CompoundRingGearHelix(Pitch=PlanetaryPitchA, nTeeth=InputRing_t, Thickness=GearWidth, twist=-twist, HB=false);
	
	InsideRace(BallCircle_d=BallCircle_d, Race_ID=Race_ID, Ball_d=Ball_d, Race_w=GearWidth, nBolts=nBolts, myFn=myFn)
			Bolt4HeadHole();
	
	// connector
	difference(){
		cylinder(d=Race_ID+1,h=GearWidth);
		translate([0,0,-Overlap])cylinder(d=85,h=GearWidth+Overlap*2);
	} // diff
} // RingGearA

//translate([0,0,-1])RingGearA(myFn=90);

module RingGearB(myFn=90){
	nBolts=12;
	
	SkirtThickness=2;
	Nut_l=8;
	GearEndClearance=0.4; // just a little extra so the two ring gears don't press on each other
	
	CompoundRingGearHelix(Pitch=PlanetaryPitchB, nTeeth=OutputRing_t, Thickness=GearWidth-GearEndClearance, twist=twist, HB=false);
	
	OutsideRace(BallCircle_d=BallCircle_d,Race_OD=Race_OD,Ball_d=Ball_d,Race_w=GearWidth,nBolts=nBolts,RaceBoltInset=BL_RaceBoltInset,myFn=myFn) Bolt4HeadHole();
	
	//*
	// connector
	difference(){
		cylinder(d=BallCircle_d+14,h=2);
		
		translate([0,0,-Overlap])cylinder(d=85,h=3);
		
		translate([0,0,2])OutideRaceBoltPattern(Race_OD=PC_Race_OD,nBolts=12,RaceBoltInset=BL_RaceBoltInset) Bolt4Hole();
	} // diff
	/**/
	
	PC_r=25;
	PC_t=Race_w;
	PC_w=10; // changed from 8 to 10 1/9/18
	
	PC_BallCircle_d=PC_r*2+PC_w+Ball_d;
	PC_Race_OD=PC_BallCircle_d+26;
	
	
	
} // RingGearB

//translate([0,0,GearWidth+0.4])
//translate([0,0,2])RingGearB(myFn=90);

module PlanetA(){
	
	difference(){
		CompoundPlanetGearHelixA(Pitch=PlanetaryPitchA,nTeethA=PlanetA_t, PitchB=PlanetaryPitchB, nTeethB=PlanetB_t, Thickness=GearWidth, Offset_a=0, HB=false, Spline_d=15, nSplines=5);
		
		// clearance for misaligned ring gears
		translate([0,0,GearWidth-PlanetClearance])
		difference(){
			cylinder(d=30,h=PlanetClearance+Overlap);
			translate([0,0,-Overlap])cylinder(d=21,h=PlanetClearance+Overlap*4);
		}
	} // diff
} // PlanetA

//PlanetA();

module PlanetB(nB=0){
	RotB=180/OutputRing_t*(OutputRing_t/nPlanets*nB); //*(PlanetA_t/PlanetB_t);
	echo(RotB=RotB);
	
	difference(){
		
		//rotate([0,0,RotB])
		CompoundPlanetGearHelixB(Pitch=PlanetaryPitchA,nTeethA=PlanetA_t, PitchB=PlanetaryPitchB, nTeethB=PlanetB_t, Thickness=GearWidth, Offset_a=0, HB=false, Spline_d=15, nSplines=5, Spline_a=-RotB);
		
		
		// clearance for misaligned ring gears
		translate([0,0,-Overlap])
		difference(){
			cylinder(d=30,h=PlanetClearance+Overlap);
			translate([0,0,-Overlap])cylinder(d=18.8,h=PlanetClearance+Overlap*4);
		}
		
		for (j=[1:nB+1]) rotate([0,0,360/PlanetB_t*j]) translate([PlanetB_t*PlanetaryPitchB/360-3.5,0,GearWidth-0.3]) cylinder(d=0.5,h=2);
	} // diff
} // PlanetB

//rotate([180,0,0])PlanetB(4);

module ShowPlanets(CutAway=true,HideGears=true){
	
	PitchA=PlanetaryPitchA;
		PitchB=PlanetaryPitchB;
		Planet_BC=SunGear_t*PitchA/180 + PlanetA_t*PitchA/180;
		Ratio=OutputRing_t*PitchB/180/((InputRing_t*PitchA/180  / (PlanetA_t*PitchA/180) * (PlanetB_t*PitchB/180)-OutputRing_t*PitchB/180))*(InputRing_t/SunGear_t);
		
		SunGearRA=$t*Ratio*360;
		PlanetPosRA=SunGearRA/((InputRing_t/SunGear_t)+(InputRing_t/SunGear_t));//  29.7r /(InputRing_t/SunGear_t); // 2.57 4.5
		PlanetRA=-PlanetPosRA-PlanetPosRA*((InputRing_t/PlanetA_t));
		OutputRingRA=-360*$t;
	
	translate([0,0,0])rotate([180,0,0]) color("Brown")PlanetCarrierA();
	for (j=[0:nPlanets-1])rotate([0,0,PlanetPosRA+360/nPlanets*j])
		translate([Planet_BC/2,0,0])color("Red")cylinder(d=6.35,h=PlanetShaft_l);
	translate([0,0,PlanetShaft_l])color("Brown")PlanetCarrierB();
	
	if (HideGears==false)
	difference(){
		translate([0,0,GearWidth*2]) rotate([180,0,0])
			for (j=[0:nPlanets-1])
				rotate([0,0,PlanetPosRA+360/nPlanets*j])translate([Planet_BC/2,0,0])rotate([0,0,PlanetRA]){
					color("Tan") PlanetA();
				
					translate([0,0,GearWidth]) PlanetB(nB=j);
				}
			
				if (CutAway==true)
			translate([0,-Planet_BC,-Overlap])cube([Planet_BC,Planet_BC,PlanetShaft_l]);
		} // diff
			/**/
} // ShowPlanets

//ShowPlanets(CutAway=true,HideGears=false);
//ShowPlanets(CutAway=true,HideGears=true);

PlanetCarrierA_t=4;

module PlanetCarrierA(PC_t=PlanetCarrierA_t){
	PC_r=25;
	PC_w=10; // changed from 8 to 10 1/9/18
	
	difference(){
		cylinder(r=PC_r+PC_w/2,h=PC_t);
		
		translate([0,0,-Overlap]) cylinder(r=PC_r-PC_w/2,h=PC_t+Overlap*2);
			
		for (j=[0:nPlanets-1]) rotate([0,0,360/nPlanets*j]) translate([PC_r,0,PC_t]) Bolt4ButtonHeadHole();
	} // diff
	
} // PlanetCarrierA

//PlanetCarrierA();
PlanetShaft_l=19.05; // 3/4"

module PlanetCarrierB(EndRace=true, myFn=90){
	PC_r=25;
	PC_t=Race_w;
	PC_w=10; // changed from 8 to 10 1/9/18
	
	PC_BallCircle_d=PC_r*2+PC_w+Ball_d;
	PC_Race_ID=PC_r*2+PC_w-Overlap;
	
	difference(){
		cylinder(r=PC_r+PC_w/2,h=PC_t);
		
		translate([0,0,-Overlap]) cylinder(r=PC_r-PC_w/2,h=PC_t+Overlap*2);
			
		if (EndRace==false){
				for (j=[0:nPlanets-1]) rotate([0,0,360/nPlanets*j]) translate([PC_r,0,PC_t]) Bolt4ClearHole();
			} else {
				for (j=[0:nPlanets-1]) rotate([0,0,360/nPlanets*j]) translate([PC_r,0,0]) rotate([180,0,0]) Bolt4ButtonHeadHole();
			}		
	} // diff
	
	InsideRace(BallCircle_d=PC_BallCircle_d, Race_ID=PC_Race_ID, Ball_d=Ball_d, Race_w=PC_t, nBolts=0, myFn=myFn)
			Bolt4Hole();
	
} // PlanetCarrierB

//PlanetCarrierB(EndRace=false, myFn=90);
//translate([0,0,Race_w*2+Overlap])rotate([180,0,0]) PlanetCarrierB(EndRace=true, myFn=90);

module PCBOuterRace(EndRace=true, myFn=90){
	PC_r=25;
	PC_t=Race_w;
	PC_w=10; // changed from 8 to 10 1/9/18
	
	PC_BallCircle_d=PC_r*2+PC_w+Ball_d;
	PC_Race_OD=PC_BallCircle_d+26;
	

	
	OutsideRace(BallCircle_d=PC_BallCircle_d, Race_OD=PC_Race_OD, Ball_d=Ball_d, Race_w=PC_t, nBolts=12, myFn=myFn)
			Bolt4ClearHole();
	
} // PCBOuterRace

//PCBOuterRace(EndRace=true, myFn=90);

module RW_InsideRace(myFn=360,nBolts=8){
		InsideRace(BallCircle_d=BallCircle_d, Race_ID=Race_ID, Ball_d=Ball_d, Race_w=Race_w, nBolts=nBolts, myFn=myFn)
			Bolt4Hole();
} // RW_InsideRace

//translate([0,0,GearWidth+Race_w])rotate([180,0,0]) RW_InsideRace(myFn=90);

module RW_OutsideRace(myFn=360){
	nBolts=12;
	OutsideRace(BallCircle_d=BallCircle_d,Race_OD=Race_OD,Ball_d=Ball_d,Race_w=Race_w,nBolts=nBolts,RaceBoltInset=BL_RaceBoltInset,myFn=myFn) Bolt4Hole();
		
} // RW_OutsideRace

//translate([0,0,GearWidth+Race_w])rotate([180,0,0])RW_OutsideRace(myFn=90);

module ShowArmJoint(){
	//*
	translate([0,0,-1]){
		RingGearA();
		translate([0,0,GearWidth+Race_w])rotate([180,0,0]) RW_InsideRace(myFn=90);
	}
	/**/
	translate([0,0,GearWidth*2+1.4])rotate([180,0,0])RingGearB();
	translate([0,0,GearWidth+1.4-Race_w]) RW_OutsideRace(myFn=90);
	
	ShowPlanets(CutAway=false,HideGears=true);
	
	translate([0,0,GearWidth+1.4]) BallSpacer(BallCircle_d=BallCircle_d,Ball_d=Ball_d,nBalls=16);
	
	//PlanetCarrierB(EndRace=false, myFn=90);
	translate([0,0,GearWidth*2+1.2+Race_w*2+Overlap])rotate([180,0,0]) PlanetCarrierB(EndRace=true, myFn=90);

	translate([0,0,GearWidth*2+1.2]) PCBOuterRace(EndRace=true, myFn=90);
	translate([0,0,GearWidth*2+1.2+Race_w*2+Overlap])rotate([180,0,0]) PCBOuterRace(EndRace=true, myFn=90);
} // ShowArmJoint

//ShowArmJoint();

