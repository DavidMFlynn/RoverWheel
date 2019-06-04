// **********************************************
// Rocker Bogie for Lan's Rover
// Filename: RockerBogieMainPiv.scad
// by David M. Flynn
// Created: 12/28/2018
// Revision: 1.1.3 5/19/2019
// Units: mm
// **********************************************
//  ***** Notes *****
// This is the main pivot and chassis mount.
// It uses a 37 pin AMP connector for electrical 
// connections to the motors.
// **********************************************
//  ***** History *****
// 1.1.3 5/19/2019 Moved FrontGluingFixture to this file and corrected angle and left (mirror) version.
// 1.1.2 5/11/2019 Removed non main pivot things.
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
//  *** Tools ***
// FrontGluingFixture(); // For Right side Main Pivot to Corner tube
// rotate([90,0,0]) mirror([0,0,1]) FrontGluingFixture(); // For Left side Main Pivot to Corner tube
//
// **********************************************
//  ***** for Viewing *****
// ShowMainPivot();
// **********************************************
// **** other routines *****
// AlTube(Len=25);
// **********************************************

include<Nut_Job.scad>
include<ActoboticsLib.scad>
include<CommonStuffSAEmm.scad>
//include<RoverWheel.scad>
include<BearingLib.scad>
include<TubeConnectorLib.scad>

//$fn=24;
$fn=180;
IDXtra=0.2;
Overlap=0.05;

Tube_OD=38.1; //38.1; //25.4;
Wall_t=0.84;
TubeEnd_ID=Tube_OD-Wall_t*2-8;

RaceBoltInset=3.5;

// Main pivot values
MainPivot_d=90;
MP_Ring_h=Tube_OD+30;
MP_Ball_d=0.375*25.4;
MP_Ring_BC_d=MainPivot_d-MP_Ball_d-10;
MP_Ring_Tilt_a=20+18; // 18 = no motion
//echo(MP_Ring_BC_d=MP_Ring_BC_d);

MP_Race_w=10;
AMP37_d=38;
MP_nBBolts=10;

MP_GTube_d=0.314*25.4;
MP_nGTubes=5;
MP_GTube_x=24;
MP_Standoff_l=63.5; //76.2=3"; //63.5=2.5";
MP_GTube_l=57; // verified 4/17/2019
MP_Standoff_d=6.35;
MP_HubBolt_d=7/32*25.4;
MP_HubBolt_l=12.7;

module ShowMainPivot(){
	
	//rotate([0,10,0]) translate([MainPivot_d/2,0,0]) rotate([0,90,0]) TubeSocket(TubeOD=Tube_OD, SocketLen=19, Threaded=false);	
	
	rotate([90,0,0]){
		MainPivot_Ring();
		
		translate([0,0,-MP_Ring_h/2-1]) color("Green") ChassisMount();
		
		// Ball locations
		//translate([0,0,-MP_Ring_h/2+MP_Race_w/2]) cylinder(d=30,h=0.01);
		//translate([0,0,MP_Ring_h/2-MP_Race_w/2]) cylinder(d=30,h=0.01);
		
		translate([0,0,-MP_Ring_h/2+11+Overlap]) color("Tan") MP_StopRace();
		translate([0,0,-MP_Ring_h/2+11+Overlap*2]) MP_StopRing();
		
		translate([0,0,-6.1]) MP_AMP37_Nut(DrawNut=false);
		
		translate([0,0,MP_Ring_h/2-11-Overlap]) color("Tan") MP_OuterInnerRace();
		translate([0,0,MP_Ring_h/2+1+Overlap]) color("Green") MP_OuterOuterRace();
		
		translate([0,0,MP_Ring_h/2+1.3]) color("Orange") MP_OuterCover();
		
		// Guide Tubes
		translate([0,0,-28.5]) color("LightGray") MP_GuideTubes(D=MP_GTube_d,Len=MP_GTube_l,ID=6.4);
		// standoffs
		translate([0,0,-36]) color("Red") MP_GuideTubes(D=MP_Standoff_d,Len=MP_Standoff_l,ID=0);
		
		// ShoulderBolts
		translate([0,0,-36+MP_Standoff_l+0.2]) color("Red") MP_GuideTubes(D=MP_Standoff_d,Len=12.7,ID=0);
		translate([0,0,-36+MP_Standoff_l+0.2+12.7]) color("Red") MP_GuideTubes(D=10,Len=4,ID=0);
	}
} // ShowMainPivot

// ShowMainPivot();

// Flange 1, front angeled out
	MP_Flange1Offset_d=12;
	MP_Flange1Offset_z=-6;	MP_Flange1_aZ=-10; // angle down
	MP_Flange1_aY=-15; // angle out

module MainPivot_Ring(myFn=36){
  // the large outer body of the main pivot

	
	
	// Flange 2, rear straight
	MP_Flange2Offset_d=5;
	MP_Flange2_aZ=190; // 10 degrees down
	MP_Flange2Offset_z=-(MP_Ring_h/2-TubeFlageOD(TubeOD=Tube_OD)/2);
	
	translate([0,0,-MP_Ring_h/2])
		OnePieceOuterRace(BallCircle_d=MP_Ring_BC_d, Race_OD=MainPivot_d-8,
				Ball_d=MP_Ball_d, Race_w=MP_Race_w, PreLoadAdj=0, VOffset=0.00, BI=false, myFn=myFn);
	
	translate([0,0,MP_Ring_h/2-MP_Race_w])
		OnePieceOuterRace(BallCircle_d=MP_Ring_BC_d, Race_OD=MainPivot_d-8,
				Ball_d=MP_Ball_d, Race_w=MP_Race_w, PreLoadAdj=0, VOffset=0.00, BI=false, myFn=myFn);

	difference(){
		union(){
			// Flange 1
			translate([0,0,MP_Flange1Offset_z])
				rotate([0,MP_Flange1_aY,MP_Flange1_aZ])
					translate([MainPivot_d/2+MP_Flange1Offset_d,0,0]) 
						rotate([0,-90,0]) TubeFlange(TubeOD=Tube_OD,FlangeLen=20+MP_Flange1Offset_d,Threaded=true);
			
			// Flange 2
			translate([0,0,MP_Flange2Offset_z])
			rotate([0,0,MP_Flange2_aZ])
					translate([MainPivot_d/2+MP_Flange2Offset_d,0,0]) 
						rotate([0,-90,0]) TubeFlange(TubeOD=Tube_OD,FlangeLen=20+MP_Flange1Offset_d,Threaded=true);
			
			// Main body
			translate([0,0,-MP_Ring_h/2]) cylinder(d=MainPivot_d,h=MP_Ring_h,$fn=myFn);
			
			// tower
			translate([0,0,-MP_Ring_h/2]){
				hull(){
					cylinder(d=MainPivot_d-10,h=12.7);
					translate([0,120,0]) cylinder(d=12.7,h=12.7);
				} // hull
				hull(){
					translate([0,MainPivot_d/2-7,0]) cylinder(d=12.7,h=MP_Ring_h/2+12.7);
					translate([0,80,0]) cylinder(d=12.7,h=12.7);
				} // hull
			}
		} // union
		
		// tower bolts
		translate([0,120,-MP_Ring_h/2+12.7]) Bolt6ClearHole();
		//translate([0,120-9.525,-MP_Ring_h/2+12.7]) Bolt6ClearHole();
		//translate([0,120-9.525*2,-MP_Ring_h/2+12.7]) Bolt6ClearHole();
		
		// inside
			translate([0,0,-MP_Ring_h/2-Overlap]) cylinder(d=MainPivot_d-12,h=MP_Ring_h+Overlap*2);
			translate([0,0,-MP_Ring_h/2-Overlap]) cylinder(d=MainPivot_d-8-Overlap*2,h=MP_Race_w);
			translate([0,0,MP_Ring_h/2+Overlap-MP_Race_w]) cylinder(d=MainPivot_d-8-Overlap*2,h=MP_Race_w+Overlap*2);
		
		// Flange 1 wire path
		translate([0,0,MP_Flange1Offset_z]) rotate([0,90+MP_Flange1_aY,MP_Flange1_aZ]) cylinder(d=TubeEnd_ID+8,h=MainPivot_d);
		
		// Flange 2 Wire Path
		translate([0,0,MP_Flange2Offset_z])
		rotate([0,90,MP_Flange2_aZ]) cylinder(d=TubeEnd_ID+8,h=MainPivot_d);
		
		// flange1 bolts
		translate([0,0,MP_Flange1Offset_z])
			rotate([0,MP_Flange1_aY,MP_Flange1_aZ]) 
				translate([MainPivot_d/2+MP_Flange1Offset_d,0,0])
					rotate([0,-90,0]) TubeSocketBolts(TubeOD=Tube_OD) rotate([180,0,0]) Bolt4Hole(depth=20);
		
		// flange2 bolts
		translate([0,0,MP_Flange2Offset_z])
			rotate([0,0,MP_Flange2_aZ]) 
				translate([MainPivot_d/2+MP_Flange2Offset_d,0,0])
					rotate([0,-90,0]) TubeSocketBolts(TubeOD=Tube_OD) rotate([180,0,0]) Bolt4Hole(depth=20);
	} // diff
	
	// rotation stop
	translate([0,MainPivot_d/2-5,-MP_Ring_h/2+MP_Race_w+3.5])
	hull(){
		cylinder(d=10,h=0.1);
		translate([0,-15,0]) cylinder(d=5,h=0.1);
		translate([0,0,20]) cylinder(d=10,h=0.1);
	}
	
	
} // MainPivot_Ring

//MainPivot_Ring(myFn=360);
//rotate([180,0,0]) mirror([0,0,1]) 
//rotate([180,0,0]) mirror([0,0,1]) MainPivot_Ring(myFn=36);

module FrontGluingFixture(){
	
	//*
	
	translate([0,0,MP_Flange1Offset_z])
		rotate([0,MP_Flange1_aY,MP_Flange1_aZ]) //rotate([0,-10,-10])
			translate([MainPivot_d/2+MP_Flange1Offset_d,0,0]) 
				rotate([0,-90,0]) //TubeFlange(TubeOD=Tube_OD,FlangeLen=20+MP_Flange1Offset_d,Threaded=true);
									TubeFlange(TubeOD=Tube_OD,FlangeLen=15,Threaded=true);
	/**/
	
	difference(){
		translate([0,-49,-30]) rotate([0,MP_Flange1_aY,0]) cube([58,25,60]);
		
		translate([0,0,MP_Flange1Offset_z])
		rotate([0,MP_Flange1_aY,MP_Flange1_aZ])
			translate([MainPivot_d/2+MP_Flange1Offset_d+5,0,0]) 
				rotate([0,-90,0]) cylinder(d=54,h=20);
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

//rotate([90,0,0]) mirror([0,0,1]) FrontGluingFixture();


module ChassisPlate(myFn=60,DrawNut=false){
	CP_t=6.35+5.5;
	CP_d=60;
	
	
	
	difference(){
		union(){
			difference(){
				//cylinder(d=CP_d,h=CP_t);
				translate([-(CP_d+4)/2,-CP_d/2,0]) cube([CP_d+4,CP_d+2,CP_t]);
				translate([0,0,-Overlap]) cylinder(d=AMP37_d,h=CP_t+Overlap*2);
			} // diff
			
			if (DrawNut==true) rotate([0,0,20])
				translate([0,0,CP_t-6.35-5.5]) 
				Nut_Job(type="nut",
					nut_thread_outer_diameter = 34.925+IDXtra,
					nut_thread_step = 1.27,
					nut_diameter  = 40,
					nut_height	  = 5); // 5mm thick
		} // union
			
		
		
		translate([0,0,CP_t-1]) MP_GuideTubes(D=MP_Standoff_d,Len=2);
		translate([0,0,CP_t]) MP_GuideLocations() Bolt8Hole(depth=CP_t); // Bolt8ClearHole(depth=CP_t);
		
		difference(){
			for (x=[0:2]) for (y=[0:1]) translate([x*1.5*25.4-1.5*25.4,y*1.5*25.4-10.5,0])
				ChassisPlateFullPattern() rotate([180,0,0]) Bolt6Hole();
		
			translate([0,0,-Overlap*2]) cylinder(d=AMP37_d+8,h=CP_t+10);
		
			translate([0,0,-Overlap*2]) MP_GuideLocations() cylinder(d=10,h=CP_t+10);
			
			difference(){
				translate([-CP_d,-CP_d,-Overlap*2]) cube([CP_d*2,CP_d*2,CP_t+10]);
				translate([-(CP_d)/2,-CP_d/2+3,-Overlap*2]) cube([CP_d,CP_d-2,CP_t+10]);
			} // diff
		
	} // diff
	} // diff
	
} // ChassisPlate

//ChassisPlate(myFn=60,DrawNut=false);
// ChassisPlate(myFn=60,DrawNut=true);

module ChassisMount(myFn=60){
	// the inside race closest to the chassis
	difference(){
		rotate([0,0,90+180/MP_nBBolts])
			InsideRace(BallCircle_d=MP_Ring_BC_d, Race_ID=Tube_OD, Ball_d=MP_Ball_d, Race_w=6, nBolts=MP_nBBolts, 
				RaceBoltInset=BL_RaceBoltInset, PreLoadAdj=0.00, myFn=myFn) Bolt4Hole();
		
		
		translate([0,0,-Overlap]) MP_GuideTubes(D=MP_Standoff_d,Len=6+Overlap*2);
	}
} // ChassisMount

//translate([0,0,-MP_Ring_h/2-1]) ChassisMount();

module MP_StopRace(myFn=60){
	// the second race moving out
	difference(){
		rotate([180,0,90+180/MP_nBBolts])
			InsideRace(BallCircle_d=MP_Ring_BC_d, Race_ID=AMP37_d, Ball_d=MP_Ball_d, 
				Race_w=6, nBolts=MP_nBBolts, RaceBoltInset=BL_RaceBoltInset, PreLoadAdj=0.00, myFn=myFn) Bolt4ClearHole();
		
		translate([0,0,-6-Overlap]) MP_GuideTubes(D=MP_GTube_d, Len=6+Overlap*2);
	} // diff
	
} // MP_StopRace

//translate([0,0,-MP_Ring_h/2+11+Overlap]) MP_StopRace();

module MP_OuterInnerRace(myFn=60){
	// the 3rd inner race
	difference(){
		rotate([0,0,90+180/MP_nBBolts])
			InsideRace(BallCircle_d=MP_Ring_BC_d, Race_ID=Tube_OD, Ball_d=MP_Ball_d, Race_w=6, nBolts=MP_nBBolts, 
				RaceBoltInset=BL_RaceBoltInset, PreLoadAdj=0.00, myFn=myFn) Bolt4Hole();
		
		
		translate([0,0,-Overlap]) MP_GuideTubes(D=MP_GTube_d,Len=6+Overlap*2);
	}
} // MP_OuterInnerRace

//translate([0,0,MP_Ring_h/2-12-Overlap]) MP_OuterInnerRace();

module MP_OuterOuterRace(myFn=60){
	// the most outside of the 4 inner races
	difference(){
		rotate([180,0,90+180/MP_nBBolts])
			InsideRace(BallCircle_d=MP_Ring_BC_d, Race_ID=AMP37_d, Ball_d=MP_Ball_d, 
				Race_w=6, nBolts=MP_nBBolts, RaceBoltInset=BL_RaceBoltInset, PreLoadAdj=0.00, myFn=myFn) Bolt4HeadHole();
		
		translate([0,0,-6-Overlap]) MP_GuideTubes(D=MP_HubBolt_d,Len=6+Overlap*2);
		
		for (j=[0:MP_nBBolts/2-1]) rotate([0,0,360/(MP_nBBolts/2)*j]) translate([0,AMP37_d/2+5,0]) Bolt4Hole();
	} // diff
	
} // MP_OuterOuterRace

//translate([0,0,MP_Ring_h/2]) MP_OuterOuterRace();

module MP_OuterCover(TheText="DMF"){
	Cover_t=1.2;
	nSpokes=10;
	
	difference(){
		union(){
			cylinder(d=MainPivot_d,h=1.2);
			
			cylinder(d=AMP37_d+20,h=5);
			
			cylinder(d=AMP37_d,h=7);
			
			for (j=[0:nSpokes-1]) rotate([0,0,360/nSpokes*(j+0.5)]) hull(){
				translate([0,MainPivot_d/2-3,Cover_t-Overlap]) cylinder(d=3,h=0.1);
				translate([0,AMP37_d/2-4,Cover_t-Overlap]) cylinder(d=3,h=5.7);
			} // for hull
		} // union
		
		// center dish
		translate([0,0,3]) cylinder(d1=AMP37_d-7 ,d2=AMP37_d-4,h=7);
		
		// bolt holes for shoulder bolts 1/2 long x 7/32 dia, 8-32 thread
		translate([0,0,-Overlap]) MP_GuideTubes(D=MP_HubBolt_d,Len=20);
		
		for (j=[0:MP_nBBolts/2-1]) rotate([0,0,360/(MP_nBBolts/2)*j]) translate([0,AMP37_d/2+5,Cover_t+4]) Bolt4HeadHole();
	} // diff
	
	linear_extrude(3+0.6) text(text=TheText,halign="center",valign="center",size=9);
} // MP_OuterCover

//MP_OuterCover();

module MP_StopRing(){
	StopRing_t=2;
	StopBoltInset=18;
	
		difference(){
			union(){
				cylinder(d=MainPivot_d-14,h=StopRing_t);
				rotate([0,0,MP_Ring_Tilt_a]) translate([0,MainPivot_d/2-StopBoltInset,StopRing_t-Overlap])
					hull(){
						cylinder(d=8,h=5);
						translate([0,7,0]) cylinder(d=8,h=5);
					} // hull
					
				rotate([0,0,-MP_Ring_Tilt_a]) translate([0,MainPivot_d/2-StopBoltInset,StopRing_t-Overlap])
					hull(){
						cylinder(d=8,h=5);
						translate([0,7,0]) cylinder(d=8,h=5);
					} // hull
			} // union
			
			
			translate([0,0,-Overlap]) cylinder(d=AMP37_d,h=2+Overlap*2);
			
			translate([0,0,StopRing_t])
			rotate([0,0,90+180/MP_nBBolts])
				InsideRaceBoltPattern(Race_ID=Tube_OD,nBolts=MP_nBBolts,RaceBoltInset=BL_RaceBoltInset) Bolt4ClearHole();
			
		
			
			translate([0,0,-Overlap]) MP_GuideTubes(Len=10);
		} // diff
		
		
} // MP_StopRing

//translate([0,0,-MP_Ring_h/2+11+Overlap]) MP_StopRing();

module MP_GuideLocations(){
	for (j=[0:MP_nGTubes-1]) rotate([0,0,90+360/MP_nGTubes*(j+0.5)]) translate([MP_GTube_x,0,0]) children();
} // MP_GuideLocations

module MP_GuideTubes(D=MP_GTube_d,Len=MP_GTube_l,ID=0){
	MP_GuideLocations()
		difference(){
			cylinder(d=D,h=Len);
			if (ID!=0) translate([0,0,-Overlap])
				cylinder(d=ID,h=Len+Overlap*2);
		} // diff
			
} // MP_GuideTubes

// Guide Tubes
//translate([0,0,-30]) color("LightGray") MP_GuideTubes(D=MP_GTube_d,Len=MP_GTube_l,ID=6.4);
// standoffs
//translate([0,0,-36]) color("Red") MP_GuideTubes(D=MP_Standoff_d,Len=MP_Standoff_l,ID=0);

module AMP37(){
	cylinder(d=32.5,h=34);
	translate([0,0,17]) cylinder(d=AMP37_d,h=12);
	translate([0,0,34-7.5])cylinder(d=35,h=7.5);
} // AMP37

//translate([0,0,-35]) color("Red") AMP37();
// AMP37 thread 1-3/8 20tpi (34.925mm x 1.27mm pitch)

module MP_AMP37_Nut(DrawNut=false){
	
	difference(){
		union(){
			if (DrawNut==true)
			Nut_Job(type="nut",
				nut_thread_outer_diameter = 34.925+IDXtra,
				nut_thread_step = 1.27,
				nut_diameter  = 40,
				nut_height	  = 5);
			
			difference(){
				for (j=[0:MP_nGTubes-1]) hull(){
					rotate([0,0,90+360/MP_nGTubes*(j+0.5)]) translate([MP_GTube_x,0,0]) cylinder(d=13,h=5);
					cylinder(d=43,h=5);
				} // hull
				translate([0,0,-Overlap]) cylinder(d=37,h=5+Overlap*2);
			} // diff			
		} // union
		
		translate([0,0,-Overlap])
			for (j=[0:MP_nGTubes-1]) 
				rotate([0,0,90+360/MP_nGTubes*(j+0.5)]) translate([MP_GTube_x,0,0]) cylinder(d=MP_GTube_d,h=5+Overlap*2);
			
	} // diff
	
} // MP_AMP37_Nut

//translate([0,0,-6.1]) MP_AMP37_Nut(DrawNut=false);


//$fn=40;
//rotate([0,0,-90]) rotate([0,-90,0]) TubeConnector(Tube_OD=Tube_OD,Wall_t=Wall_t);


module AlTube(Len=25){
	color("Silver") 
	difference(){
		cylinder(d=Tube_OD,h=Len);
		translate([0,0,-Overlap]) cylinder(d=Tube_OD-1.68,h=Len+Overlap*2);
	} // diff
} // AlTube


















