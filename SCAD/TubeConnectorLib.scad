// ***************************************************
// Tube Connector Library
// Filename: TubeConnectorLib.scad
// by David M. Flynn
// Created: 3/4/2018
// Revision: 1.1.4 9/3/2018
// Units: mm
// ***************************************************
// History:
echo(str("TubeConnectorLib 1.1.4"));
// 1.1.4 9/3/2018  Added GluingFixture()
// 1.1.3 7/2/2018  Added TubeSocketBolts
// 1.1.2 5/14/2018 Added DoubleBoltFlange.
// 1.1.1 4/14/2018 Added TubeFlange.
// 1.1.0 3/4/2018  Added TubeSocket.
// 1.0.3 1/27/2018 Added cone to TubeEnd to make wire threading easier.
// 1.0.2 1/26/2018 Added GlueAllowance. Added Tube2Pivot, Tube2PivotCover.
// 1.0.1 1/21/2018 Added TubeSection.
// 1.0.0 1/16/2018 First code.
// ***************************************************
// Notes:
//  if GlueAllowance is >0 (0.4 is recommended) the tube end is a
//   looser fit and has a glue grip groove.
// ***************************************************
// for STL output

// TubeEll_STL(TubeOD=25.4,Wall_t=0.84,Hole_d=14, GlueAllowance=0.40);
// rotate([0,-90,0])Tube2Pivot(TubeAngle=150,Length=60,WireExit=-105, GlueAllowance=0.2);
// Tube2PivotCover(Length=60);
// TubeSocket(TubeOD=25.4, SocketLen=16, Threaded=true);
// TubeSocket(TubeOD=25.4, SocketLen=16, Threaded=false);
// TubeFlange(TubeOD=25.4,FlangeLen=10,Threaded=true);
// rotate([180,0,0])DoubleBoltFlange(TubeOD=19.05,FlangeLen=7,Threaded=false);
// rotate([180,0,0])DoubleBoltFlange(TubeOD=19.05,FlangeLen=7,Threaded=true);
// GluingFixture(TubeOD=25.4);

// ***************************************************
// Routines
// TubeEll_STL(TubeOD=25.4,Wall_t=0.84,Hole_d=14, GlueAllowance=0.40);
// TubeSection(TubeOD=25.4,Wall_t=0.84, Length=100);
// TubeEnd(TubeOD=25.4,Wall_t=0.84,Hole_d=14, Stop_l=TubeStop_l, GlueAllowance=0.40);
// TubeEll(TubeOD=25.4,Wall_t=0.84,Hole_d=14, GlueAllowance=0.40);
// Tube2Pivot(TubeAngle=180,Length=50,WireExit=0, GlueAllowance=0.40);
// Tube2PivotCover(Length=60);
// TubeSocketBolts(TubeOD=25.4) children();
// function TubeFlageOD(TubeOD=25.4) = TubeOD+BoltOffset*4;
// ***************************************************

include<CommonStuffSAEmm.scad>

// Override these constants as required
$fn=90;
Overlap=0.05;
IDXtra=0.2;

TubeStop_l=2;
TubeGrip_l=0.5; //x TubeOD (default 0.375)
Tube_OD=25.4;
BoltOffset=4;
Bearing_ID=12.7;
Bearing_OD=28.575;
Bearing_W=7.938;

function TubeFlageOD(TubeOD=25.4) = TubeOD+BoltOffset*4;

module TubeFlange(TubeOD=25.4,FlangeLen=10,Threaded=true){
		
	difference(){
		cylinder(d=TubeOD+BoltOffset*4, h=FlangeLen);
			
		translate([0,0,-Overlap]) cylinder(d=TubeOD-1, h=FlangeLen+Overlap*2);
		
		if (Threaded==true){
				for (j=[0:7]) rotate([0,0,360/8*j]) translate([TubeOD/2+BoltOffset,0,10]) Bolt4Hole(depth=13);
			} else {
				for (j=[0:7]) rotate([0,0,360/8*j]) translate([TubeOD/2+BoltOffset,0,7]) Bolt4HeadHole(depth=13);
			}
	} // diff
} // TubeFlange

//TubeFlange(TubeOD=19.05,FlangeLen=10,Threaded=false);

module GluingFixture(TubeOD=25.4){
	difference(){
		translate([0,0,3]) cube([70,70,6],center=true);
		
		// bolts
		for (j=[0:7]) rotate([0,0,360/8*j]) translate([TubeOD/2+BoltOffset,0,6]) Bolt4Hole();
		
		// 15° edge
		translate([36,-35,-Overlap]) rotate([0,0,15])cube([70,100,6+Overlap*2]);
		
		// 22.5° edge
		translate([-37,-35,-Overlap]) rotate([0,0,-22.5]) mirror([1,0,0]) cube([70,100,6+Overlap*2]);
	} // diff
} // GluingFixture

//GluingFixture(TubeOD=25.4);

module DoubleBoltFlange(TubeOD=25.4,FlangeLen=10,Threaded=true){
		
	difference(){
		union(){
			cylinder(d=TubeOD+BoltOffset*4, h=FlangeLen);
			
			translate([0,0,FlangeLen-4])cylinder(d=TubeOD+BoltOffset*8, h=4);
		} // union
			
		translate([0,0,-Overlap]) cylinder(d=TubeOD-1, h=FlangeLen+Overlap*2);
		
		//translate([0,0,FlangeLen/2]) rotate_extrude() translate([TubeOD/2-0.35,0,0]) circle(d=2);
		//translate([0,0,-Overlap]) cylinder(d=TubeOD-1, h=SocketLen+Overlap*2);
		//translate([0,0,1]) cylinder(d=TubeOD+IDXtra, h=SocketLen);


		for (j=[0:7]) rotate([0,0,360/8*j]) translate([TubeOD/2+BoltOffset,0,7]) Bolt4HeadHole(depth=13);
			
		if (Threaded==true){
				for (j=[0:7]) rotate([0,0,360/8*j+22.5]) translate([TubeOD/2+BoltOffset*3,0,10]) Bolt4Hole(depth=13);
			} else {
				for (j=[0:7]) rotate([0,0,360/8*j+22.5]) translate([TubeOD/2+BoltOffset*3,0,7]) Bolt4ClearHole(depth=13);
			}
	} // diff
} // DoubleBoltFlange

//rotate([180,0,0])DoubleBoltFlange(TubeOD=19.05,FlangeLen=7,Threaded=false);
//rotate([180,0,0])DoubleBoltFlange(TubeOD=19.05,FlangeLen=7,Threaded=true);

module TubeSocketBolts(TubeOD=25.4){
	for (j=[0:7]) rotate([0,0,360/8*j]) translate([TubeOD/2+BoltOffset,0,0]) children();
} // TubeSocketBolts


module TubeSocket(TubeOD=25.4, SocketLen=16, Threaded=true){
		
	difference(){
		hull(){
			cylinder(d=TubeOD+BoltOffset*4, h=6);
			cylinder(d=TubeOD+6, h=SocketLen);
		} // hull
		
		translate([0,0,SocketLen/2]) rotate_extrude() translate([TubeOD/2-0.35,0,0]) #circle(d=2);
		translate([0,0,-Overlap]) cylinder(d=TubeOD-1, h=SocketLen);
		translate([0,0,1]) cylinder(d=TubeOD+IDXtra, h=SocketLen);
		
		if (Threaded==true){
				translate([0,0,10]) TubeSocketBolts(TubeOD=TubeOD) Bolt4Hole(depth=13);
			} else {
				translate([0,0,10]) TubeSocketBolts(TubeOD=TubeOD) #Bolt4HeadHole(depth=13);
			}
	} // diff
} // TubeSocket

//TubeSocket(TubeOD=25.4, SocketLen=16, Threaded=true);
//TubeSocket(TubeOD=25.4, SocketLen=16, Threaded=false);

module TubeSection(TubeOD=25.4,Wall_t=0.84, Length=100){
	difference(){
		cylinder(d=TubeOD,h=Length);
		translate([0,0,-Overlap])cylinder(d=TubeOD-Wall_t*2,h=Length+Overlap*2);
	} // diff
} // TubeSection

module TubeEnd(TubeOD=25.4,Wall_t=0.84,Hole_d=14, Stop_l=TubeStop_l, GlueAllowance=0.00){
	translate([0,0,-Stop_l])
	difference(){
		union(){
			cylinder(d=TubeOD,h=Stop_l);
			translate([0,0,Stop_l-Overlap]) cylinder(d=TubeOD-Wall_t*2-GlueAllowance,h=TubeGrip_l*TubeOD+Overlap);
			translate([0,0,Stop_l+TubeGrip_l*TubeOD-Overlap]) cylinder(d1=TubeOD-Wall_t*2-GlueAllowance,d2=TubeOD-Wall_t*2-GlueAllowance-1,h=2);
		} // union
		
		// Glue grip
		if (GlueAllowance!=0) translate([0,0,Stop_l+TubeGrip_l*TubeOD/2]) rotate_extrude() translate([TubeOD/2-Wall_t+0.25,0,0]) circle(d=2);
		
		// Center hole
		translate([0,0,-Overlap]) cylinder(d=Hole_d,h=Stop_l+TubeGrip_l*TubeOD+2+Overlap*2);
		translate([0,0,Stop_l+TubeGrip_l*TubeOD-1]) cylinder(d1=Hole_d,d2=TubeOD-6,h=3);
	} // diff
} // TubeEnd

//TubeEnd(TubeOD=25.4,Wall_t=0.84,Hole_d=14, Stop_l=TubeStop_l, GlueAllowance=0.40);
	
module TubeEll_STL(TubeOD=25.4,Wall_t=0.84,Hole_d=14, GlueAllowance=0.00){
	rotate([0,90,0])difference(){
		TubeEll(TubeOD=TubeOD,Wall_t=Wall_t,Hole_d=Hole_d, GlueAllowance=GlueAllowance);
		rotate([0,90,0]) cylinder(d=100,h=100);
	} // diff
} // TubeEll_STL

module TubeEll(TubeOD=25.4,Wall_t=0.84,Hole_d=14, GlueAllowance=0.00){
	
	rotate([-90,0,0])translate([0,0,TubeOD/2]) TubeEnd(TubeOD=TubeOD,Wall_t=Wall_t,Hole_d=Hole_d, GlueAllowance=GlueAllowance);
	translate([0,0,TubeOD/2])TubeEnd(TubeOD=TubeOD,Wall_t=Wall_t,Hole_d=Hole_d, GlueAllowance=GlueAllowance);
	
	difference(){
		hull(){
			rotate([-90,0,0])translate([0,0,TubeOD/2-TubeStop_l])cylinder(d=TubeOD,h=0.01);
			translate([0,0,TubeOD/2-TubeStop_l])cylinder(d=TubeOD,h=0.01);
		} // hull
		
		rotate([-90,0,0])translate([0,0,TubeOD/2-TubeStop_l])cylinder(d=Hole_d,h=TubeStop_l);
		translate([0,0,TubeOD/2-TubeStop_l])cylinder(d=Hole_d,h=TubeStop_l);
		
		hull(){
			rotate([-90,0,0])translate([0,0,TubeOD/2-TubeStop_l])cylinder(d=Hole_d,h=0.01);
			translate([0,0,TubeOD/2-TubeStop_l])cylinder(d=Hole_d,h=0.01);
		} // hull
	} // diff
} // TubeEll

//TubeEll(TubeOD=25.4,Wall_t=0.84,Hole_d=14, GlueAllowance=0.40);

module Tube2Pivot(TubeAngle=180,Length=50,WireExit=0, GlueAllowance=0.40){
	nBolts=6;
	
	difference(){
		union(){
			translate([0,0,Length/2])TubeEnd(TubeOD=Tube_OD,Wall_t=0.84,Hole_d=14, Stop_l=6, GlueAllowance=GlueAllowance);
			rotate([TubeAngle,0,0])translate([0,0,Length/2])TubeEnd(TubeOD=Tube_OD,Wall_t=0.84,Hole_d=14, Stop_l=6, GlueAllowance=GlueAllowance);
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
			translate([0,0,Tube_OD]) Bolt4Hole();
		} // diff
} // Tube2Pivot

//rotate([0,-90,0])Tube2Pivot(TubeAngle=150,Length=60,WireExit=-105, GlueAllowance=0.2);

module Tube2PivotCover(Length=50){
	nBolts=6;
	translate([0,0,-2]){
	difference(){
		cylinder(d=Length,h=2);
		
		// Center hole
		translate([0,0,-Overlap])cylinder(d=Bearing_OD-2,h=3);
		
		// bolts
		for (j=[0:nBolts-1]) rotate([0,0,360/nBolts*j]) translate([Bearing_OD/2+4.5,0,2])
			 Bolt4ClearHole();
		
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

//translate([Tube_OD/2+Overlap,0,0])rotate([0,-90,0]) Tube2PivotCover(Length=60);












