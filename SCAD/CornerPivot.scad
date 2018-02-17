// ************************************************
// Corner Pivot
// by David M. Flynn
// Filename: CornerPivot.scad
// Created: 1/27/2018
// Revision: 1.0.5 2/14/2018
// **********************************************
// History
// 1.0.5 2/14/2018 Stop on any 45 degrees.
// 1.0.4 2/13/2018 Added CornerPivotS(UpperTubeAngle=10,LowerRot=90);
// 1.0.3 2/5/2018 Better servo.
// 1.0.2 2/2/2018 Moved bearing races to BearingLib.scad
// 1.0.1 2/1/2018 Servo top.
// 1.0.0 1/27/2018 Moved from Four Wheel Test Frame 1.0.2
// **********************************************
// for STL output
//
// MotorCover();
// rotate([180,0,0]) Driver(); // goes on the motor shaft with a 5/32" shaft coller.

// CornerPivotUpperSTL();
// translate([-10,0,0]) mirror([1,0,0]) CornerPivotUpperSTL();
// CornerPivotUpperS();

// CornerPivotLowerSTL();
// translate([10,0,0]) mirror([1,0,0]) CornerPivotLowerSTL();

// LowerInnerRace(myFn=360);
// UpperInnerRace(myFn=360);
// OutsideRace(BallCircle_d=CornerPivot_bc, Race_OD=CP_OD, Ball_d=9.525, Race_w=7, nBolts=8, myFn=360) Bolt4ClearHole();
// OutsideRace(BallCircle_d=CornerPivot_bc, Race_OD=CP_OD, Ball_d=9.525, Race_w=5, nBolts=8, myFn=360) Bolt4Hole();
// **********************************************
// for Viewing
// CornerPivotS(UpperTubeAngle=10,LowerRot=90);
// Show_CP();
// **********************************************

include<CommonStuffSAEmm.scad>

include<BearingLib.scad>

include<TubeConnectorLib.scad>
// TubeEll_STL(TubeOD=25.4,Wall_t=0.84,Hole_d=14);
// TubeSection(TubeOD=25.4,Wall_t=0.84, Length=100, Stop_l=TubeStop_l);
// TubeEnd(TubeOD=25.4,Wall_t=0.84,Hole_d=14, GlueAllowance=0.40);
// TubeEll(TubeOD=25.4,Wall_t=0.84,Hole_d=14);

$fn=90;
IDXtra=0.2;
Overlap=0.05;

Tube_OD=25.4;
RaceBoltInset=3.5;
CornerPivot_bc=60;
CP_OD=CornerPivot_bc+26;
CP_ID=CornerPivot_bc-26;
MotorCover_d=32;

module CornerPivotS(UpperTubeAngle=10,LowerRot=90){
	CornerPivotUpperS(Tube_a=UpperTubeAngle);
	
	translate([0,0,-Overlap]) rotate([180,0,22.5]) OutsideRace(BallCircle_d=CornerPivot_bc, Race_OD=CP_OD, Ball_d=9.525, Race_w=7, nBolts=8, myFn=90) Bolt4ClearHole();
	translate([0,0,-7-5-Overlap*2]) rotate([0,0,22.5]) OutsideRace(BallCircle_d=CornerPivot_bc, Race_OD=CP_OD, Ball_d=9.525, Race_w=5, nBolts=8, myFn=360) Bolt4Hole();
	
	translate([0,0,-7-5-Overlap*2]) rotate([0,0,LowerRot]) CornerPivotLower();
} // CornerPivotS

//CornerPivotS(UpperTubeAngle=10,LowerRot=90);

module MotorCover(){
	Motor_h=11.7+30.8+25;
	difference(){
		cylinder(d=MotorCover_d,h=Motor_h);
		
		translate([0,0,2])cylinder(d=MotorCover_d-2,h=Motor_h);
		
		hull(){
			translate([0,0,Motor_h]) rotate([90,0,0])cylinder(d=14,h=MotorCover_d/2+1);
			translate([0,0,Motor_h-10]) rotate([90,0,0])cylinder(d=14,h=MotorCover_d/2+1);
		} // hull
	} // diff
} // MotorCover

//MotorCover();

module CornerPivotUpperM(){
	// This version is for the 25mm gear motor
	Base_h=2;
	nBolts=8;
	TubeStop_y=25;
	
	Motor_d=28;
	Stop_a=45;
	
	translate([0,TubeStop_y,Tube_OD/2+Base_h])rotate([-80,0,0])TubeEnd(TubeOD=25.4,Wall_t=0.84,Hole_d=14, GlueAllowance=0.40);
	
	difference(){
		union(){
			
			translate([0,0,3-Overlap])cylinder(d1=CP_OD-RaceBoltInset*4,d2=40,h=3+Overlap);
			//translate([0,0,6-Overlap])cylinder(d=MotorCover_d-2,h=3);
			
			cylinder(d=CP_OD,h=3);
		}
		
		// motor 
		translate([0,0,4])cylinder(d=Motor_d,h=5);
						
		// Pololu Motor shaft and bolts
		translate([0,0,-Overlap]) cylinder(d=7+IDXtra,h=30);
		translate([8.5,0,-Overlap]) rotate([180,0,0]) Bolt4ButtonHeadHole();
		translate([-8.5,0,-Overlap]) rotate([180,0,0]) Bolt4ButtonHeadHole();
		
		// Outer race bolts
		for (j=[0:nBolts-1]) rotate([0,0,360/nBolts*j+180/nBolts]) translate([(CP_OD)/2-RaceBoltInset,0,3]) 
			 Bolt4ClearHole();
		
		// tube clearance
		translate([0,TubeStop_y,Tube_OD/2+Base_h]) rotate([-80,0,0]) cylinder(d=Tube_OD+IDXtra*2,h=CornerPivot_bc);
		
		// wire path
		translate([0,TubeStop_y,Tube_OD/2+Base_h]) rotate([-80,0,0]) translate([0,0,-15]) cylinder(d=14,h=CornerPivot_bc);
		translate([0,15,-Overlap]) cylinder(d=14,h=14);
		
		// Rotation Stop
		difference(){
			translate([0,0,-Overlap]) cylinder(r=CP_ID/2+RaceBoltInset+2.5,h=3);
			
			translate([0,0,-Overlap*2]){
				cylinder(r=CP_ID/2+RaceBoltInset-2.5,h=3+Overlap*2);
				translate([-(CP_ID/2+RaceBoltInset+2.5+Overlap),0,0])
					cube([(CP_ID/2+RaceBoltInset+2.5+Overlap)*2,CP_ID/2+RaceBoltInset+2.5+Overlap,3+Overlap*2]);
				rotate([0,0,-90-Stop_a-90]) cube([CP_ID/2+RaceBoltInset+2.5+Overlap,CP_ID/2+RaceBoltInset+2.5+Overlap,3+Overlap*2]);
				rotate([0,0,-90+Stop_a]) cube([CP_ID/2+RaceBoltInset+2.5+Overlap,CP_ID/2+RaceBoltInset+2.5+Overlap,3+Overlap*2]);
			}
		} // diff
		
		rotate([0,0,-90-Stop_a]) translate([CP_ID/2+RaceBoltInset,0,-Overlap]) cylinder(d=5,h=3);
		rotate([0,0,-90+Stop_a]) translate([CP_ID/2+RaceBoltInset,0,-Overlap]) cylinder(d=5,h=3);
	} // diff
	
	difference(){
		hull(){
			translate([0,TubeStop_y,Tube_OD/2+Base_h]) rotate([-80+180,0,0])cylinder(d=25.4,h=5);
			translate([0,0,3]) cylinder(d=55,h=1);
		} // hull
		
		// motor
		cylinder(d=MotorCover_d,h=40);
		
		// wire path
		translate([0,TubeStop_y,Tube_OD/2+Base_h]) rotate([-80,0,0]) translate([0,0,-15]) cylinder(d=14,h=CornerPivot_bc);
		translate([0,15,0]) cylinder(d=14,h=13);
	} // diff

} // CornerPivotUpperM

//CornerPivotUpperM();

module CornerPivotUpperSTL(){
	
	difference(){
		rotate([0,90,0]) CornerPivotUpperS();
		translate([-100,-100,-100]) cube([200,200,100]);
	} // diff
} // CornerPivotUpperSTL

//CornerPivotUpperSTL();
//translate([-10,0,0])mirror([1,0,0])CornerPivotUpperSTL();
//translate([0,0,-10.1])rotate([0,0,22.5])Show_CP();

module Servo_MG996R(BottomMount=true,TopAccess=true){
	MG996R_Shaft_Offset=10.25;
	MG996R_BoltSpace=10;
	MG996R_BoltSpace2=48.7;
	MG996R_x=55;
	MG996R_h1=28;
	MG996R_w=20.5;
	MG996R_Body_l=41;
	MG996R_Deck_h=2.7;
	MG996R_TopStep_h=9;
	
	translate([-MG996R_Shaft_Offset,0,0]){
	// body
	if (BottomMount==true){
		translate([-MG996R_x/2,-MG996R_w/2,-MG996R_h1])cube([MG996R_x,MG996R_w,MG996R_h1+Overlap]);
	} else{
	translate([-MG996R_Body_l/2,-MG996R_w/2,-MG996R_h1])cube([MG996R_Body_l,MG996R_w,MG996R_h1+Overlap]);
	}
	
	// top
	if (BottomMount==true){
		translate([-MG996R_x/2,-MG996R_w/2,0])cube([MG996R_x,MG996R_w,MG996R_Deck_h+Overlap]);
		translate([-MG996R_Body_l/2,-MG996R_w/2,MG996R_Deck_h])cube([MG996R_Body_l,MG996R_w,MG996R_TopStep_h+Overlap]);
		hull(){
			translate([-MG996R_x/2,-0.6,MG996R_Deck_h])cube([MG996R_x,1.2,0.01]);
			translate([-MG996R_Body_l/2,-0.6,MG996R_Deck_h+0.9])cube([MG996R_Body_l,1.2,0.01]);
		} // hull
	} else
	if (TopAccess==true){
		translate([-MG996R_x/2,-MG996R_w/2,0])cube([MG996R_x,MG996R_w,19]);
	} else {
	translate([-MG996R_x/2,-MG996R_w/2,0])cube([MG996R_x,MG996R_w,14]);
	}
	
	// Bolt holes
	translate([-MG996R_BoltSpace2/2,MG996R_BoltSpace/2,0]) Bolt4Hole();
	translate([-MG996R_BoltSpace2/2,-MG996R_BoltSpace/2,0]) Bolt4Hole();
	translate([MG996R_BoltSpace2/2,MG996R_BoltSpace/2,0]) Bolt4Hole();
	translate([MG996R_BoltSpace2/2,-MG996R_BoltSpace/2,0]) Bolt4Hole();
		
	if (BottomMount==true){
		translate([-MG996R_BoltSpace2/2,MG996R_BoltSpace/2,0]) rotate([180,0,0])Bolt4Hole();
	translate([-MG996R_BoltSpace2/2,-MG996R_BoltSpace/2,0]) rotate([180,0,0])Bolt4Hole();
	translate([MG996R_BoltSpace2/2,MG996R_BoltSpace/2,0]) rotate([180,0,0])Bolt4Hole();
	translate([MG996R_BoltSpace2/2,-MG996R_BoltSpace/2,0]) rotate([180,0,0])Bolt4Hole();

	} else{
		translate([-MG996R_BoltSpace2/2,MG996R_BoltSpace/2,0]) Bolt4Hole();
	translate([-MG996R_BoltSpace2/2,-MG996R_BoltSpace/2,0]) Bolt4Hole();
	translate([MG996R_BoltSpace2/2,MG996R_BoltSpace/2,0]) Bolt4Hole();
	translate([MG996R_BoltSpace2/2,-MG996R_BoltSpace/2,0]) Bolt4Hole();

	}
	
	if (BottomMount==true){
	translate([MG996R_Shaft_Offset,0,8]) cylinder(d=21.3,h=12);
	} else {
		translate([MG996R_Shaft_Offset,0,0]) cylinder(d=21.3,h=19.6);
	}
	translate([MG996R_Shaft_Offset,0,0]) cylinder(d=9,h=30);
	translate([MG996R_Shaft_Offset,14.5/2,19.6+6]) Bolt4HeadHole();
	translate([MG996R_Shaft_Offset,-14.5/2,19.6+6]) Bolt4HeadHole();
	}
} // Servo_MG996R

//Servo_MG996R(BottomMount=true,TopAccess=false);


module Servo_HS5645MG(BottomMount=true,TopAccess=true){
	Servo_Shaft_Offset=9.85; // this moves double
	Servo_BoltSpace=10;
	Servo_BoltSpace2=48.0;
	Servo_x=53.5;
	Servo_h1=27; // bottom of servo to bottom of mount
	Servo_w=20.0;
	Servo_Body_l=40.5;
	Servo_Deck_h=2.5;
	Servo_TopStep_h=8;
	Servo_TopOfWheel=17.75;
	
	translate([-Servo_Shaft_Offset,0,0]){
	// body
	if (BottomMount==true){
		translate([-Servo_x/2,-Servo_w/2,-Servo_h1])cube([Servo_x,Servo_w,Servo_h1+Overlap]);
	} else{
	translate([-Servo_Body_l/2,-Servo_w/2,-Servo_h1])cube([Servo_Body_l,Servo_w,Servo_h1+Overlap]);
	}
	
	// top
	if (BottomMount==true){
		translate([-Servo_x/2,-Servo_w/2,0])cube([Servo_x,Servo_w,Servo_Deck_h+Overlap]);
		translate([-Servo_Body_l/2,-Servo_w/2,Servo_Deck_h])cube([Servo_Body_l,Servo_w,Servo_TopStep_h+Overlap]);
		hull(){
			translate([-Servo_x/2,-0.7,Servo_Deck_h])cube([Servo_x,1.4,0.01]);
			translate([-Servo_Body_l/2,-0.7,Servo_Deck_h+1.75])cube([Servo_Body_l,1.4,0.01]);
		} // hull
	} else
	if (TopAccess==true){
		translate([-Servo_x/2,-Servo_w/2,0])cube([Servo_x,Servo_w,19]);
	} else {
	translate([-Servo_x/2,-Servo_w/2,0])cube([Servo_x,Servo_w,14]);
	}
	
	// Bolt holes
	translate([-Servo_BoltSpace2/2,Servo_BoltSpace/2,0]) Bolt4Hole();
	translate([-Servo_BoltSpace2/2,-Servo_BoltSpace/2,0]) Bolt4Hole();
	translate([Servo_BoltSpace2/2,Servo_BoltSpace/2,0]) Bolt4Hole();
	translate([Servo_BoltSpace2/2,-Servo_BoltSpace/2,0]) Bolt4Hole();
		
	if (BottomMount==true){
		translate([-Servo_BoltSpace2/2,Servo_BoltSpace/2,0]) rotate([180,0,0])Bolt4Hole();
		translate([-Servo_BoltSpace2/2,-Servo_BoltSpace/2,0]) rotate([180,0,0])Bolt4Hole();
		translate([Servo_BoltSpace2/2,Servo_BoltSpace/2,0]) rotate([180,0,0])Bolt4Hole();
		translate([Servo_BoltSpace2/2,-Servo_BoltSpace/2,0]) rotate([180,0,0])Bolt4Hole();
	} else{
		translate([-Servo_BoltSpace2/2,Servo_BoltSpace/2,0]) Bolt4Hole();
		translate([-Servo_BoltSpace2/2,-Servo_BoltSpace/2,0]) Bolt4Hole();
		translate([Servo_BoltSpace2/2,Servo_BoltSpace/2,0]) Bolt4Hole();
		translate([Servo_BoltSpace2/2,-Servo_BoltSpace/2,0]) Bolt4Hole();
	}
	
	if (BottomMount==true){
		// servo wheel
		translate([Servo_Shaft_Offset,0,Servo_Deck_h+Servo_TopStep_h-Overlap])
			cylinder(d=21.3,h=Servo_TopOfWheel-Servo_Deck_h-Servo_TopStep_h+Overlap);
	} else {
		translate([Servo_Shaft_Offset,0,0]) cylinder(d=21.3,h=19.6);
	}
	translate([Servo_Shaft_Offset,0,0]) cylinder(d=9,h=30);
	translate([Servo_Shaft_Offset,14.5/2,19.6+6]) Bolt4HeadHole();
	translate([Servo_Shaft_Offset,-14.5/2,19.6+6]) Bolt4HeadHole();
	}
} // Servo_HS5645MG

//Servo_HS5645MG(BottomMount=true,TopAccess=true);

module CornerPivotUpperS(Tube_a=10){
	// This version is for a standard r/c servo
	Base_h=2;
	nBolts=8;
	TubeStop_y=25;
	
	Motor_d=28;
	Stop_a=45;
	Servo_h=13;
	
	translate([0,TubeStop_y,Tube_OD/2+Base_h]) rotate([-90+Tube_a,0,0]) TubeEnd(TubeOD=25.4,Wall_t=0.84,Hole_d=14, GlueAllowance=0.40);
	
	difference(){
		union(){
			
			translate([0,0,3-Overlap]) cylinder(d1=CP_OD-RaceBoltInset*4,d2=40,h=3+Overlap);
			//translate([0,0,6-Overlap])cylinder(d=MotorCover_d-2,h=3);
			
			// base
			cylinder(d=CP_OD,h=3);
			
			hull(){
				translate([0,TubeStop_y,Tube_OD/2+Base_h]) rotate([-90+Tube_a+180,0,0]) cylinder(d=25.4,h=5);
				translate([0,0,3]) cylinder(d=55,h=1);
				
				// Servo attachment
				translate([-17.75,-10,3]) cube([0.1,20.0,7.5]);
				translate([36.50,-10,3]) cube([0.1,20.0,7.5]);
			} // hull
		} // union
		
		// Servo
		translate([0,0,Servo_h]) rotate([0,180,0]) Servo_HS5645MG(BottomMount=true,TopAccess=false);
		
		// motor 
		//translate([0,0,4])cylinder(d=Motor_d,h=5);
						
		// Pololu Motor shaft and bolts
		//translate([0,0,-Overlap])cylinder(d=7+IDXtra,h=30);
		//translate([8.5,0,-Overlap])rotate([180,0,0])Bolt4ButtonHeadHole();
		//translate([-8.5,0,-Overlap])rotate([180,0,0])Bolt4ButtonHeadHole();
		
		// Outer race bolts
		for (j=[0:nBolts-1]) rotate([0,0,360/nBolts*j+180/nBolts]) translate([(CP_OD)/2-RaceBoltInset,0,6]) 
			 Bolt4HeadHole();
		
		// tube clearance
		translate([0,TubeStop_y, Tube_OD/2+Base_h]) rotate([-90+Tube_a,0,0]) cylinder(d=Tube_OD+IDXtra*2, h=CornerPivot_bc);
		
		// wire path
		translate([0, TubeStop_y, Tube_OD/2+Base_h]) rotate([-90+Tube_a,0,0]) translate([0,0,-16]) cylinder(d=14, h=CornerPivot_bc);
		hull(){
			translate([0,15,-Overlap]) cylinder(d=14,h=13);
			translate([0,0,-Overlap]) cylinder(d=14,h=13);
		} // hull
		
		// Rotation Stop
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
	} // diff
	
} // CornerPivotUpperS

//CornerPivotUpperS(Tube_a=10);
//CornerPivotUpperS(Tube_a=45);

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

module Driver(){
	// Used with the 25mm gear motor
	Driver_w=9.5;
	
	difference(){
		union(){
			hull(){
				translate([CP_ID/2-Driver_w/2,0,0])cylinder(d=Driver_w,h=4.5+Overlap);
				translate([-CP_ID/2+Driver_w/2,0,0])cylinder(d=Driver_w,h=4.5+Overlap);
			} // hull
			translate([0,0,4.5])
			hull(){
				translate([CP_ID/2-Driver_w/2-1,0,0])cylinder(d=Driver_w+2,h=5);
				translate([-CP_ID/2+Driver_w/2+1,0,0])cylinder(d=Driver_w+2,h=5);
			} // hull
		} // union
		
		// motor shaft
		translate([0,0,-Overlap]) cylinder(d=4+IDXtra,h=10);
		
		// Set screw
		//translate([0,0,4.5+1.5])rotate([0,90,0]) Bolt8Hole();
		
		// 5/32" shaft collar
		translate([0,0,4.5])cylinder(d=7/16*25.4,h=6.35);
		translate([0,0,4.5+0.125*25.4])rotate([0,90,0]) Bolt8Hole();
	} // diff
	
} // Driver

//translate([0,0,0.5+Overlap])rotate([0,0,22.5]) Driver();

module DriverS(){
	// Used with the 25mm gear motor
	Driver_w=9.5;
	BC=21;
	
	difference(){
		union(){
			hull(){
				translate([CP_ID/2-Driver_w/2,0,0])cylinder(d=Driver_w,h=4.5+Overlap);
				translate([-CP_ID/2+Driver_w/2,0,0])cylinder(d=Driver_w,h=4.5+Overlap);
			} // hull
			translate([0,0,4.5])
			hull(){
				translate([CP_ID/2-Driver_w/2-1,0,0])cylinder(d=Driver_w+2,h=3);
				translate([-CP_ID/2+Driver_w/2+1,0,0])cylinder(d=Driver_w+2,h=3);
			} // hull
		} // union
		
		translate([BC/2,0,0])rotate([180,0,0])Bolt4HeadHole();
		translate([-BC/2,0,0])rotate([180,0,0])Bolt4HeadHole();
		// motor shaft
		//translate([0,0,-Overlap]) cylinder(d=4+IDXtra,h=10);
		
		// Set screw
		//translate([0,0,4.5+1.5])rotate([0,90,0]) Bolt8Hole();
		
		// 5/32" shaft collar
		//translate([0,0,4.5])cylinder(d=7/16*25.4,h=6.35);
		//translate([0,0,4.5+0.125*25.4])rotate([0,90,0]) Bolt8Hole();
	} // diff
	
} // DriverS

//translate([0,0,0.5+Overlap])rotate([0,0,22.5]) 
//rotate([180,0,0])DriverS();

module DriverS5645(){
	// Used with the 25mm gear motor
	Driver_w=9.5;
	Driver_l=CP_ID/2-0.5;
	ServoArm_h=7-6.3;
	
	
	BC=21;
	
	difference(){
		union(){
			hull(){
				translate([Driver_l-Driver_w/2,0,0])cylinder(d=Driver_w,h=4.5+Overlap);
				translate([-Driver_l+Driver_w/2,0,0])cylinder(d=Driver_w,h=4.5+Overlap);
			} // hull
			translate([0,0,4.5])
			hull(){
				translate([Driver_l-Driver_w/2-0.5,0,0])cylinder(d=Driver_w+1,h=ServoArm_h);
				translate([-Driver_l+Driver_w/2+0.5,0,0])cylinder(d=Driver_w+1,h=ServoArm_h);
			} // hull
		} // union
		
		translate([BC/2,0,0])rotate([180,0,0])Bolt4HeadHole();
		translate([-BC/2,0,0])rotate([180,0,0])Bolt4HeadHole();
		
		
		// Servo Arm contour
		translate([0,0,4.5+ServoArm_h])
			hull(){
				cube([8.5,Driver_w+3,1.35*2],center=true);
				cube([17.5,Driver_w+3,Overlap],center=true);
		}
	} // diff
	
} // DriverS5645

//rotate([180,0,0])DriverS5645();

module LowerInnerRace(myFn=90){
	nBolts=8;
	// Driver width is 9.5 ( 14.5 - 5 )
	
	difference(){
		union(){
			InsideRace(BallCircle_d=CornerPivot_bc, Race_ID=CP_ID, Ball_d=9.525, Race_w=5, nBolts=nBolts, myFn=myFn) Bolt4ClearHole();
			rotate([0,0,180/nBolts]){
			translate([-CP_ID/2,14.5/2-2.5,0])cube([CP_ID,5,5]);
			translate([-CP_ID/2,-14.5/2-2.5,0])cube([CP_ID,5,5]);}
		} // union
		
		// Rotation Stop
		for (j=[0:nBolts-1]) rotate([0,0,360/nBolts*j+180/nBolts]) 
			translate([CP_ID/2+RaceBoltInset,0,5])
				Bolt4Hole();
		
		//translate([0,14.5/2,0]) rotate([180,0,0])Bolt2HeadHole();
		//translate([0,-14.5/2,0]) rotate([180,0,0])Bolt2HeadHole();
	} // diff
} // LowerInnerRace

//LowerInnerRace(myFn=90);

module UpperInnerRace(myFn=90){
	nBolts=8;
	
	difference(){
		InsideRace(BallCircle_d=CornerPivot_bc, Race_ID=CP_ID, Ball_d=9.525, Race_w=5, nBolts=nBolts, myFn=myFn) 
		translate([0,0,0.5]) Bolt4HeadHole();
			
		// Rotation Stop
		for (j=[0:nBolts-1]) rotate([0,0,360/nBolts*j+180/nBolts]) 
			translate([CP_ID/2+RaceBoltInset,0,5])
				Bolt4Hole();
		
	} // diff
} // UpperInnerRace

//UpperInnerRace(myFn=90);

module Show_CP(){
	nBolts=8;
	
	//translate([0,0,-Overlap])CornerPivotLower();
	rotate([0,0,180/nBolts*7]) LowerInnerRace();
	//rotate([0,0,180/nBolts*9]) translate([0,0,10+Overlap*2]) rotate([180,0,0]) UpperInnerRace(myFn=90);


	//translate([0,0,12+Overlap])rotate([180,0,0])
	//	OutsideRace(BallCircle_d=CornerPivot_bc, Race_OD=CP_OD, Ball_d=9.525, Race_w=7, nBolts=8, myFn=360) Bolt4ClearHole();
	
	//OutsideRace(BallCircle_d=CornerPivot_bc, Race_OD=CP_OD, Ball_d=9.525, Race_w=5, nBolts=8, myFn=90) Bolt4Hole();
	
	translate([0,0,12+Overlap*3]) CornerPivotUpperS();
	
} // Show_CP

//Show_CP();


