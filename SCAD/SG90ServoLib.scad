// **************************************************
// SG90 Servo Library
// David M. Flynn
// Filename: SG90ServoLib.scad
// Created: 4/28/2018
// Rev: 1.0 4/28/2018
// Units: millimeters
// **************************************************
// History:
	echo("SG90ServoLib 1.0");
// 1.0 4/28/2018 Coppied from LightArmJoint 
// **************************************************
// Notes:
//  Mounting of R/C micro servo SG90.
//  ToDo: Servo wheel needs adjusting.
// **************************************************
// Routines
//	ServoSG90();
//	SG90ServoWheel();
// **************************************************

module ServoSG90(){
	kDeck_x=32.4;
	kDeck_z=2.5;
	kWheel_z=14.2;
	kWheelOffset=5; // body CL to wheel CL
	kBoltCl=28.2;
	kWidth=12.4;
	
	kBody_h=16;
	kBody_l=23;
	
	kTopBox_h=4.5;
	
	translate([kWheelOffset,0,0]){
		translate([-kDeck_x/2,-kWidth/2,0]) cube([kDeck_x,kWidth,kDeck_z]);
		translate([-kBody_l/2,-kWidth/2,kDeck_z]) cube([kBody_l,kWidth,kTopBox_h]);
		translate([-kBody_l/2,-kWidth/2,-kBody_h]) cube([kBody_l,kWidth,kBody_h]);
		
		translate([-kBoltCl/2,0,0]) Bolt2Hole();
		translate([kBoltCl/2,0,0]) Bolt2Hole();
		translate([-kBoltCl/2,0,0]) rotate([180,0,0])Bolt2Hole();
		translate([kBoltCl/2,0,0]) rotate([180,0,0])Bolt2Hole();
		
		
	}
	cylinder(d=kWidth,h=kWheel_z);
	hull(){
		cylinder(d=6.35,h=11.5);
		translate([7,0,0])cylinder(d=6.35,h=11.5);
	}
	
	//Gear
	translate([0,0,kWheel_z]) cylinder(d=24,h=5);
} // ServoSG90

//ServoSG90();

module SG90ServoWheel(){
	hull(){
			translate([0,0,-Overlap]) cylinder(d=7,h=1.6);
			translate([0,15.1,-Overlap]) cylinder(d=4,h=1.6);
			translate([0,-15.1,-Overlap]) cylinder(d=4,h=1.6);
		} // hull
		
		hull(){
			translate([-6,0,-Overlap]) cylinder(d=3.7,h=1.6);
			translate([6,0,-Overlap]) cylinder(d=3.7,h=1.6);
		} // hull
} // SG90ServoWheel

//SG90ServoWheel();


