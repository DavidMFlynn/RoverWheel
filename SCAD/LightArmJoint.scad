// **************************************************
// Light Arm Joint
// David M. Flynn
// Filename: LightArmJoint.scad
// Created: 4/6/2018
// Rev: 1.1.2 6/3/2018
// Units: millimeters
// **************************************************
// History:
// 1.1.2 6/3/2018 Added TableMount.
// 1.1.1 5/7/2018 fixed DriveGear5245
// 1.1.0 5/6/2018 Added bottom cover w/ HS-5245MG, tighter planet carrier bearing.
// 1.0.2 5/5/2018 2mm shorter sun gear, 0.2 preload on planet carrier B, etc.
// 1.0.1 4/22/2018 First working version.
// 1.0.0 4/6/2018 First code
// **************************************************
// Notes:
// 4/22/2018 To Do: 
// **************************************************
// ***** for STL output *****
// SunGear(myFN=360); // FC2
// rotate([180,0,0]) SunGearRace(HasSideFlange=false, myFn=360); // FC3, end mount version
// PlanetA(); // Good
// for (j=[0:nPlanets-1]) rotate([180,0,360/nPlanets*j]) translate([30,0,0]) PlanetB(nB=j); // Good
// RingGearA(HasSideFlange=true,myFn=360); // side flange version
// RingGearA(HasSideFlange=false,myFn=360); // end mount version
// rotate([180,0,0]) RingGearB(HasSideFlange=false,myFn=360);  // end mount version
// PlanetCarrierA(); // Good
// PlanetCarrierB(EndRace=false, myFn=360); // Good
// PlanetCarrierB(EndRace=true, myFn=360); // Good
// PCBOuterRace(HasSideFlange=false,myFn=360); // Good
// TopCover(HasSideFlange=false); // FC1
// TubeSocket(TubeOD=Tube_d, SocketLen=16, Threaded=false); // good
// rotate([180,0,0]) DriveGear(); // for SG90 servo, FC1
// rotate([180,0,0]) DriveGear5245();
// rotate([180,0,0]) BottomCover(); // for SG90 servo, Good
// rotate([180,0,0]) BottomCover5245(HasSideFlange=false);
// TableMount();  // Clamp to table for testing.
// BigBase(); // Big heavy rubber footed base, Armatron4 ?
// TopConnector(); // connects TopCover(HasSideFlange=false) to BottomCover5245(HasSideFlange=true)
// **************************************************
// ***** for viewing *****
// ShowJointCutAway();
// **************************************************
include<SG90ServoLib.scad>
include<HS-5245MGServoLib.scad>
include<involute_gears.scad>
include<TubeConnectorLib.scad>
include<CompoundHelicalPlanetary.scad>
include<CommonStuffSAEmm.scad>
include<cogsndogs.scad>
include<BearingLib.scad>

$fn=90;
IDXtra=0.2;
Overlap=0.05;

Spline_Hole_d=6.35+IDXtra; // for a 1/4" standoff
Spline_Gap=0.18; // 0.22 loose fit, 0.20 snug fit, 0.15 press fit

//260:260 = 36:37 = 74:1, 12t 12t 13t, nPlanets=3
PlanetaryPitchA=280;
PlanetaryPitchB=280;
kSpline_d=14;
SunGear_t=12;
PlanetA_t=12;
PlanetB_t=13;
//PlanetB_a=0;
nPlanets=3;
kSpline_d=14;
knSplines=3;
BackLash=0.4; // 0.3 works but is tight, 0.5 is Loose



SunGear_a=0;
//InputRing_t()=36; calculated value from CompoundHelicalPlanetary.scad
//OutputRing_t=37; calculated value from CompoundHelicalPlanetary.scad

PlanetStack=2; // number of gears 2 or 3

Pressure_a=24; //22.5;
GearWidth=9;
twist=0; // set to 0 for straight gears, 200 for helical gears

Shaft_d=7;
Race_w=4;
//Ball_d=9.525; // 0.375"
Ball_d=7.9375; // 0.3125"
RaceBoltInset=3.5;
BallCircle_d=72;

Tube_d=19.05; // 3/4"
RingGearA_OD=BallCircle_d-Ball_d*0.8;

PlanetClearance=1; // cut-away 1mm of teeth

module RoundRect(X=1,Y=1,H=0.2,R=0.2){
	hull(){
		translate([-X/2+R,-Y/2+R,-H/2]) cylinder(r=R,h=H);
		translate([X/2-R,-Y/2+R,-H/2]) cylinder(r=R,h=H);
		translate([-X/2+R,Y/2-R,-H/2]) cylinder(r=R,h=H);
		translate([X/2-R,Y/2-R,-H/2]) cylinder(r=R,h=H);
	} // hull
} //RoundRect

module TableMount(){
	Size_X=75;
	Size_Y=75;
	Size_Z=75;
	Plate_t=6;
	GussetSpace=Size_X-20;
	
	RoundRect(X=Size_X,Y=Size_Y,H=Plate_t,R=1.2);
	
	difference(){
		translate([0,Size_Y/2-Plate_t/2,Size_Z/2-Plate_t/2])rotate([-90,0,0])RoundRect(X=Size_X,Y=Size_Z,H=Plate_t,R=1.2);
	
		translate([0,Size_Y/2+Overlap,Size_Z-Tube_d])rotate([90,0,0]) cylinder(d=34,h=Plate_t+Overlap*2);
	} // diff
	
	translate([0,Size_Y/2,Size_Z-Tube_d])rotate([90,0,0])TubeFlange(TubeOD=Tube_d,FlangeLen=6,Threaded=false);
	
	translate([-GussetSpace/2+Plate_t,0,0])
	hull(){
		translate([0,-Size_Y/2+Plate_t,0])cube([Plate_t,Plate_t,Plate_t],center=true);
		translate([0,Size_Y/2-Plate_t/2,0])cube([Plate_t,Plate_t,Plate_t],center=true);
		translate([0,Size_Y/2-Plate_t/2,Size_Z-Plate_t*1.5])cube([Plate_t,Plate_t,Plate_t],center=true);
	}
	
	translate([GussetSpace/2-Plate_t,0,0])
	hull(){
		translate([0,-Size_Y/2+Plate_t,0])cube([Plate_t,Plate_t,Plate_t],center=true);
		translate([0,Size_Y/2-Plate_t/2,0])cube([Plate_t,Plate_t,Plate_t],center=true);
		translate([0,Size_Y/2-Plate_t/2,Size_Z-Plate_t*1.5])cube([Plate_t,Plate_t,Plate_t],center=true);
	}
} // TableMount

//rotate([-90,0,0])TableMount();


module ShowMyBalls(BallCircle_d=BallCircle_d, nBalls=12){
	for (j=[0:nBalls-1]) rotate([0,0,360/nBalls*j]) translate([BallCircle_d/2,0,0]) sphere(d=Ball_d-Overlap*2);
} // ShowMyBalls

Hub_d=24;
Hub_BC=Hub_d+Ball_d*0.8;
SunGearHub_l=21; // changed from 23 to 21 5/5/2018

module SunGear(ShowGearOnly=false,myFN=90){
	
	Hub_ID=7;
	HubGearThickness=6;
	
	CompoundDrivePinionHelix(Pitch=PlanetaryPitchA, nTeeth=SunGear_t, Thickness=GearWidth, bEndScrew=0, HB=false,Hub_t=0,Hub_d=0);
	
	if (ShowGearOnly==false)
	translate([0,0,-GearWidth-SunGearHub_l])
	difference(){
		translate([0,0,6])cylinder(d=Hub_d,h=SunGearHub_l-6+Overlap);
		
			
		translate([0,0,SunGearHub_l-Race_w-Ball_d/2-1.5])BallTrack(BallCircle_d=Hub_BC, Ball_d=Ball_d, myFn=myFN);
		
		// motor shaft
		translate([0,0,-Overlap]) cylinder(d=Hub_ID,h=SunGearHub_l+GearWidth+Overlap*2);			
	} // diff
	
	if (ShowGearOnly==false)
		translate([0,0,-GearWidth-SunGearHub_l]) 
			//BeltPulley(Belt_w = 4,Teeth=36,CenterHole_d=Hub_ID,Dish=false);
			gear (
				number_of_teeth=18,
				circular_pitch=PlanetaryPitchA, diametral_pitch=false,
				pressure_angle=Pressure_a,
				clearance = 0.2,
				gear_thickness=HubGearThickness,
				rim_thickness=HubGearThickness,
				rim_width=5,
				hub_thickness=HubGearThickness,
				hub_diameter=Hub_ID+3,
				bore_diameter=Hub_ID,
				circles=0,
				backlash=BackLash,
				twist=0,
				involute_facets=0,
				flat=false);
} // SunGear

//translate([0,0,GearWidth-0.5]) SunGear();

FlangeA_h=10.2;
module RingAFlange(){
	translate([0,-RingGearA_OD/2-5,-20]) rotate([0,22.5,0])rotate([-90,0,0]) TubeFlange(TubeOD=Tube_d,FlangeLen=FlangeA_h,Threaded=true);
} // RingAFlange

//RingAFlange();

module RingAFlangeBase(){
	translate([0,-RingGearA_OD/2-5+FlangeA_h-0.1,-20]) rotate([-90,0,0]) cylinder(d=Tube_d+16,h=0.1);
} // RingBFlangeBase

module RingAFlangeTube(){
	translate([0,-RingGearA_OD/2-5,-20]) rotate([-90,0,0]) cylinder(d=18,h=30);
} // RingBFlangeBase

module RingGearA(HasSideFlange=true,myFn=90){
	kPreLoad=0.1;
	SunGearBall_cl=-Race_w-Ball_d/2-2;
	
	CompoundRingGearHelix(Pitch=PlanetaryPitchA, nTeeth=InputRing_t(), Thickness=GearWidth, twist=-twist, HB=false,RimWidth=2);
	
	translate([0,0,-Ball_d/2-2]) rotate([180,0,0])
	OutsideRace(BallCircle_d=Hub_BC, Race_OD=Hub_BC+26, Ball_d=Ball_d, Race_w=Race_w, nBolts=6, RaceBoltInset=BL_RaceBoltInset, myFn=myFn) Bolt4Hole();
	
	difference(){
		union(){
			translate([0,0,SunGearBall_cl]) cylinder(d=RingGearA_OD,h=GearWidth-SunGearBall_cl);
			// race
			translate([0,0,SunGearBall_cl+GearWidth]) cylinder(d1=RingGearA_OD,d2=BallCircle_d-Ball_d*0.7,h=2);
			translate([0,0,SunGearBall_cl+GearWidth+2]) cylinder(d=BallCircle_d-Ball_d*0.7,h=Ball_d,$fn=myFn);
			
			if (HasSideFlange==true) RingAFlange();
		}
		
		//Ball insert groove
		translate([BallCircle_d/2+0.3,0,SunGearBall_cl+GearWidth+2+Ball_d/2]) 
		hull(){
			sphere(d=Ball_d);
			translate([0,0,-Ball_d])sphere(d=Ball_d);
		} // hull
		
		translate([0,0,SunGearBall_cl-Overlap]) cylinder(d=Hub_BC+25,h=Race_w);
		// center hole
		translate([0,0,SunGearBall_cl+Race_w-Overlap*2]) cylinder(d=53,h=GearWidth+Race_w+Overlap*2);
		
		// the ring gear goes here
		cylinder(d=61,h=GearWidth+Overlap);
		
		translate([0,0,GearWidth-Ball_d/2]) BallTrack(BallCircle_d=BallCircle_d+kPreLoad, Ball_d=Ball_d, myFn=myFn);
		
		// remove extra tube flange 
		if (HasSideFlange==true)
		translate([0,-RingGearA_OD/2-5,SunGearBall_cl]) rotate([180,0,0])cylinder(d=50,h=50);
	}
	
} // RingGearA

//RingGearA(HasSideFlange=true,myFn=90);

SunGearRace_h=10;

module SunGearRace(HasSideFlange=true,myFn=90){
	kSGR_Preload=0.8;
	BoltBoss_r=RingGearA_OD/2+0.5;
	SunGearRaceBottom=-Race_w*2-2-SunGearRace_h;
	nBolts=8;
	
	translate([0,0,-Race_w*2-Ball_d/2-2-Overlap]) 
		OutsideRace(BallCircle_d=Hub_BC, Race_OD=Hub_BC+26, Ball_d=Ball_d, Race_w=Race_w, nBolts=6,
			RaceBoltInset=BL_RaceBoltInset, PreLoadAdj=kSGR_Preload, myFn=myFn) Bolt4ButtonHeadHole();
	
	difference(){
		union(){
			if (HasSideFlange==true) RingAFlange();
			
			translate([0,0,SunGearRaceBottom]) cylinder(d=RingGearA_OD,h=SunGearRace_h);
			
			// bolt flanges
			for (j=[0:nBolts-2]) rotate([0,0,360/nBolts*(j+1)]) translate([BoltBoss_r,0,-Race_w*2-2-SunGearRace_h]){
				translate([0,0,SunGearRace_h-3.5])sphere(d=7);
				cylinder(d=7,h=SunGearRace_h-3.5);}
			
			// Gear cover
			translate([24.2,0,SunGearRaceBottom]) cylinder(d=28,h=SunGearRace_h);
		} // union
		
		// Drive Gear clearance
		translate([24.2,0,-22.5]) cylinder(d=24,h=8);
		
		translate([0,0,-Race_w*2-2-SunGearRace_h-Overlap]){
			cylinder(d=Hub_BC+26-Overlap,h=SunGearRace_h+Overlap*2);
			translate([0,0,-Race_w])cylinder(d=RingGearA_OD-4,h=SunGearRace_h+Overlap*2);
		}
		
		//RingAFlangeTube();
		// remove extra tube flange (Top)
		if (HasSideFlange==true) translate([0,-RingGearA_OD/2-5,-Race_w-Ball_d/2-2-0.03]) cylinder(d=100,h=50);
		// remove extra tube flange (Bottom)
		if (HasSideFlange==true) translate([0,-RingGearA_OD/2-5,-Race_w*2-2-SunGearRace_h-0.001]) rotate([180,0,0])cylinder(d=50,h=50);
		
		// bolts
		for (j=[0:nBolts-2]) rotate([0,0,360/nBolts*(j+1)]) translate([BoltBoss_r,0,-Race_w*2-2-3]) Bolt4Hole(depth=SunGearRace_h);
	} // diff
	
} // SunGearRace

//SunGearRace(HasSideFlange=false);
//translate([0,0,-Race_w*2-2]) ShowMyBalls(BallCircle_d=Hub_BC, nBalls=11);


// for SG90 servo
module BottomCover(){
	BottomCover_h=7;
	BottomCover_t=3;
	BoltBoss_r=RingGearA_OD/2+0.5;
	nBolts=8;
	
	BottomOfCover_z=-Race_w*2-2-SunGearRace_h-BottomCover_h;
		
	difference(){
		union(){
			RingAFlange();
			
			translate([0,0,BottomOfCover_z+4]) cylinder(d=RingGearA_OD,h=BottomCover_h-4);
			translate([0,0,BottomOfCover_z]) cylinder(d=RingGearA_OD-8,h=BottomCover_h);
			
			translate([0,0,BottomOfCover_z+4])rotate_extrude() translate([RingGearA_OD/2-4,0]) circle(r=4);
			
			// Flange fill
			hull(){
				RingAFlangeBase();
				translate([0,0,BottomOfCover_z+8]) cylinder(d=10,H=4);
			} // hull
			
			// bolt flanges
			for (j=[0,1,2,3,4,6]) rotate([0,0,360/nBolts*(j+1)]) translate([BoltBoss_r,0,BottomOfCover_z+BottomCover_h])	
				rotate([180,0,0])cylinder(d=7,h=BottomCover_h-3);
			rotate([0,0,360/nBolts*(5+1)]) translate([BoltBoss_r,0,BottomOfCover_z+BottomCover_h])	
				rotate([180,0,0])cylinder(d=7,h=10);
			
			// Gear cover
			translate([24.2,0,BottomOfCover_z]) cylinder(d=28,h=BottomCover_h);
			// Servo mount
			translate([24.2,0,-32.5+Overlap]) rotate([0,0,120]) translate([-12,-7,0]) cube([34,14,8]);
			
		}
		
		// Drive Gear clearance
		translate([24.2,0,-22.5-2]) cylinder(d=24,h=8);
		
		translate([24.2,0,-35]) rotate([0,0,120]) ServoSG90();
		
		// bolt flanges
			for (j=[0,1,2,3,4,6]) rotate([0,0,360/nBolts*(j+1)]) translate([BoltBoss_r,0,BottomOfCover_z+3])
				rotate([180,0,0])cylinder(d=7,h=4);
			
		// carv out inside
		translate([0,0,BottomOfCover_z+BottomCover_t+4]) cylinder(d=RingGearA_OD-4,h=BottomCover_h-4+Overlap);
		translate([0,0,BottomOfCover_z+BottomCover_t]) cylinder(d=RingGearA_OD-8-4,h=BottomCover_h-BottomCover_t+Overlap);
		translate([0,0,BottomOfCover_z+4+BottomCover_t]) rotate_extrude() translate([RingGearA_OD/2-4-2,0]) circle(r=4);
		
		//Encoder shaft
		translate([0,0,BottomOfCover_z-Overlap]) cylinder(d=6.35+IDXtra,h=BottomCover_h+Overlap*2);
		//Encoder mount
		translate([0,0,BottomOfCover_z+1]) rotate([180,0,0])cylinder(d=23+IDXtra,h=10);
		translate([8.5,0,BottomOfCover_z]) rotate([180,0,0])Bolt2Hole();
		translate([-8.5,0,BottomOfCover_z]) rotate([180,0,0])Bolt2Hole();
		
		// remove extra tube flange (Top)
		translate([0,0,-Race_w-Ball_d/2-2-0.03-SunGearRace_h]) cylinder(d=100,h=50);
		
		// bolts
		for (j=[0:nBolts-2]) rotate([0,0,360/nBolts*(j+1)]) translate([BoltBoss_r,0,-Race_w*2-2-SunGearRace_h-BottomCover_h+Overlap]) 
			rotate([180,0,0])Bolt4HeadHole(depth=BottomCover_h,lHead=20);
	} // diff
} // BottomCover

//BottomCover();


module BigBase(){
	BB_h=50;
	BB_d=190;
	BoltBoss_r=RingGearA_OD/2+0.5;
	nBolts=8;
	Servo_a=124;
	BaseHole_r=BoltBoss_r+18;
	BasePlate_h=8;
	
	difference(){
		union(){
			for (j=[0,1,2,3,4,5,6]) rotate([0,0,360/nBolts*(j+1)]) translate([BoltBoss_r,0,BB_h-4])	
				cylinder(d=7,h=4);
			
			difference(){
				hull(){
					cylinder(r=BaseHole_r+6,h=BasePlate_h,$fn=8);
					translate([0,0,BB_h-4])cylinder(r=BoltBoss_r+3,h=4);
				} // hull
				translate([0,0,-Overlap])
				hull(){
					cylinder(r=BaseHole_r,h=BasePlate_h,$fn=8);
					translate([0,0,BB_h-10])cylinder(r=BoltBoss_r+IDXtra,h=10+Overlap*2);
				} // hull
			} // diff
		} // union
	
	for (j=[0,1,2,3,4,5,6]) rotate([0,0,360/nBolts*(j+1)]) translate([BoltBoss_r,0,BB_h-20])	
				cylinder(d=5,h=16);
	// bolts
		for (j=[0:nBolts-2]) rotate([0,0,360/nBolts*(j+1)]) translate([BoltBoss_r,0,BB_h]) 
			 Bolt4ClearHole();
		
					// Gear cover
			translate([38,0,BB_h-18]) cylinder(d=38,h=36);
			
			// Servo mount
			//translate([24.2,0,BB_h-35]) rotate([0,0,Servo_a]) translate([-14,-8,0]) #cube([44,16,36]);

	}
	
	
	
	difference(){
		intersection(){
			cylinder(d=230,h=BasePlate_h,$fn=3);
			cylinder(d=BB_d,h=BasePlate_h,$fn=90);
		}
		
		translate([0,0,-Overlap])cylinder(r=BaseHole_r,h=BasePlate_h+Overlap*2,$fn=8);
		
	} // diff
} // BigBase

//BigBase();

module BottomCover5245(HasSideFlange=true){
	BottomCover_h=7;
	BottomCover_t=3;
	BoltBoss_r=RingGearA_OD/2+0.5;
	nBolts=8;
	Servo_a=124;
	BottomOfCover_z=-Race_w*2-2-SunGearRace_h-BottomCover_h;
		
	difference(){
		union(){
			if (HasSideFlange==true) RingAFlange();
			
			translate([0,0,BottomOfCover_z+4]) cylinder(d=RingGearA_OD,h=BottomCover_h-4);
			translate([0,0,BottomOfCover_z]) cylinder(d=RingGearA_OD-8,h=BottomCover_h);
			
			translate([0,0,BottomOfCover_z+4])rotate_extrude() translate([RingGearA_OD/2-4,0]) circle(r=4);
			
			// Flange fill
			if (HasSideFlange==true)
			hull(){
				RingAFlangeBase();
				translate([0,0,BottomOfCover_z+8]) cylinder(d=10,H=4);
			} // hull
			
			// bolt flanges
			if (HasSideFlange==true){
			for (j=[0,1,2,3,4,6]) rotate([0,0,360/nBolts*(j+1)]) translate([BoltBoss_r,0,BottomOfCover_z+BottomCover_h])	
				rotate([180,0,0])cylinder(d=7,h=BottomCover_h-3);
			} else {
			for (j=[0,1,2,3,4,5,6]) rotate([0,0,360/nBolts*(j+1)]) translate([BoltBoss_r,0,BottomOfCover_z+BottomCover_h])	
				rotate([180,0,0])cylinder(d=7,h=BottomCover_h-3);
			}
			if (HasSideFlange==true)
			rotate([0,0,360/nBolts*(5+1)]) translate([BoltBoss_r,0,BottomOfCover_z+BottomCover_h])	
				rotate([180,0,0])cylinder(d=7,h=10);
			
			// Gear cover
			translate([24.2,0,BottomOfCover_z]) cylinder(d=28,h=BottomCover_h);
			
			// Servo mount
			translate([24.2,0,-31.0+Overlap]) rotate([0,0,Servo_a]) translate([-14,-8,0]) cube([44,16,12.5]);
			
		} // union
		
		// Drive Gear clearance
		translate([24.2,0,-22.5-2]) cylinder(d=24,h=8);
		
		// servo
		translate([24.2,0,-33.5]) rotate([0,0,Servo_a]) ServoHS5245MG();
		
		// bolt flanges
		if (HasSideFlange==true){
			for (j=[0,1,2,3,4,6]) rotate([0,0,360/nBolts*(j+1)]) translate([BoltBoss_r,0,BottomOfCover_z+3])
				rotate([180,0,0])cylinder(d=7,h=4);
		} else {
			for (j=[0,1,2,3,4,5,6]) rotate([0,0,360/nBolts*(j+1)]) translate([BoltBoss_r,0,BottomOfCover_z+3])
				rotate([180,0,0])cylinder(d=7,h=4);
		}
			
		// carv out inside
		translate([0,0,BottomOfCover_z+BottomCover_t+4]) cylinder(d=RingGearA_OD-4,h=BottomCover_h-4+Overlap);
		translate([0,0,BottomOfCover_z+BottomCover_t]) cylinder(d=RingGearA_OD-8-4,h=BottomCover_h-BottomCover_t+Overlap);
		translate([0,0,BottomOfCover_z+4+BottomCover_t]) rotate_extrude() translate([RingGearA_OD/2-4-2,0]) circle(r=4);
		
		//Encoder shaft
		translate([0,0,BottomOfCover_z-Overlap]) cylinder(d=6.35+IDXtra,h=BottomCover_h+Overlap*2);
		//Encoder mount
		translate([0,0,BottomOfCover_z+1]) rotate([180,0,0])cylinder(d=23+IDXtra,h=10);
		translate([8.5,0,BottomOfCover_z]) rotate([180,0,0])Bolt2Hole();
		translate([-8.5,0,BottomOfCover_z]) rotate([180,0,0])Bolt2Hole();
		
		// remove extra tube flange (Top)
		translate([0,0,-Race_w-Ball_d/2-2-0.03-SunGearRace_h]) cylinder(d=100,h=50);
		
		// bolts
		for (j=[0:nBolts-2]) rotate([0,0,360/nBolts*(j+1)]) translate([BoltBoss_r,0,-Race_w*2-2-SunGearRace_h-BottomCover_h+Overlap]) 
			rotate([180,0,0])Bolt4HeadHole(depth=BottomCover_h,lHead=20);
	} // diff
} // BottomCover5245

//BottomCover5245(HasSideFlange=false);

module DriveGear(){
	
	difference(){
			gear(number_of_teeth=13,
				circular_pitch=PlanetaryPitchA, diametral_pitch=false,
				pressure_angle=Pressure_a,
				clearance = 0.2,
				gear_thickness=5,
				rim_thickness=5,
				rim_width=5,
				hub_thickness=5,
				hub_diameter=7,
				bore_diameter=5,
				circles=0,
				backlash=BackLash,
				twist=0,
				involute_facets=0,
				flat=false);
		
		intersection(){
			SG90ServoWheel();
			
			translate([0,0,-Overlap]) cylinder(d=PlanetaryPitchA*13/180-5.4,h=2);
		} // intersection
		
	} // diff
} // DriveGear

//translate([24.2,0,-23.5])DriveGear();

module DriveGear5245(){
	
	difference(){
			gear(number_of_teeth=13,
				circular_pitch=PlanetaryPitchA, diametral_pitch=false,
				pressure_angle=Pressure_a,
				clearance = 0.2,
				gear_thickness=5,
				rim_thickness=5,
				rim_width=5,
				hub_thickness=5,
				hub_diameter=7,
				bore_diameter=5,
				circles=0,
				backlash=BackLash,
				twist=0,
				involute_facets=0,
				flat=false);
		
		intersection(){
			HS5245MGServoWheel();
			
			translate([0,0,-Overlap]) cylinder(d=PlanetaryPitchA*13/180-5.4,h=10);
		} // intersection
		
	} // diff
} // DriveGear5245

//DriveGear5245();
//translate([24.2,0,-23.5])DriveGear5245();

RingGearB_OD=BallCircle_d+Ball_d*0.8+8;

//echo(RingGearB_OD=RingGearB_OD);

module RingBFlange(){
	translate([0,-RingGearB_OD/2-5,GearWidth]) rotate([0,22.5,0])rotate([-90,0,0]) TubeFlange(TubeOD=Tube_d,FlangeLen=10,Threaded=true);
} // RingAFlange

module RingBFlangeBase(){
	translate([0,-RingGearB_OD/2-5+9.9,GearWidth]) rotate([-90,0,0]) cylinder(d=Tube_d+16,h=0.01);
} // RingBFlangeBase

//RingBFlange();

module RingGearB(ShowGearOnly=false,HasSideFlange=true,myFn=90){
	nBolts=12;
	
	SkirtThickness=2;
	Nut_l=8;
	
	CompoundRingGearHelix(Pitch=PlanetaryPitchB, nTeeth=OutputRing_t(), Thickness=GearWidth, twist=twist, HB=false);
	
	BoltBoss_r=RingGearB_OD/2-0.5;
	
	if (ShowGearOnly==false)
	difference(){
		union(){
			translate([0,0,-1-Ball_d])cylinder(d=RingGearB_OD,h=GearWidth+1+Ball_d);
			if (HasSideFlange==true) RingBFlange();
			
			
			// bolt flanges
			
			for (j=[0:nBolts-1]) rotate([0,0,360/nBolts*j]) translate([BoltBoss_r,0,0]){
				sphere(d=7);
				cylinder(d=7,h=GearWidth);
			}
		} // union
		
		//Ball insert groove
		translate([BallCircle_d/2-0.1,0,-1-Ball_d/2-Overlap]) 
		hull(){
			sphere(d=Ball_d);
			translate([0,0,-Ball_d])sphere(d=Ball_d);
		} // hull
		
		// balls and race
		translate([0,0,-1-Ball_d-Overlap]) cylinder(d=BallCircle_d+Ball_d*0.7,h=GearWidth+1+Ball_d-2);
		// ring gear B
		translate([0,0,-5.5-Overlap]) cylinder(d=66,h=GearWidth+5.5+Overlap*2);
		
		translate([0,0,-1-Ball_d/2]) BallTrack(BallCircle_d=BallCircle_d, Ball_d=Ball_d, myFn=360);
		// Race screw access
		for (j=[0:nBolts-1]) rotate([0,0,360/nBolts*j]) translate([BallCircle_d/2,0,GearWidth-8]) cylinder(d=Ball_d/2,h=10);
		
		// remove extra tube flange
		if (HasSideFlange==true) 
		translate([0,-RingGearB_OD/2-2,GearWidth]) cylinder(d=50,h=50);
		
		// bolts
		for (j=[0:nBolts-1]) rotate([0,0,360/nBolts*j]) translate([BoltBoss_r,0,GearWidth]) Bolt4Hole(depth=GearWidth);
	} // diff
		
} // RingGearB

//translate([0,0,GearWidth+1])RingGearB(ShowGearOnly=false,HasSideFlange=false,myFn=90);
//translate([0,0,2])
//
//translate([0,0,GearWidth+0.5]) ShowMyBalls(BallCircle_d=BallCircle_d, nBalls=12);
PCBOuterRace_h=3;

module PCBOuterRace(HasSideFlange=true,myFn=90){
	nBolts=12;
	PCBOuterRace_PreLoad=0.6;
	PCBOuterRace_OD=PC_BallCircle_d+Ball_d*0.8+8;
	BoltBoss_r=RingGearB_OD/2-0.5;
		
	OnePieceOuterRace(BallCircle_d=PC_BallCircle_d, Race_OD=PCBOuterRace_OD, Ball_d=Ball_d, Race_w=PC_t*2, PreLoadAdj=PCBOuterRace_PreLoad, myFn=myFn);
	
	difference(){
		union(){
			cylinder(d=RingGearB_OD,h=PCBOuterRace_h);
			if (HasSideFlange==true) translate([0,0,-GearWidth]) RingBFlange();
			
			// bolt flanges
				for (j=[0:nBolts-1]) rotate([0,0,360/nBolts*j]) translate([BoltBoss_r,0,0]){
					//sphere(d=7);
					cylinder(d=7,h=PCBOuterRace_h);
				}
		} // union
		
		//bearing race
		translate([0,0,-Overlap]) cylinder(d=PCBOuterRace_OD-Overlap,h=PC_t*2+Overlap*2);
		//Dish out
		//translate([0,0,2]) cylinder(d=RingGearB_OD-6,h=PC_t*2+Overlap*2);
		// bolts
		for (j=[0:nBolts-1]) rotate([0,0,360/nBolts*j]) translate([BoltBoss_r,0,PCBOuterRace_h]) Bolt4ClearHole(depth=PCBOuterRace_h);
			
		// Remove extra flange (bottom)
		if (HasSideFlange==true) translate([0,-RingGearB_OD/2-2,-(GearWidth+5+PC_t)]) cylinder(d=50,h=GearWidth+5+PC_t);
		
		// Remove extra flange (top)
		if (HasSideFlange==true) translate([0,-RingGearB_OD/2-2,PCBOuterRace_h]) cylinder(d=50,h=50);
	} // diff
} // PCBOuterRace

//translate([0,0,GearWidth*2+1])PCBOuterRace(HasSideFlange=false,myFn=90);

TopFlange_BC=RingGearB_OD-10-7;

module TopConnector(){
	TopFlange_OD=RingGearB_OD-10;
	nBolts=12;
	
	translate([0,0,13])rotate([180,0,0])TubeFlange(TubeOD=19.05,FlangeLen=13,Threaded=false);
	
	difference(){
		
		cylinder(d=TopFlange_OD,h=3);
		
		translate([0,0,-Overlap])cylinder(d=34,h=3+Overlap*2);
		
		// bolts
		for (j=[0:nBolts-1]) rotate([0,0,360/nBolts*j]) translate([TopFlange_BC/2,0,3.5]) Bolt4ButtonHeadHole();
	} // diff
} // TopConnector

//TopConnector();

module TopCover(HasSideFlange=true){
	nBolts=12;
	BoltBoss_r=RingGearB_OD/2-0.5;
	TCBF_h=5;
	TC_h=9;
	TC_r=4;
	TCWall=3;
	TopFlange_h=6;
	TopFlange_OD=RingGearB_OD-10;
	
	// top mount
	if (HasSideFlange==false)
		translate([0,0,TC_h-Overlap])
		difference(){
			cylinder(d=TopFlange_OD,h=TopFlange_h);
			translate([0,0,-Overlap]) cylinder(d=TopFlange_OD-13,h=TopFlange_h+Overlap*2);
			
			// bolts
			for (j=[0:nBolts-1]) rotate([0,0,360/nBolts*j]) translate([TopFlange_BC/2,0,TopFlange_h]) Bolt4Hole();
		} // diff
	
	
	difference(){
		union(){
			cylinder(d=RingGearB_OD,h=TC_h-TC_r);
			if (HasSideFlange==true) translate([0,0,-GearWidth-PCBOuterRace_h]) RingBFlange();
			if (HasSideFlange==true) 
			hull(){
				translate([0,0,-GearWidth-PCBOuterRace_h]) RingBFlangeBase();
				cylinder(d=10,H=10);
			} // hull
			
			translate([0,0,TC_h-4]) rotate_extrude() translate([RingGearB_OD/2-4,0,0]) circle(d=8);
			
			// bolt flanges
			for (j=[0:nBolts-1]) rotate([0,0,360/nBolts*j]) translate([BoltBoss_r,0,0])	cylinder(d=7,h=TCBF_h);
				
			cylinder(d=RingGearB_OD-8,h=TC_h);
		} // union 
			
		// bolts
		for (j=[0:nBolts-1]) rotate([0,0,360/nBolts*j]) translate([BoltBoss_r,0,TCBF_h]) Bolt4ClearHole(depth=20);
			
		rotate([0,0,360/nBolts*-3]) translate([BoltBoss_r,0,TCBF_h+3]) Bolt4HeadHole(depth=20);
		
		// bolt flanges
		if (HasSideFlange==true) {
			for (j=[0:nBolts-2]) rotate([0,0,360/nBolts*(j-2)]) translate([BoltBoss_r,0,TCBF_h]) cylinder(d=7,h=10);
		} else {
			for (j=[0:nBolts-1]) rotate([0,0,360/nBolts*j]) translate([BoltBoss_r,0,TCBF_h]) cylinder(d=7,h=10);
		}

		// Remove extra flange (bottom)
		if (HasSideFlange==true) translate([0,-RingGearB_OD/2-2,0]) rotate([180,0,0]) cylinder(d=100,h=50);
		
		translate([0,0,TC_h-4-TCWall]) rotate_extrude() translate([RingGearB_OD/2-4-TCWall-1,0,0]) circle(d=8);
			
		// Dish-out
		difference(){
			union(){
				translate([0,0,-Overlap]) cylinder(d=RingGearB_OD-16,h=TC_h-TCWall);
				translate([0,0,-Overlap]) cylinder(d=RingGearB_OD-TCWall*2-2,h=TC_h-TCWall-4);
			} // union
			
			
			translate([0,0,-Overlap*2]) cylinder(d=20,h=TC_h-3+Overlap*2);
		} // diff
			
		// Rod
		translate([0,0,-Overlap])cylinder(d=6.35,h=30);
	} // diff
	
} // TopCover

//translate([0,0,GearWidth*2+1+PCBOuterRace_h+Overlap]) TopCover();

module PlanetA(){
	
	difference(){
		CompoundPlanetGearHelixA(Pitch=PlanetaryPitchA,nTeethA=PlanetA_t, PitchB=PlanetaryPitchB, nTeethB=PlanetB_t, Thickness=GearWidth, HB=false, Spline_d=kSpline_d, nSplines=knSplines);
		
		// clearance for misaligned ring gears
		translate([0,0,GearWidth-PlanetClearance])
		difference(){
			cylinder(d=30,h=PlanetClearance+Overlap);
			translate([0,0,-Overlap])cylinder(d=15.3,h=PlanetClearance+Overlap*4);
		}
	} // diff
} // PlanetA

//PlanetA();

module PlanetB(nB=0){
	//RotB=180/OutputRing_t()*(OutputRing_t()/nPlanets*nB); //*(PlanetA_t/PlanetB_t);
	RotB=2*360/PlanetB_t/nPlanets*nB;
	//echo(RotB=RotB);
	//RotB=0;
	//PlanetB_a
	
	difference(){
		
		//rotate([0,0,RotB])
		CompoundPlanetGearHelixB(Pitch=PlanetaryPitchA,nTeethA=PlanetA_t, PitchB=PlanetaryPitchB, nTeethB=PlanetB_t, Thickness=GearWidth,
		Offset_a=RotB, HB=false, Spline_d=kSpline_d, nSplines=knSplines, Spline_a=-RotB);
		
		
		// clearance for misaligned ring gears
		translate([0,0,-Overlap])
		difference(){
			cylinder(d=30,h=PlanetClearance+Overlap);
			translate([0,0,-Overlap])cylinder(d=16.6,h=PlanetClearance+Overlap*4);
		}
		
		for (j=[1:nB+1]) rotate([0,0,360/PlanetB_t*j]) translate([PlanetB_t*PlanetaryPitchB/360-3.5,0,GearWidth-0.3]) cylinder(d=0.5,h=2);
	} // diff
} // PlanetB

//rotate([180,0,0])PlanetB(4);

module ShowPlanets(CutAway=true,HideGears=true,HidePC=true){
	PitchA=PlanetaryPitchA;
	PitchB=PlanetaryPitchB;
	Planet_BC=SunGear_t*PitchA/180 + PlanetA_t*PitchA/180;
		
		SunGearRA=$t*Ratio*360;
		PlanetPosRA=SunGearRA/((InputRing_t()/SunGear_t)+(InputRing_t()/SunGear_t));//  29.7r /(InputRing_t()/SunGear_t); // 2.57 4.5
		PlanetRA=-PlanetPosRA-PlanetPosRA*((InputRing_t()/PlanetA_t));
		OutputRingRA=-360*$t;
	
	if (HidePC==false){
		translate([0,0,0]) rotate([180,0,0]) color("Brown") PlanetCarrierA();
		for (j=[0:nPlanets-1]) rotate([0,0,PlanetPosRA+360/nPlanets*j])
			translate([Planet_BC/2,0,0]) color("Red") cylinder(d=6.35,h=PlanetShaft_l);
		translate([0,0,PlanetShaft_l]) color("Brown") PlanetCarrierB();
	}
		
	if (HideGears==false)
	difference(){
			for (j=[0:nPlanets-1])
				rotate([0,0,PlanetPosRA+360/nPlanets*j]) translate([Planet_BC/2,0,0]) rotate([0,0,PlanetRA]){
					color("Tan") PlanetA();
				
					translate([0,0,GearWidth]) PlanetB(nB=j);
				}
			
				if (CutAway==true)
			translate([0,-Planet_BC,-Overlap])cube([Planet_BC,Planet_BC,PlanetShaft_l]);
		} // diff
	
} // ShowPlanets

//ShowPlanets(CutAway=true,HideGears=false);
//ShowPlanets(CutAway=true,HideGears=true);

PlanetCarrierA_t=4;

function Planet_BC()=SunGear_t*PlanetaryPitchA/180 + PlanetA_t*PlanetaryPitchA/180;
PC_w=10; // changed from 8 to 10 1/9/18

module PlanetCarrierA(PC_t=PlanetCarrierA_t){
	
	difference(){
		cylinder(d=Planet_BC+PC_w,h=PC_t);
		
		translate([0,0,-Overlap]) cylinder(d=Planet_BC-PC_w,h=PC_t+Overlap*2);
			
		for (j=[0:nPlanets-1]) rotate([0,0,360/nPlanets*j]) translate([Planet_BC/2,0,PC_t]) Bolt4ButtonHeadHole();
	} // diff
	
} // PlanetCarrierA

 //color("Tan")rotate([180,0,0])PlanetCarrierA();

PlanetShaft_l=19.05; // 3/4"
Planet_BC=SunGear_t*PlanetaryPitchA/180 + PlanetA_t*PlanetaryPitchA/180;
PC_w=10; // changed from 8 to 10 1/9/18
PC_BallCircle_d=Planet_BC+PC_w+Ball_d+2;
PC_Race_ID=Planet_BC+PC_w-Overlap;
PC_Race_OD=PC_BallCircle_d+26;
PC_t=Race_w;

module PlanetCarrierB(EndRace=true, myFn=90){
	PC_B_PreLoad=0.4;
	
	difference(){
		cylinder(d=Planet_BC+PC_w,h=PC_t);
		
		translate([0,0,-Overlap]) cylinder(d=Planet_BC-PC_w,h=PC_t+Overlap*2);
			
		if (EndRace==false){
				for (j=[0:nPlanets-1]) rotate([0,0,360/nPlanets*j]) translate([Planet_BC/2,0,PC_t]) Bolt4ClearHole();
			} else {
				for (j=[0:nPlanets-1]) rotate([0,0,360/nPlanets*j]) translate([Planet_BC/2,0,0]) rotate([180,0,0]) Bolt4ButtonHeadHole();
			}		
	} // diff
	
	InsideRace(BallCircle_d=PC_BallCircle_d, Race_ID=PC_Race_ID, Ball_d=Ball_d, Race_w=PC_t, nBolts=0, RaceBoltInset=0, PreLoadAdj=PC_B_PreLoad, myFn=myFn)
			Bolt4Hole();
	
} // PlanetCarrierB

//PlanetCarrierB(EndRace=false, myFn=90);
//translate([0,0,Race_w*2+Overlap])rotate([180,0,0]) PlanetCarrierB(EndRace=true, myFn=90);

module ShowArmJoint(){
	
	//rotate([0,0,180/InputRing_t()]) RingGearA();
		
	translate([0,0,GearWidth+1]) rotate([0,0,180/OutputRing_t()]) RingGearB(ShowGearOnly=false);
	
	ShowPlanets(CutAway=false,HideGears=false,HidePC=true);
	
	//color("Tan")rotate([180,0,0])PlanetCarrierA();
	//translate([0,0,GearWidth-Ball_d/2]) BallSpacer(BallCircle_d=BallCircle_d,Ball_d=Ball_d,nBalls=16);
	//translate([0,0,GearWidth-Ball_d/2]) 
	//	TwoPartBoltedBallSpacer(BallCircle_d=BallCircle_d,Ball_d=Ball_d,nBalls=15) translate([0,0,-Ball_d]) cylinder(d=1.7,h=Ball_d+Overlap);
	
	//translate([0,0,GearWidth*2+1+Overlap]) PlanetCarrierB(EndRace=false, myFn=90);
	//translate([0,0,GearWidth*2+1+Race_w*2+Overlap*2])rotate([180,0,0]) PlanetCarrierB(EndRace=true, myFn=90);

	//translate([0,0,GearWidth*2+1.0+Overlap]) rotate([0,0,180/OutputRing_t()]) PCBOuterRace(EndRace=true, myFn=90);
	//translate([0,0,GearWidth*2+1+PCBOuterRace_h+Overlap*2]) rotate([0,0,180/OutputRing_t()]) TopCover();
	
	Pinion_a= ((PlanetA_t/2)!=floor(PlanetA_t/2)) ?  0 : (180/SunGear_t);
	translate([0,0,GearWidth-0.5])rotate([0,0,Pinion_a])SunGear(ShowGearOnly=false);
	
	//translate([0,0,-Overlap]) rotate([0,0,180/OutputRing_t()])SunGearRace();
} // ShowArmJoint

module ShowArmJointA(){
	PC_Offset=1;
	
	rotate([0,0,180/InputRing_t()]) RingGearA();
	translate([0,0,GearWidth/2+0.4]) color("Red") ShowMyBalls(BallCircle_d=BallCircle_d, nBalls=20);
	translate([0,0,GearWidth+1]) rotate([0,0,180/OutputRing_t()]) RingGearB(ShowGearOnly=false);
	
	translate([0,0,PC_Offset]){
		ShowPlanets(CutAway=false,HideGears=false,HidePC=true);
	
		translate([0,0,-0.5]) color("Tan")rotate([180,0,0])PlanetCarrierA();
		translate([0,0,GearWidth*2+0.5+Overlap]) PlanetCarrierB(EndRace=false, myFn=90);
		translate([0,0,GearWidth*2+0.5+Race_w*2+Overlap*2])rotate([180,0,0]) PlanetCarrierB(EndRace=true, myFn=90);
	}
	

	translate([0,0,GearWidth*2+1.0+Overlap]) rotate([0,0,180/OutputRing_t()]) PCBOuterRace(EndRace=true, myFn=90);
	translate([0,0,GearWidth*2+1+PCBOuterRace_h+Overlap*2]) rotate([0,0,180/OutputRing_t()]) TopCover();
	
	Pinion_a= ((PlanetA_t/2)!=floor(PlanetA_t/2)) ?  0 : (180/SunGear_t);
	translate([0,0,GearWidth-0.5]) rotate([0,0,Pinion_a]) SunGear(ShowGearOnly=false);
	translate([0,0,-GearWidth-0.9]) color("Red") ShowMyBalls(BallCircle_d=Hub_BC, nBalls=9);
	translate([24.2,0,-21.5]) DriveGear5245();
	
	translate([0,0,-Overlap]) rotate([0,0,180/OutputRing_t()])SunGearRace();
	
	translate([0,0,-Overlap*2]) rotate([0,0,180/OutputRing_t()]) BottomCover();
} // ShowArmJoint

//ShowArmJoint();
module ShowJointCutAway(){
difference(){
	ShowArmJointA();
	translate([0,-100,-100]) cube([100,100,200]);
}
} // ShowJointCutAway

//ShowJointCutAway();






