
// ***********************************
// for STL output
//rotate([0,-90,0])OnePartWheel();
// **********************************

include<CommonStuffSAEmm.scad>

include<TubeConnectorLib.scad>
// TubeEll_STL(TubeOD=25.4,Wall_t=0.84,Hole_d=14, GlueAllowance=0.40);
// TubeSection(TubeOD=25.4,Wall_t=0.84, Length=100);
// TubeEnd(TubeOD=25.4,Wall_t=0.84,Hole_d=14, Stop_l=TubeStop_l, GlueAllowance=0.40);
// TubeEll(TubeOD=25.4,Wall_t=0.84,Hole_d=14, GlueAllowance=0.40);
// Tube2Pivot(TubeAngle=180,Length=50,WireExit=0, GlueAllowance=0.40);
// Tube2PivotCover(Length=60);


$fn=90;
IDXtra=0.03;
Overlap=0.05;

Tire_w=140;
Tire_d=180;
nTreads=20;
Tread_h=2.0;

module MotorToTube(){
	MotorCover_OD=42;
	TubeFace=30;
	
	translate([MotorCover_OD/2+12.5,0,TubeFace]) TubeEnd(TubeOD=25.4,Wall_t=0.84,Hole_d=14, Stop_l=TubeStop_l, GlueAllowance=0.40);
	
	// motor cover
	difference(){
		union(){
			translate([0,0,28])cylinder(d=MotorCover_OD-2,h=12);
			hull(){
				translate([0,0,28])cylinder(d=MotorCover_OD,h=2);
				cylinder(d=40,h=1);
			} // hull
		} // union
		
		//translate([0,0,28-Overlap]) cylinder(d=GearCase_d,h=13);
		translate([0,0,-Overlap]) cylinder(d=GearCase_d,h=41);
	} // diff
	
	difference(){
		union(){
			cylinder(d=40,h=30);
			hull(){
				cylinder(d=40,h=TubeFace);
				translate([MotorCover_OD/2+12.5,0,TubeFace-2]) cylinder(d=25.4,h=2);
			} // hull
		} // union
		
		translate([0,0,6])MotorMountGearMotor();
	} // diff
} // MotorToTube

//MotorToTube();

GearCase_d=32+IDXtra;

module MotorMountGearMotor(){
	// mount for RobotZone PN:638324 118 RPM Planetary Gear Motor
	// difference this from the mount
	// z zero is motor face
	
	MountBolts_BC_d=26;
	GearCase_h=35;
	Nose_h=3.5;
	Nose_d=20+IDXtra;
	
	translate([0,0,-Nose_h])
	difference(){
		cylinder(d=Nose_d,h=Nose_h+Overlap);
		
		translate([9,-Nose_d/2,-Overlap]) cube([2,Nose_d,Nose_h+Overlap*3]);
		mirror([1,0,0]) translate([9,-Nose_d/2,-Overlap]) cube([2,Nose_d,Nose_h+Overlap*3]);
	} // diff
	
	translate([0,0,-20]) cylinder(d=6.5,h=20); // shaft
	cylinder(d=GearCase_d,h=GearCase_h);
	for (j=[0:3]) rotate([0,0,90*j+45]) translate([MountBolts_BC_d/2,0,-6])rotate([180,0,0])Bolt4ButtonHeadHole();
	
} // MotorMountGearMotor

//MotorMountGearMotor();



module OnePartWheel(){
	Rim();
	Hub();
	Spoke();
} // OnePartWheel

module Rim(){
difference(){
	scale([3,1,1]) sphere(d=Tire_d,$fn=360);
	
	scale([3,1,1]) sphere(d=Tire_d-4,$fn=360);
	
	translate([Tire_w/2,-100,-100]) cube([200,200,200]);
	mirror([1,0,0])translate([Tire_w/2,-100,-100]) cube([200,200,200]);
} // diff

	for (j=[0:nTreads-1]) rotate([360/nTreads*j,0,0]){
	hull(){
		rotate([-5,0,0])translate([-15,0,Tire_d/2-1]) cylinder(d1=4,d2=2,h=Tread_h);
		rotate([5,0,0])translate([15,0,Tire_d/2-1]) cylinder(d1=4,d2=2,h=Tread_h);
	} // hull
	hull(){
		rotate([-5,0,0])translate([45,0,Tire_d/2-2]) cylinder(d1=4,d2=2,h=Tread_h);
		rotate([5,0,0])translate([15,0,Tire_d/2-1]) cylinder(d1=4,d2=2,h=Tread_h);
	} // hull
	hull(){
		rotate([-5,0,0])translate([45,0,Tire_d/2-2]) cylinder(d1=4,d2=2,h=Tread_h);
		rotate([5,0,0])translate([65,0,Tire_d/2-3.5]) cylinder(d1=4,d2=2,h=Tread_h);
	} // hull
	hull(){
		rotate([5,0,0])translate([-45,0,Tire_d/2-2]) cylinder(d1=4,d2=2,h=Tread_h);
		rotate([-5,0,0])translate([-15,0,Tire_d/2-1]) cylinder(d1=4,d2=2,h=Tread_h);
	} // hull
	hull(){
		rotate([5,0,0])translate([-45,0,Tire_d/2-2]) cylinder(d1=4,d2=2,h=Tread_h);
		rotate([-5,0,0])translate([-65,0,Tire_d/2-3.5]) cylinder(d1=4,d2=2,h=Tread_h);
	} // hull
} // for
} // Rim

//Rim();

Hub_d=40;
Hub_l=30;
Spoke_w=1;
Spoke_l=55;
nSpokes=9;

nLugBolts=6;
Hub_BC_d=30;

module MotorHub(){
	ShaftCollar_d=12.64+IDXtra;
	ShaftCollar_l=8;
	Shaft_l=13;
	
	difference(){
		cylinder(d=Hub_d,h=Shaft_l);
		
		translate([0,0,Shaft_l-ShaftCollar_l-1]) {
			cylinder(d=ShaftCollar_d,h=Shaft_l);
			translate([0,0,ShaftCollar_l/2]) rotate([90,0,0]) Bolt8ClearHole(depth=20);
		}
		translate([0,0,-Overlap]) cylinder(d=6,h=Shaft_l+Overlap*2);
		
		for (j=[0:nLugBolts-1]) rotate([0,0,360/nLugBolts*j])
		translate([Hub_BC_d/2,0,Shaft_l]) Bolt4Hole(depth=Shaft_l);
	} // diff
	
} // MotorHub

MotorHub();

module Hub(){
difference(){
	translate([-Tire_w/2,0,0]) rotate([0,90,0]) cylinder(d=Hub_d,h=Hub_l);
	
	translate([-Tire_w/2-Overlap,0,0]) rotate([0,90,0]) cylinder(d=8+IDXtra,h=Hub_l+Overlap*2);
	for (j=[0:nLugBolts-1]) translate([-Tire_w/2+Hub_l-8,0,0]) rotate([0,-90,0]) rotate([0,0,360/nLugBolts*j])
		translate([Hub_BC_d/2,0,0]) Bolt4HeadHole(depth=8,lHead=Hub_l);
} // diff
} // Hub

module GearSpace(){
	translate([-Tire_w/2+Hub_l,0,0]) rotate([0,90,0]) cylinder(d1=Hub_d+30,d2=Tire_d,h=Tire_w-Hub_l+Overlap);
}

module Spoke(){
for (j=[0:nSpokes-1]){
	difference(){
		translate([-Tire_w/2,0,0]) rotate([360/nSpokes*j,0,0]) translate([0,-Spoke_w/2,Hub_d/2-Overlap]) cube([Tire_w,Spoke_w,Spoke_l+Overlap*2]);
		
		GearSpace();
	} // diff
	
	difference(){
		translate([-Tire_w/2,0,0]) rotate([360/nSpokes*j,0,0]) translate([0,-5,Hub_d/2+Spoke_l]) rotate([0,90,0]) cylinder(d=10+Spoke_w,h=Tire_w);
		
		translate([-Tire_w/2-Overlap,0,0]) rotate([360/nSpokes*j,0,0]) translate([0,-5,Hub_d/2+Spoke_l]) rotate([0,90,0]) cylinder(d=10-Spoke_w,h=Tire_w+Overlap*2);
		translate([-Tire_w/2-Overlap,0,0]) rotate([360/nSpokes*j,0,0]) translate([0,-5,Hub_d/2+Spoke_l]) rotate([0,90,0]){
			translate([0,-Overlap,0])rotate([0,0,0])cube([10,10,Tire_w+Overlap*2]);
			translate([-Overlap,0,0])rotate([0,0,-90])cube([10,10,Tire_w+Overlap*2]);
			rotate([0,0,180])cube([10,10,Tire_w+Overlap*2]);
		}
		
		GearSpace();

	} // diff

	
	difference(){
		translate([-Tire_w/2,0,0]) rotate([360/nSpokes*j,0,0]) translate([0,-45,Hub_d/2+Spoke_l+5-Spoke_w/2]) cube([Tire_w,40+Overlap,Spoke_w]);
		
		difference(){
			scale([3,1,1]) sphere(d=200);
			scale([3,1,1]) sphere(d=180-1);
			
		} // diff
		
		GearSpace();

	} // diff

} // for

} // Spoke

//Spoke();

