// **************************************************
// The fifth degree of freedom, roll.
// David M. Flynn
// Filename: FifthDoF.scad
// Created: 6/26/2018
// Rev: 1.0d3 7/25/2018
// Units: millimeters
// **************************************************
// History:
// 1.0d3 7/25/2018 Changed BackLash=0.2; was 0.4, BearingPreload=0.4; was 0.2
// 1.0d2 7/5/2018 Added BearingPreload=0.2;
// 1.0d1 6/25/2018 First code.
// **************************************************
// Notes:
// Encoder shaft length 50mm long x 6.35mm dia + 8.5mm long x 6mm dia.
// **************************************************
// ***** for STL output *****
// OutputTubeBearing(myFn=360);
// OuterRacePart2(myFn=360);
// OutsideRace(BallCircle_d=Tube_BC, Race_OD=SmallRace_d, Ball_d=Ball_d, Race_w=5, nBolts=8, RaceBoltInset=RaceBoltInset, PreLoadAdj=BearingPreload, myFn=360) Bolt4ClearHole();
// rotate([180,0,0]) TheRing(SideMount=false, myFn=360);
// rotate([180,0,0]) TheRing(SideMount=true, myFn=360); // side mount version
// PlanetGear(Pitch=PlanetaryPitch, nTeeth=nPlanetTeeth, Thickness=GearWidth, SholderBolt=1);
// PinionPlate2();
// SunGear();
// rotate([180,0,0]) BasePlate();
// rotate([180,0,0]) DriveGear();
// **************************************************
// ***** for Viewing *****
ShowFifthDoF();
// **************************************************

include<SG90ServoLib.scad>
include<involute_gears.scad>
include<TubeConnectorLib.scad>
include<CommonStuffSAEmm.scad>
include<BearingLib.scad>
include<PlanetDriveLib.scad>

$fn=90;
IDXtra=0.2;
Overlap=0.05;

//Ball_d=9.525; // 0.375"
Ball_d=7.9375; // 0.3125"
RaceBoltInset=3.5;
Tube_d=19.05; // 3/4"
Tube_BC=Tube_d+6+Ball_d; // Ball Circle of bearings

PlanetaryPitch=260;
BackLash=0.2;
Pressure_a=24;
GearWidth=8;
DrivePlateXtra_d=10;
ShoulderBoltHeadClearance_d=9;
nPlanetTeeth=12;
nSunTeeth=12;
SmallRace_d=Tube_BC+Ball_d+2+RaceBoltInset*4;

ShoulderBolt_l=9.5;
LargeRace_d=63;
InnerRace_l=Ball_d*3+6;
RingGear_h=ShoulderBolt_l*2+5;
BearingPreload=0.4;

echo(Tube_BC=Tube_BC);
echo(SmallRace_d=SmallRace_d);

ServoOffset=9.39+17.34;
Servo_a=-55;

module CutAway(){
	rotate([0,0,-60]) translate([0,-100,-50]) cube([100,100,100]);
} // CutAway

module ShowMyBalls(BallCircle_d=BallCircle_d, nBalls=12){
	for (j=[0:nBalls-1]) rotate([0,0,360/nBalls*j]) translate([BallCircle_d/2,0,0]) sphere(d=Ball_d-Overlap*2);
} // ShowMyBalls

module ShowFifthDoF(){
	
	//*
	difference(){
		translate([0,0,Ball_d/2+6+Ball_d*2+5+Overlap*2])
			rotate([180,0,22.5])
				color("Brown") OutsideRace(BallCircle_d=Tube_BC, Race_OD=SmallRace_d, Ball_d=Ball_d, 
							Race_w=5, nBolts=8,RaceBoltInset=RaceBoltInset,PreLoadAdj=BearingPreload, myFn=90)
					Bolt4ClearHole();
		CutAway();
	} // diff
	/**/
	
	//*
	difference(){
		color("Tan") OutputTubeBearing();
		CutAway();
	} // diff
	/**/
	
	//*
	difference(){
		translate([0,0,6+Overlap]) color("Silver") OuterRacePart2();
		CutAway();
	} // diff
	/**/
	
	//*
	difference(){
		translate([0,0,-RingGear_h-Overlap]) color("Pink") BasePlate();
		CutAway();
	} // diff
	
	translate([0,0,-RingGear_h-Overlap-BottomCover_h-0.5]) color("Red") EncoderMount();
	rotate([0,0,Servo_a]) translate([ServoOffset,0,-RingGear_h-Overlap-21]) rotate([0,0,120]) color("Red") ServoSG90();
	/**/
	
	difference(){
		translate([0,0,-RingGear_h])TheRing();
		CutAway();
	} // diff
	
	color("Blue")
	for (j=[0:2]) rotate([0,0,120*j])
		translate([DrivePlateBC(Pitch=PlanetaryPitch, nTeeth=nPlanetTeeth, nTeethPinion=nSunTeeth)/2,0,0])
			rotate([180,0,180/nPlanetTeeth]) PlanetGear(Pitch=PlanetaryPitch, nTeeth=nPlanetTeeth, Thickness=GearWidth, SholderBolt=1);
	
	
	color("Blue")
	translate([0,0,-ShoulderBolt_l-5-0.5])
	for (j=[0:2]) rotate([0,0,120*j])
		translate([DrivePlateBC(Pitch=PlanetaryPitch, nTeeth=nPlanetTeeth, nTeethPinion=nSunTeeth)/2,0,0])
			rotate([180,0,180/nPlanetTeeth]) PlanetGear(Pitch=PlanetaryPitch, nTeeth=nPlanetTeeth, Thickness=GearWidth, SholderBolt=1);
	
	translate([0,0,-ShoulderBolt_l-5]) color("Green") PinionPlate2();
	
	translate([0,0,-ShoulderBolt_l*2-5]) color("Orange")SunGear();
	
	rotate([0,0,Servo_a])translate([ServoOffset,0,-28.5])rotate([0,0,360/12*0.3])color("LightBlue")DriveGear();
	
	// Encoder shaft
	translate([0,0,-RingGear_h-BottomCover_h-8.5]) color("Red"){
		cylinder(d=6,h=8.5+Overlap);
		translate([0,0,8.5]) cylinder(d=6.35,h=50);
	}
	
} // ShowFifthDoF

//ShowFifthDoF();

//PlanetGear(Pitch=PlanetaryPitch, nTeeth=nPlanetTeeth, Thickness=GearWidth, SholderBolt=1);

//OutsideRace(BallCircle_d=Tube_BC, Race_OD=SmallRace_d, Ball_d=Ball_d, Race_w=5, nBolts=6, RaceBoltInset=RaceBoltInset, PreLoadAdj=0.00, myFn=360) Bolt4ClearHole();


//translate([0,0,Ball_d/2+6+Ball_d*2+5])rotate([180,0,0])OutsideRace(BallCircle_d=Tube_BC, Race_OD=SmallRace_d, Ball_d=Ball_d, Race_w=5, nBolts=6, RaceBoltInset=RaceBoltInset, PreLoadAdj=0.00, myFn=90) Bolt4ClearHole();

module SunGear(){
	
	
	difference(){
		union(){
			translate([0,0,-Overlap])
		gear (number_of_teeth=nSunTeeth,
				circular_pitch=PlanetaryPitch, diametral_pitch=false,
				pressure_angle=Pressure_a,
				clearance = 0.4,
				gear_thickness=GearWidth,
				rim_thickness=GearWidth,
				rim_width=5,
				hub_thickness=GearWidth,
				hub_diameter=0,
				bore_diameter=0,
				circles=0,
				backlash=BackLash,
				twist=0,
				involute_facets=0,
				flat=false);
			
			translate([0,0,-GearWidth])
			gear (number_of_teeth=24,
				circular_pitch=PlanetaryPitch, diametral_pitch=false,
				pressure_angle=Pressure_a,
				clearance = 0.4,
				gear_thickness=GearWidth,
				rim_thickness=GearWidth,
				rim_width=5,
				hub_thickness=GearWidth,
				hub_diameter=0,
				bore_diameter=0,
				circles=0,
				backlash=BackLash,
				twist=0,
				involute_facets=0,
				flat=false);
		} // union
		
		translate([0,0,-GearWidth-Overlap]) cylinder(d=0.257*25.4+IDXtra,h=GearWidth*2+Overlap*2);
		
	} // diff
	
} // SunGear

//SunGear();

module OutputTubeBearing(myFN=90){
	
	
	
	translate([0,0,5])TubeEnd(TubeOD=Tube_d,Wall_t=0.84,Hole_d=6.35, Stop_l=5, GlueAllowance=0.40);
	
	difference(){
		union(){
			cylinder(d=DrivePlateBC(Pitch=PlanetaryPitch,nTeeth=nPlanetTeeth, nTeethPinion=nSunTeeth)+8,h=5);
			cylinder(d=Tube_d+8+BearingPreload,h=InnerRace_l);
			translate([0,0,InnerRace_l-Overlap])cylinder(d1=Tube_d+8,d2=Tube_d+3,h=4);
			
			// Key
			intersection(){
				rotate([0,0,-160])
					translate([DrivePlateBC(Pitch=PlanetaryPitch,nTeeth=nPlanetTeeth, nTeethPinion=nSunTeeth)/2+3,-2,0])cube([4,4,5]);
				cylinder(d=DrivePlateBC(Pitch=PlanetaryPitch,nTeeth=nPlanetTeeth, nTeethPinion=nSunTeeth)+14,h=5);
			}
		} // union
		
		
		
		// center hole
		translate([0,0,5]) cylinder(d=Tube_d+IDXtra*2,h=InnerRace_l+4);
		translate([0,0,-Overlap]) cylinder(d=6.35,h=6);
		
		translate([0,0,Ball_d/2+6]) BallTrack(BallCircle_d=Tube_BC+BearingPreload, Ball_d=Ball_d, myFn=myFN);
		translate([0,0,Ball_d/2+6+Ball_d*2]) BallTrack(BallCircle_d=Tube_BC+BearingPreload, Ball_d=Ball_d, myFn=myFN);
		
	    translate([0,0,5]) DrivePlateBolts(Pitch=PlanetaryPitch,nTeeth=nPlanetTeeth, nTeethPinion=nSunTeeth) Bolt6Hole();
		
	} // diff
	
} // OutputTubeBearing

//OutputTubeBearing();

module PinionPlate2(){
	difference(){
		PinionPlate(Pitch=PlanetaryPitch, nTeeth=nPlanetTeeth, nTeethPinion=nSunTeeth, Thickness=GearWidth);
		translate([0,0,-Overlap]) cylinder(d=0.257*25.4+IDXtra,h=5+GearWidth+Overlap*2);
	} // diff
} // PinionPlate2

//translate([0,0,-20])PinionPlate2();

module OuterRacePart2(myFn=90){
	
	translate([0,0,Ball_d/2+Ball_d*2-10]) difference(){
		rotate([0,0,22.5])
		OutsideRace(BallCircle_d=Tube_BC, Race_OD=SmallRace_d, Ball_d=Ball_d, Race_w=10, nBolts=8, RaceBoltInset=RaceBoltInset, PreLoadAdj=BearingPreload, myFn=myFn)		 Bolt4Hole();
		OutideRaceBoltPattern(Race_OD=LargeRace_d,nBolts=8,RaceBoltInset=RaceBoltInset) translate([0,0,2])Bolt4HeadHole();
	}
	
	translate([0,0,Ball_d/2+6])rotate([180,0,0])OutsideRace(BallCircle_d=Tube_BC, Race_OD=LargeRace_d, Ball_d=Ball_d, Race_w=6, nBolts=8, RaceBoltInset=RaceBoltInset, PreLoadAdj=BearingPreload, myFn=myFn) Bolt4HeadHole();
	
} // OuterRacePart2

//translate([0,0,6+Overlap]) OuterRacePart2();

module EncoderMount(){
		//Encoder shaft
		translate([0,0,-Overlap]) cylinder(d=6.35+IDXtra,h=10+Overlap*2);
		//Encoder mount
		translate([0,0,1]) rotate([180,0,0])cylinder(d=23+IDXtra,h=19);
		translate([8.5,0,0]) rotate([180,0,0])Bolt2Hole();
		translate([-8.5,0,0]) rotate([180,0,0])Bolt2Hole();
} // EncoderMount

//EncoderMount();

module DriveGear(){
	nTeeth=13;
	difference(){
			gear(number_of_teeth=nTeeth,
				circular_pitch=PlanetaryPitch, diametral_pitch=false,
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
			
			translate([0,0,-Overlap]) cylinder(d=PlanetaryPitch*nTeeth/180-5.4,h=2);
		} // intersection
		
	} // diff
} // DriveGear



 //rotate([0,0,Servo_a])translate([ServoOffset,0,-28.5])DriveGear();
BottomCover_h=12;
module BasePlate(){
	nBolts=8;
	
	BottomCover_t=3;
	
	difference(){
		union(){
			translate([0,0,-BottomCover_h+4]) cylinder(d=LargeRace_d,h=BottomCover_h-4);
			translate([0,0,-BottomCover_h]) cylinder(d=LargeRace_d-8,h=BottomCover_h);
			translate([0,0,-BottomCover_h+4])rotate_extrude() translate([LargeRace_d/2-4,0]) circle(r=4);
			
			for (j=[0:nBolts-2]) rotate([0,0,360/nBolts*j]) translate([LargeRace_d/2,0,-3]) 
				cylinder(d=7,h=3);
	
			// Gear cover
			rotate([0,0,Servo_a]) translate([ServoOffset,0,-BottomCover_h]) cylinder(d=28,h=BottomCover_h);
			
			// Servo boss
			rotate([0,0,Servo_a]) translate([ServoOffset,0,-BottomCover_h-6.5+Overlap]) rotate([0,0,120]) translate([-11.5,-7,0])cube([33,14,10]);
		} // union
		
		// carv out inside
		translate([0,0,-BottomCover_h+BottomCover_t+4]) cylinder(d=LargeRace_d-10,h=BottomCover_h-BottomCover_t-4+Overlap);
		translate([0,0,-BottomCover_h+BottomCover_t]) cylinder(d=LargeRace_d-8-BottomCover_t*2,h=BottomCover_h-BottomCover_t+Overlap);
		translate([0,0,-BottomCover_h+4+BottomCover_t]) rotate_extrude() translate([LargeRace_d/2-4-5,0]) circle(r=4);
		
		// bolt holes
		for (j=[0:nBolts-2]) rotate([0,0,360/nBolts*j]) translate([LargeRace_d/2,0,-3]) rotate([180,0,0])
				cylinder(d=7,h=10);
		
			for (j=[0:nBolts-2]) rotate([0,0,360/nBolts*j]) translate([LargeRace_d/2,0,-5.95]) 
				rotate([180,0,0]) Bolt4HeadHole(depth=8);
			
		translate([0,0,-BottomCover_h-0.5]) EncoderMount();
			
		rotate([0,0,Servo_a]) translate([ServoOffset,0,-21]) rotate([0,0,120]) ServoSG90();
			
		// Drive Gear clearance
		rotate([0,0,Servo_a]) translate([ServoOffset,0,-BottomCover_h+2]) cylinder(d=24,h=BottomCover_h-2+Overlap);
			
	} // diff
	
	/*
	MR_h=26;
	MR_d=TubeFlageOD(TubeOD=25.4);
	//Base Mounting Option
	if (HasMountRing==true)
		difference(){
			translate([0,0,-BottomCover_h-MR_h]) cylinder(d=MR_d,h=MR_h+Overlap);
			
			translate([0,0,-BottomCover_h-MR_h-Overlap]) cylinder(d=MR_d-16,h=MR_h+Overlap*2);
			translate([0,0,-BottomCover_h-MR_h]) rotate([0,0,-10]) TubeSocketBolts(TubeOD=Tube_d) rotate([180,0,0]) Bolt4Hole();
			// Servo
			rotate([0,0,Servo_a]) translate([ServoOffset,0,-BottomCover_h-MR_h-Overlap]) rotate([0,0,120]) translate([-11.5,-6.5,0])cube([33,20,MR_h+1]);
		}
	*/
} // BasePlate

//translate([0,0,-RingGear_h])
//BasePlate(HasMountRing=true);

//translate([0,0,-BottomCover_h-0.5]) color("Red") EncoderMount();
//rotate([0,0,Servo_a]) translate([ServoOffset,0,-21]) rotate([0,0,120]) color("Red") ServoSG90();
//translate([0,0,-BottomCover_h-25]) rotate([180,0,0]) TubeSocket(TubeOD=Tube_d, SocketLen=16, Threaded=false);



module TheRing(SideMount=false, myFn=90){
	
	translate([0,0,RingGear_h+6])
		OutsideRace(BallCircle_d=Tube_BC, Race_OD=LargeRace_d, Ball_d=Ball_d, Race_w=4, nBolts=8, RaceBoltInset=RaceBoltInset, PreLoadAdj=BearingPreload, myFn=myFn) Bolt4Hole();
	
	nBolts=8;
	difference(){
	 union(){
		 RingGear(Pitch=PlanetaryPitch, nTeeth=nPlanetTeeth, nTeethPinion=nSunTeeth, Thickness=RingGear_h+6.5);
		 
		 difference(){
			 cylinder(d=LargeRace_d,h=RingGear_h+6.5);
			 translate([0,0,-Overlap])cylinder(d=LargeRace_d-5,h=RingGear_h+6.5+Overlap*2);
		 } // diff
		 
		
		 
		for (j=[0:nBolts-2]) rotate([0,0,360/nBolts*j]) translate([LargeRace_d/2,0,0]) 
			{
				cylinder(d=7,h=8);
				translate([0,0,8]) sphere(d=7);
			} // union
			
		} // union
		
		//Key sweeps thru here
		translate([0,0,RingGear_h-0.5])cylinder(d=DrivePlateBC(Pitch=PlanetaryPitch,nTeeth=nPlanetTeeth, nTeethPinion=nSunTeeth)+15,h=6.5);
		
		// top bolt holes
		translate([0,0,RingGear_h+0.5-Overlap])
			OutideRaceBoltPattern(Race_OD=LargeRace_d,nBolts=8,RaceBoltInset=RaceBoltInset)
				rotate([180,0,0]) Bolt4Hole();
		
		// bottom bolt holes
		for (j=[0:nBolts-2]) rotate([0,0,360/nBolts*j]) translate([LargeRace_d/2,0,0]) 
			rotate([180,0,0]) Bolt4Hole(depth=8);
		
	} // diff
	
	//Tube connection
	if (SideMount==true){
		TubeConn_h=10;
		rotate([0,0,22.5])translate([LargeRace_d/2+Tube_d/2+IDXtra,0,TubeConn_h]) rotate([180,0,0]) 
			TubeEnd(TubeOD=Tube_d,Wall_t=0.84,Hole_d=12, Stop_l=1, GlueAllowance=0.40);
		difference(){
			hull(){
				rotate([0,0,22.5])translate([LargeRace_d/2+Tube_d/2+IDXtra,0,TubeConn_h]) cylinder(d=Tube_d,h=1);
				rotate([0,0,22.5]) translate([LargeRace_d/2-10,0,TubeConn_h]) cylinder(d=20,h=22);
			}
			
			translate([0,0,TubeConn_h-Overlap]) cylinder(d=LargeRace_d-1,h=24);
		} // diff
	}
	
	
	 // Gear cover
	difference(){
		union(){
			rotate([0,0,Servo_a]) translate([ServoOffset,0,0]) cylinder(d=28,h=1+Overlap);
			translate([0,0,1])rotate([0,0,Servo_a]) translate([ServoOffset,0,0]) cylinder(d1=28,d2=8,h=14);
		} // union
		translate([0,0,-Overlap]) cylinder(d=LargeRace_d-1,h=20);
	}// diff
	
	// Key
	difference(){
	rotate([0,0,-55])
				translate([DrivePlateBC(Pitch=PlanetaryPitch,nTeeth=nPlanetTeeth, nTeethPinion=nSunTeeth)/2+4,-2,RingGear_h+0.5])cube([10,4,7]);
		translate([0,0,RingGear_h])cylinder(d=DrivePlateBC(Pitch=PlanetaryPitch,nTeeth=nPlanetTeeth, nTeethPinion=nSunTeeth)+9,h=8);
	} // diff
	
	

} // TheRing

//translate([0,0,-RingGear_h])TheRing(SideMount=true);




































