// ************************************************
// Rocker Pivot
// by David M. Flynn
// Filename: RockerPivot.scad
// Created: 3/21/2018
// Revision: 1.0.0 3/21/2018
// **********************************************
// History
// 1.0.0 3/21/2018 first code
// **********************************************
// for STL output
// RockerArmConnector2Flange(myFn=360); // for 4 wheel rover
// translate([30,30,0]) RAC2Bearing1(myFn=360);
// translate([30,-30,0]) RAC2Bearing2(myFn=360);
// translate([-30,-30,0]) RAC2Bearing3(myFn=360);
// translate([-30,30,5]) RAC2Bearing4(myFn=360);
//
//
// rotate([180,0,0])RockerArmConnector();
// InsideInnerRace(myFn=360);
// MiddleInnerRace(myFn=360); // print 2
// OutsideInnerRace(myFn=360);
// OutsideRace(BallCircle_d=RockerPivot_bc, Race_OD=RP_OD, Ball_d=Ball_d, Race_w=5, nBolts=8, myFn=360) Bolt4Hole();
// OutsideRace(BallCircle_d=RockerPivot_bc, Race_OD=RP_OD, Ball_d=Ball_d, Race_w=5, nBolts=8, myFn=360) Bolt4ClearHole(); // print 3
// **********************************************
// for Viewing
// ShowRockerPivot();
// ShowRockerPivotCutaway();
// **********************************************

include<CommonStuffSAEmm.scad>

include<BearingLib.scad>
// InsideRace(BallCircle_d=60, Race_ID=34, Ball_d=9.525, Race_w=5, nBolts=8, RaceBoltInset=BL_RaceBoltInset, myFn=360) Bolt4ClearHole();
// InsideRace(BallCircle_d=60, Race_ID=34, Ball_d=9.525, Race_w=5, nBolts=8, RaceBoltInset=BL_RaceBoltInset, myFn=360) Bolt4HeadHole();
// OutsideRace(BallCircle_d=60, Race_OD=86, Ball_d=9.525, Race_w=7, nBolts=8, RaceBoltInset=BL_RaceBoltInset, myFn=360) Bolt4ClearHole();
// OutsideRace(BallCircle_d=60, Race_OD=86, Ball_d=9.525, Race_w=5, nBolts=8, RaceBoltInset=BL_RaceBoltInset, myFn=360) Bolt4Hole();
// InsideRaceBoltPattern(Race_ID=50, nBolts=8, RaceBoltInset=BL_RaceBoltInset) Bolt4HeadHole();
// OutideRaceBoltPattern(Race_OD=150, nBolts=8, RaceBoltInset=BL_RaceBoltInset) Bolt4HeadHole();

include<TubeConnectorLib.scad>
// TubeEll_STL(TubeOD=25.4,Wall_t=0.84,Hole_d=14, GlueAllowance=0.40);
// TubeSection(TubeOD=25.4,Wall_t=0.84, Length=100);
// TubeEnd(TubeOD=25.4,Wall_t=0.84,Hole_d=14, Stop_l=TubeStop_l, GlueAllowance=0.40);
// TubeEll(TubeOD=25.4,Wall_t=0.84,Hole_d=14, GlueAllowance=0.40);
// Tube2Pivot(TubeAngle=180,Length=50,WireExit=0, GlueAllowance=0.40);
// Tube2PivotCover(Length=60);

$fn=90;
IDXtra=0.2;
Overlap=0.05;

Tube_OD=25.4;
RaceBoltInset=3.5;
RockerPivot_bc=54;
RP_Shaft_d=12.7;
ShaftCollar_d=28.3;
ShaftCollar_t=10.2;
RP_ID=ShaftCollar_d; //RockerPivot_bc-26;
Ball_d=9.525;
RP_OD=RockerPivot_bc+26;
BearingPreload=0.2;

module RockerArmConnector(){
	difference(){
		union(){
			cylinder(d=RP_OD+6,h=20+8); //20+6+Overlap
			//translate([0,0,20+6]) cylinder(d1=RP_OD+6,d2=RockerPivot_bc-Ball_d,h=3);
		} // union
		
		//translate([5,-28,26.5]) rotate([0,0,80]) linear_extrude(height=3) text(text="JPL", size=20, font="Arial Black");
		
		translate([0,0,-Overlap]) cylinder(d=RP_OD+IDXtra,h=20+Overlap*2);
		translate([0,0,20]) cylinder(d1=RockerPivot_bc+7,d2=RockerPivot_bc-6,h=3);
		
		translate([0,0,20+6+1]) OutideRaceBoltPattern(Race_OD=RP_OD, nBolts=8, RaceBoltInset=RaceBoltInset) Bolt4HeadHole();
	} // diff
	
	difference(){
		translate([0,-(RP_OD+6)/2-3,13.5])rotate([80,0,0])TubeEnd(TubeOD=Tube_OD, Wall_t=0.84, Hole_d=14, Stop_l=6, GlueAllowance=0.40);
		cylinder(d=RP_OD+4,h=20+6+Overlap);
	}
	rotate([0,0,160])translate([0,-(RP_OD+6)/2,13])rotate([90,0,0])TubeEnd(TubeOD=Tube_OD, Wall_t=0.84, Hole_d=14, Stop_l=3, GlueAllowance=0.40);
} // RockerArmConnector

//translate([0,0,2]) RockerArmConnector();

BearingDist=24;


module RAC2Bearing1(myFn=90){
	BossLen=BearingDist-0.4;
	InsideRace(BallCircle_d=RockerPivot_bc, Race_ID=12.7, Ball_d=Ball_d, Race_w=6, nBolts=6, RaceBoltInset=10, myFn=myFn) Bolt4Hole();
	difference(){
		cylinder(d=24,h=BossLen);
		
		translate([0,0,-Overlap]) cylinder(d=12.7,h=BossLen+Overlap*2);
		rotate([0,0,30])translate([-12,0,16]) rotate([0,-90,0]) Bolt10Hole(depth=10);
	} // diff
} // RAC2Bearing1

//RAC2Bearing1(myFn=90);

module RAC2Bearing2(myFn=90){
	InsideRace(BallCircle_d=RockerPivot_bc, Race_ID=24+IDXtra, Ball_d=Ball_d, Race_w=6, nBolts=6, RaceBoltInset=4+IDXtra, myFn=myFn) Bolt4HeadHole();
	//difference(){
	//	cylinder(d=24,h=20);
		
	//	translate([0,0,-Overlap]) cylinder(d=12.7,h=20+Overlap*2);
	//} // diff
} // RAC2Bearing2

//translate([0,0,12+Overlap]) rotate([180,0,0]) RAC2Bearing2(myFn=90);

module RAC2Bearing3(myFn=90){
	InsideRace(BallCircle_d=RockerPivot_bc, Race_ID=12.7, Ball_d=Ball_d, Race_w=6, nBolts=6, RaceBoltInset=10, myFn=myFn) Bolt4Hole();
	//difference(){
	//	cylinder(d=24,h=20);
		
	//	translate([0,0,-Overlap]) cylinder(d=12.7,h=20+Overlap*2);
	//} // diff
} // RAC2Bearing3
//translate([0,0,BearingDist])RAC2Bearing3(myFn=90);

module RAC2Bearing4(myFn=90){
	InsideRace(BallCircle_d=RockerPivot_bc, Race_ID=12.7, Ball_d=Ball_d, Race_w=6, nBolts=6, RaceBoltInset=10, myFn=myFn) Bolt4ClearHole();
	
	translate([0,0,Overlap])
	difference(){
		union(){
			translate([0,0,-5])cylinder(d=54,h=5+Overlap);
			translate([0,0,-5])cylinder(d=65,h=3,$fn=myFn);
		}// union
		
		translate([0,0,-5-Overlap]) cylinder(d=12.7,h=5+Overlap*3);
		InsideRaceBoltPattern(Race_ID=12.7, nBolts=6, RaceBoltInset=10) Bolt4HeadHole();
		
		dmfe_a=10;
		rotate([0,0,dmfe_a]) translate([0,-20,-5-Overlap]) linear_extrude(1) mirror([0,1]) text("D",halign="center");
		rotate([0,0,dmfe_a+27]) translate([0,-20,-5-Overlap]) linear_extrude(1) mirror([0,1]) text("M",halign="center");
		rotate([0,0,dmfe_a+54]) translate([0,-20,-5-Overlap]) linear_extrude(1) mirror([0,1]) text("F",halign="center");
		//rotate([0,0,dmfe_a+75]) translate([0,-20,-5-Overlap]) linear_extrude(1) mirror([0,1]) text("E",halign="center");
		
		/*
		Mapping_a=-55;
		Mapping_r=28;
		//rotate([0,0,Mapping_a]) translate([0,-29,-5-Overlap]) linear_extrude(1) text("M",halign="center");
		//rotate([0,0,Mapping_a-23]) translate([0,-29,-5-Overlap]) linear_extrude(1) text("A",halign="center");
		//cartography
		rotate([0,0,Mapping_a]) translate([0,-Mapping_r,-5-Overlap]) linear_extrude(1) mirror([1,0]) text("C",halign="center");
		rotate([0,0,Mapping_a-20]) translate([0,-Mapping_r,-5-Overlap]) linear_extrude(1) mirror([1,0]) text("a",halign="center");
		rotate([0,0,Mapping_a-35]) translate([0,-Mapping_r,-5-Overlap]) linear_extrude(1) mirror([1,0]) text("r",halign="center");
		rotate([0,0,Mapping_a-50]) translate([0,-Mapping_r,-5-Overlap]) linear_extrude(1) mirror([1,0]) text("t",halign="center");
		rotate([0,0,Mapping_a-65]) translate([0,-Mapping_r,-5-Overlap]) linear_extrude(1) mirror([1,0]) text("o",halign="center");
		rotate([0,0,Mapping_a-85]) translate([0,-Mapping_r,-5-Overlap]) linear_extrude(1) mirror([1,0]) text("g",halign="center");
		rotate([0,0,Mapping_a-100]) translate([0,-Mapping_r,-5-Overlap]) linear_extrude(1) mirror([1,0]) text("r",halign="center");
		rotate([0,0,Mapping_a-115]) translate([0,-Mapping_r,-5-Overlap]) linear_extrude(1) mirror([1,0]) text("a",halign="center");
		rotate([0,0,Mapping_a-132]) translate([0,-Mapping_r,-5-Overlap]) linear_extrude(1) mirror([1,0]) text("p",halign="center");
		rotate([0,0,Mapping_a-150]) translate([0,-Mapping_r,-5-Overlap]) linear_extrude(1) mirror([1,0]) text("h",halign="center");
		rotate([0,0,Mapping_a-168]) translate([0,-Mapping_r,-5-Overlap]) linear_extrude(1) mirror([1,0]) text("y",halign="center");
		/**/
	} // diff
} // RAC2Bearing4

//translate([0,0,BearingDist+12+Overlap]) rotate([180,0,0]) RAC2Bearing4(myFn=90);

module RockerArmConnector2Flange(myFn=90){
	RP_OD=RockerPivot_bc+Ball_d+6;
	Horn_l=100;
	
	difference(){
		union(){
			cylinder(d=RP_OD,h=TubeFlageOD(TubeOD=Tube_OD),$fn=myFn); //20+6+Overlap
			
			//*
			// Flange1
			rotate([0,0,10]){
				translate([0,-RP_OD/2-3,TubeFlageOD(TubeOD=Tube_OD)/2]) rotate([80,0,0]) TubeFlange(TubeOD=Tube_OD, FlangeLen=10, Threaded=true);
				hull(){
					//difference(){
						cylinder(d=RP_OD,h=TubeFlageOD(TubeOD=Tube_OD),$fn=myFn);
				
						//translate([0,0,-Overlap]) cylinder(d=RP_OD-3,h=TubeFlageOD(TubeOD=Tube_OD)+Overlap*2);
					//} // diff
					translate([0,-RP_OD/2-3,TubeFlageOD(TubeOD=Tube_OD)/2])rotate([80,0,0]) cylinder(d=TubeFlageOD(TubeOD=Tube_OD),h=0.01,$fn=myFn);
				} // hull
			}
			
			// Flange2
			rotate([0,0,170]){
			translate([0,-RP_OD/2-3,TubeFlageOD(TubeOD=Tube_OD)/2]) rotate([80,0,0]) TubeFlange(TubeOD=Tube_OD, FlangeLen=10, Threaded=true);
			hull(){
				//difference(){
					cylinder(d=RP_OD,h=TubeFlageOD(TubeOD=Tube_OD),$fn=myFn);
					
					//translate([0,0,-Overlap]) cylinder(d=RP_OD-1,h=TubeFlageOD(TubeOD=Tube_OD)+Overlap*2);
				//} // diff
				translate([0,-RP_OD/2-3,TubeFlageOD(TubeOD=Tube_OD)/2])rotate([80,0,0]) cylinder(d=TubeFlageOD(TubeOD=Tube_OD),h=0.01,$fn=myFn);
			} // hull
			} // rotate
			/**/
			
			// Horn
			hull(){
				cylinder(d=35,h=6);
				translate([-Horn_l,0,0]) cylinder(d=12,h=6);
			} // hull
			hull(){
				cylinder(d=6,h=35);
				translate([-Horn_l+10,0,0]) cylinder(d=6,h=6);
			} // hull
			
		} // union
			
		translate([0,0,-Overlap]) cylinder(d=RP_OD-3,h=TubeFlageOD(TubeOD=Tube_OD)+Overlap*2);
		
		// horn bolt
		translate([-Horn_l,0,6]) Bolt6Hole();
	} // diff
	
	OnePieceOuterRace(BallCircle_d=RockerPivot_bc, Race_OD=RP_OD-1, Ball_d=Ball_d, Race_w=12, PreLoadAdj=BearingPreload, VOffset=0.00, myFn=myFn);
	
	difference(){
		translate([0,0,12-Overlap]) cylinder(d=RP_OD-3-Overlap,h=BearingDist-12+Overlap*2);
		translate([0,0,12-Overlap*2]) cylinder(d=RockerPivot_bc+Ball_d*0.7,h=BearingDist-12+Overlap*4);
	} // diff
		
	translate([0,0,BearingDist]) 
		OnePieceOuterRace(BallCircle_d=RockerPivot_bc, Race_OD=RP_OD-1, Ball_d=Ball_d, Race_w=12, PreLoadAdj=BearingPreload, VOffset=0.00, myFn=myFn);
} // RockerArmConnector2Flange

//translate([0,0,2])
//RockerArmConnector2Flange(myFn=90);


module InsideInnerRace(myFn=90){
	nBolts=8;
	// inches
	BC_d=1.50*25.4;
	BC_r=BC_d/2;
	

	difference(){
		InsideRace(BallCircle_d=RockerPivot_bc, Race_ID=RP_ID, Ball_d=Ball_d, Race_w=7, nBolts=nBolts, myFn=myFn) 
			Bolt4Hole();
			
		// Box Bolts
		for (j=[0:3]) rotate([0,0,90*j+22.5]) 
			translate([BC_r,0,5])
				Bolt6Hole();
		
	} // diff
	
	difference(){
		cylinder(d=RP_ID+Overlap,h=6);
		
		translate([0,0,-Overlap]) cylinder(d=RP_Shaft_d,h=8);
	}
} // InsideInnerRace

//InsideInnerRace(myFn=90);


module MiddleInnerRace(myFn=90){
	nBolts=8;

	InsideRace(BallCircle_d=RockerPivot_bc, Race_ID=RP_ID, Ball_d=Ball_d, Race_w=5, nBolts=nBolts, myFn=myFn) 
		Bolt4ClearHole();
			
} // MiddleInnerRace

//translate([0,0,7+5+Overlap]) rotate([180,0,0])MiddleInnerRace(myFn=90);
//translate([0,0,7+5+Overlap*2]) MiddleInnerRace(myFn=90);


module OutsideInnerRace(myFn=90){
	nBolts=8;
	
		InsideRace(BallCircle_d=RockerPivot_bc, Race_ID=RP_ID, Ball_d=Ball_d, Race_w=7, nBolts=nBolts, myFn=myFn) 
			Bolt4HeadHole();
	
	difference(){
		cylinder(d=RP_ID+Overlap,h=7);
		
		translate([0,0,-Overlap]) cylinder(d=RP_Shaft_d,h=8);
	}
} // OutsideInnerRace

//translate([0,0,7*2+5*2+Overlap*3]) rotate([180,0,0])OutsideInnerRace(myFn=90);

module ShowMyBalls(){
	nBalls=17;
	
	for (j=[0:nBalls-1]) rotate([0,0,360/nBalls*j]) translate([RockerPivot_bc/2,0,0]) color("Pink") sphere(d=Ball_d);
} // ShowMyBalls


module ShowRockerPivot(){
	translate([0,0,2+Overlap*3])RockerArmConnector();
	InsideInnerRace(myFn=90);
	translate([0,0,7+5+Overlap]) rotate([180,0,0])MiddleInnerRace(myFn=90);
	translate([0,0,7+5+Overlap*2]) MiddleInnerRace(myFn=90);
	translate([0,0,7*2+5*2+Overlap*3]) rotate([180,0,0])OutsideInnerRace(myFn=90);
translate([0,0,7])ShowMyBalls();
translate([0,0,7+10+Overlap*3])ShowMyBalls();

translate([0,0,2])OutsideRace(BallCircle_d=RockerPivot_bc, Race_OD=RP_OD, Ball_d=Ball_d, Race_w=5, nBolts=8, myFn=90) Bolt4Hole();
translate([0,0,2+5*2+Overlap])rotate([180,0,0])OutsideRace(BallCircle_d=RockerPivot_bc, Race_OD=RP_OD, Ball_d=Ball_d, Race_w=5, nBolts=8, myFn=90) Bolt4ClearHole();
translate([0,0,2+5*2+Overlap*2])OutsideRace(BallCircle_d=RockerPivot_bc, Race_OD=RP_OD, Ball_d=Ball_d, Race_w=5, nBolts=8, myFn=90) Bolt4ClearHole();
translate([0,0,2+5*4+Overlap*3])rotate([180,0,0])OutsideRace(BallCircle_d=RockerPivot_bc, Race_OD=RP_OD, Ball_d=Ball_d, Race_w=5, nBolts=8, myFn=90) Bolt4ClearHole();
} // ShowRockerPivot

module ShowRockerPivotCutaway(){
	difference(){
		ShowRockerPivot();
		translate([0,0,-1]) cube([100,100,100]);
	} // diff
} // ShowRockerPivotCutaway

//ShowRockerPivotCutaway();





