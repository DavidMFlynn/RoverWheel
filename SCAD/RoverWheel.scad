// **************************************************
// Rover wheel
// David M. Flynn
// Filename: RoverWheel.scad
// Created: 1/5/2018
// Rev: 1.0.0a2 1/10/2018
// Units: millimeters
// **************************************************
// History:
// 1.0.0a2 1/10/2018 Test fit on everything.
// 1.0.0a1 1/9/2018 Added encoder mount. worked on InputRingGear()
// 1.0.0 1/5/2018 First code
// **************************************************
// for STL output, from outside inward
//	HubCap();
//	rotate([180,0,0]) InnerRim(); // Print 2
//  OuterPlanetCarrier();
//  PlanetA();
//  rotate([180,0,0]) PlanetB();
//  InnerPlanetCarrier();
//	Pinion(); // aka sun gear
//  DriveRingGear();
//  rotate([180,0,0]) SensorMount();
//  rotate([180,0,0]) InputRingGear();
//  OutsideRace(myFn=360); // print 2
//  InsideRace(myFn=360); // Print 2
//  AdapterRing();
//  OuterRim();
//  WheelMount();
//  ChannelConnector();
// **************************************************
// for viewing
//  ShowPlanets(CutAway=true,HideGears=false);
//  ShowPlanets(CutAway=true,HideGears=true);
//  ShowWheel();
//  ShowCutAwayView(a=-50);
// **************************************************
// Routines and parts.
//  OPB490N_Sensor_Cutout();
//  OPB490N_Sensor();
//  OPB490_Sensor();
//  RS775_DC_Motor();
//  RS775_MotorMountHoles();
//  ShowMyBalls();
//  rotate([180,0,0]) InputRingGearMountingPlate();
//  SensorMountAssyTool();
// **************************************************

include<Motors.scad>
include<CompoundHelicalPlanetary.scad>
include<CommonStuffSAE.scad>

$fn=90;
IDXtra=0.2;
Overlap=0.05;
Spline_Hole_d=6.35+IDXtra; // for a 1/4" standoff
Spline_Gap=0.20; // 0.22 loose fit, 0.20 snug fit, 0.15 press fit

PlanetaryPitchA=300;
PlanetaryPitchB=290.3225;
Pinion_t=15;
Pinion_a=0;
PlanetA_t=15;
PlanetB_t=14;
PlanetStack=2; // number of gears 2 or 3
nPlanets=5;
Pressure_a=24; //22.5;
GearWidth=12;
twist=0;

bead_d=97.8; // 3.8"
bead_h=7;
bead_t=1.4;
bead_minD=94; // 3.46"
tire_w=78.0; // 3"
nBeadBolts=8;


module ChannelBoltPattern0770(){
	// inches
	BC_d=0.77;
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

//scale(25.4)ChannelBoltPattern0770() Bolt6Hole();

module ChannelBoltPattern1500(){
	// inches
	BC_d=1.50;
	BC_r=BC_d/2;
	
	rotate([0,0,45]) translate([BC_r,0,0]) children();
	rotate([0,0,135]) translate([BC_r,0,0]) children();
	rotate([0,0,225]) translate([BC_r,0,0]) children();
	rotate([0,0,315]) translate([BC_r,0,0]) children();
	
} // ChannelBoltPattern1500

//scale(25.4)ChannelBoltPattern1500() Bolt6Hole();

module ChannelMountingBlock(){
	ChannelDepth=1.410;
	ChannelWidth=1.320;
	
	difference(){
		cube([1.500,ChannelWidth,ChannelDepth],center=true);
		
		cylinder(d=0.5,h=ChannelDepth+0.01,center=true);
		rotate([90,0,0])cylinder(d=0.5,h=ChannelWidth+0.01,center=true);
		
		translate([0,0,ChannelDepth/2]){
			ChannelBoltPattern0770() Bolt6Hole();
			ChannelBoltPattern1500() Bolt6Hole();
		}
		
		rotate([90,0,0])
		translate([0,0,ChannelWidth/2]){
			ChannelBoltPattern0770() Bolt6Hole();
			ChannelBoltPattern1500() Bolt6Hole();
		}
		rotate([-90,0,0])
		translate([0,0,ChannelWidth/2]){
			ChannelBoltPattern0770() Bolt6Hole();
			ChannelBoltPattern1500() Bolt6Hole();
		}
	} // diff
} // ChannelMountingBlock

//scale(25.4)ChannelMountingBlock();

module OPB490N_Sensor_Cutout(){
	OPB490N_z=12.32+IDXtra;
	OPB490N_y=6.35+IDXtra;
	OPB490N_x=10.8+IDXtra;
	OPB490N_Beam=2.79;
	OPB490N_Wire_y=5.33+IDXtra;
	OPB490N_Wire_x=5.33+IDXtra;
	
	translate([-OPB490N_Beam,-OPB490N_y/2,-OPB490N_z/2])cube([OPB490N_x,OPB490N_y,OPB490N_z]);
	//wire clearance
	translate([-OPB490N_Beam+OPB490N_x-Overlap,-OPB490N_Wire_y/2,-OPB490N_z/2])cube([OPB490N_Wire_x,OPB490N_Wire_y,OPB490N_z]);
} // OPB490N_Sensor_Cutout

//OPB490N_Sensor_Cutout();

module OPB490N_Sensor(){
	OPB490N_z=12.32;
	OPB490N_y=6.35;
	OPB490N_x=10.8;
	OPB490N_Beam=2.79;
	OPB490N_Wire_y=5.33;
	OPB490N_Wire_x=5.33;
	
	// light beam
	color("Blue") cylinder(d=1,h=5,center=true);
	
	difference(){
		translate([-OPB490N_Beam,-OPB490N_y/2,-OPB490N_z/2])color("Red")cube([OPB490N_x,OPB490N_y,OPB490N_z]);
		translate([OPB490N_x/2-3.18,0,0])cube([OPB490N_x+Overlap,OPB490N_y+Overlap,3.18],center=true);
	} // diff
	//wire clearance
	translate([-OPB490N_Beam+OPB490N_x-Overlap,-OPB490N_Wire_y/2,-OPB490N_z/2])color("Red")cube([OPB490N_Wire_x,OPB490N_Wire_y,OPB490N_z]);
} // OPB490N_Sensor_Cutout

//OPB490N_Sensor();

module OPB490_Sensor(){
	
	// light beam
	color("Blue") rotate([0,90,0]) cylinder(d=1,h=5,center=true);
	
	translate([0,0,-3.18-8.76+2.79]){
		difference(){
		hull(){
			translate([9.51,0,0])cylinder(d=6.35,h=2.54);
			translate([-5.78,-3.18,0])cube([0.01,6.35,2.54]);
		} // hull
		translate([9.51,0,-Overlap])cylinder(d=3.18,h=2.54+Overlap*2);
	} // diff
		
		translate([-5.78,-3.18,0])cube([4.57,6.35,10.8]);
		translate([1.6,-3.18,0])cube([4.57,6.35,10.8]);
	}
} // OPB490_Sensor

//OPB490_Sensor();

module RS775_DC_Motor(){
	cylinder(d=5,h=93);
	translate([0,0,8.25])cylinder(d=17.5,h=4.7);
	translate([0,0,12.75])
	difference(){
		cylinder(d=46,h=66.5);
		translate([14.5,0,-Overlap])cylinder(d=4,h=3);
		translate([-14.5,0,-Overlap])cylinder(d=4,h=3);
	} // diff
	translate([0,0,12.75+66.5])cylinder(d=15.5,h=4);
} // RS775_DC_Motor

//RS775_DC_Motor();

module RS775_MotorMountHoles(){
	translate([0,0,Overlap])
	mirror([0,0,1]){
		cylinder(d=17.5,h=5);
		
		translate([14.5,0,4.5])children(); //cylinder(d=4,h=12);
		translate([-14.5,0,4.5])children(); //cylinder(d=4,h=12);
	}
} // RS775_MotorMountHoles

//RS775_MotorMountHoles() scale(25.4)Bolt8ButtonHeadHole();

module Pinion(){
	Hub_d=30;
	Shaft_d=5;
	EncDisk_d=Hub_d+12;
	EncDisk_t=1.5;
	nEncPulses=10;
	PinionHub_l=12;
	
	CompoundDrivePinionHelix(Pitch=PlanetaryPitchA, nTeeth=Pinion_t, Thickness=GearWidth, bEndScrew=0, HB=false,Hub_t=0,Hub_d=0);
	
	translate([0,0,-GearWidth-PinionHub_l])
	difference(){
		cylinder(d=Hub_d,h=PinionHub_l+Overlap);
		
		translate([0,0,-Overlap]) cylinder(d=Shaft_d,h=20);
		translate([0,0,6]) rotate([90,0,0]) scale(25.4) Bolt8Hole();
	} // diff
	
	// encoder disk
	translate([0,0,-GearWidth-PinionHub_l])
	difference(){
		cylinder(d=EncDisk_d,h=EncDisk_t);
		
		for (j=[0:nEncPulses])
			hull(){
				rotate([0,0,360/nEncPulses*j+360/nEncPulses/4])
			translate([-EncDisk_d/2+3,0,EncDisk_t/2]) 
				cube([7,0.01,EncDisk_t+Overlap*2],center=true);
				
		rotate([0,0,360/nEncPulses*j-360/nEncPulses/4])
			translate([-EncDisk_d/2+3,0,EncDisk_t/2]) 
				cube([7,0.01,EncDisk_t+Overlap*2],center=true);
			}
			translate([0,0,-Overlap]) cylinder(d=Shaft_d,h=20);
	} // diff
	translate([0,0,-GearWidth-PinionHub_l])
	difference(){
		cylinder(d=EncDisk_d,h=EncDisk_t);
		translate([0,0,-Overlap])cylinder(d=EncDisk_d-EncDisk_t*2,h=EncDisk_t+Overlap*2);
	}
} // Pinion

//InputRingGear();
//rotate([180,0,0])Pinion();
/*
rotate([0,0,80])color("Red"){
rotate([0,0,36-9])
translate([17.5,0,GearWidth+11.5])rotate([0,-90,0])OPB490_Sensor();
translate([17.5,0,GearWidth+11.5])rotate([0,-90,0])OPB490_Sensor();}
*/

PlanetClearance=1; // cut-away 1mm of teeth

module PlanetA(){
	
	difference(){
		CompoundPlanetGearHelixA(Pitch=PlanetaryPitchA,nTeethA=PlanetA_t, PitchB=PlanetaryPitchB, nTeethB=PlanetB_t, Thickness=GearWidth, Offset_a=0, HB=false, Spline_d=15, nSplines=5);
		
		// clearance for misaligned ring gears
		translate([0,0,GearWidth-PlanetClearance])
		difference(){
			cylinder(d=30,h=PlanetClearance+Overlap);
			translate([0,0,-Overlap])cylinder(d=21,h=PlanetClearance+Overlap*4);
		}
	} // diff
} // PlanetA

//PlanetA();

module PlanetB(){
	
	difference(){

		CompoundPlanetGearHelixB(Pitch=PlanetaryPitchA,nTeethA=PlanetA_t, PitchB=PlanetaryPitchB, nTeethB=PlanetB_t, Thickness=GearWidth, Offset_a=0, HB=false, Spline_d=15, nSplines=5);
		
		
		// clearance for misaligned ring gears
		translate([0,0,-Overlap])
		difference(){
			cylinder(d=30,h=PlanetClearance+Overlap);
			translate([0,0,-Overlap])cylinder(d=18.8,h=PlanetClearance+Overlap*4);
		}
		/**/
	} // diff
} // PlanetB

//rotate([180,0,0])PlanetB();

module OuterPlanetCarrier(){
	// Added Stiffenner 1/9/18
	PC_r=25;
	PC_t=3;
	difference(){
		union(){
			for (j=[0:nPlanets-1]){
				rotate([0,0,360/nPlanets*j])
					hull(){
						cylinder(d=10, h=PC_t);
						translate([PC_r,0,0]) cylinder(d=8, h=PC_t);
					} // hull
				
				// Stiffenner
				hull(){
					rotate([0,0,360/nPlanets*j]) translate([PC_r+2,0,0]) cylinder(d=3, h=PC_t-0.3);
					rotate([0,0,360/nPlanets*(j+1)]) translate([PC_r+2,0,0]) cylinder(d=3, h=PC_t-0.3);
				} // hull
			} // for
			
			cylinder(d=11,h=PC_t+1);
			cylinder(d=10,h=PC_t+5);
		} // union
			
		for (j=[0:nPlanets-1]) rotate([0,0,360/nPlanets*j]) translate([PC_r,0,PC_t]) scale(25.4) Bolt4ClearHole();
	} // diff
	
} // OuterPlanetCarrier

//OuterPlanetCarrier();

module InnerPlanetCarrier(){
	PC_r=25;
	PC_t=4;
	PC_w=10; // changed from 8 to 10 1/9/18
	
	difference(){
		cylinder(r=PC_r+PC_w/2,h=PC_t);
		
		translate([0,0,-Overlap]) cylinder(r=PC_r-PC_w/2,h=PC_t+Overlap*2);
			
		for (j=[0:nPlanets-1]) rotate([0,0,360/nPlanets*j]) translate([PC_r,0,PC_t]) scale(25.4) Bolt4ButtonHeadHole();
	} // diff
	
} // InnerPlanetCarrier

//InnerPlanetCarrier();

module ShowPlanets(CutAway=true,HideGears=true){
	PlanetShaft_l=24.5;
	PitchA=PlanetaryPitchA;
		PitchB=PlanetaryPitchB;
		Planet_BC=Pinion_t*PitchA/180 + PlanetA_t*PitchA/180;
		Ratio=OutputRing_t*PitchB/180/((InputRing_t*PitchA/180  / (PlanetA_t*PitchA/180) * (PlanetB_t*PitchB/180)-OutputRing_t*PitchB/180))*(InputRing_t/Pinion_t);
		
		PinionRA=$t*Ratio*360;
		PlanetPosRA=PinionRA/((InputRing_t/Pinion_t)+(InputRing_t/Pinion_t));//  29.7r /(InputRing_t/Pinion_t); // 2.57 4.5
		PlanetRA=-PlanetPosRA-PlanetPosRA*((InputRing_t/PlanetA_t));
		OutputRingRA=-360*$t;
	
	translate([0,0,bead_h+3])rotate([180,0,0]) color("Brown")OuterPlanetCarrier();
	for (j=[0:nPlanets-1])rotate([0,0,PlanetPosRA+360/nPlanets*j])
		translate([Planet_BC/2,0,bead_h+3.05])color("Red")cylinder(d=6.35,h=PlanetShaft_l);
	translate([0,0,bead_h+3.1+PlanetShaft_l])color("Brown")InnerPlanetCarrier();
	
	if (HideGears==false)
	difference(){
		translate([0,0,GearWidth*2+bead_h+3.2]) mirror([0,0,1])
			for (j=[0:nPlanets-1])
				rotate([0,0,PlanetPosRA+360/nPlanets*j])translate([Planet_BC/2,0,0])rotate([0,0,PlanetRA]){
					color("Tan")
					CompoundPlanetGearHelixA(Pitch=PitchA,nTeethA=PlanetA_t, PitchB=PitchB, nTeethB=PlanetB_t, Thickness=GearWidth, Offset_a=PlanetB_a*j, HB=false, Spline_d=15, nSplines=5);
				
					translate([0,0,GearWidth])
						CompoundPlanetGearHelixB(Pitch=PitchA,nTeethA=PlanetA_t, PitchB=PitchB, nTeethB=PlanetB_t, Thickness=GearWidth, Offset_a=PlanetB_a*j, HB=false, Spline_d=15, nSplines=5);
				}
			
				if (CutAway==true)
			translate([0,-Planet_BC,bead_h+3.1])cube([Planet_BC,Planet_BC,PlanetShaft_l]);
		} // diff
			/**/
} // ShowPlanets

//ShowPlanets(CutAway=true,HideGears=false);
//ShowPlanets(CutAway=true,HideGears=true);

module ShowWheel(){

	PitchA=PlanetaryPitchA;
		PitchB=PlanetaryPitchB;
		Planet_BC=Pinion_t*PitchA/180 + PlanetA_t*PitchA/180;
		Ratio=OutputRing_t*PitchB/180/((InputRing_t*PitchA/180  / (PlanetA_t*PitchA/180) * (PlanetB_t*PitchB/180)-OutputRing_t*PitchB/180))*(InputRing_t/Pinion_t);
		echo(Ratio=Ratio);
		PinionRA=$t*Ratio*360;// 76.5r
		PlanetPosRA=PinionRA/((InputRing_t/Pinion_t)+(InputRing_t/Pinion_t));//  29.7r /(InputRing_t/Pinion_t); // 2.57 4.5
		PlanetRA=-PlanetPosRA-PlanetPosRA*((InputRing_t/PlanetA_t));
		OutputRingRA=-360*$t;
	
	HubCap();
	//translate([0,0,bead_h+3])rotate([180,0,0]) OuterPlanetCarrier();
	//translate([0,0,bead_h+3+GearWidth*2+0.5])InnerPlanetCarrier();
	color("Green")InnerRim();

	// Planets
	ShowPlanets(CutAway=false,HideGears=true);
		/*
	translate([0,0,GearWidth*2+bead_h+3.1]) mirror([0,0,1])
	for (j=[0:nPlanets-1])
		rotate([0,0,PlanetPosRA+360/nPlanets*j])translate([Planet_BC/2,0,0])rotate([0,0,PlanetRA]){
		
		
			CompoundPlanetGearHelixA(Pitch=PitchA,nTeethA=PlanetA_t, PitchB=PitchB, nTeethB=PlanetB_t, Thickness=GearWidth, Offset_a=PlanetB_a*j, HB=false, Spline_d=15, nSplines=5);
			
			translate([0,0,GearWidth])
			CompoundPlanetGearHelixB(Pitch=PitchA,nTeethA=PlanetA_t, PitchB=PitchB, nTeethB=PlanetB_t, Thickness=GearWidth, Offset_a=PlanetB_a*j, HB=false, Spline_d=15, nSplines=5);
			
			
		}
		/**/
		translate([0,0,bead_h+3.3+GearWidth]){
			rotate([180,0,0])color("Black")Pinion();
			
			rotate([0,0,76+36-9])translate([18.0,0,GearWidth+11.0])OPB490N_Sensor();
			rotate([0,0,76])	translate([18.0,0,GearWidth+11.0])OPB490N_Sensor();

		}
		
		// drive ring
		translate([0,0,bead_h+3.1]) {
			
			color("Tan")DriveRingGear();
			translate([0,0,InnerSleve_l]) {
				translate([0,0,Race_w])color("Pink")ShowMyBalls();
				OutsideRace(myFn=90);
				color("LightBlue")InsideRace(myFn=90);
				translate([0,0,Race_w*2]) rotate([180,0,0]){
					OutsideRace(myFn=90);
					color("LightBlue")InsideRace(myFn=90);
				}
			}
		}
/**/
		
		//translate([0,0,25-12.7+4.5]) color("Red") RS775_DC_Motor();
		
		//input ring
		translate([0,0,bead_h+3.2+GearWidth]) {
			color("Orange")InputRingGear();
			translate([0,0,-Overlap*2])color("Tan")SensorMount();
		}
			
			
		
	translate([0,0,bead_h+3.1+InnerSleve_l+Race_w*2]) color("Blue")AdapterRing();
		
	translate([0,0,tire_w])rotate([180,0,0]){
		OuterRim();
		color("Green")InnerRim();
		}
		
	translate([0,0,bead_h+3.1+InnerSleve_l+Race_w*2]) color("Gray")WheelMount();
	/**/
} // ShowWheel

//ShowWheel();

module ShowCutAwayView(a=30){
	difference(){
		ShowWheel();
		
		rotate([0,0,a])translate([-100,-100,-Overlap])cube([100,100,200]);
	} // diff
	
} // ShowCutAwayView

//ShowCutAwayView();

Ada_h=6; // AdapterRing height
Race_w=5;
BallCircle_d=80;
Ball_d=9.525; // 0.375"
RaceBoltInset=3.5;
Race_OD=BallCircle_d+26;

InnerSleve_l=tire_w-(bead_h+3.1)*2-Race_w*2-Ada_h;

/*

translate([0,0,bead_h+3.2+GearWidth]){
	InputRingGear();
	rotate([180,0,0])Pinion();
	translate([0,0,GearWidth+0.5])InnerPlanetCarrier();
	
	rotate([0,0,76])color("Red"){
		rotate([0,0,36-9]) translate([18.0,0,GearWidth+11.0])OPB490N_Sensor();
		translate([18.0,0,GearWidth+11.0])OPB490N_Sensor();}
	}

/**/

//translate([0,0,tire_w])rotate([180,0,0]){OuterRim();InnerRim();}
	

	//translate([0,0,bead_h+3.1+InnerSleve_l+Race_w*2]) AdapterRing();
	
/*
	
translate([0,0,bead_h+3.1])
	translate([0,0,InnerSleve_l]) {
				//OutsideRace(myFn=90);
				InsideRace(myFn=90);
	//translate([0,0,Race_w])color("Pink")ShowMyBalls();
				translate([0,0,Race_w*2]) rotate([180,0,0]){
					//OutsideRace(myFn=90);
					//InsideRace(myFn=90);
				}}

/**/
//translate([0,0,bead_h+3.1]) DriveRingGear();
		
//HubCap();
//InnerRim();

WheelMount_l=25;
WheelMount_OD=bead_minD-17;
nMountingBolts=8;
MBoltInset=3.5;
	
module ChannelConnector(){
	
	
	difference(){
		union(){
		translate([WheelMount_OD/2-4,0,0])
				scale(25.4)translate([0.75,0,1.41/2])ChannelMountingBlock();
		cylinder(d=WheelMount_OD,h=25);
		} // union
		
		// wire path
		translate([WheelMount_OD/2-8,0,0.705*25.4])rotate([0,90,0]) cylinder(d=12.7,h=45);
		
		translate([0,0,3]) hull(){
			translate([-WheelMount_OD/4,0,0]) cube([WheelMount_OD/2,WheelMount_OD+Overlap*2,0.01],center=true);
			translate([0,0,23]) cube([WheelMount_OD-8,WheelMount_OD+Overlap*2,0.01],center=true);
		}
		
		translate([0,0,-Overlap])cylinder(d=WheelMount_OD-MBoltInset*4,h=WheelMount_l+Overlap*2);
		
		translate([-WheelMount_OD/2-Overlap,-WheelMount_OD/2-Overlap,-Overlap]) 
			cube([WheelMount_OD/2,WheelMount_OD+Overlap*2,26]);
		
		// Mounting Bolts
		for (j=[0:nMountingBolts-1]) rotate([0,0,180/nMountingBolts*j+180/nMountingBolts/2-90]) 
			translate([WheelMount_OD/2-MBoltInset,0,8])
				scale(25.4) Bolt4HeadHole(lHead=2); //Bolt6HeadHole(lAccess=2);
		
	} // diff
} // ChannelConnector

//color("Red")RS775_DC_Motor();
//translate([0,0,WheelMount_l])ChannelConnector();

module WheelMount(){
	
	difference(){
		cylinder(d=WheelMount_OD,h=6);
		
		translate([0,0,-Overlap])cylinder(d=Race_ID,h=6+Overlap*2);
		translate([0,0,6]) for (j=[0:nBeadBolts-1]) rotate([0,0,360/nBeadBolts*j]) translate([Race_ID/2+RaceBoltInset,0,0]) 
			scale(25.4) Bolt4HeadHole();
	} // diff
	
	difference(){
		cylinder(d=WheelMount_OD,h=WheelMount_l);
		
		translate([0,0,-Overlap])cylinder(d=WheelMount_OD-MBoltInset*4,h=WheelMount_l+Overlap*2);
		
		// Mounting Bolts
		for (j=[0:nMountingBolts-1]) rotate([0,0,180/nMountingBolts*j+180/nMountingBolts/2-90]) 
			translate([WheelMount_OD/2-MBoltInset,0,WheelMount_l]) scale(25.4)
				Bolt4Hole(); //Bolt6Hole();
		
		// cut away
		hull(){
			translate([-WheelMount_OD/4,0,WheelMount_l]) cube([WheelMount_OD/2,WheelMount_OD+Overlap*2,0.01],center=true);
			translate([-WheelMount_OD/2,0,0]) cylinder(d=10,h=1);
		} // hull
	} // diff
} // WheelMount

//translate([0,0,bead_h+3.1+InnerSleve_l+Race_w*2]) WheelMount();

module SensorMountAssyTool(){
	Hub_d=30;
	EncDiskClear_d=Hub_d+14;
	
	difference(){
		union(){
		cylinder(d=EncDiskClear_d,h=3);
		cylinder(d=Hub_d+1,h=5);
		}
		
		translate([0,0,-Overlap])cylinder(d=17,h=6);
	} // diff
	
} // SensorMountAssyTool

//SensorMountAssyTool();


MotorPlate_t=4.5;
MotorInset=25;
Enc_a=76;
InputGear_d=85.4;

module SensorMount(){
	Hub_d=30;
	EncDiskClear_d=Hub_d+14;
	
	SM_Thickness=6;
	
	translate([0,0,MotorInset])
	difference(){
		
		
		translate([0,0,-SM_Thickness]) cylinder(d=InputGear_d-12,h=SM_Thickness);
		
		// crop ends
		rotate([0,0,Enc_a-36]) translate([-InputGear_d/2,-InputGear_d,-SM_Thickness-Overlap]) cube([InputGear_d,InputGear_d,SM_Thickness+1]);
		rotate([0,0,180+Enc_a+36-9+36]) translate([-InputGear_d/2,-InputGear_d,-SM_Thickness-Overlap]) cube([InputGear_d,InputGear_d,SM_Thickness+1]);
		// encoder disk clearance
		translate([0,0,-SM_Thickness-Overlap]) cylinder(d=EncDiskClear_d,h=SM_Thickness+1);
		
		rotate([0,0,Enc_a+36-9]) translate([18.0,0,-1.5])OPB490N_Sensor_Cutout();
		rotate([0,0,Enc_a]) translate([18.0,0,-1.5])OPB490N_Sensor_Cutout();

		// Encoder Mounting Bolts
		rotate([0,0,Enc_a+36-9+30]) translate([EncDiskClear_d/2+12,0,-SM_Thickness]) rotate([180,0,0])
			scale(25.4) Bolt4ButtonHeadHole();
		rotate([0,0,Enc_a-30]) translate([EncDiskClear_d/2+12,0,-SM_Thickness]) rotate([180,0,0])
			scale(25.4) Bolt4ButtonHeadHole();
		rotate([0,0,Enc_a+36-9+30]) translate([EncDiskClear_d/2+3,0,-SM_Thickness]) rotate([180,0,0])
			scale(25.4) Bolt4ButtonHeadHole();
		rotate([0,0,Enc_a-30]) translate([EncDiskClear_d/2+3,0,-SM_Thickness]) rotate([180,0,0])
			scale(25.4) Bolt4ButtonHeadHole();

	} // diff
} // SensorMount

//translate([0,0,-Overlap*2]) color("Tan")SensorMount();

module InputRingGearMountingPlate(){
	Hub_d=30;
	EncDiskClear_d=Hub_d+14;
	
	difference(){
		cylinder(d=InputGear_d,h=MotorPlate_t);
		
		// Wire paths / lightening holes
		for (j=[0:nBeadBolts-1]) rotate([0,0,360/nBeadBolts*(j+0.5)])hull(){
			translate([Race_ID/2+RaceBoltInset+7,0,-Overlap]) cylinder(d=10,h=MotorPlate_t+Overlap*2);
			translate([Race_ID/2,0,-Overlap]) cylinder(d=10,h=MotorPlate_t+Overlap*2);
		}
		
		// Encoder Mounting Bolts
		rotate([0,0,Enc_a+36-9+30]) translate([EncDiskClear_d/2+12,0,MotorPlate_t]) scale(25.4) Bolt4Hole();
		rotate([0,0,Enc_a-30]) translate([EncDiskClear_d/2+12,0,MotorPlate_t]) scale(25.4) Bolt4Hole();
		rotate([0,0,Enc_a+36-9+30]) translate([EncDiskClear_d/2+3,0,MotorPlate_t]) scale(25.4) Bolt4Hole();
		rotate([0,0,Enc_a-30]) translate([EncDiskClear_d/2+3,0,MotorPlate_t]) scale(25.4) Bolt4Hole();
		
		// test version only, doesn't fit in wheel mount
		//rotate([0,0,5])rotate([0,-90,0])scale(25.4)Stepper17_BtnHoles(Thickness=MotorPlate_t/25.4);

		// encoder clearance scaled for a loose fit
		rotate([0,0,Enc_a+36-9]) translate([18.0,0,-1.5])scale(1.1)OPB490N_Sensor_Cutout();
		rotate([0,0,Enc_a]) translate([18.0,0,-1.5])scale(1.1)OPB490N_Sensor_Cutout();
		
		
		translate([0,0,MotorPlate_t])RS775_MotorMountHoles()scale(25.4)Bolt8ButtonHeadHole();
		
		for (j=[0:nBeadBolts-1]) rotate([0,0,360/nBeadBolts*j]) translate([Race_ID/2+RaceBoltInset,0,Race_w]) 
			scale(25.4) Bolt4Hole();
	} // diff
} // InputRingGearMountingPlate

//InputRingGearMountingPlate();

module InputRingGear(){
	
	CompoundRingGearHelix(Pitch=PlanetaryPitchA, nTeeth=InputRing_t, Thickness=GearWidth+Overlap, twist=-twist, HB=false);
	
	translate([0,0,MotorInset]) InputRingGearMountingPlate();
	
	// skirt
	translate([0,0,GearWidth]) difference(){
		Skirt_h=MotorInset-GearWidth+MotorPlate_t;
		cylinder(d=InputGear_d,h=Skirt_h);
		
		translate([0,0,-Overlap])cylinder(d1=InputGear_d-14,d2=InputGear_d-4,h=10+Overlap*2);
		
		translate([0,0,10])cylinder(d=InputGear_d-4,h=MotorInset-GearWidth+MotorPlate_t+Overlap*2);
		
		// Set screw access
		for (j=[0:4]) rotate([0,0,360/5*j]) translate([InputGear_d/2-10,0,2]) hull(){
			rotate([0,90,0]) cylinder(d=1,h=20);
			translate([0,0,Skirt_h-8]) rotate([0,90,0]) cylinder(d=12,h=20);
		}
	} // diff
	
	//translate([0,0,MotorInset-12.7+MotorPlate_t])color("Red")RS775_DC_Motor();
} // InputRingGear

//InputRingGear();

module DriveRingGear(){
	
	Nut_l=8;
	
	difference(){
		union(){
			CompoundRingGearHelix(Pitch=PlanetaryPitchB, nTeeth=OutputRing_t, Thickness=GearWidth, twist=twist, HB=false);
			
			for (j=[0:nBeadBolts-1]) rotate([0,0,360/nBeadBolts*j]) translate([bead_minD/2-3,0,0]) 
			cylinder(d=7.5,h=GearWidth);
		} // union
		
		for (j=[0:nBeadBolts-1]) rotate([0,0,360/nBeadBolts*j]) translate([bead_minD/2-3,0,0]) 
			rotate([180,0,0]) scale(25.4) Bolt4Hole();
	} // diff
	
	
	difference(){
			cylinder(d=bead_minD+4,h=InnerSleve_l);	
			
			
			

		// ID
		translate([0,0,-Overlap])cylinder(d=bead_minD,h=InnerSleve_l+Overlap*2);
		
		// outer race bolts
		for (j=[0:nBeadBolts-1]) rotate([0,0,360/nBeadBolts*j]) translate([Race_OD/2-RaceBoltInset,0,InnerSleve_l]) 
			scale(25.4) Bolt4Hole(depth=0.35);
	} // diff
	
	difference(){
		for (j=[0:nBeadBolts-1]) rotate([0,0,360/nBeadBolts*j]) hull(){
				translate([bead_minD/2+1,-4,InnerSleve_l-Nut_l]) 
					cube([0.1,8,Nut_l]);
				translate([Race_OD/2-RaceBoltInset,0,InnerSleve_l-Nut_l]) 
					cylinder(d=7.5,h=Nut_l);
				translate([bead_minD/2+0.5,0,InnerSleve_l-Nut_l-12]) 
					cylinder(d=1,h=1);
			} // for hull
		
		// outer race bolts
		for (j=[0:nBeadBolts-1]) rotate([0,0,360/nBeadBolts*j]) translate([Race_OD/2-RaceBoltInset,0,InnerSleve_l]) 
			scale(25.4) Bolt4Hole(depth=0.35);
	} // diff
} // DriveRingGear

/*
DriveRingGear();
translate([0,0,InnerSleve_l]) OutsideRace(myFn=90);
translate([0,0,InnerSleve_l+Race_w*2]) rotate([180,0,0])OutsideRace(myFn=90);

translate([0,0,tire_w])rotate([180,0,0]){
		OuterRim();
		InnerRim();
	}
/**/


module ShowMyBalls(){
	nBalls=12;
	for (j=[0:nBalls-1]) rotate([0,0,360/nBalls*j]) translate([BallCircle_d/2,0,0]) sphere(d=Ball_d-Overlap*2);
} // ShowMyBalls

//translate([0,0,9.1+InnerSleve_l+Race_w])color("Pink")ShowMyBalls();

	Race_ID=50; // motor is 46

module InsideRace(myFn=360){
	
	difference(){
		cylinder(d=BallCircle_d-7,h=Race_w);
		
		translate([0,0,-Overlap]) cylinder(d=Race_ID,h=Race_w+Overlap*2);
		
		translate([0,0,Race_w])
		rotate_extrude(convexity = 10,$fn=myFn)
			translate([BallCircle_d/2, 0, 0]) circle(d = Ball_d);
		
		// wire path
		for (j=[0:nBeadBolts-1]) rotate([0,0,360/nBeadBolts*(j+0.5)]) translate([Race_ID/2-5,0,-Overlap]) 
			cylinder(d=15,h=Race_w+Overlap*2);
		
		for (j=[0:nBeadBolts-1]) rotate([0,0,360/nBeadBolts*j]) translate([Race_ID/2+RaceBoltInset,0,Race_w]) 
			scale(25.4) Bolt4ClearHole();
	} // diff
} // InsideRace

//InsideRace(myFn=90);

module OutsideRace(myFn=360){
	
	difference(){
		cylinder(d=Race_OD,h=Race_w);
		
		translate([0,0,-Overlap]) cylinder(d=BallCircle_d+7,h=Race_w+Overlap*2);
		
		for (j=[0:nBeadBolts-1]) rotate([0,0,360/nBeadBolts*j]) translate([Race_OD/2-RaceBoltInset,0,Race_w]) 
			scale(25.4) Bolt4ClearHole();
		
		translate([0,0,Race_w])
		rotate_extrude(convexity = 10,$fn=myFn)
			translate([BallCircle_d/2, 0, 0]) circle(d = Ball_d);
		
	} // diff
} // OutsideRace

//OutsideRace(myFn=90);

module AdapterRing(){
	
	difference(){
		cylinder(d1=Race_OD,d2=bead_d+bead_t*2,h=Ada_h);
		
		translate([0,0,-Overlap]) cylinder(d=bead_minD-12,h=10+Overlap*2);
		
		for (j=[0:nBeadBolts-1]) rotate([0,0,360/nBeadBolts*j]) translate([Race_OD/2-RaceBoltInset,0,6]) 
			scale(25.4) Bolt4HeadHole();
		
		for (j=[0:nBeadBolts-1]) rotate([0,0,360/nBeadBolts*(j+0.5)]) translate([bead_minD/2-3,0,Ada_h]) 
			scale(25.4) Bolt4Hole();
	} // diff
} // AdapterRing

module InnerRim(){
	
	difference(){
		cylinder(d=bead_d+bead_t*2,h=bead_h+3);
		
		translate([0,0,-Overlap]) cylinder(d=bead_d+1+bead_t*2, h=2);
		
		translate([0,0,-Overlap]) cylinder(d1=bead_d-2+bead_t*2, d2=bead_minD+bead_t*2, h=bead_h);
		
		cylinder(d=bead_minD-12, h=bead_h+4);
		
		
		for (j=[0:nBeadBolts-1]) rotate([0,0,360/nBeadBolts*j]) translate([bead_minD/2-3,0,0]) 
			rotate([180,0,0]) scale(25.4) Bolt4ClearHole();
	} // diff
	
	
} // InnerRim

//InnerRim();

module OuterRim(){
	difference(){
		union(){
			cylinder(d=bead_d,h=1);
			translate([0,0,1]) cylinder(d1=bead_d-2, d2=bead_minD, h=bead_h);
			
		} // union
		
		translate([0,0,-Overlap]) cylinder(d=bead_minD-13, h=1+bead_h+Overlap*2);
		
		for (j=[0:nBeadBolts-1]) rotate([0,0,360/nBeadBolts*j]) translate([bead_minD/2-3,0,bead_h-6]) 
			rotate([180,0,0]) scale(25.4) Bolt4HeadHole();
	} // diff
	
} // OuterRim

 //OuterRim(); 

module HubCap(){
	
	nSpokes=8;
	
	OuterRim();
	difference(){
		union(){
			// spokes
			for (j=[0:nSpokes-1]) rotate([0,0,360/nSpokes*(j+0.5)]) hull(){
				translate([bead_minD/2-3,0,0]) cylinder(d=5,h=3);
				cylinder(d=10,h=3);
			} // hull
			cylinder(d=18,h=6);
		} // union
		
		translate([0,0,-Overlap]) cylinder(d=13,h=4);
		
		translate([0,0,2]) cylinder(d=15+IDXtra,h=6);
	} // diff
} // HubCap

//HubCap();










