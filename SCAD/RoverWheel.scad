// **************************************************
// Rover wheel
// David M. Flynn
// Filename: RoverWheel.scad
// Created: 1/5/2018
// Rev: 1.0.0b4 2/2/2018
// Units: millimeters
// **************************************************
// History:
// 1.0.0b4 2/2/2018 Now using BearingLib.scad.
// 1.0.0b3 1/31/2018 Increased encoder resolution.
// 1.0.0b2 1/24/2018 Changed BackLash to 0.5mm, any distortion in the ring gears caused binding.
// 1.0.0b1 1/21/2018 Modified Sensor mount, added MotorCover. First wheel is assembled and working.
// 1.0.0a3 1/13/2018 Added GearSlop to InputRingGear for planet clearance.
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
//	SunGear();
//  DriveRingGear();
//  rotate([180,0,0]) SensorMount();
//  rotate([180,0,0]) InputRingGear();
//  RW_OutsideRace(myFn=360); // print 2
//  RW_InsideRace(myFn=360); // Print 2
//  AdapterRing();
//  OuterRim();
//  WheelMount();
//  ChannelConnector(); // Connects 1.5" channel to the hub.
//  TubeConnector(); // Connects 1" O.D. x 0.035" wall aluminum tube to the hub.
//  MotorCover(); // optional snap on cover
// **************************************************
// for viewing
//  ShowPlanets(CutAway=true,HideGears=false);
//  ShowPlanets(CutAway=true,HideGears=true);
//  ShowWheel();
//  ShowCutAwayView(a=+50);
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
//  rotate([180,0,0])SunGearCollet();
// **************************************************

include<TubeConnectorLib.scad>
include<Motors.scad>
include<CompoundHelicalPlanetary.scad>
include<CommonStuffSAEmm.scad>
include<BearingLib.scad>

$fn=90;
IDXtra=0.2;
Overlap=0.05;
Spline_Hole_d=6.35+IDXtra; // for a 1/4" standoff
Spline_Gap=0.20; // 0.22 loose fit, 0.20 snug fit, 0.15 press fit

PlanetaryPitchA=300;
PlanetaryPitchB=290.3225;
BackLash=0.5; // 0.3 works but is tight
SunGear_t=15;
SunGear_a=0;
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
	BC_d=0.77*25.4;
	BC_r=BC_d/2*25.4;
	
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
	BC_r=BC_d/2*25.4;
	
	rotate([0,0,45]) translate([BC_r,0,0]) children();
	rotate([0,0,135]) translate([BC_r,0,0]) children();
	rotate([0,0,225]) translate([BC_r,0,0]) children();
	rotate([0,0,315]) translate([BC_r,0,0]) children();
	
} // ChannelBoltPattern1500

//ChannelBoltPattern1500() Bolt6Hole();

module ChannelMountingBlock(){
	ChannelDepth=1.410*25.4;
	ChannelWidth=1.320*25.4;
	
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

//ChannelMountingBlock();

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

//RS775_MotorMountHoles() Bolt8ButtonHeadHole();

module EncoderDisc(EncDisk_d=42, nEncPulses=30, Shaft_d=5, ShowLightPath=false){
	EncDisk_t=1.5;
	EncSlotLen=3.5;
	
	difference(){
		cylinder(d=EncDisk_d,h=EncDisk_t);
	
		
		
		for (j=[0:nEncPulses])
			hull(){
				rotate([0,0,360/nEncPulses*j+360/nEncPulses/4])
					translate([-EncDisk_d/2+3,0.0,EncDisk_t/2]) 
						cube([EncSlotLen,0.01,EncDisk_t+Overlap*2],center=true);
				
				rotate([0,0,360/nEncPulses*j-360/nEncPulses/4])
					translate([-EncDisk_d/2+3,-0.01,EncDisk_t/2]) 
						cube([EncSlotLen,0.01,EncDisk_t+Overlap*2],center=true);
			}
			
			// shaft
			translate([0,0,-Overlap]) cylinder(d=Shaft_d, h=EncDisk_t+Overlap*2);
			
			// Bolts
			for (j=[0:2]) rotate([0,0,120*j]) translate([10,0,EncDisk_t]) Bolt4ClearHole();
		} // diff
			
	// Encoder disc outer ring
	difference(){
		cylinder(d=EncDisk_d,h=EncDisk_t);
		translate([0,0,-Overlap])cylinder(d=EncDisk_d-EncDisk_t*2,h=EncDisk_t+Overlap*2);
	}
	
	// Light path
	if (ShowLightPath==true)
	rotate([0,0,0]){
			rotate([0,0,36-9])translate([18.0,0,-1])color("Blue")cylinder(d=0.3,h=3);
				translate([18.0,0,-1])color("Blue")cylinder(d=0.3,h=3);}
} // EncoderDisc

//projection()
//EncoderDisc(EncDisk_d=42, nEncPulses=30, Shaft_d=5, ShowLightPath=false);

//rotate([0,0,0]){
//			rotate([0,0,36-9])translate([18.0,0,0])color("Blue")cylinder(d=0.3,h=3);
//				translate([18.0,0,0])color("Blue")cylinder(d=0.3,h=3);}


module SunGear(){
	Hub_d=30;
	Shaft_d=5;
	EncDisk_d=Hub_d+12;
	
	nEncPulses=30; // 10 * 4 * 60 = 2400 counts, 30 = 7200
	SunGearHub_l=12;
	
	CompoundDrivePinionHelix(Pitch=PlanetaryPitchA, nTeeth=SunGear_t, Thickness=GearWidth, bEndScrew=0, HB=false,Hub_t=0,Hub_d=0);
	
	translate([0,0,-GearWidth-SunGearHub_l])
	difference(){
		union(){
			rotate([0,0,180/SunGear_t])EncoderDisc(EncDisk_d=EncDisk_d, nEncPulses=nEncPulses, Shaft_d=Shaft_d);
			cylinder(d=Hub_d-1,h=SunGearHub_l+Overlap);
			
			// make a smooth surface for the planets to run against
			hull(){
				translate([0,0,SunGearHub_l-1])cylinder(d=Hub_d,h=1+Overlap);
				translate([0,0,8])cylinder(d=Hub_d-1,h=0.01);
			} // hull
			
			
		} // union
		
		
		// motor shaft
		translate([0,0,-Overlap]) cylinder(d=Shaft_d,h=20);
		// Set screw
		translate([0,0,6]) rotate([90,0,0])  Bolt8Hole();
		
		// Motor bolt access
		rotate([0,0,180/SunGear_t])
		hull(){
			translate([14.2,0,-Overlap])cylinder(d=4.2,h=0.01);
			translate([17,0,SunGearHub_l+Overlap*2])cylinder(d=4.4,h=0.01);
		} // hull
		rotate([0,0,180/SunGear_t+180])
		hull(){
			translate([14.2,0,-Overlap])cylinder(d=4.2,h=0.01);
			translate([17,0,SunGearHub_l+Overlap*2])cylinder(d=4.4,h=0.01);
		} // hull
		
		
			
	} // diff
	
} // SunGear

//InputRingGear();
//rotate([180,0,0])
//SunGear();
/*
rotate([0,0,80])color("Red"){
rotate([0,0,36-9])
translate([17.5,0,GearWidth+11.5])rotate([0,-90,0])OPB490_Sensor();
translate([17.5,0,GearWidth+11.5])rotate([0,-90,0])OPB490_Sensor();}
*/

module SunGearCollet(){
	difference(){
		translate([0,0,-18]) cylinder(d=40,h=18-Overlap);
		
		scale(1.04)SunGear();
		translate([0,0,-18-Overlap]) {
			cylinder(d=10,h=20);
			cylinder(d=30+IDXtra,h=6);
		}
	} // diff
} // SunGearCollet

//rotate([180,0,0])SunGearCollet();

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
			
		for (j=[0:nPlanets-1]) rotate([0,0,360/nPlanets*j]) translate([PC_r,0,PC_t]) Bolt4ClearHole();
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
			
		for (j=[0:nPlanets-1]) rotate([0,0,360/nPlanets*j]) translate([PC_r,0,PC_t]) Bolt4ButtonHeadHole();
	} // diff
	
} // InnerPlanetCarrier

//InnerPlanetCarrier();

module ShowPlanets(CutAway=true,HideGears=true){
	PlanetShaft_l=24.5;
	PitchA=PlanetaryPitchA;
		PitchB=PlanetaryPitchB;
		Planet_BC=SunGear_t*PitchA/180 + PlanetA_t*PitchA/180;
		Ratio=OutputRing_t*PitchB/180/((InputRing_t*PitchA/180  / (PlanetA_t*PitchA/180) * (PlanetB_t*PitchB/180)-OutputRing_t*PitchB/180))*(InputRing_t/SunGear_t);
		
		SunGearRA=$t*Ratio*360;
		PlanetPosRA=SunGearRA/((InputRing_t/SunGear_t)+(InputRing_t/SunGear_t));//  29.7r /(InputRing_t/SunGear_t); // 2.57 4.5
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
		Planet_BC=SunGear_t*PitchA/180 + PlanetA_t*PitchA/180;
		Ratio=OutputRing_t*PitchB/180/((InputRing_t*PitchA/180  / (PlanetA_t*PitchA/180) * (PlanetB_t*PitchB/180)-OutputRing_t*PitchB/180))*(InputRing_t/SunGear_t);
		echo(Ratio=Ratio);
		SunGearRA=$t*Ratio*360;// 76.5r
		PlanetPosRA=SunGearRA/((InputRing_t/SunGear_t)+(InputRing_t/SunGear_t));//  29.7r /(InputRing_t/SunGear_t); // 2.57 4.5
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
			rotate([180,0,0])color("Black")SunGear();
			
			rotate([0,0,76+36-9])translate([18.0,0,GearWidth+11.0])OPB490N_Sensor();
			rotate([0,0,76])	translate([18.0,0,GearWidth+11.0])OPB490N_Sensor();

		}
		
		// drive ring
		translate([0,0,bead_h+3.1]) {
			
			color("Tan")DriveRingGear();
			translate([0,0,InnerSleve_l]) {
				translate([0,0,Race_w])color("Pink")ShowMyBalls();
				RW_OutsideRace(myFn=90);
				color("LightBlue")RW_InsideRace(myFn=90);
				translate([0,0,Race_w*2]) rotate([180,0,0]){
					RW_OutsideRace(myFn=90);
					color("LightBlue")RW_InsideRace(myFn=90);
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
	rotate([180,0,0])SunGear();
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
				//RW_OutsideRace(myFn=90);
				RW_InsideRace(myFn=90);
	//translate([0,0,Race_w])color("Pink")ShowMyBalls();
				translate([0,0,Race_w*2]) rotate([180,0,0]){
					//RW_OutsideRace(myFn=90);
					//RW_InsideRace(myFn=90);
				}}

/**/
//translate([0,0,bead_h+3.1]) DriveRingGear();
		
//HubCap();
//InnerRim();

WheelMount_l=25;
WheelMount_OD=bead_minD-17;
nMountingBolts=8;
MBoltInset=3.5;
	
	

module TubeConnector(){
	Tube_OD=25.4;
	
	difference(){
		union(){
			translate([WheelMount_OD/2-2,0,Tube_OD/2])
				rotate([0,90,0])TubeEnd(TubeOD=Tube_OD,Wall_t=0.84,Hole_d=14);
			
			translate([WheelMount_OD/2-4,0,Tube_OD/2])
				rotate([0,90,0])cylinder(d=Tube_OD,h=3);
			
			cylinder(d=WheelMount_OD,h=25);
		} // union
		
		// wire path
		translate([WheelMount_OD/2-8,0,Tube_OD/2])rotate([0,90,0]) cylinder(d=14,h=45);
		
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
				Bolt4HeadHole(lHead=2); //Bolt6HeadHole(lAccess=2);
		
	} // diff
} // TubeConnector

//TubeConnector();

module ChannelConnector(){
	
	
	difference(){
		union(){
		translate([WheelMount_OD/2-4,0,0])
				translate([0.75,0,1.41/2])ChannelMountingBlock();
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
				Bolt4HeadHole(lHead=2); //Bolt6HeadHole(lAccess=2);
		
	} // diff
} // ChannelConnector

//color("Red")RS775_DC_Motor();
//translate([0,0,WheelMount_l])ChannelConnector();

module MotorCover(){
	BackOfMotor=63;
	
	difference(){
		cylinder(d=Race_ID+1,h=BackOfMotor+6+2);
		
		// wires
		hull(){
			translate([0,0,BackOfMotor+2-10]) rotate([90,0,0])cylinder(d=10,h=Race_ID);
			translate([0,0,BackOfMotor+2+10]) rotate([90,0,0])cylinder(d=10,h=Race_ID);
		} // hull
		
		// inside
		translate([0,0,2])cylinder(d=Race_ID-2,h=BackOfMotor+6+Overlap);
		
		// Press fit and stop
		translate([0,0,BackOfMotor+2])
		difference(){
			cylinder(d=Race_ID+3,h=7);
			translate([0,0,-Overlap])cylinder(d=Race_ID,h=8);
		} // diff
	} // diff
	
} // MotorCover

//MotorCover();



module WheelMount(){
	
	difference(){
		cylinder(d=WheelMount_OD,h=6);
		
		translate([0,0,-Overlap])cylinder(d=Race_ID,h=6+Overlap*2);
		translate([0,0,6]) for (j=[0:nBeadBolts-1]) rotate([0,0,360/nBeadBolts*j]) translate([Race_ID/2+RaceBoltInset,0,0]) 
			Bolt4HeadHole();
	} // diff
	
	difference(){
		cylinder(d=WheelMount_OD,h=WheelMount_l);
		
		translate([0,0,-Overlap])cylinder(d=WheelMount_OD-MBoltInset*4,h=WheelMount_l+Overlap*2);
		
		// Mounting Bolts
		for (j=[0:nMountingBolts-1]) rotate([0,0,180/nMountingBolts*j+180/nMountingBolts/2-90]) 
			translate([WheelMount_OD/2-MBoltInset,0,WheelMount_l]) Bolt4Hole(); //Bolt6Hole();
		
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
			Bolt4ButtonHeadHole();
		rotate([0,0,Enc_a-30]) translate([EncDiskClear_d/2+12,0,-SM_Thickness]) rotate([180,0,0])
			Bolt4ButtonHeadHole();
		rotate([0,0,Enc_a+36-9+30]) translate([EncDiskClear_d/2+3,0,-SM_Thickness]) rotate([180,0,0])
			Bolt4ButtonHeadHole();
		rotate([0,0,Enc_a-30]) translate([EncDiskClear_d/2+3,0,-SM_Thickness]) rotate([180,0,0])
			Bolt4ButtonHeadHole();

		// clearance for WheelMount bolts
		for (j=[0:nBeadBolts-1]) rotate([0,0,360/nBeadBolts*j]) translate([Race_ID/2+RaceBoltInset,0,0]) 
			Bolt4Hole(depth=0.07);
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
		rotate([0,0,Enc_a+36-9+30]) translate([EncDiskClear_d/2+12,0,MotorPlate_t]) Bolt4Hole();
		rotate([0,0,Enc_a-30]) translate([EncDiskClear_d/2+12,0,MotorPlate_t]) Bolt4Hole();
		rotate([0,0,Enc_a+36-9+30]) translate([EncDiskClear_d/2+3,0,MotorPlate_t]) Bolt4Hole();
		rotate([0,0,Enc_a-30]) translate([EncDiskClear_d/2+3,0,MotorPlate_t]) Bolt4Hole();
		
		// test version only, doesn't fit in wheel mount
		//rotate([0,0,5])rotate([0,-90,0])Stepper17_BtnHoles(Thickness=MotorPlate_t/25.4);

		// encoder clearance scaled for a loose fit
		rotate([0,0,Enc_a+36-9]) translate([18.0,0,-1.5])scale(1.1)OPB490N_Sensor_Cutout();
		rotate([0,0,Enc_a]) translate([18.0,0,-1.5])scale(1.1)OPB490N_Sensor_Cutout();
		
		// Motor bolts
		translate([0,0,MotorPlate_t])RS775_MotorMountHoles()Bolt8ButtonHeadHole();
		
		for (j=[0:nBeadBolts-1]) rotate([0,0,360/nBeadBolts*j]) translate([Race_ID/2+RaceBoltInset,0,Race_w]) 
			Bolt4Hole();
	} // diff
} // InputRingGearMountingPlate

//InputRingGearMountingPlate();

module InputRingGear(){
	GearSlop=1;
	CompoundRingGearHelix(Pitch=PlanetaryPitchA, nTeeth=InputRing_t, Thickness=GearWidth+GearSlop+Overlap, twist=-twist, HB=false);
	
	translate([0,0,MotorInset]) InputRingGearMountingPlate();
	
	// skirt
	translate([0,0,GearWidth+GearSlop]) difference(){
		Skirt_h=MotorInset-(GearWidth+GearSlop)+MotorPlate_t;
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
	SkirtThickness=2;
	Nut_l=8;
	GearEndClearance=0.4; // just a little extra so the two ring gears don't press on each other
	
	difference(){
		union(){
			CompoundRingGearHelix(Pitch=PlanetaryPitchB, nTeeth=OutputRing_t, Thickness=GearWidth-GearEndClearance, twist=twist, HB=false);
			
			for (j=[0:nBeadBolts-1]) rotate([0,0,360/nBeadBolts*j]) translate([bead_minD/2-3,0,0]) 
				cylinder(d=7.5,h=GearWidth-GearEndClearance);
		} // union
		
		for (j=[0:nBeadBolts-1]) rotate([0,0,360/nBeadBolts*j]) translate([bead_minD/2-3,0,0]) 
			rotate([180,0,0]) Bolt4Hole();
	} // diff
	
	
	difference(){
		cylinder(d=bead_minD+SkirtThickness*2,h=InnerSleve_l);	
			
		// ID
		translate([0,0,-Overlap])cylinder(d=bead_minD,h=InnerSleve_l+Overlap*2);
		
		// outer race bolts
		for (j=[0:nBeadBolts-1]) rotate([0,0,360/nBeadBolts*j]) translate([Race_OD/2-RaceBoltInset,0,InnerSleve_l]) 
			Bolt4Hole(depth=0.35);
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
			Bolt4Hole(depth=0.35);
	} // diff
} // DriveRingGear

//DriveRingGear();

/*
DriveRingGear();
translate([0,0,InnerSleve_l]) RW_OutsideRace(myFn=90);
translate([0,0,InnerSleve_l+Race_w*2]) rotate([180,0,0])RW_OutsideRace(myFn=90);

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

module RW_InsideRace(myFn=360){
	
	difference(){
		InsideRace(BallCircle_d=BallCircle_d, Race_ID=Race_ID, Ball_d=Ball_d, Race_w=Race_w, nBolts=nBeadBolts, myFn=myFn)
			Bolt4ClearHole();
		
		// wire path
		for (j=[0:nBeadBolts-1]) rotate([0,0,360/nBeadBolts*(j+0.5)]) translate([Race_ID/2-5,0,-Overlap]) 
			cylinder(d=15,h=Race_w+Overlap*2);
		
	} // diff
} // RW_InsideRace

//RW_InsideRace(myFn=90);

module RW_OutsideRace(myFn=360){
		
	OutsideRace(BallCircle_d=BallCircle_d,Race_OD=Race_OD,Ball_d=Ball_d,Race_w=Race_w,nBolts=nBeadBolts,RaceBoltInset=BL_RaceBoltInset,myFn=myFn) Bolt4ClearHole();
		
} // RW_OutsideRace

//RW_OutsideRace(myFn=90);
3D_Tire_id=180;

module Spoke(){
	// print nBeadBolts to mount 3d printed tire
	// Spokes go in place of AdapterRing, InnerRim and OuterRim
	
	SpokeThickness=8;
	SpokeWidth=4;
	
	difference(){
		cylinder(d=Race_OD,h=SpokeThickness);
		
		translate([0,0,-Overlap]) cylinder(d=Race_OD-RaceBoltInset*4,h=SpokeThickness+Overlap*2);
		
		for (j=[0:nBeadBolts-1]) rotate([0,0,360/nBeadBolts*j]) translate([Race_OD/2-RaceBoltInset,0,SpokeThickness]) 
			Bolt4HeadHole();
		
		// pie slice
		difference(){
			translate([0,0,-Overlap])cylinder(d=Race_OD+Overlap*2,h=SpokeThickness+Overlap*2);
			
			translate([0,0,-Overlap*2])
			hull(){
				rotate([0,0,180/nBeadBolts]) cube([Race_OD,Overlap,SpokeThickness+Overlap*4]);
				rotate([0,0,-180/nBeadBolts]) cube([Race_OD,Overlap,SpokeThickness+Overlap*4]);
			} // hull
		} // diff
	} // diff
	
	difference(){
		translate([Race_OD/2-RaceBoltInset,-SpokeWidth/2,0])
			rotate([0,0,20])cube([3D_Tire_id/2-Race_OD/2,SpokeWidth,SpokeThickness]);
	
		translate([0,0,-Overlap]) cylinder(d=Race_OD-Overlap,h=SpokeThickness+Overlap*2);
		
		difference(){
			translate([0,0,-Overlap])cylinder(d=3D_Tire_id,h=SpokeThickness+Overlap*2);
			translate([0,0,-Overlap*2])cylinder(d=3D_Tire_id-RaceBoltInset*4+Overlap*2,h=SpokeThickness+Overlap*4);
		} // diff
	} // diff
	
	//*
	rotate([0,0,9])
	difference(){
		cylinder(d=3D_Tire_id,h=SpokeThickness);
		
		translate([0,0,-Overlap]) cylinder(d=3D_Tire_id-RaceBoltInset*4,h=SpokeThickness+Overlap*2);
		
		for (j=[0:nBeadBolts-1]) rotate([0,0,360/nBeadBolts*j]) translate([3D_Tire_id/2-RaceBoltInset,0,SpokeThickness]) 
			Bolt4HeadHole();
		
		// pie slice
		difference(){
			translate([0,0,-Overlap])cylinder(d=3D_Tire_id+Overlap*2,h=SpokeThickness+Overlap*2);
			
			translate([0,0,-Overlap*2])
			hull(){
				rotate([0,0,5]) cube([3D_Tire_id,Overlap,SpokeThickness+Overlap*4]);
				rotate([0,0,-5]) cube([3D_Tire_id,Overlap,SpokeThickness+Overlap*4]);
			} // hull
		} // diff
	} // diff
	/**/
} // Spoke

//Spoke();

module AdapterRing(){
	// Required for traxis tire
	difference(){
		cylinder(d1=Race_OD,d2=bead_d+bead_t*2,h=Ada_h);
		
		translate([0,0,-Overlap]) cylinder(d=bead_minD-12,h=10+Overlap*2);
		
		for (j=[0:nBeadBolts-1]) rotate([0,0,360/nBeadBolts*j]) translate([Race_OD/2-RaceBoltInset,0,6]) 
			Bolt4HeadHole();
		
		for (j=[0:nBeadBolts-1]) rotate([0,0,360/nBeadBolts*(j+0.5)]) translate([bead_minD/2-3,0,Ada_h]) 
			Bolt4Hole();
	} // diff
} // AdapterRing

module InnerRim(){
	// Required for traxis tire
	difference(){
		cylinder(d=bead_d+bead_t*2,h=bead_h+3);
		
		translate([0,0,-Overlap]) cylinder(d=bead_d+1+bead_t*2, h=2);
		
		translate([0,0,-Overlap]) cylinder(d1=bead_d-2+bead_t*2, d2=bead_minD+bead_t*2, h=bead_h);
		
		cylinder(d=bead_minD-12, h=bead_h+4);
		
		
		for (j=[0:nBeadBolts-1]) rotate([0,0,360/nBeadBolts*j]) translate([bead_minD/2-3,0,0]) 
			rotate([180,0,0]) Bolt4ClearHole();
	} // diff
	
	
} // InnerRim

//InnerRim();

module OuterRim(){
	// Required for traxis tire
	difference(){
		union(){
			cylinder(d=bead_d,h=1);
			translate([0,0,1]) cylinder(d1=bead_d-2, d2=bead_minD, h=bead_h);
			
		} // union
		
		translate([0,0,-Overlap]) cylinder(d=bead_minD-13, h=1+bead_h+Overlap*2);
		
		for (j=[0:nBeadBolts-1]) rotate([0,0,360/nBeadBolts*j]) translate([bead_minD/2-3,0,bead_h-6]) 
			rotate([180,0,0]) Bolt4HeadHole();
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










