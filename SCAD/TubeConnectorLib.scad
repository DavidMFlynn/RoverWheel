// ***************************************************
// Tube Connector Library
// by David M. Flynn
// Created: 1/16/2018
// Revision: 1.0.1 1/21/2018
// Units: mm
// ***************************************************
// History:
// 1.0.1 1/21/2018 Added TubeSection.
// 1.0.0 1/16/2018 First code.
// ***************************************************
// for STL output

// TubeEll_STL(TubeOD=25.4,Wall_t=0.84,Hole_d=14);

// ***************************************************
// Routines
// TubeEll_STL(TubeOD=25.4,Wall_t=0.84,Hole_d=14);
// TubeSection(TubeOD=25.4,Wall_t=0.84, Length=100, Stop_l=TubeStop_l);
// TubeEnd(TubeOD=25.4,Wall_t=0.84,Hole_d=14);
// TubeEll(TubeOD=25.4,Wall_t=0.84,Hole_d=14);
// ***************************************************

$fn=90;
Overlap=0.05;
IDXtra=0.2;

TubeStop_l=2;
TubeGrip_l=0.375; // x TubeOD

module TubeSection(TubeOD=25.4,Wall_t=0.84, Length=100){
	difference(){
		cylinder(d=TubeOD,h=Length);
		translate([0,0,-Overlap])cylinder(d=TubeOD-Wall_t*2,h=Length+Overlap*2);
	} // diff
} // TubeSection

module TubeEnd(TubeOD=25.4,Wall_t=0.84,Hole_d=14, Stop_l=TubeStop_l){
	translate([0,0,-Stop_l])
	difference(){
		union(){
			cylinder(d=TubeOD,h=Stop_l);
			translate([0,0,Stop_l-Overlap]) cylinder(d=TubeOD-Wall_t*2,h=TubeGrip_l*TubeOD+Overlap);
			translate([0,0,Stop_l+TubeGrip_l*TubeOD-Overlap]) cylinder(d1=TubeOD-Wall_t*2,d2=TubeOD-Wall_t*2-1,h=2);
		} // union
		
		translate([0,0,-Overlap]) cylinder(d=Hole_d,h=Stop_l+TubeGrip_l*TubeOD+2+Overlap*2);
	} // diff
} // TubeEnd

//TubeEnd();
	
module TubeEll_STL(TubeOD=25.4,Wall_t=0.84,Hole_d=14){
	rotate([0,90,0])difference(){
		TubeEll(TubeOD=TubeOD,Wall_t=Wall_t,Hole_d=Hole_d);
		rotate([0,90,0]) cylinder(d=100,h=100);
	} // diff
} // TubeEll_STL

module TubeEll(TubeOD=25.4,Wall_t=0.84,Hole_d=14){
	rotate([-90,0,0])translate([0,0,TubeOD/2])TubeEnd(TubeOD=TubeOD,Wall_t=Wall_t,Hole_d=Hole_d);
	translate([0,0,TubeOD/2])TubeEnd(TubeOD=TubeOD,Wall_t=Wall_t,Hole_d=Hole_d);
	
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

//TubeEll();
