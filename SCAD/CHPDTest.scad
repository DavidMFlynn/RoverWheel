// *********************************************
// Compound planetary drive test

include <CompoundHelicalPlanetary.scad>
include <CommonStuffSAE.scad>
include <ArmatronShoulder.scad>

PitchA=280;
PitchB=308;
P_t=12;
PA_t=21;
PA_w=12;
PB_t=21;
PB_w=12;
RI_t=PA_t*2 + P_t; 
RO_t=(PA_t*PitchA/180 + PB_t*PitchB/180 + P_t*PitchA/180)*180/PitchB; 

module SpacerRing(SpacerThickness=37){
	
	difference(){
		cylinder(d=Coupler_r*2,h=SpacerThickness,$fn=360);
		
		translate([0,0,-Overlap]) cylinder(d=Coupler_r*2-12,h=SpacerThickness+Overlap*2);
		
		for (j=[0:CouplerBolts-1]) rotate([0,0,360/CouplerBolts*j]){
			translate([Coupler_r-3,0,SpacerThickness]) BoltHole();
			translate([Coupler_r-3,0,0]) rotate([180,0,0])BoltHole();
		}
	} // diff
} // SpacerRing

//SpacerRing();

module MotorPlateInputRing(){
	BackingPlate_t=6;
	difference(){
		cylinder(r=Coupler_r,h=BackingPlate_t+PA_w);
	
		translate([0,0,BackingPlate_t])scale(25.4)Size17StepperBolts() Bolt4ButtonHeadHole();
		translate([0,0,-Overlap]) cylinder(d=22+IDXtra,h=BackingPlate_t+Overlap*2);
		
		// Gear goes here
		translate([0,0,BackingPlate_t]) cylinder(d=90,h=PA_w+Overlap);
		
		// Ring bolts
		for (j=[0:CouplerBolts-1]) rotate([0,0,360/CouplerBolts*j])
				translate([Coupler_r-3,0,BackingPlate_t]) scale(25.4)Bolt4HeadHole(lDepth=0.3,lHead=1.5);
	} // diff
		
	// spacer
	//translate([0,0,BackingPlate_t-Overlap]) difference(){
	//	rotate([0,0,0.4])CompoundRingGearHelix(Pitch=PitchA, nTeeth=RI_t, Thickness=PA_w, twist=-twist);
	//	translate([0,0,0.5+Overlap*2])cylinder(d=Coupler_r*2,h=PA_w);
	//} //diff
	
	// gear
	translate([0,0,BackingPlate_t])
		//CompoundRingGear(Pitch=PitchA, nTeeth=RI_t, Thickness=PA_w);
		CompoundRingGearHelix(Pitch=PitchA, nTeeth=RI_t, Thickness=PA_w, twist=-twist, HB=false);
}

//MotorPlateInputRing();

module DriveRingAndMount(){
	BackingPlate_t=8;
	nBolts=8;
	GearSpacer_h=22;
	

	difference(){
		cylinder(d=Coupler_r*2,h=GearSpacer_h+PB_w);
		
		// center hole
		translate([0,0,-Overlap]) cylinder(d=RO_t*PitchB/180+6,h=GearSpacer_h+PB_w+2+Overlap*2);
		translate([0,0,-Overlap]) cylinder(d=RO_t*PitchB/180+9,h=GearSpacer_h);
		
		//echo(RO_t*PitchB/180+9);
		// idle ring
		//translate([0,0,GearSpacer_h-PB_w-1]) cylinder(d=94+IDXtra*2,h=PB_w+1);
		
		// bolt holes
		for (j=[0:nBolts-1]) rotate([0,0,360/nBolts*j])
			translate([RingGearBC_r,0,BackingPlate_t]) BoltHeadHole(lAccessDepth=GearSpacer_h+PB_w+2);
	} // diff
	
	echo(RO_t=RO_t);
	
	translate([0,0,GearSpacer_h])
		// negative twist because it is drawn upside down.
		//CompoundRingGearHelix(Pitch=PitchB, nTeeth=RO_t, Thickness=PB_w, twist=-twist, HB=true);
	
		CompoundRingGearHelix(Pitch=PitchB, nTeeth=RO_t, Thickness=PB_w, twist=twist, HB=false);
	
} // DriveRingAndMount

//rotate([180,0,0])
//DriveRingAndMount();
















