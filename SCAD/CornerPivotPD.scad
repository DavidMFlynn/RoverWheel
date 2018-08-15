// ************************************************
// Corner Pivot Planet Drive & Encoder
// by David M. Flynn
// Filename: CornerPivotPD.scad
// Created: 7/16/2018
// Revision: 1.2.1 8/14/2018
// **********************************************
// History
// 1.2.1 8/14/2018 Right side version (mirror X top), cover up opening to gears.
// 1.2.0 8/3/2018 Added Rotation Stop and VOffset.
// 1.1.1 8/2/2018 Outer race to RingGearWidth, BackLash=0.0
// 1.1.0 7/30/2018 Made it smaller 110mm OD
// 1.0.0 7/16/2018 Copied from CornerPivot.scad 1.0.6.
// **********************************************
// for STL output
//
// CP_DriveGear();
// rotate([180,0,0]) CP_SunGear();
// PlanetGear(Pitch=PlanetaryPitch, nTeeth=PlanetGearTeeth, Thickness=GearWidth, SholderBolt=1);
// CP_RingGear(myFn=360);
//
// CP_OuterRace(myFn=360);
//
// CornerPivotUpperLD20MG(Tube_a=10, Flanged=true, myFn=360); // Left Front & Right Rear
// mirror([1,0,0]) CornerPivotUpperLD20MG(Tube_a=10, Flanged=true, myFn=360);  // Right Front & Left Rear
// rotate([180,0,0]) CornerPivotLower(myFn=360);
//
// CornerPivotUpperSTL(Left=true);
// CornerPivotUpperSTL(Left=false);

// CornerPivotLowerSTL(Left=true);
// CornerPivotLowerSTL(Left=false);

// **********************************************
// for Viewing
// CornerPivotS(UpperTubeAngle=10,LowerRot=90);
// **********************************************

include<CommonStuffSAEmm.scad>

include<LD-20MGServoLib.scad>
include<PlanetDriveLib.scad>
include<BearingLib.scad>
include<AbsEncLib.scad>

include<TubeConnectorLib.scad>
// TubeEll_STL(TubeOD=25.4,Wall_t=0.84,Hole_d=14);
// TubeSection(TubeOD=25.4,Wall_t=0.84, Length=100, Stop_l=TubeStop_l);
// TubeEnd(TubeOD=25.4,Wall_t=0.84,Hole_d=14, GlueAllowance=0.40);
// TubeEll(TubeOD=25.4,Wall_t=0.84,Hole_d=14);
// overrides

// It's too big
/*
PlanetaryPitch=300;
DrivePlateXtra_d=12;
SunGearTeeth=15;
PinionGearTeeth=21;
DriveGearTeeth=13;
PlanetGearTeeth=15;
RingPitch_diameter  =  (PlanetGearTeeth * PlanetaryPitch / 180) * 2 + SunGearTeeth * PlanetaryPitch / 180;
RingTeeth=RingPitch_diameter * 180 / PlanetaryPitch;
CornerPivot_bc=104; // ball circle
CP_OD=CornerPivot_bc+26;
CP_ID=CornerPivot_bc-26;
Ball_d=9.525;
nTopBolts=12;
nBottomBolts=16;
/**/

// a smaller one
PlanetaryPitch=260;
DrivePlateXtra_d=12;
SunGearTeeth=15;
PinionGearTeeth=17;
DriveGearTeeth=15;
PlanetGearTeeth=12;
RingPitch_diameter  =  (PlanetGearTeeth * PlanetaryPitch / 180) * 2 + SunGearTeeth * PlanetaryPitch / 180;
RingTeeth=RingPitch_diameter * 180 / PlanetaryPitch;
CornerPivot_bc=86; // ball circle
CP_OD=CornerPivot_bc+24;
CP_ID=CornerPivot_bc-24;
RingClearance=62;
Ball_d=7.9375; // 9.525;
nTopBolts=8;
nBottomBolts=12;

BackLash=0.0;
Pressure_a=20;
GearWidth=9.5; // shoulder bolt height
DriveGearWidth=8;

ShoulderBoltHeadClearance_d=9;
RingGearWidth=(GearWidth>Ball_d+1)? GearWidth:Ball_d+1;

$fn=90;
IDXtra=0.2;
Overlap=0.05;

Tube_OD=25.4;
RaceBoltInset=3.5;

MotorCover_d=32;

BearingPreLoad=0.6;
ServoPos_a=-90;
VOffset=0.25;


echo(str("Joint OD = ",CP_OD));

module ShowPlanetGears(){
for (j=[0:2]) rotate([0,0,120*j]) translate([PlanetaryPitch*PlanetGearTeeth/360+PlanetaryPitch*SunGearTeeth/360,0,0])
	rotate([0,0,180/PlanetGearTeeth])
PlanetGear(Pitch=PlanetaryPitch, nTeeth=PlanetGearTeeth, Thickness=GearWidth, SholderBolt=1);
} // ShowPlanetGears

//ShowPlanetGears();

module CornerPivotS(UpperTubeAngle=10,LowerRot=90){
	translate([0,0,RingGearWidth+Overlap]) CornerPivotUpperLD20MG(Tube_a=UpperTubeAngle, Flanged=true);
	translate([0,0,1]) rotate([0,0,180/SunGearTeeth]) CP_SunGear();
	rotate([0,0,ServoPos_a]) 
		translate([PlanetaryPitch*PinionGearTeeth/360+PlanetaryPitch*DriveGearTeeth/360,0,Ball_d+2])
			rotate([0,0,180/DriveGearTeeth*0.7]) CP_DriveGear();
	translate([0,0,0]) rotate([0,0,180/nTopBolts]) CP_RingGear();
	//*
	translate([0,0,0]) rotate([0,0,-30]) ShowPlanetGears();
	
	
	
	translate([0,0,-VOffset*2]) CP_OuterRace();
	
	translate([0,0,-VOffset*2-Overlap]) rotate([0,0,LowerRot]) CornerPivotLower();
	/**/
} // CornerPivotS

//CornerPivotS(UpperTubeAngle=10,LowerRot=90);

module CP_DriveGear(){
	nBolts=4;
	BC=13.5;
	
	difference(){
	gear (
			number_of_teeth=DriveGearTeeth,
			circular_pitch=PlanetaryPitch, diametral_pitch=false,
			pressure_angle=Pressure_a,
			clearance = 0.2,
			gear_thickness=DriveGearWidth,
			rim_thickness=DriveGearWidth,
			rim_width=5,
			hub_thickness=DriveGearWidth,
			hub_diameter=12,
			bore_diameter=8,
			circles=0,
			backlash=BackLash,
			twist=0,
			involute_facets=0,
			flat=false);
		
		//translate([0,0,-Overlap]) cylinder(d=8,h=DriveGearWidth+Overlap);
		for (j=[0:nBolts-1]) rotate([0,0,360/nBolts*j]) translate([BC/2,0,DriveGearWidth]) Bolt2Hole();
	} // diff
} //CP_DriveGear

//translate([PlanetaryPitch*PinionGearTeeth/360+PlanetaryPitch*DriveGearTeeth/360,0,Ball_d+2]) rotate([0,0,180/DriveGearTeeth*0.7]) CP_DriveGear();


module CP_SunGear(){
	gear (
			number_of_teeth=SunGearTeeth,
			circular_pitch=PlanetaryPitch, diametral_pitch=false,
			pressure_angle=Pressure_a,
			clearance = 0.2,
			gear_thickness=GearWidth,
			rim_thickness=GearWidth,
			rim_width=5,
			hub_thickness=GearWidth,
			hub_diameter=12,
			bore_diameter=6.35+IDXtra,
			circles=0,
			backlash=BackLash,
			twist=0,
			involute_facets=0,
			flat=false);
	
	translate([0,0,GearWidth-Overlap])
		gear (
			number_of_teeth=PinionGearTeeth,
			circular_pitch=PlanetaryPitch, diametral_pitch=false,
			pressure_angle=Pressure_a,
			clearance = 0.2,
			gear_thickness=DriveGearWidth,
			rim_thickness=DriveGearWidth,
			rim_width=5,
			hub_thickness=DriveGearWidth,
			hub_diameter=12,
			bore_diameter=6.35+IDXtra,
			circles=0,
			backlash=BackLash,
			twist=0,
			involute_facets=0,
			flat=false);

} // CP_SunGear

//translate([0,0,1]) rotate([0,0,180/SunGearTeeth]) CP_SunGear();

module CP_RingGear(myFn=90){
	
	
	difference(){
		union(){
			RingGear(Pitch=PlanetaryPitch, nTeeth=PlanetGearTeeth, nTeethPinion=SunGearTeeth, Thickness=RingGearWidth);
			//difference(){
			//	translate([0,0,Ball_d+0.5-Overlap]) cylinder(d=CornerPivot_bc-Ball_d,h=RingGearWidth-(Ball_d+0.5)+Overlap);
			//	translate([0,0,Ball_d+0.5-Overlap*2]) cylinder(d=RingClearance,h=RingGearWidth-(Ball_d+0.5)+Overlap*4);
			//} // diff
			OnePieceInnerRace(BallCircle_d=CornerPivot_bc,	Race_ID=RingClearance,	Ball_d=Ball_d,
				Race_w=RingGearWidth,
				PreLoadAdj=BearingPreLoad,
				VOffset=-VOffset,
				myFn=myFn);
		}// union
		
		// Bolt holes
		for (j=[0:nTopBolts-1]) rotate([0,0,360/nTopBolts*j])
			translate([CornerPivot_bc/2-Ball_d/2-RaceBoltInset,0,RingGearWidth]) Bolt4Hole();
		
		// ball insertion cut
		rotate([0,0,180/nTopBolts]) translate([CornerPivot_bc/2,0,(Ball_d+0.5)/2]) hull(){
			sphere(d=Ball_d-BearingPreLoad);
			translate([0,0,Ball_d]) sphere(d=Ball_d-BearingPreLoad);
		}
	} // diff
	
} // CP_RingGear

//rotate([0,0,180/nTopBolts]) CP_RingGear();


module CP_OuterRace(myFn=90){
	Stop_a=6;
	Stop_w=3.5;
	Stop_h=3;
	
	
	
	difference(){
		
		OnePieceOuterRace(BallCircle_d=CornerPivot_bc, Race_OD=CP_OD, Ball_d=Ball_d, Race_w=RingGearWidth,
				PreLoadAdj=BearingPreLoad,
				VOffset=VOffset,
				myFn=myFn);
			
		
		// Bolt holes
		for (j=[0:nBottomBolts-1]) rotate([0,0,360/nBottomBolts*j])
			translate([CP_OD/2-RaceBoltInset,0,RingGearWidth+0.5]) Bolt4Hole();
		
		// ball insertion cut
		rotate([0,0,180/nTopBolts]) translate([CornerPivot_bc/2,0,RingGearWidth/2+VOffset]) hull(){
			sphere(d=Ball_d-BearingPreLoad);
			translate([0,0,Ball_d]) sphere(d=Ball_d-BearingPreLoad);
		}
		
		// Rotation Stop
		translate([0,0,RingGearWidth-Stop_h]){
		difference(){
			cylinder(r=CP_OD/2-RaceBoltInset+Stop_w/2,h=Stop_h+Overlap);
			
			translate([0,0,-Overlap]){
				
				cylinder(r=CP_OD/2-RaceBoltInset-Stop_w/2,h=Stop_h+Overlap*2);
				
				rotate([0,0,180/nBottomBolts])translate([-3,CP_OD/2-RaceBoltInset-Stop_w/2-Overlap,-Overlap*2])cube([6,Stop_w+Overlap*2,Stop_h+Overlap*4]);
				//translate([-(CP_OD/2-RaceBoltInset+2.5+Overlap),0,0])
					//#cube([(CP_OD/2-RaceBoltInset+2.5+Overlap)*2,CP_OD/2-RaceBoltInset+2.5+Overlap,Stop_h+Overlap*2]);
				//rotate([0,0,-90-Stop_a-90]) cube([CP_OD/2-RaceBoltInset+2.5+Overlap,CP_OD/2-RaceBoltInset+2.5+Overlap,Stop_h+Overlap*2]);
				//rotate([0,0,-90+Stop_a]) cube([CP_OD/2-RaceBoltInset+2.5+Overlap,CP_OD/2-RaceBoltInset+2.5+Overlap,Stop_h+Overlap*2]);
			}
		} // diff
		
		rotate([0,0,-Stop_a/2+180/nBottomBolts]) translate([0,CP_OD/2-RaceBoltInset,0]) cylinder(d=Stop_w,h=Stop_h+Overlap);
		rotate([0,0,Stop_a/2+180/nBottomBolts]) translate([0,CP_OD/2-RaceBoltInset,0]) cylinder(d=Stop_w,h=Stop_h+Overlap);
	}
		
	} // diff
	
} // CP_OuterRace

//translate([0,0,RingGearWidth-0.5]) rotate([180,0,0]) CP_OuterRace();

module CornerPivotUpperSTL(Left=true){
	
	difference(){
		if (Left==true){
		rotate([0,90,0]) CornerPivotUpperLD20MG();
		} else {
			rotate([0,-90,0]) CornerPivotUpperLD20MG();
		}
		translate([-100,-100,-100]) cube([200,200,100]);
	} // diff
} // CornerPivotUpperSTL

//CornerPivotUpperSTL();
//translate([-10,0,0])mirror([1,0,0])CornerPivotUpperSTL();
//translate([0,0,-10.1])rotate([0,0,22.5])Show_CP();

module CornerPivotUpperLD20MG(Tube_a=10, Flanged=false, myFn=90){
	// This version is for a standard r/c servo
	Base_h=2;
	TubeStop_y=18; //25;
	
	Motor_d=28;
	Stop_a=45;
	Servo_h=24.0+5.5; // Stansard servo wheel
	Servo_Deck_h=3.2;
	
	if (Flanged==true){
		translate([0,TubeStop_y,Tube_OD/2+BoltOffset*1.42+Base_h]) rotate([-90+Tube_a,0,0]) TubeFlange(TubeOD=Tube_OD,FlangeLen=10,Threaded=true);
	} else {
		translate([0,TubeStop_y,Tube_OD/2+Base_h]) rotate([-90+Tube_a,0,0]) TubeEnd(TubeOD=Tube_OD,Wall_t=0.84,Hole_d=14, GlueAllowance=0.40);
	}
	
	
	difference(){
		union(){
			translate([0,0,1-Overlap]) cylinder(d1=CP_OD-RaceBoltInset*4,d2=40,h=10+Overlap,$fn=myFn);
			
			// Stop Boss
			hull(){
				translate([-CP_OD/2+RaceBoltInset,0,0]) cylinder(r=RaceBoltInset,h=4);
				translate([-CP_OD/2+20,0,0]) cylinder(r=RaceBoltInset,h=4);
			} // hull
			
			// base
			cylinder(d=CP_OD,h=1,$fn=myFn);
			
			// Drive Gear Cover
			rotate([0,0,ServoPos_a])
				translate([PlanetaryPitch*PinionGearTeeth/360+PlanetaryPitch*DriveGearTeeth/360,0,0]) 
					cylinder(d=DriveGearTeeth*PlanetaryPitch/180+12,h=13);
			
			hull(){
				if (Flanged==true){
					translate([0,TubeStop_y,Tube_OD/2+BoltOffset*1.42+Base_h]) rotate([-90+Tube_a+180,0,0]) cylinder(d=Tube_OD+BoltOffset*4,h=0.1,$fn=myFn);
				} else {
					translate([0,TubeStop_y,Tube_OD/2+Base_h]) rotate([-90+Tube_a+180,0,0]) cylinder(d=Tube_OD,h=5,$fn=myFn);
				}
				translate([0,0,3]) cylinder(d=55,h=6,$fn=myFn);
				
				// Servo attachment
				rotate([0,0,ServoPos_a]){
				translate([PlanetaryPitch*PinionGearTeeth/360+PlanetaryPitch*DriveGearTeeth/360,0,0]) rotate([0,0,-90]){
				translate([-17.75,-10,0]) cube([0.1,24.0,Servo_h-Servo_Deck_h]);
				translate([37.00,-10,0]) cube([0.1,24.0,Servo_h-Servo_Deck_h]);}}
			} // hull
		} // union
		
		// Stop bolt
		translate([-CP_OD/2+RaceBoltInset,0,4]) Bolt4Hole();
		
		// encoder
		translate([0,0,14]) EncoderMount();
		// Servo
		rotate([0,0,ServoPos_a]){
		translate([PlanetaryPitch*PinionGearTeeth/360+PlanetaryPitch*DriveGearTeeth/360,0,Servo_h])rotate([0,0,-90])
			rotate([0,180,0]) Servo_LD20MG(BottomMount=true,TopAccess=false);}
		
		// Ring Gear bolts
		for (j=[0:nTopBolts-1]) rotate([0,0,360/nTopBolts*(j+0.5)]) translate([CornerPivot_bc/2-Ball_d/2-RaceBoltInset,0,6])
			
		//translate([(CP_OD)/2-RaceBoltInset,0,6]) 
			 Bolt4HeadHole(depth=8,lHead=30);
		
		if (Flanged==true){
			translate([0,TubeStop_y, Tube_OD/2+BoltOffset*1.42+Base_h]) rotate([-90+Tube_a,0,0]){
				translate([0,0,10-Overlap]) cylinder(d=Tube_OD+BoltOffset*4+IDXtra*2, h=CornerPivot_bc);
				translate([0,0,2]) cylinder(d=Tube_OD+BoltOffset*2+4, h=CornerPivot_bc);
				translate([0,0,-2]) cylinder(d=Tube_OD, h=20);
				translate([0,-Tube_OD/2+5,-8]) cylinder(d=10, h=20);
				
			}
		} else {
			// tube clearance
			translate([0,TubeStop_y, Tube_OD/2+Base_h]) rotate([-90+Tube_a,0,0]) cylinder(d=Tube_OD+IDXtra*2, h=CornerPivot_bc);
		}
		
		//Gear clearance
		translate([0,0,-Overlap]) hull(){
			cylinder(d=PinionGearTeeth*PlanetaryPitch/180+8,h=10);
			rotate([0,0,ServoPos_a]) translate([PlanetaryPitch*PinionGearTeeth/360+PlanetaryPitch*DriveGearTeeth/360,0,0])
				cylinder(d=DriveGearTeeth*PlanetaryPitch/180+6,h=10);
		} // hull
		
		// Rotation Stop
		/*
		difference(){
			translate([0,0,-Overlap]) cylinder(r=CP_ID/2+RaceBoltInset+2.5,h=3);
			
			translate([0,0,-Overlap*2]){
				cylinder(r=CP_ID/2+RaceBoltInset-2.5, h=3+Overlap*2);
				translate([-(CP_ID/2+RaceBoltInset+2.5+Overlap),0,0])
					cube([(CP_ID/2+RaceBoltInset+2.5+Overlap)*2, CP_ID/2+RaceBoltInset+2.5+Overlap, 3+Overlap*2]);
				rotate([0,0,-90-Stop_a-90]) cube([CP_ID/2+RaceBoltInset+2.5+Overlap, CP_ID/2+RaceBoltInset+2.5+Overlap,3+Overlap*2]);
				rotate([0,0,-90+Stop_a]) cube([CP_ID/2+RaceBoltInset+2.5+Overlap, CP_ID/2+RaceBoltInset+2.5+Overlap,3+Overlap*2]);
			}
		} // diff
		rotate([0,0,-90-Stop_a]) translate([CP_ID/2+RaceBoltInset,0,-Overlap]) cylinder(d=5,h=3);
		rotate([0,0,-90+Stop_a]) translate([CP_ID/2+RaceBoltInset,0,-Overlap]) cylinder(d=5,h=3);
		*/
	} // diff
	
} // CornerPivotUpperLD20MG

//translate([0,0,Ball_d+1+Overlap]) CornerPivotUpperLD20MG(Tube_a=10, Flanged=true, myFn=360);

module CornerPivotLower(myFn=90){
	Base_h=6;
	TubeConn_y=17; // Use 30mm of 1" tube.

	difference(){
		union(){
			translate([0,0,-3-Overlap]) cylinder(d=CP_OD,h=3+Overlap,$fn=myFn);
			translate([0,0,-Base_h]) cylinder(d1=CornerPivot_bc-10,d2=CornerPivot_bc+12,h=Base_h-1,$fn=myFn);
			//translate([0,0,-2-Overlap]) cylinder(d=CornerPivot_bc+12,h=1);
			
			hull(){
				translate([0,0,-Base_h]) cylinder(d=CornerPivot_bc-10,h=0.1,$fn=myFn);
				translate([0,TubeConn_y,-Tube_OD/2-Base_h])rotate([90,0,0]) cylinder(d=Tube_OD,h=4,$fn=myFn);
			} // hull
		} // union
		
		// Bolts
		for (j=[0:nBottomBolts-1]) rotate([0,0,360/nBottomBolts*j+180/nBottomBolts]) translate([CP_OD/2-RaceBoltInset,0,0])
			Bolt4ClearHole(depth=8);
		
		// Encoder shaft
		translate([0,0,Overlap]) rotate([180,0,0]) cylinder(d=6.35,h=40);
		
		//Planet bolts
		for (j=[0:2]) rotate([0,0,120*j+15]) translate([PlanetaryPitch*PlanetGearTeeth/360+PlanetaryPitch*SunGearTeeth/360,0,0]) Bolt6Hole(depth=10);
		
		// tube clearance
		translate([0,TubeConn_y,-Tube_OD/2-Base_h])rotate([-90,0,0])cylinder(d=Tube_OD+IDXtra*2,h=CornerPivot_bc);
		translate([-CornerPivot_bc/2,TubeConn_y+2,-Tube_OD-Base_h-2]) //cube([CornerPivot_bc,CornerPivot_bc,Tube_OD-4]);
			hull(){
				rotate([0,90,0]) cylinder(d=4,h=CornerPivot_bc);
				translate([0,0,Tube_OD])rotate([0,90,0]) cylinder(d=4,h=CornerPivot_bc);
				translate([0,CornerPivot_bc,Tube_OD])rotate([0,90,0]) cylinder(d=4,h=CornerPivot_bc);
				
			} // hull
		
		// wire path
		//translate([0,Overlap,-Tube_OD/2-Base_h])rotate([90,0,0])cylinder(d=14,h=7);
		
		//hull(){
		//	translate([0,-CP_ID/2+7,-Tube_OD/2-Base_h+5])cylinder(d=14,h=Tube_OD/2+Base_h+Overlap);
		//	translate([0,-7,-Tube_OD/2-Base_h])rotate([90,0,0])cylinder(d=14,h=0.1);
		//} // hull
	} // diff
	
	translate([0,TubeConn_y,-Tube_OD/2-Base_h])rotate([-90,0,0])TubeEnd(TubeOD=25.4,Wall_t=0.84,Hole_d=14, GlueAllowance=0.40);
} // CornerPivotLower

//CornerPivotLower(myFn=90);

module CornerPivotLowerSTL(Left=true){
	
	difference(){
		if (Left==true){
		rotate([0,90,0])CornerPivotLower();
		} else {
		rotate([0,-90,0])CornerPivotLower();
		}
		translate([-100,-100,-100]) cube([200,200,100]);
	} // diff
} // CornerPivotLowerSTL

//CornerPivotLowerSTL();
//translate([10,0,0])mirror([1,0,0])CornerPivotLowerSTL();



