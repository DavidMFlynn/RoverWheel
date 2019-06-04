// **********************************************
// Rocker Bogie for Lan's Rover
// Filename: RockerBogieLan.scad
// by David M. Flynn
// Created: 12/28/2018
// Revision: 1.1.1 5/7/2019
// Units: mm
// **********************************************
//  ***** Notes *****
//
// Screws:
// #8-32 x 3/4" Socket Head 25IP
//   Main Pivot to Rover Chassis (10 Req.)
// 7/32" x 1/2" Long Shoulder Bolt, #8-32 Thread (10 Req. McM-C 91259A418)
// #4-40 x 1/4" Button Head 8IP 
//   Secondary Pivot Cover (16 Req.)
// #4-40 x 3/4" Flat Head 10IP 
//   Corner Pivot Wire Covers (8 Req.)
// #4-40 x 3/8" Socket Head 10IP
//   4 Corner Skirt x 7 (28 Req.)
//   2 Main Pivot Outer Race x 10 (20 Req.)
//   2 Main Pivot Cover x 5 (10 Req.)
// #4-40 x 1/2" Socket Head 10IP
//   4 Corner Skirt x 1 (4 Req.)
//   2 Main Pivot Inner Race x 10 (20 Req.)
// #4-40 x 5/8" Socket Head 10IP
//   8 Tube Flanges x 8 Screws (64 Req.)
//   2 Secondary Pivots x 8 Screws (16 Req.)
//   4 Corner x 2 Bearing Races x 8 (64 Req.)
//
// Other Hardware:
//  Female threaded stand-off 1/4" O.D. x 2-1/2" Long, #8-32 Thread (10 Req. McM-C 93265A029)
//  Compression Spring 1.5" Long, 0.375" O.D., 0.325" I.D. (10 Req. McM-C 9657K33)
//  5/16" O.D. x 0.015" Wall Aluminum Tubing 
//  TE/AMP 206305-1 Main Pivot (2 Req.)
//  TE/AMP 206306-1 Rover Body (2 Req.)
//
// Aluminum Tubing (3' piece McMaster-Carr:8978K24 )
// 1-1/2" O.D. x 0.035" Wall Ridgid tubing 
// 3-1/8" Center Wheel to Secondary Pivot, Secondary Pivot to Main Pivot (4 Req.)
// 1-3/4" Corner Wheel to Corner Pivot (4 Req.)
// 4-5/8" Front Corner to Main Pivot (2 Req.)
// 3" Rear Corner to Secondary Pivot (2 Req.)
// 
// Acetel (Delrin) Balls
// 3/8" Main Pivot (2 x 2 x 23), Secondary Pivot (2 x 21) (134 Req.)
// 5/16" Corner Pivot (2 x 25) (100 Req.)
// **********************************************
//  ***** History *****
// 1.1.1 5/7/2019 Added ChassisPlate
// 1.1.0 4/13/2019 Romovable main pivot w/ AMP connector.
// 1.0.7 3/24/2019 Added Secondary Pivot w/ Access Cover (SecPivotBC)
// 1.0.6 3/24/2019 Moved corner pivot to RockerBogieCorner.scad
// 1.0.5 3/24/2019 Split lower corner pivot into 3 pieces.
// 1.0.4 2/3/2019 Added TConn_a param to UpperCorner.
// 1.0.3 1/16/2019 Added gluing fixture.
// 1.0.2 1/10/2019 Flipped bearing races for wire guidance.
// 1.0.1 1/1/2019 LowerCorner
// 1.0.0 12/28/2018 copied from RockerBogie.scad
// 1.0.0 3/24/2018	RockerBogie.scad First code
// **********************************************
//  ***** for STL output *****
// TubeConnector(Tube_OD=Tube_OD); // good
// TubeSocket(TubeOD=Tube_OD, SocketLen=19, Threaded=false);
//
//  ***** Main Body *****
// MainPivot_Ring(myFn=360); // Right
// rotate([180,0,0]) mirror([0,0,1]) MainPivot_Ring(myFn=360); // Left
//
//  ***** The Middle Stuff, in order from inside to outside, print 2 of each *****
// ChassisMount(myFn=360); // Inner Race #1, the inside race closest to the chassis
// rotate([180,0,0]) MP_StopRace(myFn=360); // Inner Race 2
// MP_StopRing(); // travel limit Stops
// MP_AMP37_Nut(DrawNut=true);
// MP_OuterInnerRace(myFn=360); // Inner Race 3
// rotate([180,0,0]) MP_OuterOuterRace(myFn=360); // Inner Race 4
// MP_OuterCover();
//
// ChassisPlate(myFn=360,DrawNut=true);
//
// **********************************************
//  ***** for Viewing *****
// ShowMainPivot();
// PhantomWheel();
// OneCorner();
// OneCornerFL();
// **********************************************
// **** other routines *****
// AlTube(Len=25);
// **********************************************

//include<Nut_Job.scad>
//include<CommonStuffSAEmm.scad>
//include<RoverWheel.scad>
//include<BearingLib.scad>
//include<TubeConnectorLib.scad>

include<RockerBogieCorner.scad>
include<RockerBogieMainPiv.scad>
include<RockerBogieSecPiv.scad>

$fn=24;
//$fn=180;
IDXtra=0.2;
Overlap=0.05;

Tube_OD=38.1; //38.1; //25.4;
Wall_t=0.84;
TubeEnd_ID=Tube_OD-Wall_t*2-8;
Tire_OD=155;
Tire_w=88;
TubeOffset_X=-Tire_w/2-Tube_OD/2-1;
TubeOffset_Z=WheelMount_OD/2;
YTubeLen=100;

LR_RoverWidth=460;  // to center of middle wheels
LR_RoverLen=600; // wheelbase
LR_WheelStager=60;


module Show6Wheels(){
	// right middle
	translate([LR_RoverWidth/2,0,0]) PhantomWheel();
	// left meddle
	translate([-LR_RoverWidth/2,0,0]) mirror([1,0,0]) PhantomWheel();
	// Right Front
	translate([LR_RoverWidth/2-LR_WheelStager,LR_RoverLen/2,0]) PhantomWheel();
	// Right Rear
	translate([LR_RoverWidth/2-LR_WheelStager,-LR_RoverLen/2,0]) PhantomWheel();
	// left front
	translate([-LR_RoverWidth/2+LR_WheelStager,LR_RoverLen/2,0]) mirror([1,0,0]) PhantomWheel();
	// left rear
	translate([-LR_RoverWidth/2+LR_WheelStager,-LR_RoverLen/2,0]) mirror([1,0,0]) PhantomWheel();
}
 // Show6Wheels

//Show6Wheels();
//Show4Corners();

// SplineShaft(d=20,l=30,nSplines=Spline_nSplines,Spline_w=30,Hole=Spline_Hole_d,Key=false);
// SplineHole(d=20,l=20,nSplines=Spline_nSplines,Spline_w=30,Gap=IDXtra,Key=false);

// OnePieceInnerRace(BallCircle_d=100,	Race_ID=50,	Ball_d=9.525, Race_w=10, PreLoadAdj=0.00, VOffset=0.00, myFn=360);
// OnePieceOuterRace(BallCircle_d=60, Race_OD=75, Ball_d=9.525, Race_w=10, PreLoadAdj=0.00, VOffset=0.00, myFn=360);


module Tube8th(TubeOD=25.4,Wall_t=0.84,Hole_d=14, GlueAllowance=0.00,Angle=110){
	
	LenComp=180/(180-Angle);
	
	rotate([Angle,0,0])translate([0,0,TubeOD/LenComp])
		TubeEnd(TubeOD=TubeOD,Wall_t=Wall_t,Hole_d=Hole_d, GlueAllowance=GlueAllowance);
	translate([0,0,TubeOD/LenComp])
		TubeEnd(TubeOD=TubeOD,Wall_t=Wall_t,Hole_d=Hole_d, GlueAllowance=GlueAllowance);
	
	difference(){
		hull(){
			rotate([Angle,0,0])translate([0,0,TubeOD/LenComp-TubeStop_l])cylinder(d=TubeOD,h=0.01);
			translate([0,0,TubeOD/LenComp-TubeStop_l])cylinder(d=TubeOD,h=0.01);
		} // hull
		
		rotate([Angle,0,0])translate([0,0,TubeOD/LenComp-TubeStop_l])cylinder(d=Hole_d,h=TubeStop_l);
		translate([0,0,TubeOD/LenComp-TubeStop_l])cylinder(d=Hole_d,h=TubeStop_l);
		
		hull(){
			rotate([Angle,0,0])translate([0,0,TubeOD/LenComp-TubeStop_l])cylinder(d=Hole_d,h=0.01);
			translate([0,0,TubeOD/LenComp-TubeStop_l])cylinder(d=Hole_d,h=0.01);
		} // hull
	} // diff
} // Tube8th

//Tube8th(TubeOD=Tube_OD,Wall_t=0.84,Hole_d=TubeEnd_ID, GlueAllowance=0.40, Angle=110);

module Show4Corners(){
	// Right Front
	translate([LR_RoverWidth/2-LR_WheelStager,LR_RoverLen/2,0]) LR_Wheel2Corner();
	
	// Right Rear
	translate([LR_RoverWidth/2-LR_WheelStager,-LR_RoverLen/2,0]) LR_Wheel2Corner();
	
	// left front
	translate([-LR_RoverWidth/2+LR_WheelStager,LR_RoverLen/2,0])
		mirror([1,0,0]) LR_Wheel2Corner();
	// left rear
	translate([-LR_RoverWidth/2+LR_WheelStager,-LR_RoverLen/2,0])
		mirror([1,0,0]) LR_Wheel2Corner();

} // Show4Corners

//Show4Corners();

module ShowMiddleTubes(){
// right middle
	translate([LR_RoverWidth/2,0,0]) MiddleTube();
		
// left meddle
	translate([-LR_RoverWidth/2,0,0]) mirror([1,0,0]) MiddleTube();
} // ShowMiddleTubes

//ShowMiddleTubes();

module MiddleTube(){
	Hub_d=60;
	translate([TubeOffset_X,0,TubeOffset_Z]){
			
			// wheel to ell tube
		color("LightGray") TubeSection(TubeOD=Tube_OD,Wall_t=0.84, Length=45);
			
		translate([0,0,60])
		rotate([70,0,0])
		Tube8th(TubeOD=Tube_OD,Wall_t=0.84,Hole_d=TubeEnd_ID, GlueAllowance=0.40, Angle=110);
		
		translate([0,0,60])
		rotate([70,0,0]) translate([0,0,15]){
		color("LightGray") TubeSection(TubeOD=Tube_OD,Wall_t=0.84, Length=100);
			
			translate([0,0,100+Hub_d/2]) rotate([15,0,0]) translate([0,0,Hub_d/2])
			color("LightGray") TubeSection(TubeOD=Tube_OD,Wall_t=0.84, Length=100);
		}
		}
} // MiddleTube

module LR_Wheel2Corner(){
	translate([TubeOffset_X,0,TubeOffset_Z]){
		// wheel to ell tube
		color("LightGray") TubeSection(TubeOD=Tube_OD,Wall_t=0.84, Length=50);
		
		translate([0,0,50+Tube_OD/2]){
			rotate([0,-90,180]) rotate([0,0,90])
			TubeEll(TubeOD=Tube_OD, Wall_t=0.84, Hole_d=TubeEnd_ID, GlueAllowance=0.40);
			}
			translate([Tube_OD/2,0,50+Tube_OD/2]) rotate([0,90,0])
			color("LightGray") TubeSection(TubeOD=Tube_OD,Wall_t=0.84, Length=50);
			}
	
} // LR_Wheel2Corner

//LR_Wheel2Corner();

module PhantomWheel(){
	
	translate([-Tire_w/2+(WheelMount_l-6),0,0])rotate([0,-90,0])WheelMount();
	translate([-Tire_w/2-6.1,0,0])rotate([0,-90,0])
		TubeConnector(Tube_OD=Tube_OD);
	
	// tire
	rotate([0,-90,0])
	difference(){
		cylinder(d=Tire_OD,h=Tire_w,center=true,$fn=36);
		cylinder(d=Tire_OD-2,h=Tire_w+Overlap*2,center=true,$fn=36);
	} // diff
} // PhantomWheel

//PhantomWheel();

module TubeConnector(Tube_OD=25.4,Wall_t=Wall_t){
	TubeCL=Tube_OD/2+1; // bracket face to tube center
	
	difference(){
	translate([WheelMount_OD/2,0,TubeCL])
				rotate([0,90,0])
					TubeEnd(TubeOD=Tube_OD,Wall_t=Wall_t,
							Hole_d=TubeEnd_ID, GlueAllowance=0.40);
		// id
		cylinder(d=WheelMount_OD,h=Tube_OD);
	} // diff
	
	difference(){
		union(){
			translate([WheelMount_OD/2-8,0,TubeCL])
				rotate([0,90,0]) cylinder(d=Tube_OD,h=7);
			
			cylinder(d=WheelMount_OD+2,h=Tube_OD);
		} // union
		
		// tube sattle
		translate([WheelMount_OD/2,0,Tube_OD/2])
				rotate([0,90,0]) cylinder(d=Tube_OD+3,h=10);
		// wire path
		translate([WheelMount_OD/2-15,0,Tube_OD/2])rotate([0,90,0]) cylinder(d=TubeEnd_ID,h=45);
		
		translate([0,0,3]) hull(){
			translate([-WheelMount_OD/4-1,0,0])
			cube([WheelMount_OD/2+2,WheelMount_OD+Overlap*2+2,0.01],center=true);
			translate([0,0,Tube_OD]) cube([WheelMount_OD-8,WheelMount_OD+Overlap*2+2,0.01],center=true);
		}
		
		// inside
		translate([0,0,-Overlap]) cylinder(d=WheelMount_OD-MBoltInset*4-1,h=WheelMount_l+Tube_OD+Overlap*2);
		
		translate([-WheelMount_OD/2-Overlap-1,-WheelMount_OD/2-Overlap-1,-Overlap]) 
			cube([WheelMount_OD/2+2,WheelMount_OD+Overlap*2+2,Tube_OD+1]);
		
		// Mounting Bolts
		for (j=[0:nMountingBolts-1]) rotate([0,0,180/nMountingBolts*j+180/nMountingBolts/2-90]) 
			translate([WheelMount_OD/2-MBoltInset,0,8])
				Bolt4HeadHole(lHead=50); 
		
	} // diff
} // TubeConnector

//TubeConnector();

//$fn=40;
//rotate([0,0,-90]) rotate([0,-90,0]) TubeConnector(Tube_OD=Tube_OD,Wall_t=Wall_t);



//TubeEll_STL(TubeOD=Tube_OD, Wall_t=0.84, Hole_d=TubeEnd_ID, GlueAllowance=0.40);

module OneCorner(){
	//PhantomWheel();
	
	translate([TubeOffset_X,0,TubeOffset_Z]){
		
		// wheel to ell tube
		color("LightGray") TubeSection(TubeOD=Tube_OD,Wall_t=0.84, Length=50);
		
		//*
		translate([0,0,50+Tube_OD/2]){
			rotate([0,-90,180]) rotate([0,0,90])
			TubeEll(TubeOD=Tube_OD, Wall_t=0.84, Hole_d=TubeEnd_ID, GlueAllowance=0.40);
			
			//translate([0,Tube_OD/2,0]) rotate([-90,0,0]) 
			//	color("LightGray") TubeSection(TubeOD=Tube_OD, Wall_t=0.84, Length=YTubeLen);
			}
		/**/
	}
} // OneCorner

module OneCornerFL(){
	//PhantomWheel();
	translate([0,0,TubeOffset_Z+93]) rotate([0,0,10]) {
		//CornerPivotS(UpperTubeAngle=10,LowerRot=80);
		
		translate([0,0,10]) rotate([-80,0,0]) translate([0,0,26])
		color("LightGray") TubeSection(TubeOD=Tube_OD,Wall_t=0.84, Length=134);
	}
	
	translate([TubeOffset_X,0,TubeOffset_Z]){
		
		// wheel to ell tube
		color("LightGray") TubeSection(TubeOD=Tube_OD,Wall_t=0.84, Length=50);
		
		
		translate([0,0,50+Tube_OD/2]){
			rotate([180,0,90])  
			TubeEll(TubeOD=Tube_OD, Wall_t=0.84, Hole_d=TubeEnd_ID, GlueAllowance=0.40);
			
			// Corner pivot to ell tube
			translate([Tube_OD/2,0,0]) rotate([0,90,0]) 
				color("LightGray") TubeSection(TubeOD=Tube_OD, Wall_t=0.84, Length=50);
			}
		
	}
} // OneCornerFL


//translate([-43,200,TubeOffset_Z+93+45.5])rotate([0,90,0])translate([0,0,2])rotate([0,0,10])RockerArmConnector();

module AlTube(Len=25){
	color("Silver") 
	difference(){
		cylinder(d=Tube_OD,h=Len);
		translate([0,0,-Overlap]) cylinder(d=Tube_OD-1.68,h=Len+Overlap*2);
	} // diff
} // AlTube


















