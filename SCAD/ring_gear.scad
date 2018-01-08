// ******************************************************************
// Ring Gear Library
// File: ring_gear.scad
// Created: 9/29/2016
// Rev: 1.0.0 1/7/2017
// Units: millimeters
// *******************************************************************
// History:
//  1.0.0 1/7/2017 First rev'd version, removed old code
//
// Dirived from:
// Parametric Involute Bevel and Spur Gears by GregFrost
// It is licensed under the Creative Commons - GNU LGPL 2.1 license.
// (c) 2010 by GregFrost, thingiverse.com/Amp
// http://www.thingiverse.com/thing:3575 and http://www.thingiverse.com/thing:3752
// ********************************************************************
// Simple Test:
//ring_gear (circular_pitch=400,gear_thickness = 12,rim_thickness = 15);

pi=3.1415926535897932384626433832795;

/*
ring_gear(number_of_teeth=45,
	circular_pitch=200, diametral_pitch=false,
	pressure_angle=20,
	clearance = 0.2,
	gear_thickness=15,
	rim_thickness=0,
	rim_width=0,
	backlash=0,
	twist=0,
	involute_facets=0, // 1 = triangle, default is 5
	flat=false);
/**/

// from PlanetGears
/*
ring_gear(number_of_teeth=36,
		circular_pitch=300, diametral_pitch=false,
		pressure_angle=24,
		clearance = 0.2,
		gear_thickness=30,
		rim_thickness=30,
		rim_width=3.5,
		backlash=0.2,
		twist=0,
		involute_facets=0, // 1 = triangle, default is 5
		flat=false);
/**/

module ring_gear (number_of_teeth=60,
					circular_pitch=false, diametral_pitch=false,
					pressure_angle=22.5,
					clearance = 0.2,
					gear_thickness=5,
					rim_thickness=8,
					rim_width=5,
					backlash=0,
					twist=0,
					involute_facets=0,
					flat=false){
						
	if (circular_pitch==false && diametral_pitch==false)
		echo("MCAD ERROR: gear module needs either a diametral_pitch or circular_pitch");

	//Convert diametrial pitch to our native circular pitch
	circular_pitch = (circular_pitch!=false?circular_pitch:180/diametral_pitch);

	// Pitch diameter: Diameter of pitch circle.
	pitch_diameter  =  number_of_teeth * circular_pitch / 180;
	pitch_radius = pitch_diameter/2;
	echo ("Teeth:", number_of_teeth, " Pitch radius:", pitch_radius);

	// Base Circle
	base_radius = pitch_radius*cos(pressure_angle);

	// Diametrial pitch: Number of teeth per unit length.
	pitch_diametrial = number_of_teeth / pitch_diameter;

	// Addendum: Radial distance from pitch circle to outside circle.
	addendum = 1/pitch_diametrial;

	//Outer Circle
	outer_radius = pitch_radius+addendum;

	// Dedendum: Radial distance from pitch circle to root diameter
	dedendum = addendum+ clearance;

	// Root diameter: Diameter of bottom of tooth spaces.
	root_radius = pitch_radius-dedendum;
	backlash_angle = backlash / pitch_radius * 180 / pi;
	half_thick_angle = (360 / number_of_teeth - backlash_angle) / 4;

	// Variables controlling the rim.
	rim_radius = outer_radius + rim_width;


	linear_exturde_flat_option(flat=flat, height=gear_thickness, convexity=10, twist=twist)
				
				//echo("root_radius=",root_radius);
				//echo("base_radius=",base_radius);
				//echo("outer_radius=",outer_radius);
				//echo("half_thick_angle=",half_thick_angle);
				//echo("involute_facets=",involute_facets);
				ring_gear_shape (
					number_of_teeth,
					pitch_radius = pitch_radius,
					root_radius = root_radius,
					base_radius = base_radius,
					outer_radius = outer_radius,
					half_thick_angle = half_thick_angle,
					involute_facets=involute_facets);

			
		if (rim_thickness>0){
			if (flat==true){
				difference(){
					circle (r=rim_radius);
					circle (r=outer_radius+0.2);
			}}else{
			difference(){
					cylinder(r=rim_radius,h=rim_thickness,$fn=number_of_teeth*2);
					translate([0,0,-0.05]) cylinder(r=outer_radius+clearance,h=rim_thickness+0.1,$fn=number_of_teeth*2);
			}
		}}
	
} // ring_gear

module linear_exturde_flat_option(flat =false, height = 10, center = false, convexity = 2, twist = 0)
{
	if(flat==false){
		linear_extrude(height = height, center = center, convexity = convexity, twist= twist) children(0);
	}else{
		children(0);
	}
} // linear_exturde_flat_option



module ring_gear_shape (number_of_teeth,
						pitch_radius,
						root_radius,
						base_radius,
						outer_radius,
						half_thick_angle,
						involute_facets){
							
						//	echo(pitch_radius);
						//	echo(root_radius);
						//	echo(base_radius);
						//	echo(outer_radius);
		

		intersection(){
			circle ($fn=number_of_teeth*2, r=outer_radius+2);
			
			for (i = [1:number_of_teeth]){
				rotate ([0,0,i*360/number_of_teeth+180]) translate([-outer_radius-pitch_radius+(outer_radius-pitch_radius),0,0])
					involute_gear_tooth (
						pitch_radius = pitch_radius,
						root_radius = root_radius,
						base_radius = base_radius,
						outer_radius = outer_radius,
						half_thick_angle = half_thick_angle,
						involute_facets=involute_facets);
			
			} // for
		}// intersect
} // ring_gear_shape

/*
ring_gear_shape (
					number_of_teeth=20,
					pitch_radius = 14.4444,
					root_radius = 12.8,
					base_radius = 12.7537,
					outer_radius = 15.8889,
					half_thick_angle = 4.5,
					involute_facets=5);
/**/
/*
involute_gear_tooth (
	pitch_radius=14.4444,
	root_radius=12.8,
	base_radius=12.7537,
	outer_radius=15.8889,
	half_thick_angle=4.5,
	involute_facets=0);
*/
module involute_gear_tooth(pitch_radius,
							root_radius,
							base_radius,
							outer_radius,
							half_thick_angle,
							involute_facets){
								
	min_radius = max (base_radius,root_radius);

	pitch_point = involute (base_radius, involute_intersect_angle (base_radius, pitch_radius));
	pitch_angle = atan2 (pitch_point[1], pitch_point[0]);
	centre_angle = pitch_angle + half_thick_angle;

	start_angle = involute_intersect_angle (base_radius, min_radius);
	stop_angle = involute_intersect_angle (base_radius, outer_radius);

	res=(involute_facets!=0)?involute_facets:($fn==0)?5:$fn/4;

	union (){
		for (i=[1:res]){
			point1=involute (base_radius,start_angle+(stop_angle - start_angle)*(i-1)/res);
			point2=involute (base_radius,start_angle+(stop_angle - start_angle)*i/res);
		
			
				side1_point1=rotate_point (centre_angle, point1);
				side1_point2=rotate_point (centre_angle, point2);
				side2_point1=mirror_point (rotate_point (centre_angle, point1));
				side2_point2=mirror_point (rotate_point (centre_angle, point2));
			
				polygon (
					points=[[0,0],side1_point1,side1_point2,side2_point2,side2_point1],
					paths=[[0,1,2,3,4,0]]);
			
		} // for
	} // union
} // involute_gear_tooth

// Mathematical Functions
//===============

// Finds the angle of the involute about the base radius at the given distance (radius) from it's center.
//source: http://www.mathhelpforum.com/math-help/geometry/136011-circle-involute-solving-y-any-given-x.html

function involute_intersect_angle (base_radius, radius) = sqrt (pow (radius/base_radius, 2) - 1) * 180 / pi;

// Calculate the involute position for a given base radius and involute angle.

function rotated_involute (rotate, base_radius, involute_angle) =
[
	cos (rotate) * involute (base_radius, involute_angle)[0] + sin (rotate) * involute (base_radius, involute_angle)[1],
	cos (rotate) * involute (base_radius, involute_angle)[1] - sin (rotate) * involute (base_radius, involute_angle)[0]
];

function mirror_point (coord) = [coord[0],-coord[1]];

function rotate_point (rotate, coord) =
[
	cos (rotate) * coord[0] + sin (rotate) * coord[1],
	cos (rotate) * coord[1] - sin (rotate) * coord[0]
];

function involute (base_radius, involute_angle) =
[
	base_radius*(cos (involute_angle) + involute_angle*pi/180*sin (involute_angle)),
	base_radius*(sin (involute_angle) - involute_angle*pi/180*cos (involute_angle))
];



