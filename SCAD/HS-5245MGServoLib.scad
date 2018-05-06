// **************************************************
// HS-5245MG Servo Library
// David M. Flynn
// Filename: HS-5245MGServoLib.scad
// Created: 5/5/2018
// Rev: 1.0.0 5/5/2018
// Units: millimeters
// **************************************************
// History:
	echo("HS-5245MGServoLib 1.0.0");
// 1.0.0 4/28/2018 Coppied from SG90ServoLib.scad
// **************************************************
// Notes:
//  Mounting of R/C mini servo HS-5245MG.
//  ToDo: Servo wheel needs adjusting.
// **************************************************
// Routines
//	ServoHS5245MG();
//	HS5245MGServoWheel();
// **************************************************

include<CommonStuffSAEmm.scad>

$fn=90;

module ServoHS5245MG(){
	kDeck_x=44.2;
	kDeck_z=2.5;
	kWheel_z=12.0;
	kWheelOffset=8; // body CL to wheel CL
	kBoltCl=38.9;
	kBoltCl_y=8;
	kWidth=16.9;
	
	kBody_h=23.8;
	kBody_l=32.5;
	kTopBoss_d=13;
	
	kTopBox_h=7.5;
	
	translate([kWheelOffset,0,0]){
		translate([-kDeck_x/2,-kWidth/2,0]) cube([kDeck_x,kWidth,kDeck_z]);
		translate([-kBody_l/2,-kWidth/2,kDeck_z]) cube([kBody_l,kWidth,kTopBox_h]);
		translate([-kBody_l/2,-kWidth/2,-kBody_h]) cube([kBody_l,kWidth,kBody_h]);
		
		translate([-kBoltCl/2,kBoltCl_y/2,0]) Bolt4Hole();
		translate([kBoltCl/2,kBoltCl_y/2,0]) Bolt4Hole();
		translate([-kBoltCl/2,-kBoltCl_y/2,0]) Bolt4Hole();
		translate([kBoltCl/2,-kBoltCl_y/2,0]) Bolt4Hole();
		translate([-kBoltCl/2,kBoltCl_y/2,0]) rotate([180,0,0])Bolt4Hole();
		translate([kBoltCl/2,kBoltCl_y/2,0]) rotate([180,0,0])Bolt4Hole();
		translate([-kBoltCl/2,-kBoltCl_y/2,0]) rotate([180,0,0])Bolt4Hole();
		translate([kBoltCl/2,-kBoltCl_y/2,0]) rotate([180,0,0])Bolt4Hole();
		
		
	}
	cylinder(d=kTopBoss_d,h=kWheel_z);
	
	//Gear
	translate([0,0,kWheel_z]) cylinder(d=24,h=5);
} // ServoHS5245MG

//ServoHS5245MG();

module HS5245MGServoWheel(){
	kHornThickness=2.1;
	kHub_d=9.4;
	
	cylinder(d=7.8,h=kHornThickness+1.2);
	cylinder(d=5.8,h=kHornThickness+10);
	
	hull(){
			translate([0,0,-Overlap]) cylinder(d=kHub_d,h=kHornThickness);
			translate([0,16.05,-Overlap]) cylinder(d=5.1,h=kHornThickness);
		} // hull
		
	hull(){
			translate([0,0,-Overlap]) cylinder(d=kHub_d,h=kHornThickness);
			translate([0,-16.05,-Overlap]) cylinder(d=5.1,h=kHornThickness);
		} // hull
		
		hull(){
			translate([0,0,-Overlap]) cylinder(d=kHub_d,h=kHornThickness);
			translate([-15.05,0,-Overlap]) cylinder(d=5.1,h=kHornThickness);
		} // hull
		
		hull(){
			translate([0,0,-Overlap]) cylinder(d=kHub_d,h=kHornThickness);
			translate([15.05,0,-Overlap]) cylinder(d=5.1,h=kHornThickness);
		} // hull
} // HS5245MGServoWheel

//HS5245MGServoWheel();


