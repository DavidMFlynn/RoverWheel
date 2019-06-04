// **********************************************
// Rocker Bogie for Lan's Rover
// Filename: RockerBogieCrossBar.scad
// by David M. Flynn
// Created: 5/20/2018
// Revision: 1.0.2 5/27/2019
// Units: mm
// **********************************************
//  ***** Notes *****
// This is the cross bar to connect the main pivots and chassis.
// **********************************************
//  ***** History *****
// 1.0.2 5/27/2019 Moved Actobotics hole patterns to ActoboticsLib.scad
// 1.0.1 5/22/2019 Added Chassis plate bolt pattern
// 1.0.0 5/20/2019 First code
// **********************************************
//  ***** for STL output *****
// CrossBarBearingCover();
// CrossBar(myFn=360);
// rotate([180,0,0]) CrossBarCover(IsBottom=false); // Print 2
// rotate([180,0,0]) CrossBarCover(IsBottom=true); // Print 2
// CrossBarEnd(); // Print 2
// ChassisPost(myFn=360);
// **********************************************
//  ***** for Viewing *****
// ShowCrossBar(myFn=36);
// **********************************************
// **** other routines *****
// **********************************************

include<ActoboticsLib.scad>
include<CommonStuffSAEmm.scad>
include<BearingLib.scad>

$fn=24;
//$fn=180;
IDXtra=0.2;
Overlap=0.05;

RaceBoltInset=4.5;
BearingPreload=-0.2;
Ball_d=9.525;
ChassisPostBearing_BC=50;
ChassisPostCL_h=14;
Race_w=12;
CrossBar_L=233+36*2;
CrossBar_a=25;

module ShowCrossBar(myFn=36){
	
	color("Green") ChassisPost(myFn=myFn);
	color("Silver") CrossBar(myFn=myFn);
	translate([0,0,14+Overlap*2]) color("Tan") CrossBarBearingCover();
	translate([0,0,12+Overlap]) color("Orange") CrossBarCover(IsBottom=false);
	translate([0,0,-Overlap]) rotate([180,0,0]) color("LightBlue") CrossBarCover(IsBottom=true);
	translate([0,0,12+Overlap]) rotate([0,0,180]) color("Orange") CrossBarCover(IsBottom=false);
	translate([0,0,-Overlap]) rotate([180,0,180]) color("LightBlue") CrossBarCover(IsBottom=true);
	CrossBarEnd();
	rotate([0,0,180]) CrossBarEnd();

} // ShowCrossBar

//ShowCrossBar(myFn=36);

module ChassisPost(myFn=36){
	nChBolts=8;
	
	
	OnePieceInnerRace(BallCircle_d=ChassisPostBearing_BC,Race_ID=20,Ball_d=Ball_d, Race_w=Race_w, 
		PreLoadAdj=BearingPreload, VOffset=0.00, BI=true, myFn=myFn);
	
	translate([0,0,-ChassisPostCL_h+Race_w/2]) 
	difference(){
		cylinder(d1=52,d2=ChassisPostBearing_BC-Ball_d*0.7,h=ChassisPostCL_h-Race_w/2+1);
		
		translate([0,0,-Overlap]) cylinder(d=20,h=ChassisPostCL_h+Overlap*3);
		
		//for (j=[0:nChBolts-1]) rotate([0,0,360/nChBolts*j]) translate([20,0,0]) rotate([180,0,0]) Bolt4Hole();
		
		intersection(){
			translate([-0.75*25.4,-0.75*25.4,0])
			for (x=[0:1]) for (y=[0:1]) translate([x*1.5*25.4,y*1.5*25.4,0]) 
				ChassisPlateFullPattern() rotate([180,0,0]) #Bolt6Hole();
			
			translate([0,0,-Overlap]) cylinder(d=46,h=20);
		} // int
	} // diff
} // ChassisPost

ChassisPost(myFn=36);

TieBar_w=8;
nRaceBolts=8;
InnerArmBoltSpacing=14;
OuterArmBoltSpacing=15;

module CrossBar(myFn=36){
	
	OnePieceOuterRace(BallCircle_d=ChassisPostBearing_BC, Race_OD=ChassisPostBearing_BC+Ball_d+5, Ball_d=Ball_d, Race_w=Race_w, 
					PreLoadAdj=BearingPreload, VOffset=0.00, BI=true, myFn=myFn);

	
	difference(){
		union(){
			cylinder(d=ChassisPostBearing_BC+Ball_d*3,h=12);
			
			hull(){
				translate([CrossBar_L/2,0,0]) rotate([0,0,-CrossBar_a/2]) translate([-80,0,0])  cylinder(d=TieBar_w,h=12);
				translate([CrossBar_L/2,0,0]) rotate([0,0,-CrossBar_a/2]) translate([-150,0,0])  cylinder(d=TieBar_w,h=12);
			} // hull
			
			hull(){
				translate([CrossBar_L/2,0,0]) rotate([0,0,CrossBar_a/2]) translate([-80,0,0])  cylinder(d=TieBar_w,h=12);
				translate([CrossBar_L/2,0,0]) rotate([0,0,CrossBar_a/2]) translate([-150,0,0])  cylinder(d=TieBar_w,h=12);
			} // hull

			rotate([0,0,180])
			hull(){
				translate([CrossBar_L/2,0,0]) rotate([0,0,-CrossBar_a/2]) translate([-80,0,0])  cylinder(d=TieBar_w,h=12);
				translate([CrossBar_L/2,0,0]) rotate([0,0,-CrossBar_a/2]) translate([-150,0,0])  cylinder(d=TieBar_w,h=12);
			} // hull
			rotate([0,0,180])
			hull(){
				translate([CrossBar_L/2,0,0]) rotate([0,0,CrossBar_a/2]) translate([-80,0,0])  cylinder(d=TieBar_w,h=12);
				translate([CrossBar_L/2,0,0]) rotate([0,0,CrossBar_a/2]) translate([-150,0,0])  cylinder(d=TieBar_w,h=12);
			} // hull

		} // union
		
		// Arm bolts
		translate([CrossBar_L/2,0,12]) rotate([0,0,-CrossBar_a/2]) translate([-80,0,0])
			for (j=[0:3]) translate([-InnerArmBoltSpacing*j,0,0]) Bolt4Hole(depth=12);
			
		translate([CrossBar_L/2,0,12]) rotate([0,0,CrossBar_a/2]) translate([-80,0,0])
			for (j=[0:3]) translate([-InnerArmBoltSpacing*j,0,0]) Bolt4Hole(depth=12);
		
		rotate([0,0,180])
		translate([CrossBar_L/2,0,12]) rotate([0,0,-CrossBar_a/2]) translate([-80,0,0])
			for (j=[0:3]) translate([-InnerArmBoltSpacing*j,0,0]) Bolt4Hole(depth=12);
		rotate([0,0,180])
		translate([CrossBar_L/2,0,12]) rotate([0,0,CrossBar_a/2]) translate([-80,0,0])
			for (j=[0:3]) translate([-InnerArmBoltSpacing*j,0,0]) Bolt4Hole(depth=12);
		
		// Race bolts
		for (j=[0:nRaceBolts-1]) rotate([0,0,360/nRaceBolts*j+22.5]) translate([(ChassisPostBearing_BC+Ball_d*3)/2-RaceBoltInset,0,12])
			Bolt4Hole(depth=12);
		
		// Bearing hole
		translate([0,0,-Overlap]) cylinder(d=ChassisPostBearing_BC+Ball_d+5-Overlap,h=12+Overlap*2);
	} // diff
	
} // CrossBar

// CrossBar(myFn=36);

EndLen=50;

module CrossBarBearingCover(){
	difference(){
		union(){
			cylinder(d=ChassisPostBearing_BC+Ball_d*3,h=2);
			
			for (j=[0:nRaceBolts*2-1]) rotate([0,0,180/nRaceBolts*j+90/nRaceBolts])
					hull(){
						translate([20,0,0]) cylinder(d=3,h=6);
						translate([(ChassisPostBearing_BC+Ball_d*3)/2-3,0,0]) cylinder(d=3,h=2);
					} // hull
					
			cylinder(d1=45,d2=43,h=6);
		} // union
		
		// Race bolts
		for (j=[0:nRaceBolts-1]) rotate([0,0,360/nRaceBolts*j+22.5]) translate([(ChassisPostBearing_BC+Ball_d*3)/2-RaceBoltInset,0,2])
			Bolt4ClearHole();
		
		translate([0,0,3]) cylinder(d1=35,d2=37,h=3+Overlap);
	} // diff
} // CrossBarBearingCover

//translate([0,0,14]) CrossBarBearingCover();

module CrossBarCover(IsBottom=false){
	Cover_t=2;
	
	difference(){
		union(){
			cylinder(d=ChassisPostBearing_BC+Ball_d*3,h=Cover_t);
			
			hull(){
				translate([CrossBar_L/2,0,0]) cylinder(d=TieBar_w,h=Cover_t);
				translate([CrossBar_L/2,0,0]) rotate([0,0,-CrossBar_a/2]) translate([-CrossBar_L/2,0,0])  cylinder(d=TieBar_w,h=Cover_t);
			
				translate([CrossBar_L/2,0,0]) cylinder(d=TieBar_w,h=Cover_t);
				translate([CrossBar_L/2,0,0]) rotate([0,0,CrossBar_a/2]) translate([-CrossBar_L/2,0,0])  cylinder(d=TieBar_w,h=Cover_t);
			} // hull
			
			hull(){
				translate([CrossBar_L/2,0,-6]) rotate([0,0,-CrossBar_a/2]) translate([-EndLen,0,0])  cylinder(d=TieBar_w,h=6+Overlap);
				translate([CrossBar_L/2,0,-6]) rotate([0,0,-CrossBar_a/2]) translate([-80,0,0])  cylinder(d=TieBar_w,h=6+Overlap);
			} // hull
			hull(){
				translate([CrossBar_L/2,0,-6]) rotate([0,0,CrossBar_a/2]) translate([-EndLen,0,0])  cylinder(d=TieBar_w,h=6+Overlap);
				translate([CrossBar_L/2,0,-6]) rotate([0,0,CrossBar_a/2]) translate([-80,0,0])  cylinder(d=TieBar_w,h=6+Overlap);
			} // hull
		} // union
		
		// Bearing hole
		translate([0,0,-Overlap]) cylinder(d=ChassisPostBearing_BC+Ball_d-Overlap,h=Cover_t+Overlap*2);
		
		translate([CrossBar_L/2,0,-Overlap]) cylinder(d=15,h=Cover_t+Overlap*2);
		
		translate([CrossBar_L/2,0,-6-Overlap]) rotate([0,0,-CrossBar_a/2]) 
			translate([-EndLen,0,0])  cylinder(d=TieBar_w+IDXtra*2,h=6+Overlap);
		translate([CrossBar_L/2,0,-6-Overlap]) rotate([0,0,-CrossBar_a/2]) 
			translate([-80,0,0])  cylinder(d=TieBar_w+IDXtra*2,h=6+Overlap);
		
		translate([CrossBar_L/2,0,-6-Overlap]) rotate([0,0,CrossBar_a/2]) 
			translate([-EndLen,0,0])  cylinder(d=TieBar_w+IDXtra*2,h=6+Overlap);
		translate([CrossBar_L/2,0,-6-Overlap]) rotate([0,0,CrossBar_a/2]) 
			translate([-80,0,0])  cylinder(d=TieBar_w+IDXtra*2,h=6+Overlap);
		
		// Race bolts
		for (j=[0:nRaceBolts-1]) rotate([0,0,360/nRaceBolts*j+22.5])
			translate([(ChassisPostBearing_BC+Ball_d*3)/2-RaceBoltInset,0,Cover_t])
				Bolt4ClearHole();
		
		translate([CrossBar_L/2,0,Cover_t]) rotate([0,0,-CrossBar_a/2]) translate([-80,0,0])
			for (j=[0:3]) translate([-InnerArmBoltSpacing*j,0,0]) Bolt4ClearHole();
			
		translate([CrossBar_L/2,0,Cover_t]) rotate([0,0,CrossBar_a/2]) translate([-80,0,0])
			for (j=[0:3]) translate([-InnerArmBoltSpacing*j,0,0]) Bolt4ClearHole();
				
		translate([CrossBar_L/2,0,Cover_t]) rotate([0,0,-CrossBar_a/2])
		  for (j=[1:3]) translate([-OuterArmBoltSpacing*j-4,0,0]) Bolt4ClearHole(depth=Cover_t);
		
		 if (IsBottom==true){
			 translate([CrossBar_L/2,0,Cover_t]) rotate([0,0,-CrossBar_a/2])
				translate([-OuterArmBoltSpacing*4-4,0,0]) Bolt4Hole();
		 } else{
			 translate([CrossBar_L/2,0,Cover_t]) rotate([0,0,-CrossBar_a/2])
				translate([-OuterArmBoltSpacing*4-4,0,0]) Bolt4ClearHole();
		 }
		 
		translate([CrossBar_L/2,0,Cover_t]) rotate([0,0,CrossBar_a/2])
		  for (j=[1:3]) translate([-OuterArmBoltSpacing*j-4,0,0]) Bolt4ClearHole(depth=Cover_t);
			  
		  if (IsBottom==true){
			 translate([CrossBar_L/2,0,Cover_t]) rotate([0,0,CrossBar_a/2])
				translate([-OuterArmBoltSpacing*4-4,0,0]) Bolt4Hole();
		 } else{
			 translate([CrossBar_L/2,0,Cover_t]) rotate([0,0,CrossBar_a/2])
				translate([-OuterArmBoltSpacing*4-4,0,0]) Bolt4ClearHole();
		 }
		 
		//cut in half
		translate([-100+IDXtra,0,Cover_t/2]) cube([200,200,Cover_t+Overlap*2],center=true);
	} // diff
} // CrossBarCover

//translate([0,0,12]) CrossBarCover(IsBottom=true);

module CrossBarEnd(){
	
	
	difference(){
		union(){
			translate([CrossBar_L/2,0,0]) cylinder(d=15,h=12);
			hull(){
				translate([CrossBar_L/2,0,0]) cylinder(d=TieBar_w,h=12);
				translate([CrossBar_L/2,0,0]) rotate([0,0,-CrossBar_a/2]) translate([-EndLen,0,0])  cylinder(d=TieBar_w,h=12);
			} // hull
			hull(){
				translate([CrossBar_L/2,0,0]) cylinder(d=TieBar_w,h=12);
				translate([CrossBar_L/2,0,0]) rotate([0,0,CrossBar_a/2]) translate([-EndLen,0,0])  cylinder(d=TieBar_w,h=12);
			} // hull
		} // union
		
		translate([CrossBar_L/2,0,12]) Bolt10Hole();
		
		translate([CrossBar_L/2,0,12]) rotate([0,0,-CrossBar_a/2])
		  for (j=[1:3]) translate([-15*j-4,0,0]) Bolt4Hole(depth=12);
		translate([CrossBar_L/2,0,12]) rotate([0,0,CrossBar_a/2])
		  for (j=[1:3]) translate([-15*j-4,0,0]) Bolt4Hole(depth=12);
	} // diff
} // CrossBarEnd

//CrossBarEnd();
//rotate([0,0,180]) CrossBarEnd();

































