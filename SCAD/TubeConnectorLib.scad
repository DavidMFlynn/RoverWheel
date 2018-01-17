// ***************************************************
// Tube Connector Library
// by David M. Flynn
// Created: 1/16/2018
// Revision: 1.0.0 1/16/2018
// Units: mm
// ***************************************************
// History:
// 1.0.0 1/16/2018 First code.
// ***************************************************
// for STL output

	/*
	rotate([0,90,0])difference(){
		TubeEll(TubeOD=25.4,Wall_t=0.84,Hole_d=14);
		rotate([0,90,0]) cylinder(d=100,h=100);
	} // diff
	/**/
// ***************************************************

$fn=90;
Overlap=0.05;
IDXtra=0.2;

TubeStop_l=2;
TubeGrip_l=0.375; // x TubeOD

module TubeEnd(TubeOD=25.4,Wall_t=0.84,Hole_d=14){
	difference(){
		union(){
			cylinder(d=TubeOD,h=TubeStop_l);
			translate([0,0,TubeStop_l-Overlap]) cylinder(d=TubeOD-Wall_t*2,h=TubeGrip_l*TubeOD+Overlap);
			translate([0,0,TubeStop_l+TubeGrip_l*TubeOD-Overlap]) cylinder(d1=TubeOD-Wall_t*2,d2=TubeOD-Wall_t*2-1,h=2);
		} // union
		
		translate([0,0,-Overlap]) cylinder(d=Hole_d,h=TubeStop_l+TubeGrip_l*TubeOD+2+Overlap*2);
	} // diff
} // TubeEnd

//TubeEnd();
	
module TubeEll(TubeOD=25.4,Wall_t=0.84,Hole_d=14){
	rotate([-90,0,0])translate([0,0,TubeOD/2-TubeStop_l])TubeEnd(TubeOD=TubeOD,Wall_t=Wall_t,Hole_d=Hole_d);
	translate([0,0,TubeOD/2-TubeStop_l])TubeEnd(TubeOD=TubeOD,Wall_t=Wall_t,Hole_d=Hole_d);
	
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

