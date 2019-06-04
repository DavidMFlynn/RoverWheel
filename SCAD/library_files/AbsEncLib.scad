// ************************************************
// Absolute Encoder Library
// by David M. Flynn
// Filename: AbsEncLib.scad
// Created: 8/3/2018
// Revision: 1.0.0 8/3/2018
// **********************************************
// History
echo(str("AbsEncLib 1.0.0"));
// 1.0.0 8/3/2018 Copied and updated from CornerPivotPD.scad
// **********************************************
// Routines
// EncoderMount(); // Encoder body, shaft and bolts
// **********************************************


include<CommonStuffSAEmm.scad>

IDXtra=0.2;
$fn=90;

AE_ShaftLen=20;
AE_BodyLen=29;

module EncoderMount(){
		//Encoder shaft
		translate([0,0,-AE_ShaftLen]) cylinder(d=6.35+IDXtra,h=AE_ShaftLen+Overlap);
		//Encoder mount
		translate([0,0,0]) cylinder(d=23+IDXtra,h=3);// mounting plate
		translate([0,0,2]) cylinder(d=24+IDXtra,h=AE_BodyLen-2); // body clearance
		translate([8.5,0,0]) Bolt2Hole();
		translate([-8.5,0,0]) Bolt2Hole();
} // EncoderMount

//EncoderMount();


