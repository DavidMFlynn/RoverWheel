// **********************************************
// Rocker Bogie for Lan's Rover
// Secondary Pivot
// Filename: RockerBogieSecPiv.scad
// by David M. Flynn
// Created: 3/24/2019
// Revision: 1.0.2 5/17/2019
// Units: mm
// **********************************************
// Notes:
//  Secondary pivot with wire path.
// **********************************************
// History
// 1.0.2 5/17/2019 Added SecPivotB_Race IsLeft
// 1.0.1 3/30/2019 Made more parametric.
// 1.0.0 3/24/2019 Moved Secondary Pivot to this file
//  RockerBogieLan.scad
// 1.0.7 3/24/2019 Added Secondary Pivot w/ Access Cover (SecPivotBC)
// **********************************************
//  ***** for STL output *****
// SecPivotA(myFn=360); // outer bearing race and inside tube connector
// rotate([180,0,0]) SecPivotBC(myFn=360); // near side
// mirror([0,0,1]) SecPivotBC(myFn=360); // far side
// SecPivotAccessPlate(BuilderID="LBD");
// rotate([180,0,0]) SecPivotB_Race(myFn=360,IsLeft=false);
// rotate([180,0,0]) SecPivotB_Race(myFn=360,IsLeft=true);
// **********************************************
//  ***** for Viewing *****
//rotate([-90,0,0]) ShowSecPivot();
//rotate([180,0,0]) ShowSecPivotExpanded(myFn=360);
// **********************************************

include<CommonStuffSAEmm.scad>
include<RoverWheel.scad>
include<BearingLib.scad>
include<TubeConnectorLib.scad>

//include<CornerPivot.scad>
//include<RockerPivot.scad>

//$fn=24; // for viewing quickly
$fn=180; // for STL production
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
BearingPreload=0;
CornerSpline_d=30;
nCornerSplines=5;

// Secondary pivot values
SecPivot_d=84;
SP_Ring_h=Tube_OD;
SP_Ball_d=0.375*25.4;
SP_Ring_BC_d=SecPivot_d-SP_Ball_d-10;
SP_Ring_Tilt_a=20+18; // 18 = no motion
//echo(MP_Ring_BC_d=MP_Ring_BC_d);

module ShowSecPivot(myFn=36){
	SecPivotA(myFn=myFn);
	
	translate([0,0,-SP_Ring_h/2+10])   rotate([180,0,0]) SecPivotB_Race();
	
	translate([0,0,-Tube_OD-9])  SecPivotBC();
	
	translate([0,0,-Tube_OD-9-(Tube_OD+9)/2-1]) rotate([180,0,0]) SecPivotAccessPlate(BuilderID="DMF");
} // ShowSecPivot

//ShowSecPivot();

module ShowSecPivotExpanded(myFn=36){
	module ShowTheBalls(BC=SP_Ring_BC_d,Ball_d=SP_Ball_d,nBalls=16){
		for (j=[0:nBalls-1]) rotate([0,0,360/nBalls*j]) translate([BC/2,0,0]) sphere(d=Ball_d);
	} // ShowTheBalls
	
	color("lightblue") SecPivotA(myFn=myFn);
	
	translate([0,0,-30]) color("Red") ShowTheBalls();
	translate([0,0,-45])   rotate([180,0,0]) color("Tan") SecPivotB_Race(myFn=myFn);
	
	translate([0,0,-90])  color("Gray") SecPivotBC(myFn=myFn);
	
	translate([0,0,-130]) rotate([180,0,0]) color("Green") SecPivotAccessPlate(BuilderID="DMF");
} // ShowSecPivotExpanded

//rotate([180,0,0]) ShowSecPivotExpanded(myFn=36);


module SecPivotB_Race(myFn=36, IsLeft=false){
	SP_Race_w=11;
	nSP_Race_Bolts=8;
	
	RotStop1_a= IsLeft? -32:-25;
	RotStop2_a= IsLeft? 25:32;
	RotStop1_Y= 6;
	RotStop2_Y= -6;
	
	
	difference(){
		OnePieceInnerRace(BallCircle_d=SP_Ring_BC_d, Race_ID=Tube_OD, Ball_d=SP_Ball_d, Race_w=SP_Race_w, PreLoadAdj=BearingPreload,
			VOffset=-0.5, BI=true, myFn=myFn);
		
		for (j=[0:nSP_Race_Bolts-1]) rotate([0,0,360/nSP_Race_Bolts*j]) translate([Tube_OD/2+4,0,SP_Race_w]) Bolt4Hole();
	} // diff
	
	difference(){
		union(){
		// rotation stop
		rotate([0,0,RotStop1_a]) // yields 22.5
			translate([-SP_Ring_BC_d/2+4, RotStop1_Y, -5+Overlap])
				hull(){
					cylinder(d=5,h=5);
					translate([22,0,0]) cylinder(d=5,h=5);
				} // hull
	
		// rotation stop 2
		rotate([0,0,RotStop2_a]) // yields 30
			translate([-SP_Ring_BC_d/2+4, RotStop2_Y, -5+Overlap])
				hull(){
					cylinder(d=5,h=5);
					translate([22,0,0]) cylinder(d=5,h=5);
				} // hull
			} // union
				
		translate([0,0,-10]) cylinder(d=Tube_OD,h=SP_Race_w+5);
				
		translate([0,0,-10+Overlap*2])
		difference(){
			cylinder(d=SP_Ring_BC_d+SP_Ball_d*2,h=10);
			translate([0,0,-Overlap]) cylinder(d2=SP_Ring_BC_d-SP_Ball_d*0.7,d1=SP_Ring_BC_d-SP_Ball_d*2,h=10+Overlap*4);
		} // diff
	} // diff
} // SecPivotB_Race

//rotate([0,0,-22.5])
//rotate([0,0,30])
//translate([0,0,-SP_Ring_h/2+10])   rotate([180,0,0]) 
//SecPivotB_Race(IsLeft=false);
//SecPivotB_Race(IsLeft=true);

module SP_RS(){
	SP_Race_w=10;
	
// rotation stop
	translate([-SecPivot_d/2+6,0,-SP_Ring_h/2+SP_Race_w])
		hull(){
			cylinder(d=8,h=1);
			translate([15,0,0]) cylinder(d=8,h=10);
		} // hull
	}

//SP_RS();

module SecPivotBC(myFn=36){
	// outer part of secondary pivot w/o access cover
	nSP_Race_Bolts=8;
	BoltPlate_t=8;
	
	//Flange1_az=160;
	Flange1_az=140;
	Flange1_ay=5; // was -10;
	Flange1_OffsetZ=0; // was -10
	Flange1_Pushout=5; // was 10
	Flange2_az=10;
	Flange2_ay=0;
	Flange2_Pushout=5;
	
	// Bolt ring
	translate([0,0,Tube_OD/2+8-BoltPlate_t]) 
		difference(){
			union(){
				cylinder(d=Tube_OD+20,h=BoltPlate_t);
				
				cylinder(d=SecPivot_d,h=BoltPlate_t);
			} // union
			
			translate([0,0,-Overlap]) cylinder(d=Tube_OD,h=BoltPlate_t+Overlap*2);
			
			for (j=[0:nSP_Race_Bolts-1]) rotate([0,0,360/nSP_Race_Bolts*j]) translate([Tube_OD/2+4,0,0]) 
				rotate([180,0,0]) Bolt4HeadHole();
			
			translate([0,0,-(Tube_OD/2+8-BoltPlate_t)]) {
				
			// Tube Flange 1
		translate([0,0,Flange1_OffsetZ]) rotate([0,Flange1_ay,Flange1_az])
			translate([SecPivot_d/2+Flange1_Pushout,0,0]) rotate([0,-90,0])
				TubeSocketBolts(TubeOD=Tube_OD) rotate([180,0,0]) Bolt4Hole();
			
		// Tube Flange 2
		rotate([0,Flange2_ay,Flange2_az])
			translate([SecPivot_d/2+Flange2_Pushout,0,0]) rotate([0,-90,0])
				TubeSocketBolts(TubeOD=Tube_OD) rotate([180,0,0]) Bolt4Hole();
			
		}
			
		} // diff
   
	//*
	difference(){
		hull(){
			// main plate, bolts to bearing
			translate([0,0,Tube_OD/2+8-BoltPlate_t+0.01]) cylinder(d=SecPivot_d,h=0.01);
			
			// Tube flange 1
			translate([0,0,Flange1_OffsetZ]) rotate([0,Flange1_ay,Flange1_az])
				translate([SecPivot_d/2+Flange1_Pushout,0,0]) 
					rotate([0,-90,0]) translate([0,0,15]) cylinder(d=Tube_OD+16,h=0.01);
			
			// Tube flange 2
			rotate([0,Flange2_ay,Flange2_az])
				translate([SecPivot_d/2+Flange2_Pushout,0,0])
					rotate([0,-90,0]) translate([0,0,15]) cylinder(d=Tube_OD+16,h=0.01);
			
			// Body
			//translate([0,0,-12]) sphere(d=Tube_OD+8);
			translate([0,0,-8-Tube_OD/2]) cylinder(d=Tube_OD+18,h=0.01);
		} // hull
		
		
		// carve out inside
		hull(){
			// Main plate
			translate([0,0,Tube_OD/2+8-9]) cylinder(d=Tube_OD+16,h=10);
			
			// Tube, Wire Path
			translate([0,0,Flange1_OffsetZ]) rotate([0,Flange1_ay,Flange1_az])
					translate([SecPivot_d/2+Flange1_Pushout,0,0]) rotate([0,-90,0]) translate([0,0,14]) cylinder(d=Tube_OD,h=1);
			
			// Tube, Wire Path
			rotate([0,Flange2_ay,Flange2_az])
					translate([SecPivot_d/2+5,0,0]) 
					rotate([0,-90,0]) translate([0,0,14]) cylinder(d=Tube_OD,h=1);
		} // hull
		
		// Access plate opening
		translate([0,0,-12-(Tube_OD+9)/2]) cylinder(d=Tube_OD+2,h=30);
		translate([0,0,-12-(Tube_OD+9)/2]) cylinder(d=Tube_OD+15,h=11);
		for (j=[0:nSP_Race_Bolts-1]) rotate([0,0,360/nSP_Race_Bolts*(j+0.5)])
			translate([Tube_OD/2+4,0,-(Tube_OD+9)/2-1]) rotate([180,0,0]) Bolt4Hole();
		
		// carve out inside
		hull(){
			translate([0,0,-12]) sphere(d=Tube_OD-4);
			translate([0,0,Tube_OD/2+8-BoltPlate_t+0.01]) cylinder(d=SecPivot_d-12,h=0.01);
		}
		
		// center core
		translate([0,0,-Tube_OD/2-4]) cylinder(d=Tube_OD,h=Tube_OD+8);
		
		// Tube Flange 1
		translate([0,0,Flange1_OffsetZ]) rotate([0,Flange1_ay,Flange1_az])
			translate([SecPivot_d/2+Flange1_Pushout,0,0]) rotate([0,-90,0]){
				cylinder(d=Tube_OD+16,h=15-Overlap);
				TubeSocketBolts(TubeOD=Tube_OD) rotate([180,0,0]) Bolt4Hole();
			}
		
		// Tube Flange 2
		rotate([0,Flange2_ay,Flange2_az])
			translate([SecPivot_d/2+Flange2_Pushout,0,0]) rotate([0,-90,0]){
				cylinder(d=Tube_OD+16,h=15-Overlap);
				TubeSocketBolts(TubeOD=Tube_OD) rotate([180,0,0]) Bolt4Hole();
			}
		
		// Screwdriver access
		for (j=[0:nSP_Race_Bolts-1]) rotate([0,0,360/nSP_Race_Bolts*j]) translate([Tube_OD/2+4,0,-50]) 
			cylinder(d=4.5,h=50);
		
		
	} // diff
	
	
		// Tube Flange 1
			translate([0,0,Flange1_OffsetZ]) rotate([0,Flange1_ay,Flange1_az])
				translate([SecPivot_d/2+Flange1_Pushout,0,0]) 
						rotate([0,-90,0]) TubeFlange(TubeOD=Tube_OD,FlangeLen=15,Threaded=true);
	
		// Tube Flange 2
			rotate([0,Flange2_ay,Flange2_az])
					translate([SecPivot_d/2+Flange2_Pushout,0,0]) 
						rotate([0,-90,0]) TubeFlange(TubeOD=Tube_OD,FlangeLen=15,Threaded=true);
		/**/
} // SecPivotBC

//rotate([0,40,0])rotate([-90,0,0]) SecPivotBC();

module SecPivotAccessPlate(BuilderID="DMF"){
	nSP_Race_Bolts=8;
	difference(){
		union(){
			cylinder(d=Tube_OD+14,h=3);
			cylinder(d=Tube_OD,h=5);
		} // union
		
		translate([0,0,2]) cylinder(d=Tube_OD-10,h=5);
		
		for (j=[0:nSP_Race_Bolts-1]) rotate([0,0,360/nSP_Race_Bolts*j])
			translate([Tube_OD/2+4,0,3]) Bolt4ClearHole();
	} // diff
	
	translate([0,0,1.5]) linear_extrude(height=2) text(size=8,text=BuilderID,valign="center",halign="center");
} // SecPivotAccessPlate

//translate([0,0,-(Tube_OD+9)/2-1]) rotate([180,0,0]) SecPivotAccessPlate();


module SecPivotA(myFn=36){
	SP_Race_w=10;
	SP_Flange1Offset_d=12;
	SP_Flange2Offset_d=5;
	SP_Flange1Offset_z=-8;
	
	//*
	translate([0,0,-SP_Ring_h/2+SP_Race_w]) rotate([180,0,0])
		OnePieceOuterRace(BallCircle_d=SP_Ring_BC_d, Race_OD=SecPivot_d-Overlap,
				Ball_d=SP_Ball_d, Race_w=SP_Race_w, PreLoadAdj=BearingPreload, VOffset=0.00, BI=true, myFn=myFn);
	
	translate([SecPivot_d/2,0,0]) rotate([0,90,0]) TubeEnd(TubeOD=Tube_OD,Wall_t=0.84,Hole_d=TubeEnd_ID, Stop_l=TubeStop_l, GlueAllowance=0.40);
	
	difference(){
		translate([SecPivot_d/2,0,0]) rotate([0,-90,0]) cylinder(d=Tube_OD,h=4);
		
		translate([SecPivot_d/2,0,0]) rotate([0,-90,0]) translate([0,0,-Overlap]) cylinder(d=TubeEnd_ID,h=4+Overlap*2);
	} // diff
	
	/**/
	
	// rotation stop
	translate([-SecPivot_d/2+6,0,-SP_Ring_h/2+SP_Race_w])
		hull(){
			cylinder(d=8,h=1);
			translate([15,0,0]) cylinder(d=8,h=10);
		} // hull
	
	// Shell
	difference(){
		hull(){
			translate([0,0,-SP_Ring_h/2+SP_Race_w-Overlap*2]) cylinder(d=SecPivot_d,h=Overlap*2);
			sphere(d=Tube_OD-8);
			translate([SecPivot_d/2,0,0]) rotate([0,-90,0]) cylinder(d=Tube_OD,h=4);
		} // hull
		
		hull(){
			translate([0,0,-SP_Ring_h/2+SP_Race_w-Overlap*2]) cylinder(d=SecPivot_d-11,h=2);
			sphere(d=Tube_OD-8-9);
			translate([SecPivot_d/2+Overlap,0,0]) rotate([0,-90,0]) cylinder(d=TubeEnd_ID,h=0.01);
		} // hull
		
		translate([0,0,-SP_Ring_h/2]) cylinder(d=SecPivot_d-8,h=SP_Race_w-Overlap);
		
		// ball removal tool access
		translate([0,-SP_Ring_BC_d/2,-SP_Ring_h/2+SP_Race_w]) cylinder(d=3,h=20);
	} // diff
	
	//rotate([0,0,190])
	//				translate([SecPivot_d/2+SP_Flange2Offset_d,0,0]) 
	//					rotate([0,-90,0]) TubeFlange(TubeOD=Tube_OD,FlangeLen=20+SP_Flange1Offset_d,Threaded=true);
	
} // SecPivotA

//SecPivotA(myFn=36);
