// **********************************************
// Rocker Bogie
// by David M. Flynn
// Created: 3/24/2018
// Revision: 1.0.0 3/24/2018
// **********************************************
// History
// 1.0.0 3/24/2018		First code
// **********************************************
// for Viewing
// PhantomWheel();
// OneCorner();
// OneCornerFL();
// **********************************************

include<CommonStuffSAEmm.scad>
include<RoverWheel.scad>

include<TubeConnectorLib.scad>

include<CornerPivot.scad>
include<RockerPivot.scad>

$fn=24;
IDXtra=0.2;
Overlap=0.05;

Tube_OD=25.4;
Tire_OD=155;
Tire_w=88;
TubeOffset_X=-Tire_w/2-6-Tube_OD/2;
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


module PhantomWheel(){
	
	translate([-Tire_w/2+(WheelMount_l-6),0,0])rotate([0,-90,0])WheelMount();
	translate([-Tire_w/2-6.1,0,0])rotate([0,-90,0])TubeConnector();
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
		
		// wheel to ell tube
		color("LightGray") TubeSection(TubeOD=Tube_OD,Wall_t=0.84, Length=50);
		
		//*
		translate([0,0,50+Tube_OD/2]){
			rotate([0,-90,180]) rotate([0,0,90]) TubeEll(TubeOD=Tube_OD, Wall_t=0.84, Hole_d=14, GlueAllowance=0.40);
			
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
			rotate([180,0,90])  TubeEll(TubeOD=Tube_OD, Wall_t=0.84, Hole_d=14, GlueAllowance=0.40);
			
			// Corner pivot to ell tube
			translate([Tube_OD/2,0,0]) rotate([0,90,0]) 
				color("LightGray") TubeSection(TubeOD=Tube_OD, Wall_t=0.84, Length=50);
			}
		
	}
} // OneCornerFL


//translate([-43,200,TubeOffset_Z+93+45.5])rotate([0,90,0])translate([0,0,2])rotate([0,0,10])RockerArmConnector();



















