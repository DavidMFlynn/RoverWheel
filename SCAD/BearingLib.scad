// ************************************************
// Bearing Library
// by David M. Flynn
// Filename: BearingLib.scad
// Created: 2/2/2018
// Revision: 1.0.0 2/2/2018
// **********************************************
// History
// 1.0.0 2/2/2018 First code.
// **********************************************
// for STL output (examples)
//
// InsideRace(BallCircle_d=60, Race_ID=34, Ball_d=9.525, Race_w=5, nBolts=8, myFn=360) Bolt4ClearHole();
// InsideRace(BallCircle_d=60, Race_ID=34, Ball_d=9.525, Race_w=5, nBolts=8, myFn=360) Bolt4HeadHole();
// OutsideRace(BallCircle_d=60, Race_OD=86, Ball_d=9.525, Race_w=7, nBolts=8, myFn=360) Bolt4ClearHole();
// OutsideRace(BallCircle_d=60, Race_OD=86, Ball_d=9.525, Race_w=5, nBolts=8, myFn=360) Bolt4Hole();
// **********************************************

include<CommonStuffSAEmm.scad>

$fn=90;
IDXtra=0.2;
Overlap=0.05;

BL_RaceBoltInset=3.5;

module InsideRace(BallCircle_d=100,
	Race_ID=50,
	Ball_d=9.525,
	Race_w=5,
	nBolts=8,
	RaceBoltInset=BL_RaceBoltInset,
	myFn=360){
	
	difference(){
		cylinder(d=BallCircle_d-7,h=Race_w,$fn=myFn);
		
		// center hole
		translate([0,0,-Overlap]) cylinder(d=Race_ID,h=Race_w+Overlap*2);
		
		// ball track
		translate([0,0,Race_w])
		rotate_extrude(convexity = 10,$fn=myFn)
			translate([BallCircle_d/2, 0, 0]) circle(d = Ball_d);
		
		// Bolts
		for (j=[0:nBolts-1]) rotate([0,0,360/nBolts*j]) translate([Race_ID/2+RaceBoltInset,0,0])
			rotate([180,0,0]) children();
			
	} // diff
} // InsideRace

//InsideRace(BallCircle_d=60, Race_ID=34, Ball_d=9.525, Race_w=5, nBolts=8, myFn=90) Bolt4ClearHole();

module OutsideRace(BallCircle_d=60,
	Race_OD=150,
	Ball_d=9.525,
	Race_w=5,
	nBolts=8,
	RaceBoltInset=BL_RaceBoltInset,
	myFn=360){
	
	difference(){
		cylinder(d=Race_OD,h=Race_w);
		
		// center hole
		translate([0,0,-Overlap]) cylinder(d=BallCircle_d+7,h=Race_w+Overlap*2,$fn=myFn);
		
		// Bolts
		for (j=[0:nBolts-1]) rotate([0,0,360/nBolts*j]) translate([Race_OD/2-RaceBoltInset,0,0]) 
			 rotate([180,0,0]) children();
		
		translate([0,0,Race_w])
			rotate_extrude(convexity = 10,$fn=myFn)
				translate([BallCircle_d/2, 0, 0]) circle(d = Ball_d);
		
	} // diff
} // OutsideRace

//OutsideRace(BallCircle_d=60, Race_OD=86, Ball_d=9.525, Race_w=5, nBolts=8, myFn=90) Bolt4ClearHole();
//translate([0,0,10+Overlap])rotate([180,0,0])OutsideRace(BallCircle_d=60, Race_OD=86, Ball_d=9.525, Race_w=5, nBolts=8, myFn=90) Bolt4ButtonHeadHole();



