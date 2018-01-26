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
// **********************************************

include<CommonStuffSAE.scad>
include<RoverWheel.scad>

include<TubeConnectorLib.scad>
// TubeEll_STL(TubeOD=25.4,Wall_t=0.84,Hole_d=14);
// TubeSection(TubeOD=25.4,Wall_t=0.84, Length=100, Stop_l=TubeStop_l);
// TubeEnd(TubeOD=25.4,Wall_t=0.84,Hole_d=14);
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

YTubeLen=100;

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
		translate([RC_BoltSpace/2,Tube_OD/2+RC_Spacer_h,TM_h/2])rotate([-90,0,0]) scale(25.4) Bolt4Hole();
		translate([-RC_BoltSpace/2,Tube_OD/2+RC_Spacer_h,TM_h/2])rotate([-90,0,0]) scale(25.4) Bolt4Hole();
		
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
			translate([0,0,Tube_OD])scale(25.4)Bolt4Hole();
		} // diff
	
} // Tube3Junction

//rotate([0,-90,0])Tube3Junction(TubeAngle=150,Length=60,WireExit=75);

module Tube2Pivot(TubeAngle=180,Length=50,WireExit=0){
	nBolts=6;
	
	difference(){
		union(){
			translate([0,0,Length/2])TubeEnd(TubeOD=Tube_OD,Wall_t=0.84,Hole_d=14, Stop_l=6);
			rotate([TubeAngle,0,0])translate([0,0,Length/2])TubeEnd(TubeOD=Tube_OD,Wall_t=0.84,Hole_d=14, Stop_l=6);
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
			translate([0,0,Tube_OD])scale(25.4)Bolt4Hole();
		} // diff
} // Tube2Pivot

//rotate([0,-90,0])Tube2Pivot(TubeAngle=150,Length=60,WireExit=-105);

module Tube2PivotCover(Length=50){
	nBolts=6;
	translate([0,0,-2]){
	difference(){
		cylinder(d=Length,h=2);
		
		// Center hole
		translate([0,0,-Overlap])cylinder(d=Bearing_OD-2,h=3);
		
		// bolts
		for (j=[0:nBolts-1]) rotate([0,0,360/nBolts*j]) translate([Bearing_OD/2+4.5,0,2])
			scale(25.4)Bolt4ClearHole();
		
	} // diff
	
	difference(){
		cylinder(d=Bearing_OD-IDXtra,h=4);
		
		translate([0,0,-Overlap]) cylinder(d=Bearing_OD-4,h=10);
	} // diff
	
	difference(){
		cylinder(d=Length-6-IDXtra,h=4);
		
	
		
		translate([0,0,-Overlap]) cylinder(d=Length-6-IDXtra-4,h=10);
	} // diff
}
} // Tube2PivotCover

//translate([Tube_OD/2+Overlap,0,0])rotate([0,-90,0])
//Tube2PivotCover(Length=60);































