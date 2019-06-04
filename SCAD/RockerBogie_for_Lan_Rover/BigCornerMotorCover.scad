// **************************************************
// Big Corner Motor Cover
// David M. Flynn
// Filename: RoverWheel.scad
// Created: 3/15/2018
// Rev: 1.0.0 3/15/2018
// Units: millimeters
// **************************************************
// History:
// **************************************************

include<CommonStuffSAEmm.scad>

$fn=90;
IDXtra=0.2;
Overlap=0.05;

module MotorCover(){
	Motor_d=40;
	Motor_h=76;
	Wall_t=1.0;

	
	difference(){
		union(){
			cylinder(d=Motor_d+Wall_t*2, h=Motor_h+1);
			
			hull(){
				translate([ChannelLength/2,-(Motor_d+Wall_t*2)/2,Motor_h+1-Overlap])cube([2,Motor_d+Wall_t*2,0.01]);
				translate([-ChannelLength/2-2,-(Motor_d+Wall_t*2)/2,Motor_h+1-Overlap])cube([2,Motor_d+Wall_t*2,0.01]);
				translate([0,0,Motor_h-15]) cylinder(d=Motor_d+Wall_t*2,h=0.01);
			} // hull
		} // union
		
		translate([0,0,1]) cylinder(d=Motor_d,h=Motor_h+Overlap);
		
	} // diff
	
	difference(){
		translate([ChannelLength/2,-(Motor_d+Wall_t*2)/2,Motor_h+1-Overlap])cube([2,Motor_d+Wall_t*2,10]);
		translate([ChannelLength/2+3,0,Motor_h+1+1.5/2*25.4])rotate([0,90,0])ChannelBoltPattern1500() Bolt8ClearHole();
	}
	difference(){
		translate([-ChannelLength/2-2,-(Motor_d+Wall_t*2)/2,Motor_h+1-Overlap])cube([2,Motor_d+Wall_t*2,10]);
		translate([-ChannelLength/2-3,0,Motor_h+1+1.5/2*25.4])rotate([0,-90,0])ChannelBoltPattern1500() Bolt8ClearHole();
	}
} // MotorCover

MotorCover();

module ChannelBoltPattern0770(){
	// inches
	BC_d=0.77*25.4;
	BC_r=BC_d/2;
	
	translate([BC_r,0,0]) children();
	rotate([0,0,45]) translate([BC_r,0,0]) children();
	rotate([0,0,90]) translate([BC_r,0,0]) children();
	rotate([0,0,135]) translate([BC_r,0,0]) children();
	rotate([0,0,180]) translate([BC_r,0,0]) children();
	rotate([0,0,225]) translate([BC_r,0,0]) children();
	rotate([0,0,270]) translate([BC_r,0,0]) children();
	rotate([0,0,315]) translate([BC_r,0,0]) children();
	
} // ChannelBoltPattern0770

//ChannelBoltPattern0770() Bolt6Hole();

module ChannelBoltPattern1500(){
	// inches
	BC_d=1.50*25.4;
	BC_r=BC_d/2;
	
	rotate([0,0,45]) translate([BC_r,0,0]) children();
	rotate([0,0,135]) translate([BC_r,0,0]) children();
	rotate([0,0,225]) translate([BC_r,0,0]) children();
	rotate([0,0,315]) translate([BC_r,0,0]) children();
	
} // ChannelBoltPattern1500

//ChannelBoltPattern1500() Bolt6Hole();

	ChannelDepth=1.410*25.4;
	ChannelWidth=1.320*25.4;
	ChannelLength=1.500*25.4;
