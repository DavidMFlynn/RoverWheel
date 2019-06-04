// **************************************
// Cable Chain Library
// Filename: CableChainLib.scad
// Created: 4/4/2019
// Units: mm
// **************************************

$fn=90;
Overlap=0.05;
IDXtra=0.2;

module CC_Link(){
	CC_h=7;
	CC_w=10;
	CC_l=9;
	CC_Pin_d=4.6;
	CC_Wall_t=1.2;
	
		
	module LinkSide(){
		translate([0,-CC_w/2,0]) rotate([-90,0,0]) cylinder(d=CC_Pin_d, h=CC_Wall_t+Overlap);
		
		hull(){
			translate([0,-CC_w/2+CC_Wall_t,0]) rotate([-90,0,0]) cylinder(d=CC_Pin_d+CC_Wall_t*2, h=CC_Wall_t);
			translate([CC_Pin_d/2+CC_Wall_t,-CC_w/2+CC_Wall_t,-CC_Pin_d/2-CC_Wall_t]) cube([0.01,CC_Wall_t,CC_Pin_d+CC_Wall_t*2]);
		} // hull
		
		// middle transition
		difference(){
			hull(){
				translate([CC_Pin_d/2+CC_Wall_t,-CC_w/2+CC_Wall_t,-CC_Pin_d/2-CC_Wall_t]) cube([0.01,CC_Wall_t,CC_Pin_d+CC_Wall_t*2]);
				translate([CC_l-CC_Pin_d/2-CC_Wall_t,-CC_w/2,-CC_Pin_d/2-CC_Wall_t]) cube([0.01,CC_Wall_t,CC_Pin_d+CC_Wall_t*2]);
			} // hull
			
			translate([0,-CC_w/2,0]) rotate([-90,0,0]) cylinder(d=CC_h+IDXtra, h=CC_Wall_t);
		} // diff
		
		difference(){
			hull(){
				translate([CC_l,-CC_w/2,0]) rotate([-90,0,0]) cylinder(d=CC_h, h=CC_Wall_t);
				translate([CC_l-CC_Pin_d/2-CC_Wall_t,-CC_w/2,-CC_h/2]) cube([0.01,CC_Wall_t,CC_h]);
			}
			translate([CC_l,-CC_w/2-Overlap,0]) rotate([-90,0,0]) cylinder(d=CC_Pin_d+IDXtra, h=CC_Wall_t+Overlap*2);
		} // diff
	} // LinkSide

	LinkSide();
	mirror([0,1,0]) LinkSide();
	
	// Bottom cross link
	hull(){
		translate([CC_Pin_d/2+CC_Wall_t,-CC_w/2+CC_Wall_t,-CC_h/2]) cube([0.01,CC_w-CC_Wall_t*2,CC_Wall_t]);
		translate([CC_l-CC_Pin_d/2-CC_Wall_t,-CC_w/2,-CC_h/2]) cube([0.01,CC_w,CC_Wall_t]);
	} // hull
	// Top cross link
	hull(){
		translate([CC_Pin_d/2+CC_Wall_t,-CC_w/2+CC_Wall_t,CC_h/2-CC_Wall_t]) cube([0.01,CC_w-CC_Wall_t*2,CC_Wall_t]);
		translate([CC_l-CC_Pin_d/2-CC_Wall_t,-CC_w/2,CC_h/2-CC_Wall_t]) cube([0.01,CC_w,CC_Wall_t]);
	} // hull

} // CC_Link

CC_Link();

