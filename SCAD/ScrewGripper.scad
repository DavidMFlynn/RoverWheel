// **************************************************
// Screw Drive Gripper
// Filename: ScrewGripper.scad
// Created: 6/17/2018
// Revision: 1.0d1 6/17/2018
// Units: mm
// **************************************************
// Notes:
//  Light gripper to pick up a stuff.
//  Uses one SG90 micro servo.
// **************************************************
// History:
// 
// 1.0d1 6/17/2018 First code. Copied form Can Grip.
// **************************************************
// ***** for STL output *****
//rotate([90,0,0]) TopMount(Servo=true);
//rotate([0,180,0])TopMount(Servo=false);
//rotate([180,0,0])	PinionGear();
//rotate([180,0,0])LeftClaw();
//RightClaw();
// **************************************************
// ***** for viewing *****
// ShowGripper();
// **************************************************

include <SG90ServoLib.scad>
include <TubeConnectorLib.scad>
include <involute_gears.scad>
include <ring_gear.scad>

$fn=90;
IDXtra=0.2;
Overlap=0.05;


module ShowGripper(){
	// Claw
	translate([0,IP_len,Grip_width/2]) HalfFinger();
	translate([0,IP_len,Grip_width/2]) mirror([0,0,1]) HalfFinger();

	translate([Claw_Space,IP_len,Grip_width/2]) mirror([1,0,0]) HalfFinger();
	translate([Claw_Space,IP_len,Grip_width/2]) mirror([1,0,0]) mirror([0,0,1]) HalfFinger();


	// Parallels
	translate([-(IP_width+2),0,0]){
		translate([0,0,IP_thickness])rotate([0,180,0]) InsideParallel(MidBolt=0);
		translate([0,0,Grip_width-IP_thickness]) InsideParallel(MidBolt=0);}

	translate([0,0,IP_thickness])rotate([0,180,0])InsideParallel(MidBolt=0.4);
	translate([0,0,Grip_width-IP_thickness]) InsideParallel(MidBolt=0.4);

	translate([Claw_Space,0,0]){
		translate([0,0,IP_thickness])rotate([0,180,0])InsideParallel(MidBolt=0.4);
		translate([0,0,Grip_width-IP_thickness]) InsideParallel(MidBolt=0.4);}

	translate([Claw_Space+(IP_width+2),0,0]){
		translate([0,0,IP_thickness])rotate([0,180,0])InsideParallel(MidBolt=0);
		translate([0,0,Grip_width-IP_thickness]) InsideParallel(MidBolt=0);}
		
	
} // ShowGripper

ShowGripper();

Grip_width=12;
Claw_Space=40;
Claw_length=25;
IP_len=40;
IP_width=8;
IP_thickness=2.5;
IP_Bolt_d=3;

module BoltBoss(D=10,ID=3,H=3){
	difference(){
		cylinder(d=D,h=H);
		
		translate([0,0,-Overlap]) cylinder(d=ID,h=H+Overlap*2);
	} // diff
} // BoltBoss

module HalfFinger(){
	
	difference(){
		hull(){
			translate([0,Claw_length,0]) cube([IP_width,5,Grip_width/2]);
			cylinder(d=IP_width+2,h=Grip_width/2);
			translate([-IP_width-2,0,0]) cylinder(d=IP_width+2,h=Grip_width/2);
		} // hull
	
		hull(){
			translate([0,Claw_length,0.9]) cube([IP_width-2.0,3,Grip_width/2]);
			translate([3,IP_width,0.9]) cylinder(d=2,h=Grip_width/2);
			translate([-IP_width-1,IP_width,0.9]) cylinder(d=2,h=Grip_width/2);
		} // hull
		
		hull(){
			translate([IP_width,0,Grip_width/2-IP_thickness]) cylinder(d=IP_width+2+Overlap,h=Grip_width/2);
			translate([-IP_width*2,0,Grip_width/2-IP_thickness]) cylinder(d=IP_width+2+Overlap,h=Grip_width/2);
		} // hull
		
		// bolts
		translate([0,0,-Overlap]) cylinder(d=IP_Bolt_d,h=Grip_width/2+Overlap*2);
	
		translate([-IP_width-2,0,-Overlap]) cylinder(d=IP_Bolt_d,h=Grip_width/2+Overlap*2);
	} // diff
	
	BoltBoss(D=IP_width-Overlap,ID=IP_Bolt_d,H=Grip_width/2-IP_thickness);
	
	translate([-(IP_width+2),0,0]) BoltBoss(D=IP_width-Overlap,ID=IP_Bolt_d,H=Grip_width/2-IP_thickness);
} // HalfFinger

/*
translate([0,IP_len,Grip_width/2]) HalfFinger();
translate([0,IP_len,Grip_width/2]) mirror([0,0,1]) HalfFinger();

translate([Claw_Space,IP_len,Grip_width/2]) mirror([1,0,0]) HalfFinger();
translate([Claw_Space,IP_len,Grip_width/2]) mirror([1,0,0]) mirror([0,0,1]) HalfFinger();
/**/

module InsideParallel(MidBolt=0.4){
	difference(){
		hull(){
			cylinder(d=IP_width,h=IP_thickness);
			translate([0,IP_len,0]) cylinder(d=IP_width,h=IP_thickness);
		} // hull
		
		translate([0,0,0.9])
		hull(){
			cylinder(d=IP_width-2,h=IP_thickness);
			translate([0,IP_len,0]) cylinder(d=IP_width-2,h=IP_thickness);
		}
		
		// bolts
		translate([0,0,-Overlap]) cylinder(d=IP_Bolt_d,h=IP_thickness+Overlap*2);
		if (MidBolt != 0)
			translate([0,IP_len*MidBolt,-Overlap]) cylinder(d=IP_Bolt_d,h=IP_thickness+Overlap*2);
		translate([0,IP_len,-Overlap]) cylinder(d=IP_Bolt_d,h=IP_thickness+Overlap*2);
		
	} // diff
	
	// bolts
	BoltBoss(D=IP_width-Overlap,ID=IP_Bolt_d,H=IP_thickness);
	if (MidBolt != 0)
		translate([0,IP_len*MidBolt,0])BoltBoss(D=IP_width-Overlap,ID=IP_Bolt_d,H=IP_thickness);
	translate([0,IP_len,0])BoltBoss(D=IP_width-Overlap,ID=IP_Bolt_d,H=IP_thickness);
	
} // InsideParallel

/*
translate([-(IP_width+2),0,0]){
	InsideParallel(MidBolt=0);
	translate([0,0,Grip_width]) rotate([0,180,0])InsideParallel(MidBolt=0);}

InsideParallel(MidBolt=0.4);
translate([0,0,Grip_width]) rotate([0,180,0])InsideParallel(MidBolt=0.4);

translate([Claw_Space,0,0]){
	InsideParallel(MidBolt=0.4);
	translate([0,0,Grip_width]) rotate([0,180,0])InsideParallel(MidBolt=0.4);}

translate([Claw_Space+(IP_width+2),0,0]){
	InsideParallel(MidBolt=0);
	translate([0,0,Grip_width]) rotate([0,180,0])InsideParallel(MidBolt=0);}
/**/

module PinionGear(){
	
		rotate([0,0,90+180/RClawPinionTeeth])
			gear(
				number_of_teeth=RClawPinionTeeth,
				circular_pitch=kGearPitch, diametral_pitch=false,
				pressure_angle=24,
				clearance = 0.2,
				gear_thickness=kClaw_h/2,
				rim_thickness=kClaw_h/2,
				rim_width=5,
				hub_thickness=5,
				hub_diameter=10,
				bore_diameter=5,
				circles=0,
				backlash=0.5,
				twist=0,
				involute_facets=0,
				flat=false);
	
	difference(){
		translate([0,0,kClaw_h/2])rotate([0,0,90])
			gear(
				number_of_teeth=LClawPinionTeeth,
				circular_pitch=kGearPitch, diametral_pitch=false,
				pressure_angle=24,
				clearance = 0.2,
				gear_thickness=kClaw_h/2,
				rim_thickness=kClaw_h/2,
				rim_width=5,
				hub_thickness=5,
				hub_diameter=10,
				bore_diameter=5,
				circles=0,
				backlash=0.5,
				twist=0,
				involute_facets=0,
				flat=false);
		
		translate([0,0,kClaw_h]) rotate([180,0,0]) SG90ServoWheel();
	}
				
} // PinionGear

//PinionGear();
/*
translate([0,-kServoCL,-kClaw_h/2])
	rotate([0,0,Pinion_a])
		PinionGear();
/**/

module LeftClaw(){
	Pinion_d=LClawPinionTeeth*kGearPitch/180+kGearPitch/90+2;
	Pocket_od=Pinion_d+10;
	
	translate([0,kPivot,0]) rotate([0,180,0]) ClawBack();
	
	difference(){
		hull(){
			cylinder(d=20,h=kClaw_h/2);
			translate([-Pocket_od/2,2,0])cylinder(d=20,h=kClaw_h/2);
			
			translate([0,-kServoCL,0]) cylinder(d=Pocket_od,h=kClaw_h/2);
			rotate([0,0,-kOpen_a/2]) translate([0,-kServoCL,0])
				cylinder(d=Pocket_od,h=kClaw_h/2);
			rotate([0,0,-kOpen_a]) translate([0,-kServoCL,0])
				cylinder(d=Pocket_od,h=kClaw_h/2);
		} // hull
		
		translate([0,0,-Overlap]) cylinder(d=5,h=kClaw_h/2+Overlap*2);
		
		// center
		translate([0,-kServoCL,-Overlap]) cylinder(d=Pinion_d,h=kClaw_h/2+Overlap*2);
		
		rotate([0,0,-kOpen_a/2]) 
			translate([0,-kServoCL,-Overlap]) cylinder(d=Pinion_d,h=kClaw_h/2+Overlap*2);
		
		rotate([0,0,-kOpen_a]) 
			translate([0,-kServoCL,-Overlap]) cylinder(d=Pinion_d,h=kClaw_h/2+Overlap*2);
	}
	
	intersection(){
		rotate([0,0,90])
		ring_gear(number_of_teeth=LClawTeeth,
			circular_pitch=kGearPitch, diametral_pitch=false,
			pressure_angle=24,
			clearance = 0.2,
			gear_thickness=kClaw_h/2,
			rim_thickness=kClaw_h/2,
			rim_width=3,
			backlash=0.5,
			twist=0,
			involute_facets=0, // 1 = triangle, default is 5
			flat=false);
		
		union(){
			translate([0,-kServoCL,0]) cylinder(d=Pocket_od,h=kClaw_h/2);
			rotate([0,0,-kOpen_a])translate([0,-kServoCL,0]) cylinder(d=Pocket_od,h=kClaw_h/2);
		}
	}
} // LeftClaw

//rotate([0,0,kOpen_a*$t]) LeftClaw();

module RightClaw(){
	translate([0,kPivot,0]) ClawBack();
	
	translate([0,0,-kClaw_h/2])
	intersection(){
			rotate([0,0,-90])gear(
				number_of_teeth=RClawTeeth,
				circular_pitch=kGearPitch, diametral_pitch=false,
				pressure_angle=24,
				clearance = 0.2,
				gear_thickness=kClaw_h/2,
				rim_thickness=kClaw_h/2,
				rim_width=5,
				hub_thickness=5,
				hub_diameter=15,
				bore_diameter=5,
				circles=0,
				backlash=0.5,
				twist=0,
				involute_facets=0,
				flat=false);
		
		union(){
			cylinder(d=20,h=kClaw_h/2);
			rotate([0,0,-102]) translate([0,-6,0])cube([100,100,kClaw_h/2]);
			rotate([0,0,-70]) translate([-6,0,0]) cube([100,100,kClaw_h/2]);
		}
	}
} // RightClaw


//rotate([0,0,-kOpen_a*$t])RightClaw();


































