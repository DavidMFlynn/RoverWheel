// ****************************************************
// Spline Library
// by David M. Flynn
// Filename: SplineLib.scad
// Created: 12/27/2017
// Rev: 1.1.1 1/9/2018
// Units: millimeters
// ****************************************************
// Notes:
//  if Key is true the index spline (+X) will be 2x bigger than the others.
//  The center hole (Hole=6) is recommended to strength, 
//   Hole=0 will make a solid shaft.
//  Spline_w is in degrees.
//  A Gap of 0.4 is loose while a Gap of 0.1 is a press fit.
// ****************************************************
// History:
echo("SplineLib 1.1.1");
// 1.1.1 1/9/2018 Added constants Spline_Radius,Spline_Hole_d,Spline_nSplines
// 1.1.0 12/29/2017 Added Key spline.
// 1.0.0 12/27/2017 First code
// ****************************************************
// Routines:
// SplineShaft(d=20,l=30,nSplines=Spline_nSplines,Spline_w=30,Hole=Spline_Hole_d,Key=false);
// SplineHole(d=20,l=20,nSplines=Spline_nSplines,Spline_w=30,Gap=IDXtra,Key=false);
//
// for test fitting
// SplineHoleTest();
// SplineShaft(d=20,l=10,nSplines=6,Spline_w=20,Hole=6);
// ****************************************************
// Global constants, can be overridden
Overlap=0.05;
IDXtra=0.4;
$fn=90;

Spline_Radius=1; // provides smoothing of inner and outer corners 0.6mm to 1mm works well with a 0.4mm nozzle
Spline_Hole_d=6.35+IDXtra; // for a 1/4" standoff
Spline_nSplines=6;
//*****************************************************

module SplineShaft(d=20,l=50,nSplines=Spline_nSplines,Spline_w=10,Hole=Spline_Hole_d,Key=false){
	Rad=Spline_Radius;
	Small_OD=d-Rad*4.25;
	Spline_y=d*3.14/(360/Spline_w);
	Tan_a= 360/((d-Rad*2)*3.14/(Spline_y-Rad*2));
	rTan_a=360/((d-Rad*2)*3.14/(Spline_y+Rad*2));
	sTan_a=360/(Small_OD*3.14/(Spline_y-Rad*2));
	srTan_a=360/((Small_OD+Rad*2)*3.14/(Spline_y+Rad*2));
	Key_wa=Spline_w/4;
	
	//echo(Spline_y=Spline_y);
	//echo(Tan_a=Tan_a);
	//echo(rTan_a=rTan_a);
	//echo(sTan_a=sTan_a);
	//echo(srTan_a=srTan_a);
	//echo(Key_wa=Key_wa);
	
	
	difference(){
		union(){
			for (j=[0:nSplines-1]){//j=0;
				k= (j==0 && Key==true) ? Key_wa : 0;
			
				hull(){
					rotate([0,0,360/nSplines*j+Tan_a/2+k]) translate([d/2-Rad,0,0]) cylinder(r=Rad,h=l);
					rotate([0,0,360/nSplines*j-Tan_a/2-k]) translate([d/2-Rad,0,0]) cylinder(r=Rad,h=l);
					rotate([0,0,360/nSplines*j+sTan_a/2+k]) translate([Small_OD/2,0,0]) cylinder(r=Rad,h=l);
					rotate([0,0,360/nSplines*j-sTan_a/2-k]) translate([Small_OD/2,0,0]) cylinder(r=Rad,h=l);
				} // hull
				
				hull(){
					rotate([0,0,360/nSplines*j+Tan_a/2+k]) translate([d/2,0,l/2]) cube([d/8,0.01,l],center=true);
					rotate([0,0,360/nSplines*j-Tan_a/2-k]) translate([d/2,0,l/2]) cube([d/8,0.01,l],center=true);
				} // hull
			} // for
			
			cylinder(d=d-Rad*2,h=l);
		} // union
		
		translate([0,0,-Overlap])
		for (j=[0:nSplines-1]) { //j=0;
			k= (j==0 && Key==true) ? Key_wa : 0;
			m= (j==(nSplines-1) && Key==true) ? Key_wa : 0;
			hull(){
				rotate([0,0,360/nSplines*j+srTan_a/2+k]) translate([Small_OD/2+Rad,0,0]) cylinder(r=Rad,h=l+Overlap*2);
				rotate([0,0,360/nSplines*j+rTan_a/2+k]) translate([d/2-Rad,0,0]) cylinder(r=Rad,h=l+Overlap*2);
			} // hull
			
			hull(){
				rotate([0,0,360/nSplines*(j+1)-srTan_a/2-m]) translate([Small_OD/2+Rad,0,0]) cylinder(r=Rad,h=l+Overlap*2);
				rotate([0,0,360/nSplines*(j+1)-rTan_a/2-m]) translate([d/2-Rad,0,0]) cylinder(r=Rad,h=l+Overlap*2);
			} // hull
			} // for
	/**/		
		// trim OD
		difference(){
			translate([0,0,-Overlap]) cylinder(d=d+5,h=l+Overlap*2);
			translate([0,0,-Overlap*2]) cylinder(d=d,h=l+Overlap*4,$fn=360);
		} // diff
		
		
		// trim ID
		difference(){
			translate([0,0,-Overlap]) cylinder(d=d,h=l+Overlap*2);
			
			// core
			translate([0,0,-Overlap*2]) cylinder(d=Small_OD,h=l+Overlap*4,$fn=360);
			
			// splines
			for (j=[0:nSplines-1]){
				k= (j==0 && Key==true) ? Key_wa : 0;
				hull(){
					rotate([0,0,360/nSplines*j+srTan_a/2+k]) translate([d/2,0,l/2]) 
						cube([d/2,0.01,l+Overlap*4],center=true);
					rotate([0,0,360/nSplines*j-srTan_a/2-k]) translate([d/2,0,l/2]) 
						cube([d/2,0.01,l+Overlap*4],center=true);
				} // hull
			} // for
			
		} // diff
		/**/
		// center hole
		if (Hole>0)
			translate([0,0,-Overlap]) cylinder(d=Hole,h=l+Overlap*2);
	} // diff
	
} // SplineShaft

//SplineShaft(d=20,l=10,nSplines=6,Spline_w=30,Hole=6,Key=false);
//SplineShaft(d=20,l=10,nSplines=6,Spline_w=20,Hole=6,Key=true);

module SplineHole(d=20,l=20,nSplines=Spline_nSplines,Spline_w=30,Gap=IDXtra,Key=false){
	Rad=Spline_Radius;
	Small_OD=d-Rad*4.25;
	Spline_y=d*3.14/(360/Spline_w);
	Tan_a=360/((d-Rad*2)*3.14/(Spline_y-Rad*2));
	rTan_a=360/((d-Rad*2)*3.14/(Spline_y+Rad*2));
	sTan_a=360/(Small_OD*3.14/(Spline_y-Rad*2));
	srTan_a=360/((Small_OD+Rad*2)*3.14/(Spline_y+Rad*2));
	Key_wa=Spline_w/4;
	
	//echo(Spline_y=Spline_y);
	//echo(Tan_a=Tan_a);
	//echo(rTan_a=rTan_a);
	//echo(sTan_a=sTan_a);
	//echo(srTan_a=srTan_a);
	
	difference(){
		union(){
			for (j=[0:nSplines-1]) {
				k= (j==0 && Key==true) ? Key_wa : 0;
				hull(){
					rotate([0,0,360/nSplines*j+Tan_a/2+k]) translate([d/2-Rad,0,0]) cylinder(r=Rad+Gap,h=l);
					rotate([0,0,360/nSplines*j-Tan_a/2-k]) translate([d/2-Rad,0,0]) cylinder(r=Rad+Gap,h=l);
					rotate([0,0,360/nSplines*j+sTan_a/2+k]) translate([Small_OD/2,0,0]) cylinder(r=Rad+Gap,h=l);
					rotate([0,0,360/nSplines*j-sTan_a/2-k]) translate([Small_OD/2,0,0]) cylinder(r=Rad+Gap,h=l);
				} // hull
				hull(){
					rotate([0,0,360/nSplines*j+Tan_a/2+k]) translate([d/2,0,l/2]) cube([d/8,0.01,l],center=true);
					rotate([0,0,360/nSplines*j-Tan_a/2-k]) translate([d/2,0,l/2]) cube([d/8,0.01,l],center=true);
				} // hull
			} // for
			
			cylinder(d=d-Rad*2,h=l);
		} // union
		
		translate([0,0,-Overlap])
		for (j=[0:nSplines-1]) {
			k= (j==0 && Key==true) ? Key_wa : 0;
			m= (j==(nSplines-1) && Key==true) ? Key_wa : 0;

			hull(){
				rotate([0,0,360/nSplines*j+srTan_a/2+k]) translate([Small_OD/2+Rad,0,0]) cylinder(r=Rad-Gap,h=l+Overlap*2);
				rotate([0,0,360/nSplines*j+rTan_a/2+k]) translate([d/2-Rad,0,0]) cylinder(r=Rad-Gap,h=l+Overlap*2);
			} // hull
			
			hull(){
				rotate([0,0,360/nSplines*(j+1)-srTan_a/2-m]) translate([Small_OD/2+Rad,0,0]) cylinder(r=Rad-Gap,h=l+Overlap*2);
				rotate([0,0,360/nSplines*(j+1)-rTan_a/2-m]) translate([d/2-Rad,0,0]) cylinder(r=Rad-Gap,h=l+Overlap*2);
			} // hull
			} // for
	/**/		
		// trim OD
		difference(){
			translate([0,0,-Overlap]) cylinder(d=d+5,h=l+Overlap*2);
			translate([0,0,-Overlap*2]) cylinder(d=d+Gap*2,h=l+Overlap*4,$fn=360);
		} // diff
		
		
		// trim ID
		difference(){
			translate([0,0,-Overlap]) cylinder(d=d,h=l+Overlap*2);
			
			// core
			translate([0,0,-Overlap*2]) cylinder(d=Small_OD+Gap*2,h=l+Overlap*4,$fn=360);
			
			// splines
			for (j=[0:nSplines-1]){
				k= (j==0 && Key==true) ? Key_wa : 0;
				hull(){
					rotate([0,0,360/nSplines*j+srTan_a/2+k]) translate([d/2,0,l/2]) 
						cube([d/2,0.01,l+Overlap*4],center=true);
					rotate([0,0,360/nSplines*j-srTan_a/2-k]) translate([d/2,0,l/2]) 
						cube([d/2,0.01,l+Overlap*4],center=true);
				} // hull
			} // for
			
		} // diff
		/**/
		
	} // diff
	
} // SplineHole

module SplineHoleTest(){
difference(){
	cylinder(d=29,h=10);
	translate([0,0,-Overlap])SplineHole(d=20,l=20+Overlap*2,nSplines=6,Spline_w=20,Gap=IDXtra,Key=true);
	
}
}
//SplineHoleTest();


