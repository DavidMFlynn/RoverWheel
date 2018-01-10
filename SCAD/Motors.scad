// ******************************************************
// Author: David M. Flynn
// Project: 3D Printer
// filename: Motors.scad
// Rev: 1.1.1 1/9/2018
// Units: Inches
// *******************************************************
// History:
//  1.1.1 1/9/2018 Changed Stepper17_Holes(Thickness=0.5);
//  1.1 9/29/2016 Converted to a more generic form
//  1.0 8/21/2016 changes hight of Stepper17_ZBracket, also makes it easier to print
//
// *******************************************************
//StepperKL23Mount(MountThickness=0.375, BoltHole_d=KL23_BoltHole_d);
//StepperKL23H256Bolts();
//SepperKL23H256();
//Stepper17_Holes(Thickness=0.5);
//Stepper17_BtnHoles(Thickness=0.2);
//SepperKL17();
//MototMountRound(Diameter=2.625, Thickness=0.2);
//Stepper17_YBracket(YSB_CL=0.5);
//Stepper17_XBracket(XSB_CL=0.5);
//Stepper17_X_MountHoles_2d(rHole=Bolt8_r);
//Stepper17_X_MountHoles(rHole=Bolt8_r, Depth=RB_Foot_t);
//Stepper17_ZBracket();


//MotorMount(); // NEMA 23
//

$fn=90;
include <CommonStuffSAE.scad>
//include <RailsAndBrackets.scad>


// NEMA 17 motor
	KL17_BoltHole_d=0.120;
	KL17_BoltSpace=1.213;
	KL17_Frame=1.66;
	KL17_Boss_d=0.865;
	KL17_Boss_h=0.080;
	KL17_Frame_l=1.850;
	KL17_Frame_r=0.220;
	KL17_Mount_l=0.250;
	KL17_Shaft_d=0.195;
	KL17_Shaft1_l=0.99;
	KL17_Shaft2_l=0;
	
// NEMA 23 motor
	KL23_BoltHole_d=0.196;
	KL23_BoltSpace=1.856;
	KL23_Frame=2.22;
	KL23_Boss_d=1.5;
	KL23_Boss_h=0.063;
	KL23_Frame_l=2.204;
	KL23_Frame_r=0.196;
	KL23_Mount_l=0.135;
	KL23_Shaft_d=0.25;
	KL23_Shaft1_l=0.75;
	KL23_Shaft2_l=0.59;
	
	
module StepperKL23Mount(MountThickness=0.375, BoltHole_d=KL23_BoltHole_d){
	difference(){
		hull(){
			for (J=[0:3]) rotate([0,0,J*90])
			translate([-KL23_Frame/2+KL23_Frame_r,-KL23_Frame/2+KL23_Frame_r,0]) cylinder(r=KL23_Frame_r, h=MountThickness);
		} // hull
		
		translate([0,0,-OverLap]) cylinder(r=KL23_Boss_d/2+OverLap, h=MountThickness+OverLap*2);
		
		// Bolt holes
		for (J=[0:3]) rotate([0,0,J*90])
			translate([KL23_BoltSpace/2,KL23_BoltSpace/2,0]) rotate([180,0,0]) Bolt8Hole(depth=BoltHole_d+OverLap*2);
		
	} // diff
} // StepperKL23Mount

//translate([0,T_SlotExtrusion_w/2,KL23_Frame/2+0.5]) rotate([-90,0,0]) StepperKL23Mount();

module StepperKL23H256Bolts(){
	for (J=[0:3]) rotate([0,0,J*90])
			translate([KL23_BoltSpace/2,KL23_BoltSpace/2,0]) Bolt8Hole();

} // StepperKL23H256Bolts

//StepperKL23H256Bolts();

module StepperKL23H256(){
	
	translate([0,0,-KL23_Boss_h]) cylinder(r=KL23_Boss_d/2, h=KL23_Boss_h);
	translate([0,0,-KL23_Boss_h-KL23_Shaft1_l]) cylinder(r=KL23_Shaft_d/2, h=KL23_Shaft1_l);
	translate([0,0,KL23_Frame_l]) cylinder(r=KL23_Shaft_d/2, h=KL23_Shaft2_l);
	
	difference(){
		hull(){
			for (J=[0:3]) rotate([0,0,J*90])
			translate([-KL23_Frame/2+KL23_Frame_r,-KL23_Frame/2+KL23_Frame_r,0]) cylinder(r=KL23_Frame_r, h=KL23_Mount_l);
		} // hull
		
			for (J=[0:3]) rotate([0,0,J*90])
			translate([KL23_BoltSpace/2,KL23_BoltSpace/2,-OverLap]) cylinder(r=KL23_BoltHole_d/2, h=KL23_Mount_l+OverLap*2);
		
	} // diff
	
	translate([0,0,KL23_Mount_l-OverLap])
	difference(){
		translate([-KL23_Frame/2,-KL23_Frame/2,0]) cube([KL23_Frame,KL23_Frame,KL23_Frame_l+OverLap*2]);
		
		for (J=[0:3]) rotate([0,0,J*90])
		hull(){
			translate([KL23_BoltSpace/2,KL23_BoltSpace/2,-OverLap]) cylinder(r=KL23_Frame_r, h=KL23_Frame_l+OverLap*4);
			translate([KL23_BoltSpace/2+KL23_Frame_r,KL23_BoltSpace/2,-OverLap]) cylinder(r=KL23_Frame_r, h=KL23_Frame_l+OverLap*4);
			translate([KL23_BoltSpace/2,KL23_BoltSpace/2+KL23_Frame_r,-OverLap]) cylinder(r=KL23_Frame_r, h=KL23_Frame_l+OverLap*4);
		}
		
	} // diff
} // StepperKL23H256

// color("Tan") SepperKL23H256();


module SepperKL17(){
	
	translate([0,0,-KL17_Boss_h]) cylinder(r=KL17_Boss_d/2, h=KL17_Boss_h);
	translate([0,0,-KL17_Boss_h-KL17_Shaft1_l]) cylinder(r=KL17_Shaft_d/2, h=KL17_Shaft1_l);
	translate([0,0,KL17_Frame_l]) cylinder(r=KL17_Shaft_d/2, h=KL17_Shaft2_l);
	
	difference(){
		hull(){
			for (J=[0:3]) rotate([0,0,J*90])
			translate([-KL17_Frame/2+KL17_Frame_r,-KL17_Frame/2+KL17_Frame_r,0]) cylinder(r=KL17_Frame_r, h=KL17_Mount_l);
		} // hull
		
			for (J=[0:3]) rotate([0,0,J*90])
			translate([KL17_BoltSpace/2,KL17_BoltSpace/2,-OverLap]) cylinder(r=KL17_BoltHole_d/2, h=KL17_Mount_l+OverLap*2);
		
	} // diff
	
	
	translate([0,0,KL17_Mount_l-OverLap])
	hull(){
			for (J=[0:3]) rotate([0,0,J*90])
			translate([-KL17_Frame/2+KL17_Frame_r,-KL17_Frame/2+KL17_Frame_r,0]) cylinder(r=KL17_Frame_r, h=KL17_Frame_l+OverLap*4);
		} // hull
		
		
} // SepperKL17

module Stepper17_Holes(Thickness=0.5){
				// motor boss
			translate([-OverLap,0,0])
				rotate([0,90,0]) cylinder(r=KL17_Boss_d/2+ID_Xtra, h=Thickness+OverLap*2);
	
		// motor bolts
		for (J=[0:3]) rotate([J*90,0,0])
			translate([0,KL17_BoltSpace/2,KL17_BoltSpace/2]) rotate([0,-90,0])
			Bolt4ClearHole();

} // Stepper17_Holes

//Stepper17_Holes();

module Stepper17_BtnHoles(Thickness=0.2){
				// motor boss
			translate([-OverLap,0,0])
				rotate([0,90,0]) cylinder(r=KL17_Boss_d/2+ID_Xtra, h=Thickness+OverLap*2);
	
		// motor bolts
		for (J=[0:3]) rotate([J*90,0,0])
			translate([0,KL17_BoltSpace/2,KL17_BoltSpace/2]) rotate([0,-90,0])
			Bolt4ButtonHeadHole();

} // Stepper17_Holes

//Stepper17_BtnHoles();

//Stepper17_BtnHoles();

module MototMountRound(Diameter=2.625, Thickness=0.2){
	difference(){
		cylinder(d=Diameter,h=Thickness);
		rotate([0,-90,0]) Stepper17_BtnHoles(Thickness=Thickness);
		
	} // diff
} // MototMountRound

//MototMountRound(Diameter=2.625, Thickness=0.2);

module Stepper17_YBracket(YSB_CL=0.5){
	Gussett_w=0.125;
	
	difference(){
		union(){
			// mounting feet
			translate([-T_SlotExtrusion_w+0.1,KL17_Frame/2+0.05,-YSB_CL])
				cube([T_SlotExtrusion_w+RB_Foot_t-0.1,RB_w,RB_Foot_t]);
			translate([-T_SlotExtrusion_w+0.1,-KL17_Frame/2-0.05-RB_w,-YSB_CL])
				cube([T_SlotExtrusion_w+RB_Foot_t-0.1,RB_w,RB_Foot_t]);
			
			// Face plate
			translate([0,-KL17_Frame/2-0.125,-KL17_Frame/2-0.05]) cube([RB_Foot_t,KL17_Frame+0.25,KL17_Frame+0.05]);
			
			// gusserts
			hull(){
				translate([0,-KL17_Frame/2-Gussett_w-0.05,-YSB_CL])
					cube([RB_Foot_t,Gussett_w,-YSB_CL+KL17_Frame+0.17]);
				translate([-T_SlotExtrusion_w+0.1,-KL17_Frame/2-0.05-Gussett_w,-YSB_CL])
					cube([0.1,Gussett_w,RB_Foot_t]);
			}
			hull(){
				translate([0,KL17_Frame/2+0.05,-YSB_CL]) cube([RB_Foot_t,Gussett_w,-YSB_CL+KL17_Frame+0.17]);
				translate([-T_SlotExtrusion_w+0.1,KL17_Frame/2+0.05,-YSB_CL]) cube([0.1,Gussett_w,RB_Foot_t]);
			}

		} // union
	
		
			// motor boss
			translate([-OverLap,0,0])
				rotate([0,90,0]) cylinder(r=KL17_Boss_d/2+ID_Xtra, h=RB_Foot_t+OverLap*2);
		
		// Foot rouning
		difference(){
			translate([-T_SlotExtrusion_w+0.1,KL17_Frame/2+0.05+RB_w-FootEnd_r,-YSB_CL+RB_Foot_t-FootEnd_r])
				cube([T_SlotExtrusion_w+RB_Foot_t-0.1+OverLap*2,FootEnd_r*2,FootEnd_r*2]);
			
			translate([-T_SlotExtrusion_w+0.1-OverLap*2,KL17_Frame/2+0.05+RB_w-FootEnd_r,-YSB_CL+RB_Foot_t-FootEnd_r])
				rotate([0,90,0]) cylinder(r=FootEnd_r+OverLap, h=T_SlotExtrusion_w+0.1+OverLap*4);
		}
		
		mirror([0,1,0])
		difference(){
			translate([-T_SlotExtrusion_w+0.1,KL17_Frame/2+0.05+RB_w-FootEnd_r,-YSB_CL+RB_Foot_t-FootEnd_r])
				cube([T_SlotExtrusion_w+RB_Foot_t-0.1+OverLap*2,FootEnd_r*2,FootEnd_r*2]);
			
			translate([-T_SlotExtrusion_w+0.1-OverLap*2,KL17_Frame/2+0.05+RB_w-FootEnd_r,-YSB_CL+RB_Foot_t-FootEnd_r])
				rotate([0,90,0]) cylinder(r=FootEnd_r+OverLap, h=T_SlotExtrusion_w+0.1+OverLap*4);
		}
	
		// mounting Bolts
		translate([-T_SlotExtrusion_w/2,1.25,-YSB_CL+RB_Foot_t-OverLap])
			Bolt250ClearHole();
		translate([-T_SlotExtrusion_w/2,-1.25,-YSB_CL+RB_Foot_t-OverLap])
			Bolt250ClearHole();
		
		
		// motor bolts
		for (J=[0:3]) rotate([J*90,0,0])
			translate([0,KL17_BoltSpace/2,KL17_BoltSpace/2]) rotate([0,-90,0])
			Bolt4ButtonHeadHole();
	} // diff
} // Stepper17_YBracket

//Stepper17_YBracket();

//rotate([0,-90,0]) SepperKL17();

module Stepper17_XBracket(RB_Foot_t=0.25,LBCA_6_S_I=0.625,XSB_CL=0.5){
	Gussett_w=0.125;
	
	
	difference(){
		union(){
			// mounting feet
			translate([-LBCA_6_S_l+RB_Foot_t,KL17_Frame/2+0.05,-XSB_CL]) cube([LBCA_6_S_l,RB_w,RB_Foot_t]);
			translate([-LBCA_6_S_l+RB_Foot_t,-KL17_Frame/2-0.05-RB_w,-XSB_CL]) cube([LBCA_6_S_l,RB_w,RB_Foot_t]);
			
			// Face plate
			translate([0,-KL17_Frame/2-0.125,-KL17_Frame/2-0.05]) cube([RB_Foot_t,KL17_Frame+0.25,KL17_Frame+0.05]);
			
			// gusserts
			hull(){
				translate([0,-KL17_Frame/2-Gussett_w-0.05,-XSB_CL]) cube([RB_Foot_t,Gussett_w,-XSB_CL+KL17_Frame+0.17]);
				translate([-LBCA_6_S_l+RB_Foot_t,-KL17_Frame/2-0.05-Gussett_w,-XSB_CL]) cube([0.1,Gussett_w,RB_Foot_t]);
			}
			hull(){
				translate([0,KL17_Frame/2+0.05,-XSB_CL]) cube([RB_Foot_t,Gussett_w,-XSB_CL+KL17_Frame+0.17]);
				translate([-LBCA_6_S_l+RB_Foot_t,KL17_Frame/2+0.05,-XSB_CL]) cube([0.1,Gussett_w,RB_Foot_t]);
			}

		} // union
	
		
			// motor boss
			translate([-OverLap,0,0])
				rotate([0,90,0]) cylinder(r=KL17_Boss_d/2+ID_Xtra, h=RB_Foot_t+OverLap*2);
		
		
		difference(){
			translate([LBCA_6_S_l/2-LBCA_6_S_l+RB_Foot_t,KL17_Frame/2+0.05+RB_w,-XSB_CL+RB_Foot_t])
				cube([LBCA_6_S_l+OverLap*2,FootEnd_r*2,FootEnd_r*2],center=true);
			
			translate([-LBCA_6_S_l+RB_Foot_t,KL17_Frame/2+0.05+RB_w-FootEnd_r,-XSB_CL+RB_Foot_t-FootEnd_r])
				rotate([0,90,0]) cylinder(r=FootEnd_r+OverLap, h=LBCA_6_S_l+OverLap*2);
		}
		
		mirror([0,1,0])
		difference(){
			translate([LBCA_6_S_l/2-LBCA_6_S_l+RB_Foot_t,KL17_Frame/2+0.05+RB_w,-XSB_CL+RB_Foot_t])
				cube([LBCA_6_S_l+OverLap*2,FootEnd_r*2,FootEnd_r*2],center=true);
			
			translate([-LBCA_6_S_l+RB_Foot_t,KL17_Frame/2+0.05+RB_w-FootEnd_r,-XSB_CL+RB_Foot_t-FootEnd_r])
				rotate([0,90,0]) cylinder(r=FootEnd_r+OverLap, h=LBCA_6_S_l+OverLap*2);
		}
	
		// mounting Bolts
		
		translate([0,0,-XSB_CL])
		Stepper17_X_MountHoles(Bolt8_Clear_r,RB_Foot_t);
		
		// motor bolts
		for (J=[0:3]) rotate([J*90,0,0])
			translate([-OverLap,KL17_BoltSpace/2,KL17_BoltSpace/2]) rotate([0,90,0])
			cylinder(r=KL17_BoltHole_d/2+ID_Xtra, h=KL17_Mount_l+OverLap*2);
	} // diff
} // Stepper17_XBracket

//Stepper17_XBracket();


module Stepper17_X_MountHoles_2d(rHole=Bolt8_r){
	translate([-0.2+RB_Foot_t,1.25,0]) circle(r=rHole);
	translate([-0.2+RB_Foot_t,-1.25,0]) circle(r=rHole);
	translate([-LBCA_6_S_l+0.2+RB_Foot_t,1.25,0]) circle(r=rHole);
	translate([-LBCA_6_S_l+0.2+RB_Foot_t,-1.25,0]) circle(r=rHole);
} // Stepper17_X_MountHoles_2d

module Stepper17_X_MountHoles(rHole=Bolt8_r, Depth=RB_Foot_t){
	translate([-LBCA_6_S_l/2+LBCA_6_S_l/2-0.2+RB_Foot_t,1.25,-OverLap]) 
		cylinder(r=rHole,h=Depth+OverLap*2);
	translate([-LBCA_6_S_l/2+LBCA_6_S_l/2-0.2+RB_Foot_t,-1.25,-OverLap]) 
		cylinder(r=rHole,h=Depth+OverLap*2);
	translate([-LBCA_6_S_l/2-LBCA_6_S_l/2+0.2+RB_Foot_t,1.25,-OverLap]) 
		cylinder(r=rHole,h=Depth+OverLap*2);
	translate([-LBCA_6_S_l/2-LBCA_6_S_l/2+0.2+RB_Foot_t,-1.25,-OverLap]) 
		cylinder(r=rHole,h=Depth+OverLap*2);
} // Stepper17_X_MountHoles


module Stepper17_ZBracket(RB_Foot_t=0.25,FootEnd_r=0.2,RB_w=0.825,Bolt_d=0.25){
	MountPlate_h=RB_w/2;
	
	difference(){
		union(){
			translate([1-RB_Foot_t,KL17_Frame/2+0.05,-RB_w/2]) cube([RB_Foot_t,0.75,RB_w]);
			translate([1-RB_Foot_t,-KL17_Frame/2-0.05-0.75,-RB_w/2]) cube([RB_Foot_t,0.75,RB_w]);
			translate([-KL17_Frame/2,-KL17_Frame/2-0.125,MountPlate_h-RB_Foot_t]) cube([KL17_Frame/2+1,KL17_Frame+0.25,RB_Foot_t]);
			hull(){
				translate([1-RB_Foot_t,KL17_Frame/2+0.05,-RB_w/2]) cube([0.05,0.1,RB_w]);
				translate([-KL17_Frame/2,KL17_Frame/2+0.05,MountPlate_h-RB_Foot_t]) cube([0.1,0.1,RB_Foot_t]);
			} // hull
			hull(){
				translate([1-RB_Foot_t,-KL17_Frame/2-0.05-0.1,-RB_w/2]) cube([0.05,0.1,RB_w]);
				translate([-KL17_Frame/2,-KL17_Frame/2-0.05-0.1,MountPlate_h-RB_Foot_t]) cube([0.1,0.1,RB_Foot_t]);
			} // hull
		} // union
	
		// rounded foot
		difference(){
			translate([1-RB_Foot_t,KL17_Frame/2+0.05+0.75,0])
				cube([FootEnd_r*2,FootEnd_r*2,RB_w+OverLap*2],center=true);
			
			translate([1-RB_Foot_t+FootEnd_r,KL17_Frame/2+0.05+0.75-FootEnd_r,-RB_w/2-OverLap])
				cylinder(r=FootEnd_r+OverLap, h=RB_w+OverLap*2);
		}
		
		// rounded foot
		mirror([0,1,0])
		difference(){
			translate([1-RB_Foot_t,KL17_Frame/2+0.05+0.75,0])
				cube([FootEnd_r*2,FootEnd_r*2,RB_w+OverLap*2],center=true);
			
			translate([1-RB_Foot_t+FootEnd_r,KL17_Frame/2+0.05+0.75-FootEnd_r,-RB_w/2-OverLap])
				cylinder(r=FootEnd_r+OverLap, h=RB_w+OverLap*2);
		}
		
		// motor boss hole
		translate([0,0,MountPlate_h-RB_Foot_t-OverLap]) cylinder(r=KL17_Boss_d/2+ID_Xtra, h=RB_Foot_t+OverLap*2);
		// T-Slot Bolt
		translate([1-RB_Foot_t-OverLap,1.25,0]) rotate([-90,0,0])
			rotate([0,90,0]) cylinder(d=Bolt_d,h=RB_Foot_t+OverLap*2);
		translate([1-RB_Foot_t-OverLap,-1.25,0]) rotate([-90,0,0])
			rotate([0,90,0]) cylinder(d=Bolt_d,h=RB_Foot_t+OverLap*2);
		
		for (J=[0:3]) rotate([0,0,J*90])
			translate([KL17_BoltSpace/2,KL17_BoltSpace/2,MountPlate_h-RB_Foot_t-OverLap]) 
			cylinder(r=KL17_BoltHole_d/2+ID_Xtra, h=KL17_Mount_l+OverLap*2);
	} // diff
} // Stepper17_ZBracket

//Stepper17_ZBracket();

module MotorMount(T_SlotExtrusion_w=1,RB_Foot_t=0.25,Bolt_d=0.25){
	MotorZOffset=T_SlotExtrusion_w+0.5;
	MotorPlate_t=0.375;
	
	difference(){
		translate([-(KL23_Frame+T_SlotExtrusion_w)/2,-T_SlotExtrusion_w/2,T_SlotExtrusion_w])
		cube([KL23_Frame+T_SlotExtrusion_w,T_SlotExtrusion_w,RB_Foot_t]);
		
		// Bolt holes
		translate([-(KL23_Frame+T_SlotExtrusion_w)/2,-T_SlotExtrusion_w/2,T_SlotExtrusion_w]){
		translate([T_SlotExtrusion_w/4,T_SlotExtrusion_w/2,-OverLap]) cylinder(r=Bolt_d/2,h=RB_Foot_t+OverLap*2);
		translate([KL23_Frame+T_SlotExtrusion_w-T_SlotExtrusion_w/4,T_SlotExtrusion_w/2,-OverLap])
			cylinder(r=Bolt_d/2,h=RB_Foot_t+OverLap*2);}
			
			translate([0,0,MotorZOffset]) rotate([-90,0,0]){
			translate([0,0,-1.1]) cylinder(r=KL23_Boss_d/2, h=2);}
	} // diff
	
	
	difference(){
		translate([-(KL23_Frame+T_SlotExtrusion_w)/2,T_SlotExtrusion_w/2,0])
		cube([KL23_Frame+T_SlotExtrusion_w,MotorPlate_t,T_SlotExtrusion_w+RB_Foot_t]);
		
		// Bolt holes
		translate([-(KL23_Frame+T_SlotExtrusion_w)/2,T_SlotExtrusion_w/2,0]){
		translate([T_SlotExtrusion_w/4,-OverLap,T_SlotExtrusion_w/2]) rotate([-90,0,0]) cylinder(r=Bolt_d/2,h=MotorPlate_t+OverLap*2);
		translate([KL23_Frame+T_SlotExtrusion_w-T_SlotExtrusion_w/4,-OverLap,T_SlotExtrusion_w/2])
			rotate([-90,0,0]) cylinder(r=Bolt_d/2,h=MotorPlate_t+OverLap*2);}
		
				// Stepper Bolt holes
		translate([0,0,MotorZOffset]) rotate([-90,0,0]){
			translate([0,0,-1.1]) cylinder(r=KL23_Boss_d/2, h=2);
		for (J=[0:3]) rotate([0,0,J*90])
			translate([KL23_BoltSpace/2,KL23_BoltSpace/2,-OverLap]) cylinder(r=KL23_BoltHole_d/2, h=1);}

	} // diff
	
	translate([0,T_SlotExtrusion_w/2,MotorZOffset]) rotate([-90,0,0]) StepperKL23Mount(MotorPlate_t);
	
} // YMotorMount

//MotorMount();

