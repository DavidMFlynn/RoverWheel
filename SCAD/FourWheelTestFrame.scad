// ************************************************
// Four Wheel Test Frame
// by David M. Flynn
// Created: 1/21/2018
// Revision: 1.0.2 1/25/2018
// **********************************************
// History
// 1.0.2 1/25/2018 RoboClaw Tube Mount
// 1.0.1 1/24/2018 CasterMount, Tube3Junction
// 1.0.0 1/21/2018 First code
// **********************************************
// for STL output
// TubeEll_STL(TubeOD=Tube_OD,Wall_t=0.84,Hole_d=14);
//rotate([0,-90,0])Tube2Pivot(TubeAngle=180,Length=Pivot_OD);
// Tube2PivotCover(Length=Pivot_OD);
// RoboClaw15TubeMount();
// rotate([180,0,0])CasterMount();
// rotate([0,-90,0])Tube3Junction(TubeAngle=150,Length=60,WireExit=75);

//CornerPivotLowerSTL();
//translate([10,0,0])mirror([1,0,0])CornerPivotLowerSTL();
//InsideRace(BallCircle_d=CornerPivot_bc, Race_ID=CP_ID, Ball_d=9.525, Race_w=5, nBolts=8, myFn=90) translate([0,0,1])Bolt4HeadHole();
// LowerInnerRace();
//OutsideRace(BallCircle_d=CornerPivot_bc, Race_OD=CP_OD, Ball_d=9.525, Race_w=7, nBolts=8, myFn=360) Bolt4ClearHole();
//OutsideRace(BallCircle_d=CornerPivot_bc, Race_OD=CP_OD, Ball_d=9.525, Race_w=5, nBolts=8, myFn=360) Bolt4Hole();
// **********************************************

include<CommonStuffSAEmm.scad>
include<RoverWheel.scad>

include<TubeConnectorLib.scad>
// TubeEll_STL(TubeOD=25.4,Wall_t=0.84,Hole_d=14);
// TubeSection(TubeOD=25.4,Wall_t=0.84, Length=100, Stop_l=TubeStop_l);
// TubeEnd(TubeOD=25.4,Wall_t=0.84,Hole_d=14, GlueAllowance=0.40);
// TubeEll(TubeOD=25.4,Wall_t=0.84,Hole_d=14);

$fn=90;
IDXtra=0.2;
Overlap=0.05;

Tube_OD=25.4;
Tire_OD=155;
Tire_w=88;
TubeOffset_X=-Tire_w/2-2-Tube_OD/2;
TubeOffset_Z=WheelMount_OD/2;
Bearing_ID=12.7;
Bearing_OD=28.575;
Bearing_W=7.938;
Pivot_OD=60;
RaceBoltInset=3.5;
CornerPivot_bc=60;
CP_OD=CornerPivot_bc+26;
CP_ID=CornerPivot_bc-26;
YTubeLen=100;

//echo(CP_OD=CP_OD);

module CornerPivotUpper(){
	Base_h=2;
	nBolts=8;
	TubeStop_y=25;
	MotorCover_d=32;
	Motor_d=28;
	
	translate([0,TubeStop_y,Tube_OD/2+Base_h])rotate([-80,0,0])TubeEnd(TubeOD=25.4,Wall_t=0.84,Hole_d=14, GlueAllowance=0.40);
	
	difference(){
		union(){
			
			translate([0,0,3-Overlap])cylinder(d1=CP_OD-RaceBoltInset*4,d2=40,h=3+Overlap);
			//translate([0,0,6-Overlap])cylinder(d=MotorCover_d-2,h=3);
			
			cylinder(d=CP_OD,h=3);
		}
		
		// motor 
		translate([0,0,4])cylinder(d=Motor_d,h=5);
		
		// inner race clearance
		//translate([0,0,-Overlap]) cylinder(d1=CornerPivot_bc+5,d2=CornerPivot_bc,h=1);
		
		// Servo mount
		//translate([0,0,14.5])rotate([180,0,90])Servo_MG996R();
		
		// Pololu Motor shaft and bolts
		translate([0,0,-Overlap])cylinder(d=7+IDXtra,h=30);
		translate([8.5,0,-Overlap])rotate([180,0,0])Bolt4ButtonHeadHole();
		translate([-8.5,0,-Overlap])rotate([180,0,0])Bolt4ButtonHeadHole();
		
		// Outer race bolts
		for (j=[0:nBolts-1]) rotate([0,0,360/nBolts*j+180/nBolts]) translate([(CP_OD)/2-RaceBoltInset,0,3]) 
			 Bolt4ClearHole();
		
		// tube clearance
		translate([0,TubeStop_y,Tube_OD/2+Base_h])rotate([-80,0,0])cylinder(d=Tube_OD+IDXtra*2,h=CornerPivot_bc);
		
		// wire path
		translate([0,TubeStop_y,Tube_OD/2+Base_h])rotate([-80,0,0])translate([0,0,-15])cylinder(d=14,h=CornerPivot_bc);
		translate([0,15,-Overlap])cylinder(d=14,h=20);
	} // diff
	difference(){
		hull(){
			translate([0,TubeStop_y,Tube_OD/2+Base_h])rotate([-80+180,0,0])cylinder(d=25.4,h=5);
			translate([0,0,3]) cylinder(d=55,h=1);
			
		} // hull
		
		// motor
		cylinder(d=MotorCover_d,h=40);
		
		// wire path
		translate([0,TubeStop_y,Tube_OD/2+Base_h])rotate([-80,0,0])translate([0,0,-15])cylinder(d=14,h=CornerPivot_bc);
		translate([0,15,0])cylinder(d=14,h=15);
	} // diff
} // CornerPivotUpper

//CornerPivotUpper();

module CornerPivotUpperSTL(){
	
	difference(){
		rotate([0,90,0]) CornerPivotUpper();
		translate([-100,-100,-100]) cube([200,200,100]);
	} // diff
} // CornerPivotUpperSTL

//CornerPivotUpperSTL();
//translate([-10,0,0])mirror([1,0,0])CornerPivotUpperSTL();


//translate([0,0,-10.1])rotate([0,0,22.5])Show_CP();

module CornerPivotLower(){
	Base_h=6;
	nBolts=8;
	
	difference(){
		union(){
			translate([0,0,-1-Overlap]) cylinder(d=CornerPivot_bc-7,h=1);
			translate([0,0,-Base_h]) cylinder(d1=CornerPivot_bc-10,d2=CornerPivot_bc+12,h=Base_h-1);
			translate([0,0,-2-Overlap]) cylinder(d=CornerPivot_bc+12,h=1);
			
			hull(){
				translate([0,0,-Base_h]) cylinder(d=CornerPivot_bc-10,h=0.1);
				translate([0,0,-Tube_OD/2-Base_h])rotate([90,0,0]) cylinder(d=Tube_OD,h=4);
			} // hull
		} // union
		
		// Bolts
		for (j=[0:nBolts-1]) rotate([0,0,360/nBolts*j+180/nBolts]) translate([CP_ID/2+RaceBoltInset,0,0])
			Bolt4Hole(depth=8);
		
		// tube clearance
		translate([0,0,-Tube_OD/2-Base_h])rotate([-90,0,0])cylinder(d=Tube_OD+IDXtra*2,h=CornerPivot_bc);
		translate([-CornerPivot_bc/2,2,-Tube_OD-Base_h-2]) //cube([CornerPivot_bc,CornerPivot_bc,Tube_OD-4]);
			hull(){
				rotate([0,90,0]) cylinder(d=4,h=CornerPivot_bc);
				translate([0,0,Tube_OD])rotate([0,90,0]) cylinder(d=4,h=CornerPivot_bc);
				translate([0,CornerPivot_bc,Tube_OD])rotate([0,90,0]) cylinder(d=4,h=CornerPivot_bc);
				
			} // hull
		
		// wire path
		translate([0,Overlap,-Tube_OD/2-Base_h])rotate([90,0,0])cylinder(d=14,h=7);
		
		hull(){
			translate([0,-CP_ID/2+7,-Tube_OD/2-Base_h+5])cylinder(d=14,h=Tube_OD/2+Base_h+Overlap);
			translate([0,-7,-Tube_OD/2-Base_h])rotate([90,0,0])cylinder(d=14,h=0.1);
		} // hull
	} // diff
	
	translate([0,0,-Tube_OD/2-Base_h])rotate([-90,0,0])TubeEnd(TubeOD=25.4,Wall_t=0.84,Hole_d=14, GlueAllowance=0.40);
} // CornerPivotLower

//CornerPivotLower();
module CornerPivotLowerSTL(){
	
	difference(){
		rotate([0,90,0])CornerPivotLower();
		translate([-100,-100,-100]) cube([200,200,100]);
	} // diff
} // CornerPivotLowerSTL

//CornerPivotLowerSTL();
//translate([10,0,0])mirror([1,0,0])CornerPivotLowerSTL();

module Servo_MG996R(){
	MG996R_Shaft_Offset=9;
	MG996R_BoltSpace=10;
	MG996R_BoltSpace2=48.7;
	MG996R_x=55;
	MG996R_h1=28;
	MG996R_w=20.5;
	MG996R_Body_l=41;
	
	translate([-MG996R_Shaft_Offset,0,0]){
	// body
	translate([-MG996R_Body_l/2,-MG996R_w/2,-MG996R_h1])cube([MG996R_Body_l,MG996R_w,MG996R_h1]);
	
	// top
	translate([-MG996R_x/2,-MG996R_w/2,0])cube([MG996R_x,MG996R_w,14]);
	
	// Bolt holes
	translate([-MG996R_BoltSpace2/2,MG996R_BoltSpace/2,0]) Bolt4Hole();
	translate([-MG996R_BoltSpace2/2,-MG996R_BoltSpace/2,0]) Bolt4Hole();
	translate([MG996R_BoltSpace2/2,MG996R_BoltSpace/2,0]) Bolt4Hole();
	translate([MG996R_BoltSpace2/2,-MG996R_BoltSpace/2,0]) Bolt4Hole();
	
	translate([MG996R_Shaft_Offset,0,0]) cylinder(d=21.3,h=19.6);
	translate([MG996R_Shaft_Offset,0,0]) cylinder(d=9,h=30);
	translate([MG996R_Shaft_Offset,14.5/2,19.6+6]) Bolt4HeadHole();
	translate([MG996R_Shaft_Offset,-14.5/2,19.6+6]) Bolt4HeadHole();
	}
} // Servo_MG996R

//Servo_MG996R();

module LowerInnerRace(){
	InsideRace(BallCircle_d=CornerPivot_bc, Race_ID=CP_ID, Ball_d=9.525, Race_w=5, nBolts=8, myFn=90) Bolt4ClearHole();
	
	difference(){
		union(){
			translate([-CP_ID/2,14.5/2-3.5,0])cube([CP_ID,7,5]);
			translate([-CP_ID/2,-14.5/2-3.5,0])cube([CP_ID,7,5]);
		} // union
		
		translate([0,14.5/2,0]) rotate([180,0,0])Bolt2HeadHole();
		translate([0,-14.5/2,0]) rotate([180,0,0])Bolt2HeadHole();
	} // diff
} // LowerInnerRace

//LowerInnerRace();

module Show_CP(){
	
	//CornerPivotLower();
LowerInnerRace();
translate([0,0,10+Overlap])rotate([180,0,0])InsideRace(BallCircle_d=CornerPivot_bc, Race_ID=CP_ID, Ball_d=9.525, Race_w=5, nBolts=8, myFn=90) translate([0,0,1])Bolt4HeadHole();


//translate([0,0,10+Overlap])rotate([180,0,0])OutsideRace(BallCircle_d=CornerPivot_bc, Race_OD=CP_OD, Ball_d=9.525, Race_w=5, nBolts=8, myFn=90) Bolt4ClearHole();
//OutsideRace(BallCircle_d=CornerPivot_bc, Race_OD=CP_OD, Ball_d=9.525, Race_w=5, nBolts=8, myFn=90) Bolt4Hole();
} // Show_CP

//Show_CP();

module InsideRace(BallCircle_d=100, Race_ID=50, Ball_d=9.525, Race_w=5, nBolts=8, myFn=360){
	
	difference(){
		cylinder(d=BallCircle_d-7,h=Race_w);
		
		// center hole
		translate([0,0,-Overlap]) cylinder(d=Race_ID,h=Race_w+Overlap*2);
		
		// ball track
		translate([0,0,Race_w])
		rotate_extrude(convexity = 10,$fn=myFn)
			translate([BallCircle_d/2, 0, 0]) circle(d = Ball_d);
		
		// wire path
		//for (j=[0:nBolts-1]) rotate([0,0,360/nBolts*(j+0.5)]) translate([Race_ID/2-5,0,-Overlap]) 
		//	cylinder(d=15,h=Race_w+Overlap*2);
		
		// Bolts
		for (j=[0:nBolts-1]) rotate([0,0,360/nBolts*j]) translate([Race_ID/2+RaceBoltInset,0,0])
			rotate([180,0,0]) children();
			
	} // diff
} // InsideRace

//InsideRace(BallCircle_d=CornerPivot_bc, Race_ID=CP_ID, Ball_d=9.525, Race_w=5, nBolts=8, myFn=90) Bolt4ClearHole();

module OutsideRace(BallCircle_d=60, Race_OD=150, Ball_d=9.525, Race_w=5, nBolts=8, myFn=360){
	
	difference(){
		cylinder(d=Race_OD,h=Race_w);
		
		// center hole
		translate([0,0,-Overlap]) cylinder(d=BallCircle_d+7,h=Race_w+Overlap*2);
		
		// Bolts
		for (j=[0:nBolts-1]) rotate([0,0,360/nBolts*j]) translate([Race_OD/2-RaceBoltInset,0,0]) 
			 rotate([180,0,0]) children();
		
		translate([0,0,Race_w])
			rotate_extrude(convexity = 10,$fn=myFn)
				translate([BallCircle_d/2, 0, 0]) circle(d = Ball_d);
		
	} // diff
} // OutsideRace

//OutsideRace(BallCircle_d=CornerPivot_bc, Race_OD=CP_OD, Ball_d=9.525, Race_w=5, nBolts=8, myFn=90) Bolt4ClearHole();
//translate([0,0,10+Overlap])rotate([180,0,0])OutsideRace(BallCircle_d=CornerPivot_bc, Race_OD=CP_OD, Ball_d=9.525, Race_w=5, nBolts=8, myFn=90) Bolt4ButtonHeadHole();

module RoboClaw15TubeMount(){
	TM_h=8;
	RC_BoltSpace=46;
	RC_Spacer_h=4;
	
	difference(){
		union(){
			cylinder(d=Tube_OD+4,h=TM_h);
			translate([-(RC_BoltSpace+8)/2,Tube_OD/2-6,0]) cube([RC_BoltSpace+8,6,TM_h]);
			
			// Spacers
			translate([RC_BoltSpace/2,Tube_OD/2+RC_Spacer_h,TM_h/2])rotate([90,0,0])hull()
			{
				cylinder(d=7,h=RC_Spacer_h+Overlap);
				translate([3,-TM_h/2,0])cube([1,TM_h/2+3.5,7]);
				translate([-3.5,-TM_h/2,0])cube([TM_h/2+3.5,1,7]);
			}
			mirror([1,0,0])
			translate([RC_BoltSpace/2,Tube_OD/2+RC_Spacer_h,TM_h/2])rotate([90,0,0])hull()
			{
				cylinder(d=7,h=RC_Spacer_h+Overlap);
				translate([3,-TM_h/2,0])cube([1,TM_h/2+3.5,7]);
				translate([-3.5,-TM_h/2,0])cube([TM_h/2+3.5,1,7]);
			}

		} // union
		
		// Tube cut
		translate([-10,0,-Overlap]) cube([20,20,TM_h+Overlap*2]);
		
		// Bolts
		translate([RC_BoltSpace/2,Tube_OD/2+RC_Spacer_h,TM_h/2])rotate([-90,0,0])  Bolt4Hole();
		translate([-RC_BoltSpace/2,Tube_OD/2+RC_Spacer_h,TM_h/2])rotate([-90,0,0])  Bolt4Hole();
		
		// Tube
		translate([0,0,-Overlap]) cylinder(d=Tube_OD+IDXtra,h=TM_h+Overlap*2);
	} // diff
	
} // RoboClaw15TubeMount

//RoboClaw15TubeMount();


module PhantomWheel(){
	
	translate([-Tire_w/2+(WheelMount_l-2),0,0])rotate([0,-90,0])WheelMount();
	translate([-Tire_w/2-2.1,0,0])rotate([0,-90,0])TubeConnector();
	// tire
	rotate([0,-90,0])
	difference(){
		cylinder(d=Tire_OD,h=Tire_w,center=true,$fn=36);
		cylinder(d=Tire_OD-2,h=Tire_w+Overlap*2,center=true,$fn=36);
	} // diff
} // PhantomWheel

module OneCorner(){
	PhantomWheel();
	translate([TubeOffset_X,0,TubeOffset_Z]){
		color("LightGray")TubeSection(TubeOD=Tube_OD,Wall_t=0.84, Length=50);
		
		translate([0,0,50+Tube_OD/2]){
			rotate([-90,-90,0])rotate([0,0,90]) TubeEll(TubeOD=Tube_OD,Wall_t=0.84,Hole_d=14);
			
			translate([0,Tube_OD/2,0])rotate([-90,0,0])color("LightGray")TubeSection(TubeOD=Tube_OD,Wall_t=0.84, Length=YTubeLen);
		}
		
	}
} // OneCorner


//OneCorner();
//translate([TubeOffset_X,YTubeLen+Pivot_OD/2+Tube_OD/2,TubeOffset_Z+50+Tube_OD/2])rotate([90,0,0]) Tube2Pivot(TubeAngle=180,Length=Pivot_OD);
//translate([0,(YTubeLen+Pivot_OD/2+Tube_OD/2)*2,0])mirror([0,1,0])OneCorner();


module CasterMount(){
	CasterPost_d=11.0;
	CasterPost_h=32;
	TubeAngle=75;

	difference(){
		union(){
		translate([0,0,CasterPost_h-Tube_OD/2])rotate([TubeAngle,0,0])translate([0,0,18.1])TubeEnd(TubeOD=Tube_OD,Wall_t=0.84,Hole_d=14, Stop_l=13);
		cylinder(d=28,h=CasterPost_h+10);
		} // union
		
		translate([0,0,-Overlap])cylinder(d=CasterPost_d+IDXtra,h=CasterPost_h+2);
		translate([0,0,CasterPost_h*0.75])cylinder(d=CasterPost_d+1,h=CasterPost_h*0.25+2);
	} // diff
	
} // CasterMount

//rotate([180,0,0])CasterMount();

module Tube3Junction(TubeAngle=150,Length=60,WireExit=-105){
	nBolts=6;
	
	difference(){
		union(){
			translate([0,0,Length/2])TubeEnd(TubeOD=Tube_OD,Wall_t=0.84,Hole_d=14, Stop_l=6);
			rotate([TubeAngle,0,0])translate([0,0,Length/2])TubeEnd(TubeOD=Tube_OD,Wall_t=0.84,Hole_d=14, Stop_l=6);
			rotate([TubeAngle/2-180,0,0])translate([0,0,Length/2])TubeEnd(TubeOD=Tube_OD,Wall_t=0.84,Hole_d=14, Stop_l=6);
		} // union
		
		rotate([0,90,0])cylinder(d=Length-1,h=Tube_OD+Overlap*2,center=true);
	} // diff
	
	rotate([0,90,0])
	difference(){
		cylinder(d=Length,h=Tube_OD,center=true);
		
		cylinder(d=Bearing_OD-2,h=Tube_OD+Overlap*2,center=true);
		
		// Bearing
		translate([0,0,-Tube_OD/2+2]) cylinder(d=Bearing_OD+IDXtra,h=Tube_OD);
		//translate([0,0,-Tube_OD/2+2+Bearing_W]) cylinder(d=Bearing_OD+10,h=Tube_OD);
		
		// Wire Exit
		if (WireExit!=0){
			rotate([0,-90,0]) rotate([WireExit,0,0])translate([0,0,Length/2-7]) cylinder(d=14,h=8);
		}
		
		// wire path
		difference(){
			translate([0,0,-Tube_OD/2+3]) cylinder(d=Length-6,h=Tube_OD);
			translate([0,0,-Tube_OD/2+3-Overlap]) cylinder(d=Bearing_OD+6,h=Tube_OD+Overlap*2);
		} // diff
		
		rotate([0,-90,0]) translate([0,0,Length/2-7]) cylinder(d=14,h=8);
		rotate([0,-90,0]) rotate([TubeAngle,0,0])translate([0,0,Length/2-7]) cylinder(d=14,h=8);
	} // diff
	
	// bolts
	for (j=[0:nBolts-1]) rotate([360/nBolts*j,0,0]) translate([-Tube_OD/2,0,Bearing_OD/2+4.5]) rotate([0,90,0])
		difference(){
			cylinder(d=7,h=Tube_OD);
			translate([0,0,Tube_OD])Bolt4Hole();
		} // diff
	
} // Tube3Junction

//rotate([0,-90,0])Tube3Junction(TubeAngle=150,Length=60,WireExit=75);

































