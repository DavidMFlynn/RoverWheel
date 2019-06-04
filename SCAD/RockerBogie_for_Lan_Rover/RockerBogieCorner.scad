// **********************************************
// Rocker Bogie for Lan's Rover
// Corner pivot
// Filename: RockerBogieCorner.scad
// by David M. Flynn
// Created: 3/24/2019
// Revision: 1.0.3 4/21/2019
// Units: mm
// **********************************************
// History
// 1.0.3 4/21/2019 Corner STLs
// 1.0.2 4/7/2019 Changed preload from -0.2 to 0.0, was too loose.
// 1.0.1 3/25/2019 Changed offset of balls in upper race 0.7mm,
//   upper/lower races both 0.3mm for 12.6mm upper to lower space.
// 1.0.0 3/24/2019 Moved corner pivot to its own file.
// **********************************************
//  ***** for STL output *****
// MotorCoverTop();
// rotate([180,0,0]) MotorCover();
//
// UpperCorner(TubeOD=Tube_OD,Hole_d=TubeEnd_ID,GlueAllowance=0.4,TConn_a=10,IsLeft=true); // 10° up for rear wheels, fc1
// UpperCorner(TubeOD=Tube_OD,Hole_d=TubeEnd_ID,GlueAllowance=0.4,TConn_a=10,IsLeft=false); // 10° up for rear wheels, fc1
//
// UpperCorner(TubeOD=Tube_OD,Hole_d=TubeEnd_ID,GlueAllowance=0.4,TConn_a=0,IsLeft=true); // front wheels, fc1
// UpperCorner(TubeOD=Tube_OD,Hole_d=TubeEnd_ID,GlueAllowance=0.4,TConn_a=0,IsLeft=false); // front wheels, fc1
//
// UpperCornerRace(myFn=360); // Front Right/Rear Left
// mirror([0,1,0]) UpperCornerRace(myFn=360); // Front Left/Rear Right
//
// CornerAccesCover();
//
// LowerCornerSkirt(TubeOD=Tube_OD,Stop1_a=-10); // Front Right/Rear Left
// LowerCornerSkirt(TubeOD=Tube_OD,Stop1_a=10); // Front Left/Rear Right
//
// GluingFixture(); // connects Lower corner pivot lower to wheel mount
// rotate([180,0,0]) LowerCornerLower(TubeOD=Tube_OD,Hole_d=TubeEnd_ID,GlueAllowance=0.4,myFn=360); // Front Right/Rear Left
// mirror([0,1,0]) rotate([180,0,0]) LowerCornerLower(TubeOD=Tube_OD,Hole_d=TubeEnd_ID,GlueAllowance=0.4,myFn=360); // Front Left/Rear Right
// LowerCornerInnerRace(myFn=360);
// DriveSpline();
// **********************************************
//  ***** for Viewing *****
// ShowCornerPivotExpanded(myFn=180);
// ShowCornerPivot(myFn=24);
// **********************************************
//  ***** Tools *****
// GluingFixture();  // Wheel mount to LowerCornerLower()
// rotate([90,0,0]) translate([0,49,0]) FrontGluingFixture(); // Tube flange to UpperCorner(TConn_a=10);
// **********************************************

include<CommonStuffSAEmm.scad>
include<RoverWheel.scad>
include<BearingLib.scad>
include<TubeConnectorLib.scad>

//$fn=24; // faster viewing
$fn=180; // for production
IDXtra=0.2;
Overlap=0.05;

Tube_OD=38.1; //38.1; //25.4;
Wall_t=0.84;
TubeEnd_ID=Tube_OD-Wall_t*2-8;
Tire_OD=155;
Tire_w=88;
TubeOffset_X=-Tire_w/2-Tube_OD/2-1;
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

LR_RoverWidth=460;  // to center of middle wheels
LR_RoverLen=600; // wheelbase
LR_WheelStager=60;

Ball_d=0.3125*25.4;
BallCircle_d=64;
CornerRace_OD=BallCircle_d+Ball_d+16;
CornerRace_ID=BallCircle_d-Ball_d-22;
Corner_OD=CornerRace_OD+40;
BearingPreload=0.0; // -0.2 is too loose
CornerSpline_d=30;
nCornerSplines=5;

MotorOD=40;
MotorLen=107;
MotorCoverOD=MotorOD+3.5;

// Main pivot values
MainPivot_d=90;
MP_Ring_h=Tube_OD+30;
MP_Ball_d=0.375*25.4;
MP_Ring_BC_d=MainPivot_d-MP_Ball_d-10;
MP_Ring_Tilt_a=20+18; // 18 = no motion
//echo(MP_Ring_BC_d=MP_Ring_BC_d);

module ShowCornerPivotExpanded(myFn=24){
	translate([0,0,220]) color("Silver") MotorCoverTop();
	translate([0,0,110]) rotate([0,0,90]) color("Silver") MotorCover();
	translate([0,0,70]) UpperCorner(TConn_a=0); 
	translate([0,0,50]) UpperCornerRace(myFn=myFn);
	translate([0,0,30]) color("Gray") LowerCornerInnerRace(myFn=myFn);
	translate([0,0,20+12]) color("Pink") CornerAccesCover();
	translate([0,0,15]) color("Green") LowerCornerSkirt(TubeOD=Tube_OD);
	translate([0,0,-3]) color("LightBlue") LowerCornerLower(TubeOD=Tube_OD,Hole_d=TubeEnd_ID,GlueAllowance=0.4,myFn=myFn);
	translate([0,0,-30]) color("Tan") DriveSpline();
} // ShowCornerPivotExpanded

//ShowCornerPivotExpanded();

module ShowCornerPivot(myFn=24){
	rotate([0,0,90]){
	translate([0,0,120]) color("Silver") MotorCoverTop();
	translate([0,0,20]) rotate([0,0,90]) color("Silver") MotorCover();
	translate([0,0,12+Overlap]) UpperCorner(TConn_a=10,IsLeft=false); 
	}
	//translate([0,0,50]) UpperCornerRace(myFn=myFn);
	//translate([0,0,30]) color("Gray") LowerCornerInnerRace(myFn=myFn);
	translate([0,0,9.5+Overlap]) color("Green") CornerAccesCover();
	translate([0,0,0]) color("Green") LowerCornerSkirt(TubeOD=Tube_OD);
	translate([0,0,-3]) color("LightBlue") LowerCornerLower(TubeOD=Tube_OD,Hole_d=TubeEnd_ID,GlueAllowance=0.4,myFn=myFn);
	translate([0,0,-3]) color("Tan") DriveSpline();
} // ShowCornerPivot

// ShowCornerPivot(myFn=24);

//UpperCorner(TubeOD=Tube_OD,Hole_d=TubeEnd_ID,GlueAllowance=0.4,TConn_a=0);

module UpperCorner(TubeOD=Tube_OD,Hole_d=TubeEnd_ID,GlueAllowance=0.4,TConn_a=10,IsLeft=true){
	Base_h=3;

	MotorNose_d=20;
	MotorBC_d=26;
	nBolts=8;
	
	TubeOffset_z=TConn_a/30; 
	TubeOffset_y= IsLeft==true ? -37:37; // right rear 37, Right front -37
	TubeOffset_x=0;
	MotorWire_a= IsLeft==true ? -45:45; // right rear 45, Right front -45
	
	translate([Corner_OD/2+TubeOffset_x,TubeOffset_y,TubeOffset_z]) rotate([0,90-TConn_a,0])
		translate([-TubeOD/2,0,0]) TubeEnd(TubeOD=TubeOD,Wall_t=Wall_t,Hole_d=Hole_d, GlueAllowance=GlueAllowance);
	
	difference(){
		hull(){
			translate([0,0,0]) cylinder(d=Corner_OD,h=Base_h);
			
			translate([Corner_OD/2+TubeOffset_x,TubeOffset_y,TubeOffset_z]) rotate([0,90-TConn_a,0])
				translate([-TubeOD/2,0,0]) rotate([0,180,0]) cylinder(d=TubeOD,h=2);
		} // hull
		
		// Tube Clearance
		translate([Corner_OD/2+TubeOffset_x,TubeOffset_y,TubeOffset_z]) rotate([0,90-TConn_a,0])
				translate([-TubeOD/2,Overlap,0])  cylinder(d=TubeOD+1,h=30);
		
		// wire path
		hull(){
			translate([Corner_OD/2,TubeOffset_y,TubeOffset_z]) rotate([0,90-TConn_a,0])
				translate([-TubeOD/2,0,0]) rotate([0,180,0]) translate([0,0,-1]) cylinder(d=TubeEnd_ID,h=1);
		
			rotate([0,0,MotorWire_a]){
			// motor wires
			translate([MotorCoverOD/2-4,3,Base_h+11]) rotate([0,90,0]) cylinder(d=17,h=1);
			translate([MotorCoverOD/2-4,-3,Base_h+11]) rotate([0,90,0]) cylinder(d=17,h=1);}
			
			// Drive motor wires
			rotate([0,0,MotorWire_a]) translate([Corner_OD/2-2-10,0,Base_h]) cylinder(d=20-Base_h,h=TubeOD/2);
		}
		
		// Drive motor wires
		rotate([0,0,MotorWire_a]) translate([Corner_OD/2-2-10,0,-Overlap]) cylinder(d=20,h=TubeOD/2);
		
		
		
		// ball insertion hole
		//translate([0,BallCircle_d/2,0]) cylinder(d=Ball_d+1,h=Race_h+Base_h+TubeOD);
		
		//motor
		translate([0,0,-Overlap]) cylinder(d=MotorNose_d+IDXtra,h=6);
		translate([0,0,5])	cylinder(d=MotorCoverOD,h=40);
		
		for (j=[0:3]) rotate([0,0,360/4*j+45]) translate([MotorBC_d/2,0,0]) rotate([180,0,0]) Bolt4ButtonHeadHole();
			
		// bearing race bolts
		for (j=[0:nBolts-1]) rotate([0,0,360/nBolts*j+180/nBolts]) translate([CornerRace_OD/2-4,0,8]) Bolt4HeadHole(depth=8,lHead=40);
	} // diff
	
	
} // UpperCorner

//translate([0,0,4]) 
//UpperCorner();
//UpperCorner(TConn_a=10);


module MotorCover(){
	nRidges=12;
	
	difference(){
		union(){
			cylinder(d=MotorCoverOD,h=MotorLen-7);
			
			for (j=[0:nRidges-1]) rotate([0,0,360/nRidges*j]) hull(){
				translate([MotorCoverOD/2-1,0,26]) sphere(d=5);
				translate([MotorCoverOD/2-1,0,MotorLen-10]) sphere(d=5);
			}
		} // union
		
		translate([0,0,-Overlap]) cylinder(d=MotorOD,h=MotorLen);
		
		// wire path
		hull(){
			translate([0,0,-Overlap]) rotate([90,0,0]) cylinder(d=20,h=MotorOD);
			translate([0,0,9]) rotate([90,0,0]) cylinder(d=20,h=MotorOD);
		} // hull
	} // diff
	
	difference(){
		union(){
			translate([0,0,MotorLen-9]) cylinder(d=MotorOD+Overlap,h=2);
			translate([0,0,MotorLen-9]) cylinder(d=MotorOD,h=4);
		} // union
		
		translate([0,0,MotorLen-9-Overlap]) cylinder(d1=MotorOD,d2=MotorOD-3.5,h=2);
		translate([0,0,MotorLen-9-Overlap]) cylinder(d=MotorOD-3.5,h=5);
	} // diff
} // MotorCover

//rotate([180,0,0]) MotorCover();

module MotorCoverTop(){
	CS=2;
	
	difference(){
			union(){
				cylinder(d=24,h=12);
				translate([0,0,2])scale([CS,CS,1]) sphere(d=MotorCoverOD/2);
				cylinder(d=MotorCoverOD,h=2);
			} // union
			
			translate([0,0,-2]) {
				cylinder(d=MotorCoverOD-3.5,h=5);
				cylinder(d=28,h=7);
				cylinder(d=24-2.5,h=10);
				scale([CS-0.2,CS-0.2,1]) sphere(d=MotorCoverOD/2);
			}
			
			rotate([180,0,0]) cylinder(d=MotorCoverOD+Overlap*2,h=15);
		} // diff
} // MotorCoverTop

//translate([0,0,MotorLen-7]) 
//MotorCoverTop();

module UpperCornerRace(myFn=24){
	nBolts=8;
	Race_h=12;
	Stop1_a=74;
	Stop2_a=-80;
	Vert_Offset=-0.3; // overal bearing height = Race_h + 2 * Vert_Offset
	
	module RotStop(){
	// rotation stop
		hull(){
			translate([CornerRace_OD/2+8,0,0]) cylinder(d=3,h=Race_h+Overlap);
			translate([CornerRace_OD/2-1,-2.5,0]) cube([0.1,5,Race_h]);
		}
	} // RotStop
	
	rotate([0,0,Stop1_a]) RotStop();
	rotate([0,0,Stop2_a]) RotStop();
	
	// wire tray
	difference(){
		cylinder(d=CornerRace_OD+20,h=Race_h);
		
		translate([0,0,2]) cylinder(d=CornerRace_OD+16,h=Race_h);
		rotate([0,0,Stop2_a]) translate([-CornerRace_OD/2-16,0,-Overlap]) cube([CornerRace_OD*2,CornerRace_OD,Race_h+Overlap*2]);
		translate([-CornerRace_OD/2-16,0,-Overlap]) cube([CornerRace_OD*2,CornerRace_OD,Race_h+Overlap*2]);
		translate([0,0,-Overlap]) cylinder(d=CornerRace_OD-1,h=Race_h+Overlap*2);
	} // diff
	
	difference(){
		OnePieceOuterRace(BallCircle_d=BallCircle_d, Race_OD=CornerRace_OD, Ball_d=Ball_d, Race_w=Race_h, PreLoadAdj=BearingPreload,
			VOffset=Vert_Offset, BI=true, myFn=myFn);
		
		for (j=[0:nBolts-1]) rotate([0,0,360/nBolts*j+22.5]) translate([CornerRace_OD/2-4,0,Race_h]) Bolt4Hole();
	} // diff
} // UpperCornerRace

//translate([0,0,4]) rotate([0,0,0]) UpperCornerRace(myFn=40); // range 66..-80

module LowerCornerSkirt(TubeOD=Tube_OD,Stop1_a=-10){
	Base_h=3;
	Race_h=12;
	
	Rounder=12;
	CornerWall_t=1.5;
	
	
	module RotStop(){
		Base_w=8;
		difference(){
		hull(){
			translate([Corner_OD/2-15,0,0]) cylinder(d=3,h=Race_h);
			translate([Corner_OD/2-1,-Base_w/2,0]) cube([0.1,Base_w,Race_h]);
		} // hull
		// rotation stop Bolt
		rotate([0,0,3.75]) translate([Corner_OD/2-4.5,-Base_w/2,Race_h]) Bolt4HeadHole(depth=15);
	
	} // diff
	}
	
	// rotation stops
	rotate([0,0,Stop1_a]) RotStop();
	//rotate([0,0,-Stop1_a]) RotStop();
	//rotate([0,0,Stop2_a]) RotStop();
	
	module BossBolt(Offset=1){
		translate([Corner_OD/2+Offset,0,0]) rotate([180,0,0]) Bolt4Hole(depth=7);
	} // BossBoltLoc
	
	module BoltBoss(Offset=1){
		Boss_d=6;
		
		translate([Corner_OD/2+Offset,0,0])
		difference(){
			hull(){
				
				translate([0,0,7]) sphere(d=Boss_d);
				
				cylinder(d=Boss_d,h=7);
				translate([-Offset-0.5,-Boss_d/2,0]) cube([0.5,Boss_d,7]);
				
			} // hull
			rotate([180,0,0]) Bolt4Hole(depth=7);
		} // diff
	} // BoltBoss
	
	//BoltBoss();
	nSkirtBolts=8;
	
	difference(){
		union(){
			hull(){
				translate([TubeOffset_X,0,0]) cylinder(d=TubeOD,h=Race_h);
				cylinder(d=Corner_OD,h=Race_h);
			} // hull
			
			for (j=[0:nSkirtBolts-1]) rotate([0,0,360/nSkirtBolts*j]) BoltBoss();
			
		} // union
		// wire path
		translate([TubeOffset_X,0,-Overlap]) cylinder(d=TubeEnd_ID,h=Race_h+Overlap*2);
		
		hull(){
			translate([-Corner_OD/2+10,0,-Overlap]) cylinder(d=TubeEnd_ID,h=Race_h+Overlap*2);
			translate([TubeOffset_X,0,-Overlap]) cylinder(d=TubeEnd_ID,h=Race_h+Overlap*2);
		} // hull
			
		//hull(){
			translate([0,0,-Overlap]) cylinder(d=Corner_OD-CornerWall_t*2,h=Race_h+Overlap*2);
			//translate([TubeOffset_X,0,Base_h+Overlap]) cylinder(d=TubeEnd_ID,h=Race_h+Overlap*2);
		//} // hull
		
		// inspection plate bolt holes
		translate([TubeOffset_X-2,TubeEnd_ID/2+4,Race_h]) Bolt4ClearHole();
		translate([TubeOffset_X-2,-TubeEnd_ID/2-4,Race_h]) Bolt4ClearHole();
		
		for (j=[0:nSkirtBolts-1]) rotate([0,0,360/nSkirtBolts*j]) BossBolt();
	
		Cover_t=2.5;
		
		translate([0,0,Race_h-Cover_t])
		difference(){
			hull(){
				translate([TubeOffset_X,0,0]) cylinder(d=TubeOD+Overlap,h=Cover_t+Overlap);
				cylinder(d=Corner_OD+Overlap,h=Cover_t);
			} // hull			
			
			translate([0,0,-Overlap]) cylinder(d=Corner_OD,h=Base_h+Overlap*2);
			
		} // diff	
	
	} // diff	
} // LowerCornerSkirt

//rotate([180,0,0]) 
//translate([-TubeOffset_X-Tube_OD/2-1,0,95]) 
//translate([0,0,3+Overlap]) LowerCornerSkirt();
//rotate([0,-90,0])TubeConnector(Tube_OD=Tube_OD);

module CornerAccesCover(TubeOD=Tube_OD){
	Base_h=2.5;
	
	difference(){
		hull(){
			translate([TubeOffset_X,0,0]) cylinder(d=TubeOD,h=Base_h);
			cylinder(d=Corner_OD,h=Base_h);
		} // hull			
		
		// clear the ring
		difference(){
			translate([0,0,-Overlap]) cylinder(d=Corner_OD+1,h=Base_h+Overlap*2);
			// Wire Path
			hull(){
				translate([-Corner_OD/2+10,0,-Overlap]) cylinder(d=TubeEnd_ID-1,h=Base_h+Overlap);
				translate([TubeOffset_X,0,-Overlap]) cylinder(d=TubeEnd_ID-1,h=Base_h+Overlap);
			} // hull
		} // diff
		translate([0,0,-Overlap]) cylinder(d=Corner_OD-3,h=Base_h+Overlap*2);
		// remove points
		rotate([0,0,58]) translate([0,Corner_OD/2-1,-Overlap]) cube([20,20,Base_h+1]);
		mirror([0,1,0]) rotate([0,0,58]) translate([0,Corner_OD/2-1,-Overlap]) cube([20,20,Base_h+1]);
		
		// Wire Path
		hull(){
			translate([-Corner_OD/2+10,0,-Overlap]) cylinder(d=TubeEnd_ID,h=Base_h-1);
			translate([TubeOffset_X,0,-Overlap]) cylinder(d=TubeEnd_ID,h=Base_h-1);
		} // hull
		
		// inspection plate bolt holes
		translate([TubeOffset_X-2,TubeEnd_ID/2+4,Base_h]) Bolt4FlatHeadHole(depth=8,lAccess=12);//Bolt4ClearHole();
		translate([TubeOffset_X-2,-TubeEnd_ID/2-4,Base_h]) Bolt4FlatHeadHole(depth=8,lAccess=12);//Bolt4ClearHole();
	} // diff	
} // CornerAccesCover

//translate([0,0,9.5+Overlap]) CornerAccesCover();

module LowerCornerLower(TubeOD=Tube_OD,Hole_d=TubeEnd_ID,GlueAllowance=0.4,myFn=24){
	Base_h=3;
	Rounder=12;
	nLCRB=8; // Lower Corner Race Bolts
	
	Stop1_a=-10;
	//Stop2_a=84;
	
	module BossBolt(Offset=1){
		translate([Corner_OD/2+Offset,0,-Base_h]) rotate([180,0,0]) Bolt4HeadHole(depth=7);
	} // BossBoltLoc
	
	module BoltBoss(Offset=1){
		Boss_d=6;
		
		translate([Corner_OD/2+Offset,0,0])
		difference(){
			hull(){
				
				cylinder(d=Boss_d,h=Base_h);
				translate([-Offset-0.5,-Boss_d/2,0]) cube([0.5,Boss_d,Base_h]);
				
			} // hull
			rotate([180,0,0]) Bolt4ClearHole(depth=7);
		} // diff
	} // BoltBoss
	
	//BoltBoss();
	nSkirtBolts=8;
	
	module RotStopBolt(){
		Base_w=8;

		rotate([0,0,3.75]) translate([Corner_OD/2-4.5,-Base_w/2,Base_h+Overlap]) Bolt4Hole();
	}
	
	
	translate([TubeOffset_X,0,-Rounder]) rotate([180,0,0]) TubeEnd(TubeOD=TubeOD,Wall_t=Wall_t,Hole_d=Hole_d, GlueAllowance=GlueAllowance);
	
	difference(){
		union(){
			for (j=[0:nSkirtBolts-1]) rotate([0,0,360/nSkirtBolts*j]) BoltBoss();
		hull(){
			translate([TubeOffset_X,0,-Rounder]) cylinder(d=TubeOD,h=Rounder+Base_h);
			cylinder(d=Corner_OD,h=Base_h);
		} // hull
	} // union
		// wire path
		translate([TubeOffset_X,0,-Rounder-Overlap]) cylinder(d=TubeEnd_ID,h=Rounder+Base_h+Overlap*4);
		
		
		// inspection plate bolt holes
		translate([TubeOffset_X-2,TubeEnd_ID/2+4,Base_h]) Bolt4Hole();
		translate([TubeOffset_X-2,-TubeEnd_ID/2-4,Base_h]) Bolt4Hole();
				
		// Spline
		translate([0,0,-Rounder-Overlap]) SplineHole(d=CornerSpline_d,l=Rounder+Base_h+Overlap*3,nSplines=nCornerSplines,Spline_w=30,Gap=IDXtra,Key=true);
		
		// Inner Race Bolts
		for (j=[0:nLCRB-1]) rotate([0,0,360/nLCRB*j]) translate([BallCircle_d/2-Ball_d/2-4.5,0,-Base_h])
			rotate([180,0,0]) Bolt4HeadHole(depth=8,lHead=12+Rounder);
		
		// rotation stop Bolt
		rotate([0,0,Stop1_a]) RotStopBolt();
		
		for (j=[0:nSkirtBolts-1]) rotate([0,0,360/nSkirtBolts*j]) BossBolt();
	} // diff

	
} // LowerCornerLower

//LowerCornerLower(TubeOD=Tube_OD,Hole_d=TubeEnd_ID,GlueAllowance=0.4,myFn=24);
//rotate([180,0,0])LowerCornerLower(TubeOD=Tube_OD,Hole_d=TubeEnd_ID,GlueAllowance=0.4,myFn=360);

module LowerCornerInnerRace(myFn=24){
	Race_h=12;
	nLCRB=8; // Lower Corner Race Bolts
	Vert_Offset=0.3; // overal bearing height = Race_h + 2 * Vert_Offset
	
	difference(){
		union(){
			cylinder(d=CornerSpline_d+12,h=Race_h);
			OnePieceInnerRace(BallCircle_d=BallCircle_d, Race_ID=CornerRace_ID, Ball_d=Ball_d, Race_w=12, PreLoadAdj=BearingPreload,
			VOffset=Vert_Offset, BI=true, myFn=myFn);
		} // union
		
		// Bolts
		for (j=[0:nLCRB-1]) rotate([0,0,360/nLCRB*j]) translate([BallCircle_d/2-Ball_d/2-4.5,0,0])
			rotate([180,0,0]) Bolt4Hole();
		
		// Spline
		translate([0,0,-Overlap]) SplineHole(d=CornerSpline_d,l=Race_h+Overlap*3,
			nSplines=nCornerSplines,Spline_w=30,Gap=IDXtra,Key=true);
	} // diff
	
} // LowerCornerInnerRace

//translate([0,0,3+Overlap]) LowerCornerInnerRace(myFn=24);

//LowerCornerInnerRace(myFn=360);

module GluingFixture(){
	TubeCenter_x=-Tube_OD/2-1;
	
	translate([TubeCenter_x-TubeOffset_X,0,80]) 
		SplineShaft(d=CornerSpline_d-IDXtra,l=40,nSplines=nCornerSplines,Spline_w=30,Hole=0,Key=true);
	
	difference(){
		union(){
			hull(){
				translate([(CornerSpline_d+5)/2,0,0]) cylinder(d=CornerSpline_d+5,h=30);
				translate([TubeCenter_x-TubeOffset_X,0,0]) cylinder(d=CornerSpline_d+5,h=30);
			} // hull
			
			translate([TubeCenter_x-TubeOffset_X,0,0]) cylinder(d=CornerSpline_d+5,h=80+Overlap);
			
			// face block
			translate([0,-40,0]) cube([(CornerSpline_d+5)/2,80,40]);
		} // union
		
	rotate([0,-90,0])
	// Mounting Bolts
		for (j=[0:nMountingBolts-1]) rotate([0,0,180/nMountingBolts*j+180/nMountingBolts/2-90]) 
			translate([WheelMount_OD/2-MBoltInset,0,0])
				Bolt4Hole(); 
	} // diff
	
} // GluingFixture

//$fn=90;
//GluingFixture();

module DriveSpline(){
	difference(){
		SplineShaft(d=CornerSpline_d,l=12,nSplines=nCornerSplines,Spline_w=30,Hole=6,Key=true);
		
		translate([0,0,4]) cylinder(d=12.7+IDXtra,h=8.1);
		
		translate([0,0,8]) rotate([0,90,0]) cylinder(d=6,h=30);
		
	} // diff
	
} //DriveSpline

//DriveSpline();

module FrontGluingFixture(){
	MP_Flange1Offset_d=12;
	MP_Flange2Offset_d=5;
	MP_Flange1Offset_z=-8;
	
	//*
	
	translate([0,0,MP_Flange1Offset_z])
		rotate([0,-10,-10])
			translate([MainPivot_d/2+MP_Flange1Offset_d,0,0]) 
				rotate([0,-90,0]) TubeFlange(TubeOD=Tube_OD,FlangeLen=15,Threaded=true);
	/**/
	
	difference(){
		translate([0,-49,-30]) cube([45,25,60]);
		
		translate([0,0,MP_Flange1Offset_z])
		rotate([0,-10,-10])
			translate([MainPivot_d/2+MP_Flange1Offset_d,0,0]) 
				rotate([0,-90,0]) cylinder(d=52,h=70);
	}
	
	/*
	
	// Show tube and connectors
	translate([0,0,MP_Flange1Offset_z])rotate([0,-10,-10]) translate([MainPivot_d/2+MP_Flange1Offset_d,0,0]) 
	rotate([0,90,0]) translate([0,0,Overlap]){
		color("Blue") TubeSocket(TubeOD=Tube_OD, SocketLen=19, Threaded=false);
		
		// tube
		translate([0,0,1]) AlTube(Len=4.55*25.4);
	}
	/**/
} // FrontGluingFixture

//rotate([90,0,0]) translate([0,49,0]) FrontGluingFixture();
//translate([9*25.4,-12,33]) rotate([0,170,0]) rotate([-90,0,0]) UpperCorner(TubeOD=Tube_OD,Hole_d=TubeEnd_ID,GlueAllowance=0.4);
