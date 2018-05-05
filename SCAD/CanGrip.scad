// **************************************************
// Soda Can Gripper
// Filename: CanGrip.scad
// Created: 4/26/2018
// Revision: 1.0d2 5/3/2018
// Units: mm
// **************************************************
// Notes:
//  Light gripper to pick up a can/bottle of soda/beer.
//  Uses one SG90 micro servo.
// **************************************************
// History:
// 1.0d1 4/27/2018 Ready for test print.
// 1.0d1 4/26/2018 First code.
// **************************************************
// ***** for STL output *****
//rotate([90,0,0]) TopMount(Servo=true);
//rotate([0,180,0])TopMount(Servo=false);
//rotate([180,0,0])	PinionGear();
//rotate([180,0,0])LeftClaw();
//RightClaw();
// **************************************************
// ***** for viewing *****
//ShowCanGripper();
// **************************************************

include <SG90ServoLib.scad>
include <TubeConnectorLib.scad>
include <involute_gears.scad>
include <ring_gear.scad>

$fn=90;
IDXtra=0.2;
Overlap=0.05;

kCan_od=70;
kClaw_h=15;
kGearPitch=260;
kPivot=kCan_od/2+10; // Pivot to can center
RClawTeeth=40;
RClawPinionTeeth=13;
LClawPinionTeeth=26;
// Pivot to servo CL
kServoCL=(kGearPitch*RClawTeeth/360)+(kGearPitch*RClawPinionTeeth/360);
LClawGearPR=kServoCL+(kGearPitch*LClawPinionTeeth/360);
LClawTeeth=LClawGearPR*360/kGearPitch;
//echo(LClawGearPR=LClawGearPR);
//echo(LClawTeeth=LClawTeeth);
//$t=0.0;
kOpen_a=22.5;
kTubeOD=19.05;
kClawWall=6;

Pinion_a=360/RClawPinionTeeth*(kOpen_a*$t/(360/RClawTeeth));
//echo(Pinion_a=Pinion_a);

module ShowCanGripper(){
	TopMount(Servo=true);
	rotate([0,180,0])TopMount(Servo=false);

	translate([0,-kServoCL,-kClaw_h/2])
	rotate([0,0,Pinion_a])
		PinionGear();
	
	rotate([0,0,kOpen_a*$t]) LeftClaw();
	
	rotate([0,0,-kOpen_a*$t])RightClaw();
	
} // ShowCanGripper

//ShowCanGripper();

module TopMount(Servo=true){
	difference(){
		union(){
			if (Servo==true)
				translate([-6,-kServoCL-13,kClaw_h/2+1])
				cube([12,36,10.4]);
			
		translate([0,-LClawGearPR-10,0]) rotate([90,0,0])
			rotate([0,0,22.5]) TubeFlange(TubeOD=kTubeOD,FlangeLen=10,Threaded=true);
			
			hull(){
				translate([0,0,-kClaw_h/2-5]) cylinder(d=20,h=kClaw_h+10);
				translate([0,-LClawGearPR-5,0]) rotate([90,0,0]) cylinder(d=35,h=5);
			}
		} // union
		
		// Pivot bolt hole #10-32 Nylon?
		translate([0,0,-kClaw_h/2-10]) cylinder(d=5,h=kClaw_h+20);
		
		// Clearance for mechanism
		difference(){
			translate([0,0,kClaw_h/2+0.5]) rotate([180,0,0])
				cylinder(r=LClawGearPR+10.7,h=kClaw_h+1);
			
			translate([0,0,kClaw_h/2]) 
				cylinder(d=20,h=2);
			translate([0,0,-kClaw_h/2-1]) 
				cylinder(d=20,h=1.0);
			// Pinion Gear Boss
			translate([0,-kServoCL,-kClaw_h/2-1]) cylinder(d=10,h=1.0);
		}
		
		// Pinin Gear Shaft
		translate([0,-kServoCL,-kClaw_h/2-15]) cylinder(d=5,h=16.0);
			
		if (Servo==true) translate([0,-kServoCL,kClaw_h/2+14])
			rotate([180,0,90])ServoSG90();
		
		// trim flange
		//translate([0,-LClawGearPR-10,0]) rotate([180,0,0]) cylinder(d=50,h=50);
	} // diff
} // TopMount

//rotate([90,0,0])TopMount();
//rotate([0,180,0])TopMount();

module ClawBack(){
	// Drawn in the closed position
	translate([0,0,-kClaw_h/2])
	difference(){
		translate([kClaw_h,-kCan_od/2-kClawWall,0])
			cube([kCan_od/2,kCan_od+kClawWall*2,kClaw_h]);
		
		// Grip gluing holes
		for (j=[0:12]) rotate([0,0,-60+10*j]){
			translate([kCan_od/2-Overlap,0,kClaw_h/2-2])
				rotate([0,90,0]) cylinder(d=2,h=2);
			translate([kCan_od/2-Overlap,0,kClaw_h/2+2])
				rotate([0,90,0]) cylinder(d=2,h=2);
		}
		
		// Pivot
		translate([0,-kPivot,kClaw_h/2])cylinder(d=40,h=kClaw_h);
		// Can
		translate([0,0,-Overlap]) cylinder(d=kCan_od,h=kClaw_h+Overlap*2);
		
		// back
		translate([0,0,-Overlap]) difference(){
			cylinder(d=kCan_od*2,h=kClaw_h+Overlap*2);
			
			
			translate([0,0,-Overlap])
				cylinder(d=kCan_od+kClawWall*2,h=kClaw_h+Overlap*4);
			translate([0,-kCan_od/2-kClaw_h-Overlap,-Overlap])
				cube([kCan_od/2,kClaw_h*2,kClaw_h+Overlap*4]);
		}
	} // diff
} // ClawBack

//ClawBack();

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


































