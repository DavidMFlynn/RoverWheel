
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

Tire_w=90;
Tire_d=170;
3D_Tire_id=Tire_d-6;
nTreads=40;
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

//OnePartWheel();

module Rim(){
difference(){
	union(){
		scale([3,1,1]) sphere(d=Tire_d,$fn=360);
		
		//linear_extrude(1) scale([3,1]) circle(d=Tire_d+2);
	} // union
	
	scale([3,1,1]) sphere(d=Tire_d-4,$fn=360);
	
	translate([Tire_w/2,-100,-100]) cube([300,200,200]);
	mirror([1,0,0])translate([Tire_w/2,-100,-100]) cube([300,200,200]);
} // diff


//*
Tread_i=Tire_w/8;
Tread_a=2;

	for (j=[0:nTreads-1]) rotate([360/nTreads*j,0,0]){
		hull(){
			//rotate([-Tread_a,0,0])
			translate([-Tread_i,0,Tire_d/2-1]) cylinder(d1=4,d2=2,h=Tread_h);
			//rotate([Tread_a,0,0])
			translate([Tread_i,0,Tire_d/2-1]) cylinder(d1=4,d2=2,h=Tread_h);
		} // hull
		hull(){
			rotate([-Tread_a,0,0])translate([Tread_i*2.5,0,Tire_d/2-1.5]) cylinder(d1=4,d2=2,h=Tread_h);
			//rotate([Tread_a,0,0])
			translate([Tread_i,0,Tire_d/2-1]) cylinder(d1=4,d2=2,h=Tread_h);
		} // hull
		hull(){
			rotate([-Tread_a,0,0])translate([Tread_i*2.5,0,Tire_d/2-1.5]) cylinder(d1=4,d2=2,h=Tread_h);
			rotate([Tread_a,0,0])translate([Tread_i*4-3,0,Tire_d/2-2.5]) cylinder(d1=4,d2=2,h=Tread_h);
		} // hull
		hull(){
			rotate([Tread_a,0,0])translate([-Tread_i*2.5,0,Tire_d/2-2]) cylinder(d1=4,d2=2,h=Tread_h);
			//rotate([-Tread_a,0,0])
			translate([-Tread_i,0,Tire_d/2-1]) cylinder(d1=4,d2=2,h=Tread_h);
		} // hull
		hull(){
			rotate([Tread_a,0,0])translate([-Tread_i*2.5,0,Tire_d/2-2]) cylinder(d1=4,d2=2,h=Tread_h);
			rotate([-Tread_a,0,0])translate([-Tread_i*4+3,0,Tire_d/2-2.5]) cylinder(d1=4,d2=2,h=Tread_h);
		} // hull
	} // for
	/**/
	
	rotate([0,-90,0]){
	SpokeSpace=58;
	translate([0,0,SpokeSpace/2])for (j=[0:7]) rotate([0,0,45*j]) Hub_Att();
	translate([0,0,-SpokeSpace/2])rotate([180,0,0])for (j=[0:7]) rotate([0,0,45*j+22.5]) Hub_Att();
	}

} // Rim

//rotate([0,90,0])Rim();

module Hub_Att(){
	TireThickness=1.5;
	
	CutExtra=20;
	RimBoltInset=4;
	RimConnector_w=RimBoltInset*2;
	Size_z=3;
	nTreads=8;
	ChevBase=3.8;
	ChevTop=1.5;
	Chev_h=TireThickness;
	Rim_Conn_a=360/((3D_Tire_id-RimBoltInset*2)*3.14159/(RimBoltInset*4));
	SpokeOffset=0;
	
	// hub attachment
	translate([0,0,SpokeOffset-Size_z]) 
	difference(){
			hull(){
				rotate([0,0,Rim_Conn_a/2]) translate([0,3D_Tire_id/2-RimConnector_w/2,0]) cube([0.01,RimConnector_w/2+2,Size_z]);
				rotate([0,0,Rim_Conn_a/4]) translate([0,3D_Tire_id/2-RimConnector_w/2,0]) cylinder(d=RimConnector_w+Overlap,h=Size_z);
				rotate([0,0,-Rim_Conn_a/4]) translate([0,3D_Tire_id/2-RimConnector_w/2,0]) cylinder(d=RimConnector_w+Overlap,h=Size_z);
				rotate([0,0,-Rim_Conn_a/2]) translate([0,3D_Tire_id/2-RimConnector_w/2,0]) cube([0.01,RimConnector_w/2+2,Size_z]);
				
				translate([-RimConnector_w/2,3D_Tire_id/2,-RimConnector_w]) cube([RimConnector_w,2,0.01]);
			} // hull
		
		
		// trim outside
		difference(){
			translate([0,0,-RimConnector_w-Overlap]) cylinder(d=3D_Tire_id+10,h=RimConnector_w+Size_z+Overlap*2);
			translate([0,0,-RimConnector_w-Overlap*2]) cylinder(d=3D_Tire_id+2,h=RimConnector_w+Size_z+Overlap*4);
		}
		
		// inside hole
		translate([0,0,-Overlap])cylinder(d=3D_Tire_id-RimConnector_w*2,h=Size_z+Overlap*2);
		
		// bolt
		rotate([0,0,Rim_Conn_a/4])translate([0,3D_Tire_id/2-RimBoltInset,Size_z]) Bolt4Hole();
		rotate([0,0,-Rim_Conn_a/4])translate([0,3D_Tire_id/2-RimBoltInset,Size_z]) Bolt4Hole();
	} // diff

} // Hub_Att

//Hub_Att();

module Spoke(){
	// print nBeadBolts * 2 to mount 3d printed tire
	Size_x=3;
	Size_z=3;
	
	bead_d=97.8; // 3.8"
	bead_t=1.4;
	bead_minD=94; // 3.46"
	
	Rim_a=9.7;
	Connector_a=12;
	RimBoltInset=4;
	RimConnector_w=RimBoltInset*2;
	Rim_Conn_a=360/((3D_Tire_id-RimBoltInset*2)*3.14159/(RimBoltInset*4));
	
	Hub_ID=bead_minD-12;
	Hub_OD=bead_d+bead_t*2;
	
	
	// hub connector
	difference(){
		hull(){
			rotate([0,0,Connector_a/2]) translate([0,Hub_ID/2,0]) cube([0.01,(Hub_OD-Hub_ID)/2+2,Size_z]);
			rotate([0,0,-Connector_a/2]) translate([0,Hub_ID/2,0]) cube([0.01,(Hub_OD-Hub_ID)/2+2,Size_z]);
		} // hull
		
		// trim outside
		difference(){
			translate([0,0,-Overlap]) cylinder(d=Hub_OD+10,h=Size_z+Overlap*2);
			translate([0,0,-Overlap*2]) cylinder(d=Hub_OD+Overlap*2,h=Size_z+Overlap*4);
		}
		
		// inside hole
		translate([0,0,-Overlap])cylinder(d=Hub_ID,h=Size_z+Overlap*2);
		
		// bolt
		translate([0,bead_minD/2-3,Size_z]) Bolt4ClearHole();
	} // diff
	
	
	// tire connector
	rotate([0,0,Rim_a])
	difference(){
		hull(){
			rotate([0,0,Rim_Conn_a/2]) translate([0,3D_Tire_id/2-RimConnector_w/2,0]) cube([0.01,RimConnector_w/2+2,Size_z]);
			rotate([0,0,Rim_Conn_a/4]) translate([0,3D_Tire_id/2-RimConnector_w/2,0]) cylinder(d=RimConnector_w+Overlap,h=Size_z);
			rotate([0,0,-Rim_Conn_a/2]) translate([0,3D_Tire_id/2-RimConnector_w/2,0]) cube([0.01,RimConnector_w/2+2,Size_z]);
			rotate([0,0,-Rim_Conn_a/4]) translate([0,3D_Tire_id/2-RimConnector_w/2,0]) cylinder(d=RimConnector_w+Overlap,h=Size_z);
		} // hull
		
		// trim outside
		difference(){
			translate([0,0,-Overlap]) cylinder(d=3D_Tire_id+10,h=Size_z+Overlap*2);
			translate([0,0,-Overlap*2]) cylinder(d=3D_Tire_id+Overlap*2,h=Size_z+Overlap*4);
		}
		
		// inside hole
		translate([0,0,-Overlap])cylinder(d=3D_Tire_id-RimConnector_w*2,h=Size_z+Overlap*2);
		
		// bolt
		rotate([0,0,Rim_Conn_a/4])translate([0,3D_Tire_id/2-RimBoltInset,Size_z]) Bolt4ClearHole();
		rotate([0,0,-Rim_Conn_a/4])translate([0,3D_Tire_id/2-RimBoltInset,Size_z]) Bolt4ClearHole();
	} // diff
	
	
	// spoke
	Radius=(3D_Tire_id/2-RimConnector_w-Hub_OD/2)/1.50;  // for 180mm 16.5;
	
	
	translate([-Radius,Hub_OD/2,0]) 
		rotate_extrude(angle=45+Rim_a) translate([Radius-Size_x/2,0]) square([Size_x,Size_z]);
	
	rotate([0,0,Rim_a])
	translate([Radius,3D_Tire_id/2-RimConnector_w,0]) rotate([0,0,180]) 
		rotate_extrude(angle=45) translate([Radius-Size_x/2,0]) square([Size_x,Size_z]);
	
} // Spoke

//Spoke();

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

//MotorHub();

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



