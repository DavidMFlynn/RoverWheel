// *************************************************
// filename: CommondStuffSAE.scad
//  by Dave Flynn 2015, GPL v2
// Rev: 0.9.3 11/23/2017 Added Bolt4FlatHeadHole
// Some hole sizes have not been tested.
//
// This file contains constants and some common routines
// Units: Inches
// *************************************************
//  Routines for making bolt holes in parts
//  #2-56
// Bolt2ButtonHeadHole(lDepth=0.3,lHead=0.5);
// Bolt2HeadHole(lDepth=0.3,lHead=0.5);
// Bolt2Hole(depth=0.4);
// Bolt2ClearHole(depth=0.5);
//  #4-40
// Bolt4FlatHeadHole(lDepth=0.3,lAccess=0.5);
// Bolt4ButtonHeadHole(lDepth=0.3,lHead=0.5);
// Bolt4HeadHole(lDepth=0.3,lHead=0.5);
// Bolt4Hole(depth=0.5);
// Bolt4ClearHole(depth=0.5);
//  #6-32
// Bolt6ButtonHeadHole(lDepth=0.5,lHead=0.5);
// Bolt6HeadHole(lDepth=0.625, lAccess=0.5);
// Bolt6Hole(depth=0.625);
// Bolt6ClearHole(depth=0.5);
//  #8-32
// Bolt8ButtonHeadHole(lDepth=0.5,lHead=0.5);
// Bolt8HeadHole(lDepth=0.5, lAccess=0.5);
// Bolt8Hole(depth=0.75);
// Bolt8ClearHole(depth=0.5);
//  #10-32, #10-24, M5
// Bolt10ButtonHeadHole(lDepth=0.5,lHead=0.5);
// Bolt10HeadHole(lDepth=0.5, lAccess=0.5);
// Bolt10Hole(depth=0.75);
// Bolt10ClearHole(depth=0.75);
//  1/4"-20
// Bolt250ButtonHeadHole(lDepth=0.5,lHead=0.5);
// Bolt250HeadHole(lDepth=0.5, lAccess=0.5);
// Bolt250Hole(depth=0.75);
// Bolt250ClearHole(depth=0.75);
//
// Size17StepperBolts() //children();
// Size17StepperMount(x=Motor17_w,y=Motor17_w,Mount_h=0.2);
// Size17Stepper();
// *************************************************
// History
// 0.9.3 11/23/2017 Added Bolt4FlatHeadHole
// 0.9.2 9/19/2017  Added Size17StepperBolts, Size17StepperMount, Size17Stepper.
// 0.9.1 2/28/2016	Added Bolt6TapHole_r, made Bolt6_r 0.005 smaller
// 0.9 1/30/2016 	First rev'd version, Did a bunck of cleanup
// *************************************************
//ShowAllBolts(); // for visulization
//scale([25.4,25.4,25.4]) HoleTestBlock(); // Print 1 to test fit all bolts

// ********** Constants **********

OverLap=0.004;  // used to ensure manifoldness
Overlap=OverLap;
ID_Xtra=0.004;	// Added to ID to compensate for printing DMF3D

//ID_Xtra=0.008;	// Added to ID to compensate for printing Bukobot 1

Bolt2_r=0.038;
Bolt2_Head_h=0.090;
Bolt2_Head_r=0.060;
Bolt2_BtnHead_r=0.090;
Bolt2_BtnHead_h=0.045;
Bolt2_Clear_r=0.053;

Bolt4_r=0.050;
Bolt4TapHole_r=0.0445;
Bolt4_Head_r=0.091;	
Bolt4_Head_h=0.116;
Bolt4_BtnHead_r=0.120;// 0.015 over so M3 is OK
Bolt4_BtnHead_h=0.066;
Bolt4_FlatHd_d=0.255;
Bolt4_FlatHd_h=0.083;
Bolt4_Clear_r=0.063;

Bolt6_r=0.058;
Bolt6TapHole_r=0.055;
Bolt6_Head_r=0.125;
Bolt6_Head_h=0.140;
Bolt6_BtnHead_r=0.135;
Bolt6_BtnHead_h=0.075;
Bolt6_Clear_r=0.073;

Bolt8TapHole_r=0.068;
Bolt8_r=0.070;
Bolt8_Head_r=0.145;
Bolt8_Head_h=0.22;
Bolt8_BtnHead_r=0.188;
Bolt8_BtnHead_h=0.095;
Bolt8_Clear_r=0.090;

Bolt10TapHole_r=0.080;
Bolt10_r=0.080; // was 0.094;
Bolt10_Head_r=0.157;
Bolt10_Head_h=0.195;
Bolt10_BtnHead_r=0.190;
Bolt10_BtnHead_h=0.115;
Bolt10_Clear_r=0.105;

Bolt250TapHole_r=0.100;
Bolt250_r=0.110;
Bolt250_Head_r=0.190;
Bolt250_Head_h=0.250;
Bolt250_BtnHead_r=0.210;
Bolt250_BtnHead_h=0.135;
Bolt250_Clear_r=0.128;

// ***** #2-56 *****

module Bolt2ButtonHeadHole(lDepth=0.3,lHead=0.5){
	translate([0,0,-lDepth-Bolt2_BtnHead_h])
		cylinder(r=Bolt2_Clear_r+ID_Xtra,h=lDepth+OverLap,$fn=24);
	translate([0,0,-Bolt2_BtnHead_h])
		cylinder(r=Bolt2_BtnHead_r+ID_Xtra,h=lHead,$fn=24);
} // Bolt2ButtonHeadHole

module Bolt2HeadHole(lDepth=0.3,lHead=0.5){
	translate([0,0,-lDepth-Bolt2_Head_h])
		cylinder(r=Bolt2_Clear_r+ID_Xtra,h=lDepth+OverLap,$fn=24);
	translate([0,0,-Bolt2_Head_h])
		cylinder(r=Bolt2_Head_r+ID_Xtra,h=lHead,$fn=24);
} // Bolt2HeadHole

module Bolt2Hole(depth=0.4){
	translate([0,0,-depth-OverLap])
		cylinder(r=Bolt2_r+ID_Xtra,h=depth+OverLap*2,$fn=24);
} // Bolt2Hole

module Bolt2ClearHole(depth=0.5){
	translate([0,0,-depth-OverLap])
		cylinder(r=Bolt2_Clear_r+ID_Xtra,h=depth+OverLap*2,$fn=24);
} // BoltClearHole

// ***** #4-40 *****

module Bolt4ButtonHeadHole(lDepth=0.3,lHead=0.5){
	translate([0,0,-lDepth-Bolt4_BtnHead_h])
		cylinder(r=Bolt4_Clear_r+ID_Xtra,h=lDepth+OverLap,$fn=24);
	translate([0,0,-Bolt4_BtnHead_h])
		cylinder(r=Bolt4_BtnHead_r+ID_Xtra,h=lHead,$fn=24);
} // Bolt4ButtonHeadHole

module Bolt4HeadHole(lDepth=0.3,lHead=0.5){
	translate([0,0,-lDepth-Bolt4_Head_h])
		cylinder(r=Bolt4_Clear_r+ID_Xtra,h=lDepth+OverLap,$fn=24);
	translate([0,0,-Bolt4_Head_h])
		cylinder(r=Bolt4_Head_r+ID_Xtra,h=lHead,$fn=24);
} // Bolt4HeadHole


module Bolt4FlatHeadHole(lDepth=0.3,lAccess=0.5){
	translate([0,0,-lDepth])
		cylinder(r=Bolt4_Clear_r+ID_Xtra,h=lDepth+OverLap,$fn=24);
	translate([0,0,-Bolt4_FlatHd_h])
		cylinder(d1=Bolt4_Clear_r+ID_Xtra,d2=Bolt4_FlatHd_d+ID_Xtra,h=Bolt4_FlatHd_h,$fn=24);
	translate([0,0,-OverLap])cylinder(d=Bolt4_FlatHd_d+ID_Xtra,h=lAccess,$fn=24);
} // Bolt4FlatHeadHole



module Bolt4Hole(depth=0.5){
	translate([0,0,-depth-OverLap])
		cylinder(r=Bolt4_r+ID_Xtra,h=depth+OverLap*2,$fn=24);
} // Bolt4Hole

module Bolt4ClearHole(depth=0.5){
	translate([0,0,-depth-OverLap])
		cylinder(r=Bolt4_Clear_r+ID_Xtra,h=depth+OverLap*2,$fn=24);
} // BoltClearHole

// ***** #6-32 *****

module Bolt6ButtonHeadHole(lDepth=0.5,lHead=0.5){
	translate([0,0,-lDepth-Bolt6_BtnHead_h])
		cylinder(r=Bolt6_Clear_r+ID_Xtra,h=lDepth+OverLap,$fn=24);
	translate([0,0,-Bolt6_BtnHead_h])
		cylinder(r=Bolt6_BtnHead_r+ID_Xtra,h=lHead,$fn=24);
} // Bolt6ButtonHeadHole

module Bolt6ClearHole(depth=0.5){
	translate([0,0,-depth-OverLap])
		cylinder(r=Bolt6_Clear_r+ID_Xtra,h=depth+OverLap*2,$fn=24);
} // BoltClearHole

module Bolt6Hole(depth=0.625){
	translate([0,0,-depth-OverLap])
		cylinder(r=Bolt6_r+ID_Xtra,h=depth+OverLap*2,$fn=24);
} // BoltClearHole

module Bolt6HeadHole(lDepth=0.625, lAccess=0.5){
	translate([0,0,-lDepth-Bolt6_Head_h])
		cylinder(r=Bolt6_Clear_r+ID_Xtra,h=lDepth+OverLap,$fn=24);
	translate([0,0,-Bolt6_Head_h])
		cylinder(r=Bolt6_Head_r+ID_Xtra,h=Bolt6_Head_h+lAccess+OverLap,$fn=24);
} // Bolt6HeadHole

// ***** #8-32 *****

module Bolt8ButtonHeadHole(lDepth=0.5,lHead=0.5){
	translate([0,0,-lDepth-Bolt8_BtnHead_h])
		cylinder(r=Bolt8_Clear_r+ID_Xtra,h=lDepth+OverLap,$fn=24);
	translate([0,0,-Bolt8_BtnHead_h])
		cylinder(r=Bolt8_BtnHead_r+ID_Xtra,h=lHead,$fn=24);
} // Bolt8ButtonHeadHole

module Bolt8Hole(depth=0.75){
	translate([0,0,-depth-OverLap])
		cylinder(r=Bolt8_r+ID_Xtra,h=depth+OverLap*2,$fn=24);
} // Bolt8Hole

module Bolt8HeadHole(lDepth=0.5, lAccess=0.5){
	translate([0,0,-lDepth-Bolt8_Head_h])
		cylinder(r=Bolt8_Clear_r+ID_Xtra,h=lDepth+OverLap,$fn=24);
	translate([0,0,-Bolt8_Head_h])
		cylinder(r=Bolt8_Head_r+ID_Xtra,h=Bolt8_Head_h+lAccess+OverLap,$fn=24);
} // Bolt8HeadHole

module Bolt8ClearHole(depth=0.5){
	translate([0,0,-depth-OverLap])
		cylinder(r=Bolt8_Clear_r+ID_Xtra,h=depth+OverLap*2,$fn=24);
} // Bolt8Hole

// ***** #10-32, #10-24, M5 *****

module Bolt10ButtonHeadHole(lDepth=0.5,lHead=0.5){
	translate([0,0,-lDepth-Bolt10_BtnHead_h])
		cylinder(r=Bolt10_Clear_r+ID_Xtra,h=lDepth+OverLap,$fn=24);
	translate([0,0,-Bolt10_BtnHead_h])
		cylinder(r=Bolt10_BtnHead_r+ID_Xtra,h=lHead,$fn=24);
} // Bolt10ButtonHeadHole

module Bolt10Hole(depth=0.75){
	translate([0,0,-depth+OverLap])
		cylinder(r=Bolt10_r+ID_Xtra,h=depth+OverLap*2,$fn=24);
} // Bolt10Hole

module Bolt10HeadHole(lDepth=0.5, lAccess=0.5){
	translate([0,0,-lDepth-Bolt10_Head_h])
		cylinder(r=Bolt10_Clear_r+ID_Xtra,h=lDepth+OverLap,$fn=24);
	translate([0,0,-Bolt10_Head_h])
		cylinder(r=Bolt10_Head_r+ID_Xtra,h=Bolt10_Head_h+lAccess+OverLap,$fn=24);
} // Bolt10HeadHole

module Bolt10ClearHole(depth=0.75){
	translate([0,0,-depth+OverLap])
		cylinder(r=Bolt10_Clear_r+ID_Xtra,h=depth+OverLap*2,$fn=24);
} // Bolt10Hole

// ***** 1/4"-20 *****

module Bolt250ButtonHeadHole(lDepth=0.5,lHead=0.5){
	translate([0,0,-lDepth-Bolt250_BtnHead_h])
		cylinder(r=Bolt250_Clear_r+ID_Xtra,h=lDepth+OverLap,$fn=24);
	translate([0,0,-Bolt250_BtnHead_h])
		cylinder(r=Bolt250_BtnHead_r+ID_Xtra,h=lHead,$fn=24);
} // Bolt250ButtonHeadHole

module Bolt250Hole(depth=0.75){
	translate([0,0,-depth+OverLap])
		cylinder(r=Bolt250_r+ID_Xtra,h=depth+OverLap*2,$fn=24);
} // Bolt250ClearHole

module Bolt250ClearHole(depth=0.75){
	translate([0,0,-depth+OverLap])
		cylinder(r=Bolt250_Clear_r+ID_Xtra,h=depth+OverLap*2,$fn=24);
} // Bolt250ClearHole

module Bolt250HeadHole(lDepth=0.5, lAccess=0.5){
	translate([0,0,-lDepth-Bolt250_Head_h])
		cylinder(r=Bolt250_Clear_r+ID_Xtra,h=lDepth+OverLap,$fn=24);
	translate([0,0,-Bolt250_Head_h])
		cylinder(r=Bolt250_Head_r+ID_Xtra,h=Bolt250_Head_h+lAccess+OverLap,$fn=24);
} // Bolt250HeadHole

// **********************************

module ShowAllBolts(){
	translate([0,2.2,0]){ Bolt2ButtonHeadHole();
	translate([0.5,0,0]) Bolt2Hole();
	translate([1,0,0]) Bolt2ClearHole();
	translate([1.5,0,0]) Bolt2HeadHole();}

	translate([0,1.85,0]){ Bolt4ButtonHeadHole();
	translate([0.5,0,0]) Bolt4Hole();
	translate([1,0,0]) Bolt4ClearHole();
	translate([1.5,0,0]) Bolt4HeadHole();}

	translate([0,1.45,0]){ Bolt6ButtonHeadHole();
	translate([0.5,0,0]) Bolt6Hole();
	translate([1,0,0]) Bolt6ClearHole();
	translate([1.5,0,0]) Bolt6HeadHole();}

	translate([0,1,0]){ Bolt8ButtonHeadHole();
	translate([0.5,0,0]) Bolt8Hole();
	translate([1,0,0]) Bolt8ClearHole();
	translate([1.5,0,0]) Bolt8HeadHole();}

	translate([0,0.5,0]){ Bolt10ButtonHeadHole();
	translate([0.5,0,0]) Bolt10Hole();
	translate([1,0,0]) Bolt10ClearHole();
	translate([1.5,0,0]) Bolt10HeadHole();}

	translate([0,0,0]){ Bolt250ButtonHeadHole();
	translate([0.5,0,0]) Bolt250Hole();
	translate([1,0,0]) Bolt250ClearHole();
	translate([1.5,0,0]) Bolt250HeadHole();}
	
} // ShowAllBolts

module HoleTestBlock(){
	difference(){
		cube([2.25,3,0.5]);
		
		translate([0.375,0.4,0.5]) ShowAllBolts();
	} // diff
	
} // HoleTestBlock

//HoleTestBlock();

Motor17_w=1.662;

module Size17StepperBolts(){
	MotorBoltCircle_d=1.732;
	
	for (J=[0:3]) rotate([0,0,90*J])
			translate([MotorBoltCircle_d/2*0.707,MotorBoltCircle_d/2*0.707,0]) children();
}// Size17StepperBolts

module Size17StepperMount(x=Motor17_w,y=Motor17_w,Mount_h=0.2){
	MotorBoss17_d=0.866+ID_Xtra;
	MotorBoltCircle_d=1.732;

	difference(){
		translate([-x/2,-y/2,0]) cube([x,y,Mount_h]);

		translate([0,0,-OverLap]) cylinder(d=MotorBoss17_d,h=Mount_h+OverLap*2,$fn=90);

		translate([0,0,Mount_h])Size17StepperBolts() Bolt4Hole();
	} // diff

} // Size17StepperMount

//Size17StepperMount();

module Size17Stepper(){
	Motor17_h=1.867;
	MotorBoss17_d=0.866;
	MotorBoss17_h=0.080;
	MotorShaft_d=5/25.4;
	MotorShaft_l=0.9;
	MotorBoltCircle_d=1.732;
	MotorBoltHole_d=0.070;
	MotorBigShaft_h=0.9;
	MotorBigShaft_d=0.661;

	translate([0,0,MotorBigShaft_h-0.350]) cylinder(d=MotorBigShaft_d,h=0.350,$fn=24);
	translate([0,0,-Motor17_h]) {
	translate([0,0,Motor17_h]) cylinder(d=MotorBoss17_d, h=MotorBoss17_h,$fn=24);
	translate([0,0,Motor17_h]) cylinder(d=MotorShaft_d, h=MotorShaft_l,$fn=24);
	
	
	difference(){
		translate([-Motor17_w/2,-Motor17_w/2,0]) cube([Motor17_w,Motor17_w,Motor17_h]);
		translate([0,0,-OverLap]) Size17StepperBolts() cylinder(d=MotorBoltHole_d, h=Motor17_h+OverLap*2,$fn=18);

	} // diff
	}
} // Size17Stepper

//Size17Stepper();
