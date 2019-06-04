// *************************************************
// Actobotics Channel and Plate Holes Library
// Filename: ActoboticsLib.scad
// Created: 5/27/2019
// Revision: 1.0.0 5/27/2019
// Units: mm
// *************************************************
//  ***** Notes *****
// for (x=[0:1]) for (y=[0:1]) translate([x*1.5*25.4,y*1.5*25.4,0]) ChassisPlateFullPattern() Bolt6Hole();
// *************************************************
//  ***** History *****
// 1.0.0 5/27/2019 First Code
// *************************************************
//  ***** Routines *****
// ChannelBoltPattern0770() children();
// ChassisPlatePattern() children();
// ChannelBoltPattern1500() children();
// ChassisPlateFullPattern() children();
// *************************************************


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
//translate([1.5*25.4,0,0]) ChannelBoltPattern0770() Bolt6Hole();

module ChassisPlatePattern(){
	H1X=0.439*25.4/2;
	H1Y=1.061*25.4/2;
	H2X=1.061*25.4/2; // 0.956
	H2Y=0.439*25.4/2; // 0.544
	
	H3XY=1.5*25.4/2;
	
	translate([H1X,H1Y,0]) children();
	translate([H1X,-H1Y,0]) children();
	translate([-H1X,H1Y,0]) children();
	translate([-H1X,-H1Y,0]) children();

	translate([H2X,H2Y,0]) children();
	translate([H2X,-H2Y,0]) children();
	translate([-H2X,H2Y,0]) children();
	translate([-H2X,-H2Y,0]) children();
	
	translate([-H3XY,-H3XY,0]) children();
	translate([H3XY,-H3XY,0]) children();
	translate([-H3XY,H3XY,0]) children();
	translate([H3XY,H3XY,0]) children();

	translate([-H3XY,0,0]) children();
	translate([H3XY,0,0]) children();
	translate([0,H3XY,0]) children();
	translate([0,-H3XY,0]) children();
	
} // ChassisPlatePattern

//ChassisPlatePattern() Bolt6Hole();
//translate([1.5*25.4,0,0]) ChassisPlatePattern() Bolt6Hole();

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
//translate([1.5*25.4,0,0]) ChannelBoltPattern1500() Bolt6Hole();

module ChassisPlateFullPattern(){
	ChannelBoltPattern1500() children();
	ChassisPlatePattern() children();
	ChannelBoltPattern0770() children();
} // ChassisPlateFullPattern


