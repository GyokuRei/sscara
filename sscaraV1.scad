// Author: Pavlo Gryb (psg416@gmail.com)

use <Modules/Pulley_T-MXL-XL-HTD-GT2_N-tooth.scad>
use <Modules/ISOThread.scad>
use <Modules/Bearings.scad>
use <Modules/EndStoppers.scad>
use <Modules/Write.scad/Write.scad>
include <Modules/MCAD/stepper.scad>
use <Modules/HotEnds.scad>
use <Modules/LCD.scad>
use <Modules/Misc.scad>

//
ex = -65;
ey = 45;
z = 5;
//z = 140;

Linkage_1 = 70;
Linkage_2 = 80;
EndPointMountOffset = 18;
EndPointMountAngle = 50;

//
m5Rclearance = 0.1;
m5Hclearance = 0.2;
b625RClearance = 0.2;
b608Clearance = 0.3;
b6800Clearance = 0.3;
BearingRClearance = 0.3;
outerRad = (80*2/3.14*0.5);

drawHotEnd = 0;//1;
drawArray = [];

// seems like 3rd rod is required 

// more printer friedly layout (note: not all parts are done)
printLayout = 0;


drawSteppers = 1;
drawBelts = 0;
drawZBelts = 0;
drawSwitchesAll = 0;

isExpolode = 0;
pulley1H = 10.5;
pulley2H = 9;
//cylinder(r=4,h=30);
smallHolesDia = 1.55;

endStopArmH = 2.5;

shaftRadius = 5.1/2;
shaftsSegments = 32;
pulleysSpace = 0.5;

bottomArmH = 10;
topArmH = 10;

xStepperX = 25;
xStepperY = 110;
xStepperZ = 32-Bearing625Height();

yStepperX = -25;
yStepperY = 110;
yStepperZ = 32-Bearing625Height();

gearRadToTeethEnd = 10.0/2;//7.3/2;// seems like mk8
gearRad = 11.5/2;// semms like mk8
fillamentD = 1.75;
fillamentPenetration = 0.5;//mm
extruderBearingDia = Bearing623Diameter();
extruderBearingH = Bearing623Height();
extruderClearanceH = 0.2;

armsZ = 250;
armsZExtra = 15;//15;
armsExtruderExtra = 0;
extrudeMountZOffset = 0;

ArmNearestD = 8+9;
ArmNearestW = 14;


zminZCoord = 230;

BedYOffset = 30;
BedYOffsetMarginY = 5;
BedZOffset = BearingLM6UUHeight()+15;

LCDX = -58;
LCDY = -31;
LCDZ = 15;

rodOffsetX = 40;
rodOffsetY = 15;

centerTubeFixerRTop = 8;
centerTubeFixerR = 10;

UpperBearingMountH = 2+3+5;
UpperBearingMountOffset = 2;

// static const part
EX = EndPointMountOffset*cos(EndPointMountAngle)+Linkage_2;
EY = EndPointMountOffset*sin(EndPointMountAngle);
lHp2 = (EX)*(EX)+EY*EY;
lH = sqrt(lHp2);
dhalf = 0.0;
LH3 = Linkage_2/lH;
l2 = Linkage_1 * Linkage_1;
L2 = Linkage_2 * Linkage_2;
echo(EX);
echo(EY);
echo(LH3);


l = Linkage_1;
L = Linkage_2;

//AA = -2 * l * (ex - dhalf);
BB = -2 * l * ey;
//CC = (ex - dhalf) * (ex - dhalf) + ey * ey + l2 - lHp2;
FF = (ex + dhalf) * (ex + dhalf) + ey * ey + l2 - lHp2;
EE = -2  * l * (ex+dhalf);
Det2e = BB * BB - (FF * FF - EE * EE);

qq21e = (-BB + sqrt(Det2e)) / (FF - EE);
q21e = 2 * atan(qq21e);

xxd = -dhalf + l * cos(q21e);
yyd = l * sin(q21e);

echo(lH);
echo(xxd);
echo(yyd);
//color("red") translate([xxd,yyd,200]) cylinder(r=5,h=100);

K = EndPointMountOffset;
echo("K");
echo(K);
echo(lH);
echo(L);
echo("dd-ee");
echo(sqrt((ex-xxd)*(ex-xxd)+(ey-yyd)*(ey-yyd)));

cosa1 = (L*L+lH*lH-K*K)/(2*L*lH);
sina1 = sqrt(1-cosa1*cosa1);
rx = ex-xxd;
ry = ey-yyd;
x = (rx*cosa1+ry*sina1)*LH3+xxd;
y = (-rx*sina1+ry*cosa1)*LH3+yyd;

//x = 0;
//y = 60;// offset from axis to printed area

echo("xy");
echo(x);
echo(y);

//color("red") translate([x,y,200]) cylinder(r=5,h=100);

/*
hull()
{
	cylinder(r=1,h=100);
	translate([xxd,yyd,0]) cylinder(r=1,h=100);
}
*/

A = -2 * l * (x - dhalf);
B = -2 * y * l;
C = (x - dhalf) * (x - dhalf) + y * y + l2 - L2;
F = (x + dhalf) * (x + dhalf) + y * y + l2 - L2;
E = -2  * l * (x+dhalf);
Det1 = B * B - (C * C - A * A);
Det2 = B * B - (F * F - E * E);

qq11 = (-B - sqrt(Det1)) / (C - A);
q11 = 2 * atan(qq11);
//qq12 = (-B + sqrt(Det1)) / (C - A);
//q12 = 2 * atan(qq12);

//qq21 = (-B - sqrt(Det2)) / (F - E);
//q21 = 2 * atan(qq21);
qq22 = (-B + sqrt(Det2)) / (F - E);
q22 = 2 * atan(qq22);

q22Pos = q22 < 0 ? 360+q22 : q22;

echo("q22,q11");
echo(q22Pos);
echo(q11);

xd = -dhalf + l * cos(q22);
yd = l * sin(q22);

xb = -dhalf + l * cos(q11);
yb = l * sin(q11);

hx = xb-xd;
hy = yb-yd;
H = sqrt(hx*hx+hy*hy);
LH = L/H;
cosa = (H*H)/(2*L*H);
sina = -sqrt(1-cosa*cosa);
xxp = (hx*cosa+hy*sina)*LH+xd;
yyp = (-hx*sina+hy*cosa)*LH+yd;

cosz = cos(-EndPointMountAngle);
sinz = sin(-EndPointMountAngle);

echo (cosz);

LH2 = EndPointMountOffset/L;
hhx = xxp-xd;
hhy = yyp-yd;
xp = (hhx*cosz+hhy*sinz)*LH2+xxp;
yp = (-hhx*sinz+hhy*cosz)*LH2+yyp;
//xp = xxp;
//yp = yyp;

echo (hhx);
echo (hhy);

echo("hh");
echo (xp);
echo(yp);
echo("LH2");
echo (LH2);
echo("xd,yd");
echo (xd);
echo(yd);
//color("green") translate([xp,yp,200]) cylinder(r=2,h=100);
//color("blue") translate([xxp,yyp,200]) cylinder(r=3,h=100);
//color("magenta") translate([xb,yb,200]) cylinder(r=1,h=100);
//color("silver") translate([ex,ey,200]) cylinder(r=3,h=100);
//color("magenta") translate([xd,yd,200]) cylinder(r=1,h=100);


WIP = 1;

module DCJack5p5()
{
color("red") difference()
{
	cylinder(d=8,h=20);
	cylinder(d=5.5,h=21);
}
}

module PowerButton()
{
	color("green") cylinder(d=9.5,h=20);
}

module fillet(r, h)
{
    translate([r / 2, r / 2, 0])
       difference() 
			{
            cube([r + 0.01, r + 0.01, h], center = true);

            translate([r/2, r/2, 0])
                cylinder(r = r, h = h + 1, center = true);

        }
}

if( WIP )
{
}

if( drawArray==[] || search(36,drawArray)!=[])
{

	rot = printLayout ? 0 : 0;


translate([0,-20,0]) rotate([0,rot,0]) 
{
	baseH = 85;
	leftOffset = printLayout ? -55 : 11.5;
	union()
	{
	difference()
	{
		union()
		{
				translate([41+5-1+leftOffset+0.5,-53,-1.5]) cube([6.5-0.5,16,baseH+1.5]);
	
			difference()
			{
				translate([43+leftOffset-16.5,-56+3,-1.5]) cube([25,5,baseH+1.5]);
				translate([43+leftOffset-16.5,-56+5,-1.5-1]) cube([5,1.5,baseH+1.5+2]);
			}
			color( "brown") translate([43+leftOffset-5,-60+10+1,-1.5]) cube([9,10,5+1.5]);
			
			translate([45+leftOffset+1,-48,5]) 
						color("magenta") rotate([0,0,45]) scale([1,1,1]) cylinder(r=2.5,h=baseH-5,$fn=16);

			translate([43+leftOffset-5,-56+5+11,-1.5]) cube([7.5,3,baseH+1.5]);

		difference()
			{
				color( "brown") translate([26.5+leftOffset,-60+12,-1.5]) cube([10,8,5+15+1.5]);
				color( "brown") translate([26.5+leftOffset,-60+12,-1.5]) cube([11.5,1,1.5]);
			}
		color( "brown") translate([38+leftOffset,-60+12,-1.5]) cube([8,8,5+1.5+15]);
		color( "green") translate([26.5+leftOffset,-60+12,-1.5+15]) cube([25,8,7]);

			
		translate([-69+1.5,-56+3,0]) cube([8,3,baseH]);
		difference()
		{
				translate([-71+3.5,-51,-1.5]) cube([6,25,baseH+1.5]);
				translate([-71+3.5+2,-51+18+2,-1.5-1]) cube([1.5,5,baseH+1.5+2]);
		}
		//color("blue") translate([-63,-53,5]) cube([109,1.2,baseH-5]);
		//color("green") translate([-64,-56+4,77+5]) cube([109,8,3]);
		translate([-62,-48,5]) 
					color("magenta") rotate([0,0,45]) scale([1,1,1]) cylinder(r=2.5,h=baseH-5,$fn=16);

		difference()
		{
			translate([-69.5+2,-56+3,-1.5]) cube([29.5,5,baseH+1.5]);
			translate([-59+16,-56+5,-1.5-1]) cube([5,1.5,baseH+1.5+2]);
		}
		translate([-69.5+2+6,-56+3+21,-1.5]) cube([8,3,baseH+1.5]);


//
			
		
		difference()
		{
			color( "brown") translate([-48,-60+12,-1.5]) cube([10,8,5+15+1.5]);
			color( "brown") translate([-49.5,-60+12,-1.5]) cube([12,1,1.5]);
		}
		color( "brown") translate([-63,-60+12,-1.5]) cube([13.5,8,5+1.5+15]);
		color( "green") translate([-63,-60+12,-1.5+15]) cube([25,8,7]);
		color( "brown") translate([-63,-60+20,-1.5]) cube([13.5,11,1.5]);
	}
	
					translate([41+5-1+4.5+leftOffset+0.5-2,-42,-1.5-1]) cube([1.5,5,baseH+1.5+2]);
				//translate([41+5-1+4.5+leftOffset+0.5-2,-47.5,-1.5-1]) cube([1.5,5,15+2]);

	
	
		translate([31.5+leftOffset,-44,-1.5-1]) 
					color("red") rotate([0,0,0]) scale([1,1,1]) cylinder(r=1.51,h=50,$fn=16);
		translate([-42,-44,-1.5-1]) 
					color("red") rotate([0,0,0]) scale([1,1,1]) cylinder(r=1.51,h=50,$fn=16);

		//
		translate([46+leftOffset,-48,-3]) 
					color("red") rotate([0,0,0]) scale([1,1,1]) cylinder(r=1.51,h=150,$fn=16);
		translate([46+leftOffset,-48,-1.5-0.1]) 
					color("red") rotate([0,0,-20]) scale([1,1,1]) cylinder(d=rolson_hex_nut_dia(3)+1,h=3.5+2,$fn=6);
		translate([-62,-48,-0.10]) 
					color("red") rotate([0,0,0]) scale([1,1,1]) cylinder(r=1.51,h=150,$fn=16);
		translate([-62,-48,-1.5-0.1]) 
					color("red") rotate([0,0,17]) scale([1,1,1]) cylinder(d=rolson_hex_nut_dia(3)+1,h=3.5,$fn=6);


	color("silver") 
	{
		translate([-58,-35,5]) rotate([-90,0,0]) scale([1,1,1]) cylinder(d=3.1,h=254,$fn=16);
		translate([-58,-35,79]) rotate([-90,0,0]) scale([1,1,1]) cylinder(d=3.1,h=254,$fn=16);

		translate([42+leftOffset,-55+9,5]) rotate([-90,0,0]) scale([1,1,1]) cylinder(d=3.1,h=254,$fn=16);
		translate([42+leftOffset,-55+9,79]) rotate([-90,0,0]) scale([1,1,1]) cylinder(d=3.1,h=254,$fn=16);

	}



		hull()
	{
		translate([42+leftOffset,-55+15,5]) 
					color("red") rotate([90,0,0]) scale([1,1,1]) cylinder(d=rolson_hex_nut_dia(3)+1,h=3.5,$fn=6);
		translate([42+leftOffset,-55+15,-30]) 
					color("red") rotate([90,0,0]) scale([1,1,1]) cylinder(d=rolson_hex_nut_dia(3)+1,h=3.5,$fn=6);
	}
		// button
		translate([-63,-39,30]) rotate([0,90,0]) cylinder(d=13,h=15);
		translate([-70,-39,30]) rotate([0,90,0]) cylinder(d=9.8,h=15);


// jack place
//translate([20+leftOffset,-50,15]) rotate([90,0,0]) cylinder(d=8,h=20);


translate([-67.5,-56+3,50-5]) fillet(r=6,h=150);
translate([52.5-1+leftOffset,-56+3,50-5]) rotate([0,0,90]) fillet(r=6,h=150);

translate([0+leftOffset,-56,-1.5]) rotate([90,0,90]) fillet(r=3,h=150);

	}
	}
	//sphere(r=1);
}

//

}

module Part37(LAlumOffset=0)
{
{
	baseH = 85;
	leftOffset = printLayout ? -55 : 11.5;
	union()
	{
	difference()
	{
		rotate([0,0,0])  union()
		{
			translate([41+5-1+leftOffset+0.5,-53,-1.5]) cube([6.5-0.5,16,baseH+1.5]);
	
			color( "blue") difference()
			{
				translate([43+leftOffset-16.5-5-LAlumOffset/2,-45+3,-1.5]) cube([30,5,baseH+1.5]);
				translate([43+leftOffset-16.5-5-LAlumOffset/2,-45+5,-1.5-1]) cube([5,1.5,baseH+1.5+2]);
			}
			color( "brown") translate([43+leftOffset-5-LAlumOffset/2,-62+10+2,-1.5]) cube([9+LAlumOffset/2,10,5+1.5]);
			
			translate([45+leftOffset+1,-42,5]) 
						color("magenta") rotate([0,0,45]) scale([1,1,1]) cylinder(r=2.5,h=baseH-5,$fn=16);

			translate([43+leftOffset-5,-69+5+11,-1.5]) cube([7.5,3,baseH+1.5]);
			translate([43+leftOffset-19.5-2-LAlumOffset/2,-66+5+11,-1.5]) cube([3,8,baseH+1.5-15]);

			difference()
			{
				color( "brown") translate([26.5+leftOffset-2-LAlumOffset/1.2,-62+12,-1.5]) cube([10+2+LAlumOffset/3,8,5+15+1.5]);
				color( "yellow") translate([26.5+leftOffset-5-LAlumOffset/2,-55+12,-1.5]) cube([11.5+5,1,1.5]);
			}
			color( "brown") translate([38+leftOffset-LAlumOffset/2,-62+12,-1.5]) cube([8+LAlumOffset/2,8,5+1.5+15]);
			color( "green") translate([26.5+leftOffset-2-LAlumOffset/2,-62+12,-1.5+15]) cube([25+2+LAlumOffset/2,8,7]);
	}
	
					translate([41+5-1+4.5+leftOffset+0.5-2,-53,-1.5-1]) cube([1.5,5,baseH+1.5+2]);
	
		// bottom holes
		translate([31.5+leftOffset-LAlumOffset/2,-46,-1.5-1]) 
					color("red") rotate([0,0,0]) scale([1,1,1]) cylinder(r=1.51,h=50,$fn=16);
		translate([-42,-46,-1.5-1]) 
					color("red") rotate([0,0,0]) scale([1,1,1]) cylinder(r=1.51,h=50,$fn=16);

		//
		translate([46+leftOffset,-42,-3]) 
					color("red") rotate([0,0,0]) scale([1,1,1]) cylinder(r=1.51,h=150,$fn=16);
		translate([46+leftOffset,-42,-1.5-0.1]) 
					color("red") rotate([0,0,-20]) scale([1,1,1]) cylinder(d=rolson_hex_nut_dia(3)+1,h=3.5+2,$fn=6);
		
	
	
	translate([-62,-48,-0.10]) 
					color("red") rotate([0,0,0]) scale([1,1,1]) cylinder(r=1.51,h=150,$fn=16);
		translate([-62,-48,-1.5-0.1]) 
					color("red") rotate([0,0,17]) scale([1,1,1]) cylinder(d=rolson_hex_nut_dia(3)+1,h=3.5,$fn=6);


	color("silver") 
	{
		translate([-58,-35,5]) rotate([-90,0,180]) scale([1,1,1]) cylinder(d=3.1,h=254,$fn=16);
		translate([-58,-35,79]) rotate([-90,0,180]) scale([1,1,1]) cylinder(d=3.1,h=254,$fn=16);

		translate([42+leftOffset,-55+9,5]) rotate([-90,0,180]) scale([1,1,1]) cylinder(d=3.1,h=254,$fn=16);
		translate([42+leftOffset,-55+9,79]) rotate([-90,0,180]) scale([1,1,1]) cylinder(d=3.1,h=254,$fn=16);

	}


	color("silver") 
	{
		translate([42+leftOffset-13,-55+9,5]) rotate([-90,0,90]) scale([1,1,1]) cylinder(d=3.1,h=254,$fn=16);
		translate([42+leftOffset-13,-55+9,35]) rotate([-90,0,90]) scale([1,1,1]) cylinder(d=3.1,h=254,$fn=16);
		translate([42+leftOffset,-55+9,64]) rotate([-90,0,90]) scale([1,1,1]) cylinder(d=3.1,h=254,$fn=16);

	}


	hull()
	{
		translate([42+leftOffset,-62+15,5]) 
					color("red") rotate([90,0,0]) scale([1,1,1]) cylinder(d=rolson_hex_nut_dia(3)+1,h=3.5,$fn=6);
		translate([42+leftOffset,-62+15,-30]) 
					color("red") rotate([90,0,0]) scale([1,1,1]) cylinder(d=rolson_hex_nut_dia(3)+1,h=3.5,$fn=6);
	}


	hull()
	{
		translate([25+leftOffset-LAlumOffset/2,-62+16,5]) 
					color("red") rotate([90,0,90]) scale([1,1,1]) cylinder(d=rolson_hex_nut_dia(3)+1,h=3.5,$fn=6);
		translate([25+leftOffset-LAlumOffset/2,-62+16,-30]) 
					color("red") rotate([90,0,90]) scale([1,1,1]) cylinder(d=rolson_hex_nut_dia(3)+1,h=3.5,$fn=6);
	}

//translate([-67.5,-56+3,50-5]) fillet(r=6,h=150);

translate([52.5-1+leftOffset,-40+3,50-5]) rotate([0,0,180]) fillet(r=6,h=150);

	}
	}
	//sphere(r=1);
}
}

//translate([-40,131,-10]) cylinder(r=14,h=5,$fn=4);

if( drawArray==[] || search(37,drawArray)!=[] )
{
	yoffset = 187;
		rot = printLayout ? 90 : 0;
		xoffset = printLayout ? -58 : 0;


translate([xoffset,yoffset,0]) rotate([0,0,rot]) 
{
	Part37();
}
mirror() translate([xoffset+4.5,yoffset,0]) rotate([0,0,rot]) 
{
	Part37(9);
}
}

if( drawArray==[] )
{
	translate([LCDX,LCDY,LCDZ]) LCD20x4SmartController();
}

if( drawArray==[] || search(34,drawArray)!=[] )
{
	rot = printLayout ? 90 : 0;

	offsetS = 1;
	rotate([rot,0,0]) 
	difference()
	{
		color( "green") union()
		{
			translate([-53.5,LCDY-offsetS,0]) cube([4,8,73]);
			translate([-48,LCDY-offsetS,5]) cube([4,8,15]);
			hull()
			{
				translate([-49,LCDY-offsetS,13.5]) cube([4,8,7]);
				translate([-52,LCDY-offsetS,13.5]) cube([4,8,7]);
				translate([-52,LCDY-offsetS,43.5]) cube([1,8,3]);
			}
		}
		translate([LCDX,LCDY,LCDZ]) LCD20x4SmartController(1);
		hull()
		{
			translate([-44,LCDY+offsetS+7,14.5]) scale([1,1,1]) rotate([90,45,0]) cylinder(d=8,h=4,$fn=4);
			translate([-39,LCDY+offsetS,14.5]) scale([1,1,1]) rotate([90,45,0]) cylinder(d=8,h=6,$fn=4);
			//#translate([-44,LCDY+offsetS-2,11.5]) scale([1,1,1]) cylinder(d=4,h=6);
			//#translate([-42,LCDY-offsetS,12]) scale([1,1,0.7]) cylinder(d=2,h=6);
		}
				color("red") translate([LCDX,LCDY+3,LCDZ-7]) rotate([0,90,0]) cylinder(d=3,h=150,$fn=12);

	}
	dist = printLayout ? -145 : 0;
	dist2 = printLayout ? -15 : 0;
	translate([dist2,0,dist]) 	 rotate([rot,0,0]) difference() 
	{
		color( "green") union()
		{
			translate([-53.5,LCDY+144,0]) cube([4,8,73]);
			translate([-48,LCDY+144,5]) cube([4,8,6+5]);
			hull()
			{
				translate([-48,LCDY+144,13]) cube([4,8,1]);
				translate([-52,LCDY+144,13]) cube([4,8,1]);
				translate([-52,LCDY+144,35]) cube([1,8,3]);
			}
		}
		translate([LCDX,LCDY,LCDZ]) LCD20x4SmartController(1);
				color("red") translate([LCDX,LCDY+148,LCDZ-7]) rotate([0,90,0]) cylinder(d=3,h=150,$fn=12);
	}
}

module LAlum(len=200)
{
	cube([1.5,len,15]);
	cube([15,len,1.5]);
}

module LAlum10x10x1p2(len=200,extraThickness=0)
{
	color("silver")
	{
		cube([1.2+extraThickness,len,10]);
		cube([10,len,1.2+extraThickness]);
	}
}

if(  drawArray==[] )
{
	translate([-50.2,7,z+10+75+1]) rotate([0,90,0]) LAlum10x10x1p2(150-15);
	translate([50.3,7,z+10+75+1]) rotate([0,180,0]) LAlum10x10x1p2(150-15);
}

if( drawArray==[] || search(35,drawArray)!=[] )
{
	aY = printLayout ? 15 : 137;
	aZ = printLayout ? 81 : 82+z;
	rY = printLayout ? -90 : 0;
	translate([0,aY,aZ]) rotate([rY,0,0])
	{
		difference()
		{
			union()
			{
			translate([0,0,0]) cube([98.6,10,6],center=true);
			translate([0,6,-1]) cube([101,2,	10],center=true);
			}
		translate([45,0,-10]) cylinder(r=1.51,h=30,$fn=12);
		translate([-45,0,-10]) cylinder(r=1.51,h=30,$fn=12);
		translate([0,0,-10]) cylinder(r=1.51,h=30,$fn=12);
		translate([35,0,-10]) cylinder(r=1.51,h=30,$fn=12);
		translate([-35,0,-10]) cylinder(r=1.51,h=30,$fn=12);
		translate([16,0,-10]) cylinder(r=1.51,h=30,$fn=12);
		translate([-16,0,-10]) cylinder(r=1.51,h=30,$fn=12);
		}
	}
	offsZ = 79+z;
	offsY = 30.5;
	translate([0,offsY,offsZ])
	{
		difference()
		{
			union()
			{
			translate([0,0,0]) cube([74.6,9,10],center=true);
			//translate([-32.5,-1,0]) cube([9,10,10],center=true);
			//translate([32.5,-1,0]) cube([9,10,10],center=true);
			}
			translate([0,-5.5,0]) cube([9,4,11],center=true);
		translate([44,0,-10]) cylinder(r=1.51,h=30,$fn=12);
		translate([-44,0,-10]) cylinder(r=1.51,h=30,$fn=12);
		translate([0,0,-10]) cylinder(r=1.51,h=30,$fn=12);
			translate([0,-offsY,-offsZ]) 	translate([-rodOffsetX,rodOffsetY,65]) HolesBearingMount();
			mirror() translate([0,-offsY,-offsZ]) 	translate([-rodOffsetX,rodOffsetY,65]) HolesBearingMount();
		translate([27,0,-10]) cylinder(r=1.51,h=30,$fn=12);
		translate([-27,0,-10]) cylinder(r=1.51,h=30,$fn=12);
		translate([16,0,-10]) cylinder(r=1.51,h=30,$fn=12);
		translate([-16,0,-10]) cylinder(r=1.51,h=30,$fn=12);
		}
	}
}
if(  drawArray==[] )
{
	color("silver") translate([-49.5,-68,-1.5]) LAlum(213);
	mirror() color("silver") translate([-49.5,-68,-1.5]) LAlum(213);
}
// extruder
if( drawArray==[] || search(23,drawArray)!=[] )
{
	aY = printLayout ? 0 : 65+90;
	aYY = printLayout ? 180 : -90;
	armX = printLayout ? 12 :0;
	armY = printLayout ? -38 : 0;
	armZ = printLayout ? -26.15 : 0;
	armRZ = printLayout ? 205.5 : 0;
	armRX = printLayout ? 90 : 0;
	armTX = printLayout ? 10 : 0;
	translate ([0,-37,222+armsExtruderExtra]) rotate([0,aYY,180]) rotate([0,0,aY]) mirror()//rotate([90,0,0]) 
	{
		armH = extruderBearingH+3+3;
		partsOffset = -13;
		if( !printLayout )
		{
			rotate([0,0,90]) Nema17_shaft24_Stepper();
		}
		translate([0,0,-3])
		{
			difference()
			{
				//cube([36,36,4]);
				hull()
				{
					translate([-14,-14,0]) cylinder(r=7.5,h=4);
					translate([14,-14,0]) cylinder(r=7.5,h=4);
					translate([14,14,0]) cylinder(r=7.5,h=4);
					translate([-14,14,0]) cylinder(r=7.5,h=4);
					translate([24.5+extrudeMountZOffset,9,0]) cylinder(r=7.5,h=4);
				}
				extr = lookup(NemaRoundExtrusionDiameter, Nema17);
				color ("red") translate([0,0,1.5]) cylinder(d=extr+0.5,h=2.5,$fn=32);
				color ("red") translate([0,0,2]) Nema17_shaft24_Stepper(bSrewsOnly=1);
				//extruder mount
				translate([27,10.5,-30+extrudeMountZOffset]) color("red") rotate([0,0,0]) cylinder(d=3.1,h=50,$fn=16);
				translate([25.4,3.5,-30+extrudeMountZOffset]) color("red") rotate([0,0,0]) cylinder(d=3.1,h=50,$fn=16);
			}
			difference()
			{
				color ("red")  translate([gearRadToTeethEnd-1,-12,-armH]) cube([11,14,armH]);
				color( "green") translate([0,-gearRadToTeethEnd-Bearing623Diameter()/2-fillamentD/2,partsOffset+3-2]) cylinder(d=extruderBearingDia+3,h=armH+2);
				color( "green") translate([0,0,partsOffset+3-2]) cylinder(d=gearRad*2+1,h=armH+2);

				// cone
				color( "red") translate([3.9,-gearRadToTeethEnd-fillamentD/2+fillamentPenetration,-armH/2]) rotate([0,90,0]) cylinder(r2=fillamentD/2-0.2,r1=fillamentD/2+1.5,h=2,$fn=16);
				
				// fillamant
				color( "blue") translate([-50,-gearRadToTeethEnd-fillamentD/2+fillamentPenetration,-armH/2]) rotate([0,90,0]) cylinder(d=fillamentD+0.2,h=100,$fn=16);
				color( "blue") translate([10,-gearRadToTeethEnd-fillamentD/2+fillamentPenetration,-armH/2]) rotate([0,90,0]) cylinder(d=9,h=100,$fn=16);
				//
			}
			difference()
			{
				union()
				{
				color( "green") hull()
				{
					translate([15.5,-4.5-gearRadToTeethEnd-Bearing623Diameter()/2-fillamentD/2,partsOffset+3]) cylinder(d=8,h=armH+4);
					translate([20.5,-6.5-gearRadToTeethEnd-Bearing623Diameter()/2-fillamentD/2,partsOffset+3]) cylinder(d=8,h=armH+4);
				}
				color( "green") hull()
				{
					translate([15.5,-4.5-gearRadToTeethEnd-Bearing623Diameter()/2-fillamentD/2,partsOffset+3]) cylinder(d=8,h=armH+4);
					translate([9,-1-gearRadToTeethEnd-Bearing623Diameter()/2-fillamentD/2,partsOffset+3]) cylinder(d=4.5,h=armH+4);
				}
				}
				color ("red") translate([0,0,2]) Nema17_shaft24_Stepper(bSrewsOnly=1);
				//M3 HOLE
				color( "blue") translate([27,0,-armH/2]) rotate([90,0,0]) rotate([0,-25,0])  cylinder(d=4,h=100,$fn=16);
			}
			difference()
			{
				color ("red")  translate([-gearRadToTeethEnd-15,-12,-armH]) cube([15,14,armH]);
				color( "green") translate([0,0,partsOffset+3-2]) cylinder(d=gearRad*2+1,h=armH+2);
				color( "blue") hull()
				{
						translate([0,-gearRadToTeethEnd-Bearing623Diameter()/2-fillamentD/2,partsOffset+3-2]) cylinder(d=extruderBearingDia+3,h=armH+2);
						translate([0,-5-gearRadToTeethEnd-Bearing623Diameter()/2-fillamentD/2,partsOffset+3-2]) cylinder(d=extruderBearingDia+3,h=armH);
						translate([-3,-5-gearRadToTeethEnd-Bearing623Diameter()/2-fillamentD/2,partsOffset+3-2]) cylinder(d=extruderBearingDia+4,h=armH);
				}
				color( "blue") hull()
				{
					 translate([-15.5,-15.5,partsOffset+3-2]) cylinder(d=11+3,h=armH+2);
					 translate([-11.5,-15.5,partsOffset+3-2]) cylinder(d=11+3,h=armH+2);
				}
				// fillamant
				color( "blue") translate([-50,-gearRadToTeethEnd-fillamentD/2+fillamentPenetration,-armH/2]) rotate([0,90,0]) cylinder(d=fillamentD+0.2,h=100,$fn=16);
			}
		}
		//#color ("red") translate([0,0,0]) cube([10,10,10]);
		translate([armX,armY,armZ]) rotate([armRX,0,0])  rotate([0,0,armRZ]) translate([0,0,partsOffset])
		{
			difference()
			{
				union()
				{
					color( "green") hull()
					{
						color( "green") translate([-15.5,-15.5,0]) cylinder(d=11+2,h=armH);
						//#color( "green") translate([-12,-gearRadToTeethEnd-Bearing623Diameter()/2-fillamentD/2,0]) cylinder(d=extruderBearingDia+6,h=armH);
					}
					color( "magenta") hull()
					{
						translate([0,-gearRadToTeethEnd-Bearing623Diameter()/2-fillamentD/2,0]) cylinder(d=extruderBearingDia+2,h=armH);
						translate([0,-5-gearRadToTeethEnd-Bearing623Diameter()/2-fillamentD/2,0]) cylinder(d=extruderBearingDia+3,h=armH);
						translate([-3,-5-gearRadToTeethEnd-Bearing623Diameter()/2-fillamentD/2,0]) cylinder(d=extruderBearingDia+3,h=armH);
					}
					color( "green") hull()
					{
						translate([-15.5,-15.5,0]) cylinder(d=11+2,h=armH);
						translate([15,-30,0]) cylinder(d=11+2,h=armH);
					}
				}
				// bearing hole
				color( "silver")hull()
				{
					translate([0,-gearRadToTeethEnd-Bearing623Diameter()/2-fillamentD/2,(armH-Bearing623Height())/2-extruderClearanceH]) cylinder(r=Bearing623Diameter()/2+1.5,h=Bearing623Height()+extruderClearanceH*2,$fn=32);
					translate([0,10-gearRadToTeethEnd-Bearing623Diameter()/2-fillamentD/2,(armH-Bearing623Height())/2-extruderClearanceH]) cylinder(r=Bearing623Diameter()/2+1.5,h=Bearing623Height()+extruderClearanceH*2,$fn=32);
				}
				// fillamant hole
				color( "blue") translate([-50,-gearRadToTeethEnd-fillamentD/2+fillamentPenetration,armH/2]) rotate([0,90,0]) cylinder(d=fillamentD+0.2,h=100,$fn=16);
				// bearing shaft
				color( "silver") translate([0,-gearRadToTeethEnd-Bearing623Diameter()/2-fillamentD/2,-5]) cylinder(d=3.1,h=20,$fn=16);
				//
				color( "silver") hull()
				{
					translate([0,-gearRadToTeethEnd-Bearing623Diameter()/2-fillamentD/2,(armH-Bearing623Height())/2-0.5-0.1]) cylinder(d=8,h=0.5,$fn=16);
					translate([0,10-gearRadToTeethEnd-Bearing623Diameter()/2-fillamentD/2,(armH-Bearing623Height())/2-0.5-0.1]) cylinder(d=8,h=0.5,$fn=16);
				}
				//
				color( "silver") hull()
			{
				translate([0,-gearRadToTeethEnd-Bearing623Diameter()/2-fillamentD/2,(armH-Bearing623Height())/2+Bearing623Height()+0.1]) cylinder(d=8,h=0.5,$fn=16);
				translate([0,10-gearRadToTeethEnd-Bearing623Diameter()/2-fillamentD/2,(armH-Bearing623Height())/2+Bearing623Height()+0.1]) cylinder(d=8,h=0.5,$fn=16);
			}
				color( "silver") translate([-15.5,-15.5,-5]) cylinder(d=3.05,h=40,$fn=16);
			// gear hole
			color( "green") translate([0,0,-1]) cylinder(d=gearRad*2+1,h=armH+2);
			// M3 HOLE
			color( "blue") translate([27,0,armH/2]) rotate([90,0,0]) rotate([0,-25,0])  cylinder(d=4,h=100,$fn=16);
			//color( "blue") translate([27,0,armH/2]) rotate([90,0,0]) rotate([0,-25,0])  cylinder(d=4,h=100,$fn=16);

			}
		}
		translate([0,0,partsOffset])
		{
			if( !printLayout )
			{
				color( "silver") translate([0,-gearRadToTeethEnd-Bearing623Diameter()/2-fillamentD/2,armH/4-0.5]) Bearing623();
			}
			if( !printLayout )
			{
				// gear
				color( "black") translate([0,0,0]) cylinder(r=gearRad,h=10);
			}
				// fillament
			if( !printLayout )
			{
				color( "blue") translate([-50,-gearRadToTeethEnd-fillamentD/2+fillamentPenetration,armH/2]) rotate([0,90,0]) cylinder(d=fillamentD,h=100,$fn=16);
			}
		}
	}
}


// hot end
if( drawArray==[] || drawHotEnd!=0 )
{
	translate ([xp,yp,armsZ+armsZExtra+31])
	{
		rotate([180,0,0]) heatsinkE3DV5(0,100);

//		color("red") cylinder(r=5,h=40);
//		translate ([0,0,-6])
//			color("red") cylinder(r1=1,r2=5,h=6);
//		translate ([-5,-7,0])
//			color("red") cube([16,16,12]);
		//translate ([10,10,10]) color("red") cylinder(r=5,h=40);
	}
}

// bottom arm
if( drawArray==[] || search(24,drawArray)!=[])
{
		a = printLayout ? 0 : q22;
	ax = printLayout ? 0 : 0;

	translate ([0,0,armsZ+armsZExtra]) rotate([ax,0,a])
	{
		///*
		//cylinder(r=Bearing623Diameter()+2,h=bottomArmH+Bearing625Height());
		difference()
		{
			union()
			{
				hull()
				{
					cylinder(r=ArmNearestD/2,h=bottomArmH);
					translate([Linkage_1*0.15,0,0]) cylinder(r=ArmNearestW/2,h=bottomArmH);
				}
				hull()
				{
					cylinder(r=ArmNearestW/2,h=bottomArmH);
					translate([Linkage_1,0,0]) cylinder(r=ArmNearestW/2,h=bottomArmH);
				}
				hull()
				{
					translate([Linkage_1*0.85,0,0]) cylinder(r=ArmNearestW/2,h=bottomArmH);
					translate([Linkage_1,0,0]) cylinder(r=ArmNearestD/2,h=bottomArmH);
				}
				translate([6,6,bottomArmH/2]) rotate([90,0,0]) cylinder(d=rolson_hex_nut_dia(3)+1,h=12,$fn=12);
			}
			translate([Linkage_1,0,1]) cylinder(d=Bearing623Diameter()+0.2,h=bottomArmH+2);
			translate([Linkage_1,0,-1]) cylinder(d=rolson_hex_nut_dia(3)+1,h=bottomArmH+2);
			//translate([0,0,1]) cylinder(d=Bearing623Diameter()+0.2,h=bottomArmH+2);
			translate([0,0,-1]) cylinder(r=4,h=bottomArmH+2,$fn=24);
			color("blue") translate([0,0,bottomArmH-1]) cylinder(d=BearingF512MDiameter()+BearingRClearance*2,h=1+1,$fn=24);
			translate([0,-0.5,-1]) cube([10.5,1,bottomArmH+2]);
			color("red") translate([6,50,bottomArmH/2]) rotate([90,0,0]) cylinder(r=1.51,h=100,$fn=24);
			color("red") translate([6,16,bottomArmH/2]) rotate([90,0,0]) cylinder(d=rolson_hex_nut_dia(3)+1,h=10,$fn=12);
			color("red") translate([6,-6,bottomArmH/2]) rotate([90,0,0]) cylinder(d=rolson_hex_nut_dia(3)+1,h=10,$fn=12);
		//
			translate([Linkage_1*0.35,0,0]) cylinder(d=3,h=bottomArmH+2,$fn=23);
			translate([Linkage_1*0.70,0,0]) cylinder(d=3,h=bottomArmH+2,$fn=23);

		}
		if( drawArray==[] )
		{
			translate([Linkage_1,0,1]) Bearing623();
			translate([Linkage_1,0,1+Bearing623Height()]) Bearing623();
			color("silver") translate([Linkage_1,0,1+Bearing623Height()+Bearing623Height()]) hex_nut(5);
		}
	//*/
	}

		a1 = printLayout ? 0 : q22;
	ay1 = printLayout ? 23 : 0;
az1 = printLayout ? -35 : 0;

	translate ([0,ay1,armsZ+armsZExtra+35+az1]) rotate([0,0,a1])
	{
		//cylinder(r=Bearing623Diameter()+2,h=bottomArmH+Bearing625Height());
		difference()
		{
			union()
			{
				hull()
				{
					cylinder(d=Bearing625Diameter()+5,h=bottomArmH);
					translate([2,0,0]) cylinder(d=Bearing625Diameter()+5,h=bottomArmH);
					translate([Linkage_1*0.15,0,0]) cylinder(r=ArmNearestW/2,h=bottomArmH);
				}
				hull()
				{
					cylinder(r=ArmNearestW/2,h=bottomArmH);
					translate([Linkage_1,0,0]) cylinder(r=ArmNearestW/2,h=bottomArmH);
				}
				hull()
				{
					translate([Linkage_1*0.85,0,0]) cylinder(r=ArmNearestW/2,h=bottomArmH);
					translate([Linkage_1,0,0]) cylinder(r=ArmNearestD/2,h=bottomArmH);
				}
				translate([6,6,bottomArmH/2]) rotate([90,0,0]) cylinder(d=rolson_hex_nut_dia(3)+1,h=12,$fn=12);
			translate([-13,0,bottomArmH/2]) rotate([0,90,0]) cylinder(d=rolson_hex_nut_dia(3)+3.5,h=13,$fn=24);
			}
			translate([Linkage_1,0,1]) cylinder(d=Bearing623Diameter()+0.2,h=bottomArmH+2);
			translate([Linkage_1,0,-1]) cylinder(d=rolson_hex_nut_dia(3)+1,h=bottomArmH+2);
			//translate([0,0,1]) cylinder(d=Bearing623Diameter()+0.2,h=bottomArmH+2);
			translate([0,0,-1]) cylinder(d=rolson_hex_nut_dia(5)+1,h=bottomArmH+2);
			hull()
			{
			color("blue") translate([0,0,2]) cylinder(d=Bearing625Diameter()+BearingRClearance*2,h=bottomArmH);
			color("blue") translate([2,0,2]) cylinder(d=Bearing625Diameter()+BearingRClearance*2,h=bottomArmH);
			}
				// mount holes
			translate([5,-0.5,0]) cube([12.5,1,bottomArmH+2]);
			color("red") translate([12,50,bottomArmH/2]) rotate([90,0,0]) cylinder(r=1.51,h=100,$fn=24);
			color("red") translate([12,17,bottomArmH/2]) rotate([90,0,0]) cylinder(d=rolson_hex_nut_dia(3)+1,h=11,$fn=12);
			color("red") translate([12,-6,bottomArmH/2]) rotate([90,0,0]) cylinder(d=rolson_hex_nut_dia(3)+1,h=13,$fn=24);
			color("red") translate([-18,0,bottomArmH/2]) rotate([0,90,0]) cylinder(d=3,h=13,$fn=24);
			color("red") translate([-10,0,bottomArmH/2]) rotate([0,90,0]) cylinder(d=rolson_hex_nut_dia(3)+0.5,h=13,$fn=6);
						// mount holes 2
			translate([Linkage_1-11,-0.5,0]) cube([12.5,1,bottomArmH+2]);
			color("red") translate([Linkage_1-7,50,bottomArmH/2]) rotate([90,0,0]) cylinder(r=1.51,h=100,$fn=24);
			color("red") translate([Linkage_1-7,17,bottomArmH/2]) rotate([90,0,0]) cylinder(d=rolson_hex_nut_dia(3)+1,h=10,$fn=12);
			color("red") translate([Linkage_1-7,-6,bottomArmH/2]) rotate([90,0,0]) cylinder(d=rolson_hex_nut_dia(3)+1,h=10,$fn=12);

			translate([Linkage_1*0.35,0,0]) cylinder(d=3,h=bottomArmH+2,$fn=23);
			translate([Linkage_1*0.70,0,0]) cylinder(d=3,h=bottomArmH+2,$fn=23);


		}
		if( drawArray==[] )
		{
			translate([Linkage_1,0,1]) Bearing623();
			translate([Linkage_1,0,1+Bearing623Height()]) Bearing623();
			color("silver") translate([Linkage_1,0,1+Bearing623Height()+Bearing623Height()]) hex_nut(5);
		}
	}
}

if( drawArray==[] )
{
	translate ([0,0,armsZ+bottomArmH+armsZExtra-1])
	{
		BearingF512M();
		color("silver") translate ([0,0,4]) rolson_hex_nut(5);
	}
}


if( drawArray==[] || search(27,drawArray)!=[])
{
	xd = -dhalf + l * cos(q22);
  yd = l * sin(q22);
	a = printLayout ? 0 : atan((y-yd)/(x-xd));
	mountRotZ = -90;
	translate ([xd,yd,armsZ+bottomArmH+armsZExtra+2.5])
		rotate([0,0,a]) 
	{
		color("brown") difference()
		{
			union()
			{
				color("blue") 
				hull()
				{
					cylinder(r=ArmNearestD/2,h=bottomArmH);
					translate([Linkage_1*0.15,0,0]) cylinder(r=ArmNearestW/2,h=bottomArmH);
				}

				color("blue") 
				hull() 
				{
					cylinder(r=ArmNearestW/2,h=bottomArmH);
					translate([Linkage_2,0,0]) cylinder(r=ArmNearestW/2,h=bottomArmH);
				}

				color("blue") 
				hull()
				{
					translate([Linkage_2,0,0]) cylinder(r=ArmNearestD/2,h=bottomArmH);
					translate([Linkage_2*0.85,0,0]) cylinder(r=ArmNearestW/2,h=bottomArmH);
				}
								color("red") 
				hull()
				{
					translate([Linkage_2,0,0]) cylinder(r=ArmNearestD/2,h=bottomArmH);
					translate([Linkage_2,0,0]) rotate([0,0,EndPointMountAngle]) translate([EndPointMountOffset,0,0]) cylinder(d=16+6,h=bottomArmH);
				}
				color("red") hull()
				{
					translate([Linkage_2,0,0]) rotate([0,0,EndPointMountAngle]) translate([EndPointMountOffset,0,0])
					{
						cylinder(d=16+6,h=bottomArmH);
						rotate([0,0,mountRotZ]) translate([8,0,0]) cylinder(d=10,h=bottomArmH);
					}
				}
				translate([Linkage_2,0,0]) rotate([0,0,EndPointMountAngle]) translate([EndPointMountOffset,0,0]) rotate([0,0,mountRotZ]) translate([0,-4,0]) cube([16,8,bottomArmH]);

				//translate([Linkage_2-13,6,bottomArmH/2]) rotate([90,0,0]) cylinder(d=rolson_hex_nut_dia(3)+1,h=12,$fn=12);
			}
			translate([Linkage_2,0,-1]) cylinder(d=8,h=30,$fn=32);
			translate([Linkage_2,0,+1]) cylinder(d=Bearing623Diameter()+0.2,h=bottomArmH,$fn=32);
			translate([0,0,-1]) cylinder(d=3.0,h=30,$fn=32);

			//translate([Linkage_2-20,-0.5,-1]) cube([20.5,1,bottomArmH+2]);
			//color("red") translate([Linkage_2-13,50,bottomArmH/2]) rotate([90,0,0]) cylinder(r=1.51,h=100);
			//color("red") translate([Linkage_2-13,16,bottomArmH/2]) rotate([90,0,0]) cylinder(d=rolson_hex_nut_dia(3)+1,h=10,$fn=12);
			//color("red") translate([Linkage_2-13,-6,bottomArmH/2]) rotate([90,0,0]) cylinder(d=rolson_hex_nut_dia(3)+1,h=10,$fn=12);
		// end effector arm
		translate([Linkage_2,0,0]) rotate([0,0,EndPointMountAngle]) translate([EndPointMountOffset,0,bottomArmH/2])  rotate([0,0,mountRotZ])  translate([13,10,0]) rotate([90,0,0])  cylinder(d=3,h=30,$fn=12);

				translate([Linkage_2,0,0]) rotate([0,0,EndPointMountAngle]) translate([EndPointMountOffset,0,bottomArmH/2]) rotate([0,0,mountRotZ])  translate([13,10,0]) rotate([90,0,0])   cylinder(d=rolson_hex_nut_dia(3),h=3+3,$fn=12);

				translate([Linkage_2,0,0]) rotate([0,0,EndPointMountAngle])  translate([EndPointMountOffset,0,bottomArmH/2]) rotate([0,0,mountRotZ])  translate([13,-4,0]) rotate([90,0,0])  cylinder(d=rolson_hex_nut_dia(3),h=3+3,$fn=12);

			//translate([Linkage_2-20,-0.5,-1]) cube([20.5,1,bottomArmH+2]);
			//color("red") translate([Linkage_2-13,50,bottomArmH/2]) rotate([90,0,0]) cylinder(r=1.51,h=100);
			//color("red") translate([Linkage_2-13,16,bottomArmH/2]) rotate([90,0,0]) cylinder(d=rolson_hex_nut_dia(3)+1,h=10,$fn=12);
			//color("red") translate([Linkage_2-13,-6,bottomArmH/2]) rotate([90,0,0]) cylinder(d=rolson_hex_nut_dia(3)+1,h=10,$fn=12);
			
			translate([Linkage_2,0,0]) rotate([0,0,EndPointMountAngle]) translate([EndPointMountOffset,0,0]) rotate([0,0,mountRotZ]) translate([0,-0.5,0]) cube([20,1,20]);
		// hot end mount hole
			color("silver") translate([Linkage_2,0,-1]) rotate([0,0,EndPointMountAngle]) translate([EndPointMountOffset,0,0]) cylinder(r=8+0.1,h=100);
		}
		if( drawArray==[] )
		{
			translate([Linkage_2,0,1]) Bearing623();
			translate([Linkage_2,0,1+Bearing623Height()]) Bearing623();
		}
	}
}

// top arm
if( drawArray==[] || search(26,drawArray)!=[] )
{
	a = printLayout ? 0 : q11;
	ax = printLayout ? 180 : 0;
	translate ([0,0,armsZ+bottomArmH+armsZExtra+Bearing625Height()]) rotate([ax,0,a])
	{
		difference()
		{
			union()
			{
				hull()
				{
					cylinder(r=ArmNearestD/2,h=bottomArmH);
					translate([Linkage_1*0.15,0,0]) cylinder(r=ArmNearestW/2,h=bottomArmH);
				}
				hull()
				{
					cylinder(r=ArmNearestW/2,h=bottomArmH);
					translate([Linkage_1,0,0]) cylinder(r=ArmNearestW/2,h=bottomArmH);
				}
				hull()
				{
					translate([Linkage_1*0.85,0,0]) cylinder(r=ArmNearestW/2,h=bottomArmH);
					translate([Linkage_1,0,0]) cylinder(r=ArmNearestD/2,h=bottomArmH);
				}
				translate([6,6,bottomArmH/2]) rotate([90,0,0]) cylinder(d=rolson_hex_nut_dia(3)+1,h=12,$fn=12);
			}
			translate([Linkage_1,0,1]) cylinder(d=Bearing623Diameter()+0.2,h=bottomArmH+2);
			translate([Linkage_1,0,-1]) cylinder(d=rolson_hex_nut_dia(3)+1,h=bottomArmH+2);
			//translate([0,0,1]) cylinder(d=Bearing623Diameter()+0.2,h=bottomArmH+2);
			translate([0,0,-1]) cylinder(d=5.0,h=bottomArmH+2,$fn=12);
			translate([0,-0.5,-1]) cube([10.5,1,bottomArmH+2]);
			color("blue") translate([0,0,-0.1]) cylinder(d=BearingF512MDiameter()+BearingRClearance*2,h=1.1);
			//color("blue") translate([0,0,-0.1]) cylinder(d=rolson_hex_nut_dia(5)+1,h=1.1,$fn=12);
			

//			difference()
			//{
			//color("blue") translate([0,0,-0.1]) cylinder(r=ArmNearestD/2+0.5,h=0.5+0.1);
			//color("blue") translate([0,0,-0.1]) cylinder(r=ArmNearestD/2-2.3,h=0.5+0.1);
			//}
			color("red") translate([5,50,bottomArmH/2]) rotate([90,0,0]) cylinder(d=3,h=100,$fn=12);
			color("red") translate([5,17,bottomArmH/2]) rotate([90,0,0]) cylinder(d=rolson_hex_nut_dia(3)+1,h=10,$fn=12);
			color("red") translate([5,-7,bottomArmH/2]) rotate([90,0,0]) cylinder(d=rolson_hex_nut_dia(3)+1,h=10,$fn=12);
			
									// mount holes 2
			translate([Linkage_1-11,-0.5,0]) cube([12.5,1,bottomArmH+2]);
			color("red") translate([Linkage_1-7,50,bottomArmH/2]) rotate([90,0,0]) cylinder(r=1.51,h=100,$fn=24);
			color("red") translate([Linkage_1-7,17,bottomArmH/2]) rotate([90,0,0]) cylinder(d=rolson_hex_nut_dia(3)+1,h=10,$fn=12);
			color("red") translate([Linkage_1-7,-6,bottomArmH/2]) rotate([90,0,0]) cylinder(d=rolson_hex_nut_dia(3)+1,h=10,$fn=12);

			
			translate([Linkage_1*0.35,0,0]) cylinder(d=3,h=bottomArmH+2,$fn=23);
			translate([Linkage_1*0.70,0,0]) cylinder(d=3,h=bottomArmH+2,$fn=23);
		}
	}
// holder
				a1 = printLayout ? 0 : q11;
	ay1 = printLayout ? 23 : 0;
az1 = printLayout ? -10 : 40;

	translate ([0,ay1,armsZ+bottomArmH+armsZExtra+Bearing625Height()+az1]) rotate([0,0,a1])
	{
		//cylinder(r=Bearing623Diameter()+2,h=bottomArmH+Bearing625Height());
		difference()
		{
			union()
			{
				hull()
				{
					cylinder(d=Bearing625Diameter()+5,h=bottomArmH);
					translate([2,0,0]) cylinder(d=Bearing625Diameter()+5,h=bottomArmH);
					translate([Linkage_1*0.15,0,0]) cylinder(r=ArmNearestW/2,h=bottomArmH);
				}
				hull()
				{
					cylinder(r=ArmNearestW/2,h=bottomArmH);
					translate([Linkage_1,0,0]) cylinder(r=ArmNearestW/2,h=bottomArmH);
				}
				hull()
				{
					translate([Linkage_1*0.85,0,0]) cylinder(r=ArmNearestW/2,h=bottomArmH);
					translate([Linkage_1,0,0]) cylinder(r=ArmNearestD/2,h=bottomArmH);
				}
				translate([6,6,bottomArmH/2]) rotate([90,0,0]) cylinder(d=rolson_hex_nut_dia(3)+1,h=12,$fn=12);
			translate([-13,0,bottomArmH/2]) rotate([0,90,0]) cylinder(d=rolson_hex_nut_dia(3)+3.5,h=13,$fn=24);
			}
			translate([Linkage_1,0,1]) cylinder(d=Bearing623Diameter()+0.2,h=bottomArmH+2);
			translate([Linkage_1,0,-1]) cylinder(d=rolson_hex_nut_dia(3)+1,h=bottomArmH+2);
			//translate([0,0,1]) cylinder(d=Bearing623Diameter()+0.2,h=bottomArmH+2);
			translate([0,0,-1]) cylinder(d=rolson_hex_nut_dia(5)+1,h=bottomArmH+2);
			hull()
			{
			color("blue") translate([0,0,2]) cylinder(d=Bearing625Diameter()+BearingRClearance*2,h=bottomArmH);
			color("blue") translate([2,0,2]) cylinder(d=Bearing625Diameter()+BearingRClearance*2,h=bottomArmH);
			}
				// mount holes
			translate([5,-0.5,0]) cube([12.5,1,bottomArmH+2]);
			color("red") translate([12,50,bottomArmH/2]) rotate([90,0,0]) cylinder(r=1.51,h=100,$fn=24);
			color("red") translate([12,17,bottomArmH/2]) rotate([90,0,0]) cylinder(d=rolson_hex_nut_dia(3)+1,h=11,$fn=12);
			color("red") translate([12,-6,bottomArmH/2]) rotate([90,0,0]) cylinder(d=rolson_hex_nut_dia(3)+1,h=13,$fn=24);
			color("red") translate([-18,0,bottomArmH/2]) rotate([0,90,0]) cylinder(d=3,h=13,$fn=24);
			color("red") translate([-10,0,bottomArmH/2]) rotate([0,90,0]) cylinder(d=rolson_hex_nut_dia(3)+0.5,h=13,$fn=6);
						// mount holes 2
			translate([Linkage_1-11,-0.5,0]) cube([12.5,1,bottomArmH+2]);
			color("red") translate([Linkage_1-7,50,bottomArmH/2]) rotate([90,0,0]) cylinder(r=1.51,h=100,$fn=24);
			color("red") translate([Linkage_1-7,17,bottomArmH/2]) rotate([90,0,0]) cylinder(d=rolson_hex_nut_dia(3)+1,h=10,$fn=12);
			color("red") translate([Linkage_1-7,-6,bottomArmH/2]) rotate([90,0,0]) cylinder(d=rolson_hex_nut_dia(3)+1,h=10,$fn=12);

			translate([Linkage_1*0.35,0,0]) cylinder(d=3,h=bottomArmH+2,$fn=23);
			translate([Linkage_1*0.70,0,0]) cylinder(d=3,h=bottomArmH+2,$fn=23);


		}
		if( drawArray==[] )
		{
			translate([Linkage_1,0,1]) Bearing623();
			translate([Linkage_1,0,1+Bearing623Height()]) Bearing623();
			color("silver") translate([Linkage_1,0,1+Bearing623Height()+Bearing623Height()]) hex_nut(5);
		}
	}
}

module ArmCableClamp()
{
		difference()
		{
					minkowski()
		{
			translate([30.5,-5,-1]) cube([4,10,12]);
			sphere(d=1,$fn=12);
		}
			union()
			{
				color("blue") 
				hull() 
				{
					cylinder(r=ArmNearestW/2+0.4,h=bottomArmH);
					translate([Linkage_2,0,0]) cylinder(r=ArmNearestW/2+0.4,h=bottomArmH);
				}
			}
			translate([29,-10,1]) cube([7,10,8]);
		}
		minkowski()
		{
			difference()
			{
				hull()
				{
								//translate([30.5,0,-1]) cube([1,10,12]);
								translate([30.5,5,-1]) cube([4,0.1,12]);
								translate([30.5,5,0.5]) cube([4,5,9]);
				}
				translate([29,4.5,1]) cube([7,5.3,8]);
			}
			//#translate([30,5,1.5]) cube([5,4.2,1]);
			sphere(d=1,$fn=12);
		}
}

if( drawArray==[] || search(25,drawArray)!=[] )
{
  xd = dhalf + l * cos(q11);
  yd = l * sin(q11);
	a = printLayout ? 0 : atan((y-yd)/(x-xd));
	//echo (a);
	difference()
	{
	translate ([xd,yd,armsZ+bottomArmH+armsZExtra-Bearing625Height()-2.5+25])
		rotate([0,0,a+180]) 
	{
		difference()
		{
			union()
			{
				color("blue") 
				hull()
				{
					cylinder(r=ArmNearestD/2,h=bottomArmH);
					translate([Linkage_1*0.15,0,0]) cylinder(r=ArmNearestW/2,h=bottomArmH);
				}

				color("blue") 
				hull() 
				{
					cylinder(r=ArmNearestW/2,h=bottomArmH);
					translate([Linkage_2-6,0,0]) cylinder(r=ArmNearestW/2,h=bottomArmH);
				}

				color("blue") 
				hull()
				{
					//translate([Linkage_2,0,0]) cylinder(r=ArmNearestD/2,h=bottomArmH);
					translate([Linkage_2,0,0]) cylinder(r=1.5+3.5,h=bottomArmH);
					translate([Linkage_2*0.85,0,0]) cylinder(r=ArmNearestW/2,h=bottomArmH);
				}
				
		//translate([Linkage_2,0,0]) rotate([0,0,EndPointMountAngle]) translate([EndPointMountOffset+13,5,bottomArmH/2]) rotate([90,0,0]) cylinder(d=3,h=30,$fn=12);

				//translate([Linkage_2-13,6,bottomArmH/2]) rotate([90,0,0]) cylinder(d=rolson_hex_nut_dia(3)+1,h=12,$fn=12);
			}
			color("red") translate([Linkage_2,0,-1]) cylinder(d=3,h=30,$fn=32);
			color("red") translate([0,0,-1]) cylinder(d=3,h=30,$fn=32);
			//translate([Linkage_2,0,4]) cylinder(d=Bearing6800Diameter()+b6800Clearance,h=bottomArmH,$fn=32);
			//color("red") translate([0,0,-1]) cylinder(d=rolson_hex_nut_dia(3)+1,h=30,$fn=32);
			//color("red") translate([0,0,1]) cylinder(d=Bearing623Diameter()+0.2,h=30,$fn=32);
		}
		if( drawArray==[] )
		{
			translate([0,0,1]) Bearing623();
			translate([0,0,1+Bearing623Height()]) Bearing623();
		}
	}
				// hot end 
			color("silver") translate([xp,yp,armsZ+bottomArmH+armsZExtra-Bearing625Height()-2.5]) cylinder(r=13.5,h=100);
	}
}


if( drawArray==[] || search(31,drawArray)!=[] )
{
	translate ([0,0,armsZ+armsZExtra]) rotate([0,0,q22])
	{
		difference()
		{
		color("red") translate([0,0,-armsZExtra-2]) cylinder(r=ArmNearestW-0.5,h=armsZExtra+2);
		color("red") translate([0,0,-armsZExtra-3]) cylinder(d=8,h=armsZExtra+4);
		}
	}
}


if( drawArray==[] )
{
	//translate ([0,-65,0]) cylinder(r=3,h=300);
}


if( drawArray==[] )
{
  // z stepper
  translate([0,83,49]) rotate([90,0,0])
  {
    translate( [0,0,45]) rotate([180,0,0]) Nema17_shaft24_Stepper();
    translate ([0,0,52]) Pulley16Teeth();
  }

  // x stepper
  translate([xStepperX,xStepperY,xStepperZ])
  {
		if( drawSteppers )
			rotate([0,0,-90]) Nema17_shaft24_Stepper();
    translate ([0,0,-6]) rotate([180,0,0]) Pulley16Teeth();
  }
  // y stepper
  translate([-25,110,32-Bearing625Height()])
  {
		if( drawSteppers )
			rotate([0,0,-90]) Nema17_shaft24_Stepper();
    translate ([0,0,-18]) rotate([0,0,0]) Pulley16Teeth();
  }
}

// rods
if( drawArray==[] ) 
	translate([rodOffsetX,rodOffsetY/*+20*/,40+isExpolode*75]) color ("silver") cylinder(r=3,h=200);

if( drawArray==[] ) 
	translate([-rodOffsetX,rodOffsetY,40+isExpolode*75]) color ("silver") cylinder(r=3,h=200);

if( drawArray==[] ) Bearing625();

if( drawArray==[] ) translate ([0,0,Bearing625Height()+isExpolode*5]) color( "Silver") hex_nut(5);

// m3 threaded rods
if( drawArray==[] )
{
	color("silver") 
	{
		translate([-40,0,0]) rotate([0,0,0]) scale([1,1,1]) cylinder(d=3.1,h=254,$fn=16);
		translate([40,0,0])  rotate([0,0,0]) scale([1,1,1]) cylinder(d=3.1,h=254,$fn=16);
	}
}

// rods bearing
if( drawArray==[] )
{
	translate([rodOffsetX,rodOffsetY,65+z]) BearingLM6UU();
	translate([-rodOffsetX,rodOffsetY,65+z]) BearingLM6UU();
}


if( drawArray==[] || search(38,drawArray)!=[] ) 
{
	difference()
	{
		translate([-55,10,400]) cube([110,100,1]);
		hull()
		{
			translate([rodOffsetX,rodOffsetY/*+20*/,250]) color ("silver") cylinder(r=3.1,h=200);
			translate([rodOffsetX,rodOffsetY-20,250]) color ("silver") cylinder(r=1,h=200);
		}
		hull()
		{
			translate([-rodOffsetX,rodOffsetY,250]) color ("silver") cylinder(r=3.1,h=200);
			translate([-rodOffsetX,rodOffsetY-20,250]) color ("silver") cylinder(r=1,h=200);
		}

		color("red") translate([0,30,400+1])
		{
			cube([120,0.5,1],center=true);
			translate([-3,1,-0.5]) write("30",h=5,t=0.5);
		}

		color("red") translate([0,30,400+1]) cube([120,0.5,1],center=true);

		color("red") translate([0,35,400+1]) cube([120,0.5,1],center=true);

		color("red") translate([0,50,400+1]) 
		{
			cube([120,0.5,1],center=true);
			translate([-3,1,-0.5]) write("50",h=5,t=0.5);
		}

		color("red") translate([0,70,400+1]) cube([120,0.5,1],center=true);

		color("red") translate([0,90,400+1]) cube([120,0.5,1],center=true);

		color("red") translate([0,100,400+1])
		{
			cube([120,0.5,1],center=true);
			translate([-5,1,-0.5]) write("100",h=5,t=0.5);
		}


		color("red") translate([0,120,400+1])
		{
			cube([120,0.5,1],center=true);
			translate([-5,1,-0.5]) write("120",h=5,t=0.5);
		}

		color("red") translate([0,140,400+1]) cube([120,0.5,1],center=true);

		color("red") translate([0,80,400+1]) cube([0.5,120,1],center=true);

		color("red") translate([-50,80,400+1]) cube([0.5,120,1],center=true);

		color("red") translate([-25,80,400+1])
		{
			cube([0.5,120,1],center=true);
			translate([-6.5,1,-0.5]) write("-25",h=5,t=0.5);
		}

		color("red") translate([50,80,400+1]) cube([0.5,120,1],center=true);

		color("red") translate([25,80,400+1])
		{
			cube([0.5,120,1],center=true);
				translate([-3,1,-0.5]) write("25",h=5,t=0.5);
		}

		color("green") translate([-20,0,400-1]) cube([40,30,5]);

	}

	//color("green") translate([0,25,400+0.5]) cube([120,1.5,1],center=true);

	color("green") translate([0,40,400+0.5]) cube([100,1.5,1],center=true);

	color("green") translate([0,60,400+0.5]) cube([100,1.5,1],center=true);
	color("green") translate([0,80,400+0.5]) cube([100,1.5,1],center=true);
	//color("green") translate([0,90,400+0.5]) cube([120,1.5,1],center=true);

	//color("green") translate([0,120,400+0.5]) cube([120,1.5,1],center=true);
	color("green") translate([0,110,400+0.5]) cube([100,1.5,1],center=true);
	//color("green") translate([0,130,400+0.5]) cube([120,1.5,1],center=true);

	color("green") translate([12.5,65,400+0.5]) cube([1.5,90,1],center=true);
	color("green") translate([-12.5,65,400+0.5]) cube([1.5,90,1],center=true);
	color("green") translate([25+12.5,65,400+0.5]) cube([1.5,90,1],center=true);
	color("green") translate([-25-12.5,65,400+0.5]) cube([1.5,90,1],center=true);
}

module HolesBearingMount()
{
		translate([BearingLM6UUDiameter()/2+1.7,50,6.2]) rotate([90,0,0]) cylinder(d=3.1,h=100,$fn=32);
		translate([BearingLM6UUDiameter()/2+1.7,50,12.8]) rotate([90,0,0]) cylinder(d=3.1,h=100,$fn=32);
		//
		translate([-50,BearingLM6UUDiameter()/2+1.7,16]) rotate([0,90,0]) cylinder(d=3.1,h=100,$fn=32);
		translate([-50,BearingLM6UUDiameter()/2+1.7,3]) rotate([0,90,0]) cylinder(d=3.1,h=100,$fn=32);
}

module CarretSide1(index)
{
	translate([-rodOffsetX,rodOffsetY,65])
	{
		if( index==0 )
		{
			translate([0,0,0]) color( "magenta") difference()
			{
				union()
				{
						translate([0,-BearingLM6UUDiameter()/2,0]) cube([BearingLM6UUDiameter(),BearingLM6UUDiameter()+5,BearingLM6UUHeight()]);
						translate([10,-BearingLM6UUDiameter()/2,0]) cube([30,10,BearingLM6UUHeight()]);
						translate([12,-BearingLM6UUDiameter()/2-1.2,0]) cube([28,1.2,BearingLM6UUHeight()]);
				}
				translate([0,0,-1]) cylinder(d=BearingLM6UUDiameter(),h=BearingLM6UUHeight()+2,$fn=32);
				//translate([rodOffsetX-7,0,-1]) cube([10,10,BearingLM6UUHeight()+2]);
				translate([rodOffsetX-1,4,-1]) scale([1,0.5,1]) cylinder(r=7,h=BearingLM6UUHeight()+2);
				HolesBearingMount();
				translate([7.8,-BearingLM6UUDiameter()/2,-1]) scale([1,0.7,1]) cylinder(r=3,h=BearingLM6UUHeight()+2,$fn=12);
			}
		}
		else
		{
			translate([0,0,0]) difference()
			{
				union()
				{
					color( "green") hull()
					{
						translate([11,-1.2,0]) scale([0.1,1,1]) translate([0,0,0]) cylinder(d=BearingLM6UUDiameter(),h=BearingLM6UUHeight(),$fn=32);
						translate([-3,-1.2,0]) translate([0,0,0]) cylinder(d=BearingLM6UUDiameter(),h=BearingLM6UUHeight(),$fn=32);
						//color( "green") translate([-BearingLM6UUDiameter()/2-4,-BearingLM6UUDiameter()/2-1,0]) cube([BearingLM6UUDiameter(),BearingLM6UUDiameter()+15,BearingLM6UUHeight()]);
						//color( "green") translate([BearingLM6UUDiameter()/2-6,-BearingLM6UUDiameter()/2-1,0]) cube([BearingLM6UUDiameter(),BearingLM6UUDiameter()+5,BearingLM6UUHeight()]);
					}
					color( "green") hull()
					{
						translate([-3,-1.2,0]) translate([0,0,0]) cylinder(d=BearingLM6UUDiameter(),h=BearingLM6UUHeight(),$fn=32);
						translate([-3,12,0]) translate([0,0,0]) scale([1,0.1,1]) cylinder(d=BearingLM6UUDiameter(),h=BearingLM6UUHeight(),$fn=32);
					}
					translate([0,0,BearingLM6UUHeight()/2]) color( "green") hull()
					{
						translate([-3,-1.2,0]) translate([0,0,0]) cylinder(d=BearingLM6UUDiameter(),h=BearingLM6UUHeight()/2,$fn=32);
						translate([-3,30,0]) translate([0,0,0]) cylinder(d=BearingLM6UUDiameter(),h=BearingLM6UUHeight()/2,$fn=32);
					}
					translate([0,0,0]) color( "green") hull()
					{
						translate([-3,7,0]) translate([0,0,0]) cylinder(d=BearingLM6UUDiameter(),h=BearingLM6UUHeight()/2,$fn=32);
						translate([-3,30,BearingLM6UUHeight()/2]) translate([0,0,0]) cylinder(d=BearingLM6UUDiameter(),h=BearingLM6UUHeight()/2,$fn=32);
					}
					color( "red") translate([-4,12,0]) cylinder(d=BearingLM6UUDiameter()-3,h=10,$fn=32);
					color( "red") translate([-4,28,4]) cylinder(d=BearingLM6UUDiameter()-3,h=10,$fn=32);
					

				}
				difference()
				{
					translate([0,-BearingLM6UUDiameter()/2,-1]) cube([BearingLM6UUDiameter(),BearingLM6UUDiameter()+5,BearingLM6UUHeight()+2]);
					// new design
					translate([7.8,-BearingLM6UUDiameter()/2,-1]) scale([1,0.7,1]) cylinder(r=3,h=BearingLM6UUHeight()+2,$fn=12);
				}
				translate([0,0,-1]) cylinder(d=BearingLM6UUDiameter(),h=BearingLM6UUHeight()+2,$fn=32);
				HolesBearingMount();
				color( "red") translate([-4,12,-1]) cylinder(d=3.1,h=BearingLM6UUHeight()+2,$fn=32);
				color( "red") translate([-4,28,-1]) cylinder(d=3.1,h=BearingLM6UUHeight()+2,$fn=32);
			}
		}
	}
}

// 0 inner
module Carret(index)
{
	difference()
	{
		union()
		{
			CarretSide1(index);
			{
				offset = printLayout ? 102 : 0;
				offsetr = printLayout ? 0 : 0;
				mirror() translate([offset,0,0]) rotate([0,0,offsetr]) 
				{
					difference()
					{
						CarretSide1(index);
					//#translate([-5,rodOffsetY+1,65-1]) cube([5,11,BearingLM6UUHeight()+2]);
					}
				}
			}
			if( index==0 )
			{
				translate([0,0,-2.5])
					hull() 
				{
					translate([-12,15,67.5]) cylinder(d=rolson_hex_nut_dia(3)+0.5,h=rolson_hex_nut_hi(3)+0.3,$fn=6);
					translate([-12,17,67.5]) cylinder(d=rolson_hex_nut_dia(3)+0.5,h=rolson_hex_nut_hi(3)+0.3,$fn=6);
				}
				translate([0,0,-2.5])
					hull() 
				{
					translate([12,15,67.5]) cylinder(d=rolson_hex_nut_dia(3)+0.5,h=rolson_hex_nut_hi(3)+0.3,$fn=6);
					translate([12,17,67.5]) cylinder(d=rolson_hex_nut_dia(3)+0.5,h=rolson_hex_nut_hi(3)+0.3,$fn=6);
				}
			}
		}
		if( index==0 )
		{
			// d for m3 tap
			translate([-12,15,47.5]) cylinder(d=2.5,h=40,$fn=16);
			hull()
			{
				translate([-12,15,67.5]) cylinder(d=rolson_hex_nut_dia(3)+0.5,h=rolson_hex_nut_hi(3)+0.3,$fn=6);
				translate([-12,25,67.5]) cylinder(d=rolson_hex_nut_dia(3)+0.5,h=rolson_hex_nut_hi(3)+0.3,$fn=6);
			}
			// d for m3 tap
			translate([12,15,47.5]) cylinder(d=2.5,h=40,$fn=16);
			hull()
			{
				translate([12,15,67.5]) cylinder(d=rolson_hex_nut_dia(3)+0.5,h=rolson_hex_nut_hi(3)+0.3,$fn=6);
				translate([12,25,67.5]) cylinder(d=rolson_hex_nut_dia(3)+0.5,h=rolson_hex_nut_hi(3)+0.3,$fn=6);
			}
		}
	}
	if( index==0 )
	{
		mountTh = 4;
		beltOffset = 4;
		translate([-mountTh,0,0]) 
		{
			difference() 
			{
				union()
				{
					translate([beltOffset,rodOffsetY,65]) cube([mountTh,11,BearingLM6UUHeight()]);
					translate([beltOffset+beltOffset,rodOffsetY,65]) cylinder(r=1.5,h=BearingLM6UUHeight(),$fn=16);
					translate([beltOffset+beltOffset-mountTh,rodOffsetY,65]) cylinder(r=1.5,h=BearingLM6UUHeight(),$fn=16);
				}
				translate([beltOffset-1,rodOffsetY+1.6,65+2.5]) cube([4+2,6.7,1.5]);
				translate([beltOffset-1,rodOffsetY+1.6,65+7]) cube([4+2,6.7,1.5]);
				translate([beltOffset-1,rodOffsetY+1.6,65+11]) cube([4+2,6.7,1.5]);
				translate([beltOffset-1,rodOffsetY+1.6,65+15]) cube([4+2,6.7,1.5]);
			}
		}
	}
	//#translate([0,0,0]) cube([10,10,65]);
}

if( drawArray==[] || search(32,drawArray)!=[]  ) 
{
	translate([0,0,z]) 
	{
		Carret(0);
	}
}

if( drawArray==[] || search(33,drawArray)!=[]  ) 
{
	translate([0,0,z]) 
	{
		Carret(1);
	}
}

// belts
if( drawArray==[] || drawBelts==1 ) 
{
  color ("black") translate([26,0,6.5]) rotate([0,0,88]) cube([110,1.5,6]);
  color ("black") translate([-20,15,6.5]) rotate([0,0,67]) cube([110,1.5,6]);
	translate([31,70,6.5]) rotate([0,0,178]) BeltClip();

  color ("black") translate([20,15,17.5]) rotate([0,0,112]) cube([110,1.5,6]);
  color ("black") translate([-26,0,17.5]) rotate([0,0,92]) cube([110,1.5,6]);
	translate([-33,60,23.5]) rotate([180,0,3]) BeltClip();

  color ("black") translate([4,17,50]) cube([1.5,6,200]);
  color ("black") translate([-5.5,17,50]) cube([1.5,6,200]);
}

// belts
if( drawArray==[] || drawZBelts==1 ) 
{
  color ("black") translate([4,17,50]) cube([1.5,6,200]);
  color ("black") translate([-5.5,17,50]) cube([1.5,6,200]);
}

if( search(13,drawArray)!=[]  ) 
{
	a =  180;
	translate([-7,0,9]) rotate([0,180,0+a]) BeltClip(4,1);
	translate([7,0,9]) rotate([0,180,180+a]) BeltClip(4,1);
}

// pulley1
if( drawArray==[] || search(1,drawArray)!=[] )
{
	translate([0,0,Bearing625Height()+isExpolode*10])
	{	
		ArmPulley(numBigHoles=5,retainerH=endStopArmH);
		translate([0,0,pulley1H-endStopArmH]) rotate([0,0,0])
		hull()
		{
      rotate([0, 0, 197])
          translate([outerRad+7, 0, 0])
          cylinder(r=2,h=endStopArmH);
      rotate([0, 0, 202])
          translate([outerRad, 0, 0])
          cylinder(r=2,h=endStopArmH);
      rotate([0, 0, 185])
          translate([outerRad, 0, 0])
          cylinder(r=2,h=endStopArmH);
		}
	}
}

if( drawArray==[] ) translate ([0,0,Bearing625Height()+pulley1H+isExpolode*15]) color( "Silver") hex_nut(5);

// pulley2
if( drawArray==[] || search(2,drawArray)!=[] )
{
	translate ([0,0,Bearing625Height()+pulley1H+pulleysSpace+isExpolode*20]) 
	{
		//color([0,1,0,0.1]) 
		color( "Goldenrod") difference()
		{
			//echo (pulley2H-(rolson_hex_nut_hi(5)+m5Hclearance));
			//echo ((rolson_hex_nut_hi(5)+m5Hclearance));
			ArmPulley(numBigHoles=3,numSmallHoles=3,smallHolesDist=12,smallHolesDia=1.55,bigHolesRadScale=0.85,bigHolesOffset=2);
			cylinder(d=rolson_hex_nut_dia(5)+1,h=pulley2H);
			translate ([0,0,rolson_hex_nut_hi(5)])
				cylinder(r=Bearing625Diameter()/2,pulley2H);
		}
		//echo(Bearing625Height());
		if( search(2,drawArray)==[] ) translate ([0,0,rolson_hex_nut_hi(5)+isExpolode*25]) Bearing625();	
	}
}

if( drawArray==[] ) translate ([0,0,Bearing625Height()+pulley1H+pulley2H+pulleysSpace+isExpolode*30]) color( "Silver") hex_nut(5);

if( drawArray==[] || drawSwitchesAll==1 )
{
	translate([-28,-13,11]) rotate([180,180,0]) EndSwitchBody20x11();
	translate([-28,-13,Bearing625Height()+pulley1H+pulley2H-1]) rotate([180,180,0]) EndSwitchBody20x11();
}

if( drawArray==[] || search(14,drawArray)!=[] )
{
	difference()
	{
		translate([-48,-23,Bearing625Height()+pulley1H+pulley2H-7]) cube([20,10,6]);
		translate([-28,-13,11]) rotate([180,180,0]) EndSwitchBody20x11(1);
	}
}

if( drawArray==[] ) translate([0,0,Bearing625Height()+pulley1H+pulley2H+pulleysSpace+isExpolode*45]) Bearing625();

// puter tube holder - mounted to pulley2 (top)
if( drawArray==[] || search(3,drawArray)!=[] )
{
	rotate([0,0,0])//90])
	{
    translate ([0,0,Bearing625Height()+pulley1H+pulley2H+pulleysSpace+isExpolode*55]) 
    {
        difference()
        {
          union()
          {
            difference()
            {
              cylinder(r=outerRad*0.7,h=endStopArmH);
              cylinder(d=rolson_hex_nut_dia(5)+1,h=endStopArmH+0.1);
            };
            translate([0,0,endStopArmH]) cylinder(r1=outerRad*0.7,r2=4+4,h=6);
            translate([0,0,endStopArmH+6]) cylinder(r=4+4.5,h=1);
            translate([0,0,8]) 
            {
              difference()
              {
                union()
                {
                  cylinder(r=4+4.5,h=15);
                  translate([9,0,-4]) cylinder(r=5,h=19);
                }
                translate([0,-0.25,3]) cube([20,0.5,15]);
                translate([8,10,9]) rotate([90,0,0]) cylinder(r=1.55,h=25,$fn=12);
                translate([8,-4.8,9]) rotate([90,0,0]) cylinder(r=(rolson_hex_nut_dia(3)+1)/2,h=10);
                translate([8,4.8+10,9]) rotate([90,0,0]) cylinder(r=(rolson_hex_nut_dia(3)+1)/2,h=10);
              }
            }
            translate([0,0,0]) 
            hull()
            {
              rotate([0, 0, 197])
                  translate([outerRad+7, 0, 0])
                  cylinder(r=2,h=endStopArmH+1);
              rotate([0, 0, 202])
                  translate([outerRad, 0, 0])
                  cylinder(r=2,h=endStopArmH);
              rotate([0, 0, 215])
                  translate([outerRad-10, 0, 0])
                  cylinder(r=2,h=endStopArmH+1);
              rotate([0, 0, 185])
                  translate([outerRad, 0, 0])
                  cylinder(r=2,h=endStopArmH+1);
              rotate([0, 0, 180])
                  translate([outerRad-10, 0, 0])
                  cylinder(r=2,h=endStopArmH+1);
            }
        }
        for (i = [0:3-1]) 
        {
            rotate([0, 0, (360/3)*i+60])
            translate([12, 0, 0])
            cylinder(r=smallHolesDia,h=10,$fn=16);

            rotate([0, 0, (360/3)*i+60])
            translate([12, 0, 4])
            cylinder(r=(rolson_hex_nut_dia(3)+1)/2,h=5.5,$fn=20);

        }

        translate([0,0,endStopArmH])
          cylinder(d=rolson_hex_nut_dia(5)+1,h=5);

        translate([0, 0, endStopArmH+7]) cylinder(r=4,h=200,$fn=shaftsSegments);
        translate([0, 0, 0]) cylinder(r=shaftRadius,h=200,$fn=shaftsSegments);
        translate([0, 0, 0]) cylinder(d=Bearing625Diameter()+b625RClearance,h=2,$fn=32);
      }
    }
  }
}

// center tube
if( drawArray==[] )
{
	translate ([0,0,Bearing625Height()+pulley1H+pulley2H+9+isExpolode*140]) 
		color("silver")
	{
		difference()
		{
				cylinder(r=4,h=300);
				cylinder(r=3,h=300);
		}
	}
}

//translate([-50,-24,0]) cylinder(r=45,h=10);

// bottom base for big pulleys+end stoppers mount
if( drawArray==[] || search(4,drawArray)!=[] )
{
  difference()
  {
    union()
    {
      translate([-48,-49,0]) 
        color("red") rotate([0,0,0]) scale([1,1,1])
          cube([96,49,5]);

      translate([-48,-24,0]) 
        color("blue") rotate([0,0,0]) scale([1,1,1])
          cube([20,24,11]);

			//translate([13,-24,0]) 
			//	color("red") rotate([0,0,0]) scale([1,1,1]) cube([35,24,5]);

      hull()
      {
        height = 30;//Bearing625Height()+pulley1H+pulley2H+32;//30
        translate([0,-8,0]) color("blue") cylinder(d=30,h=height);

        translate([40,0,0]) 
        color("red") rotate([0,0,0]) scale([1,1,1]) cylinder(d=15,h=height,$fn=16);

        translate([-40,0,0]) 
        color("red") rotate([0,0,0]) scale([1,1,1]) cylinder(d=15,h=height,$fn=16);
      }
      color("blue") cylinder(d=56,h=5);


      rodsSupportH = 5;
			// center mount
			difference()
			{
				union()
				{
					color ("magenta") 
					{
						translate([-35,0,0]) cube([70,30,5]);
						hull()
						{
							translate([-48,10,0]) cube([96,3,5]);
							translate([-48,29,0]) cube([96,5,5]);
						}
					}
					/*
					color ("green") translate([-24,30,0]) cube([48,4,20]);
					hull()
					{
						color ("green") translate([-24,27,0]) cube([4,3,20]);
						color ("green") translate([-24,25,0]) cube([4,3,20]);
					}
					//color ("green") translate([-24,27,0]) cube([7,3,28.5]);
					hull()
					{
						color ("green") translate([24-4,27,0]) cube([4,3,20]);
						color ("green") translate([24-4,25,0]) cube([4,3,1]);
					}
					color ("green") translate([-24,25,0]) cube([48,9,29]);
					*/
				}
				
				color ("red") translate([-15,28,5]) cube([30,10,20]);
				translate([0,83,49]) rotate([90,0,0])
				{
					translate( [0,0,45]) rotate([180,0,0]) Nema17_shaft24_Stepper(bSrewsOnly=1);
								color ("silver") translate([0,0,45]) cylinder(d=23,h=10,$fn=32);
				}
				translate([40,28,-0.2]) color("red") rotate([0,0,0]) scale([1,1,1]) cylinder(r=1.51,h=rodsSupportH+1,$fn=16);
				translate([-40,28,-0.2]) color("red") rotate([0,0,0]) scale([1,1,1]) cylinder(r=1.51,h=rodsSupportH+1,$fn=16);

			}
			// center support
			color ("red") translate([-7.5,26,5]) cube([15,8,7.8]);

			// extra
      height = 30;
			///*
			color("green") hull()
			{
				translate([rodOffsetX,rodOffsetY-11,-0]) rotate([0,0,45]) cylinder(r=3+8.4,h=height,$fn=4);
				translate([40,0,0]) 
					color("red") rotate([0,0,0]) scale([1,1,1]) cylinder(d=15,h=height,$fn=16);
			}
			mirror()
			{
			color("blue") hull()
			{
				translate([-rodOffsetX-1.5,rodOffsetY-4,-0+height/2]) cube([13,4,height],center=true);
				translate([-rodOffsetX-6,rodOffsetY+6,-0+height/2]) cube([4,5,height],center=true);
				//translate([-rodOffsetX+2,rodOffsetY,height-5/2]) cube([6,5,5],center=true);
			}

			color("blue") hull()
			{
				translate([-rodOffsetX,rodOffsetY,height-5/2]) cube([10,17,5],center=true);
				translate([-rodOffsetX,rodOffsetY,height-5/2-5]) cube([3,3,5],center=true);
			}
		}
			//*/
			///*
			color("green") hull()
			{
				translate([-rodOffsetX,rodOffsetY-11,-0]) rotate([0,0,45]) cylinder(r=3+8.4,h=height,$fn=4);
				translate([-40,0,0]) 
					color("red") rotate([0,0,0]) scale([1,1,1]) cylinder(d=15,h=height,$fn=16);
			}

			color("blue") hull()
			{
				translate([-rodOffsetX-1.5,rodOffsetY-4,-0+height/2]) cube([13,4,height],center=true);
				translate([-rodOffsetX-6,rodOffsetY+6,-0+height/2]) cube([4,5,height],center=true);
				//translate([-rodOffsetX+2,rodOffsetY,height-5/2]) cube([6,5,5],center=true);
			}

			color("blue") hull()
			{
				translate([-rodOffsetX,rodOffsetY,height-5/2]) cube([10,17,5],center=true);
				translate([-rodOffsetX,rodOffsetY,height-5/2-5]) cube([3,3,5],center=true);
			}
			//*/
		}
		translate([0,0,5]) color("green") cylinder(d=60,h=Bearing625Height()+pulley1H+pulley2H+35+5);

		color("red") translate([0,38,8.5]) rotate([90,0,0]) scale([1,1,1]) cylinder(r=1.51,h=28,$fn=16);


		color ("magenta") hull()
		{
			color("red") translate([-28,13,15]) rotate([90,0,0]) scale([1,1,1]) cylinder(d=13,h=28,$fn=16);

			color("red") translate([-28,13,27]) rotate([90,0,0]) scale([1,1,1]) cylinder(d=13,h=28,$fn=16);
		}

		mirror() color ("magenta") hull()
		{
			color("red") translate([-28,13,15]) rotate([90,0,0]) scale([1,1,1]) cylinder(d=13,h=28,$fn=16);

			color("red") translate([-28,13,27]) rotate([90,0,0]) scale([1,1,1]) cylinder(d=13,h=28,$fn=16);
		}

		translate([40,0,0-0.1]) 
		{
			color("red") rotate([0,0,0]) scale([1,1,1]) cylinder(d=3.1,h=Bearing625Height()+pulley1H+pulley2H+35+isExpolode*45+5,$fn=16);
			color("red") translate([0,0,0]) cylinder(d=rolson_hex_nut_dia(3)+0.1,h=rolson_hex_nut_hi(3)+0.5,$fn=6);
		}
		translate([-40,0,0-0.1]) 
		{
			color("red") rotate([0,0,0]) scale([1,1,1]) cylinder(d=3.1,h=Bearing625Height()+pulley1H+pulley2H+35+isExpolode*45+5,$fn=16);
			color("red") translate([0,0,0]) cylinder(d=rolson_hex_nut_dia(3)+0.1,h=rolson_hex_nut_hi(3)+0.5,$fn=6);
		}
		
		translate([-40,15,0-0.1]) 
		{
			color("red") rotate([0,0,0]) scale([1,1,1]) cylinder(d=3.1,h=Bearing625Height()+pulley1H+pulley2H+35+isExpolode*45+5,$fn=16);
			color("red") translate([0,0,0]) cylinder(d=rolson_hex_nut_dia(3)+0.1,h=rolson_hex_nut_hi(3)+0.5,$fn=6);
		}

		translate([40,15,0-0.1]) 
		{
			color("red") rotate([0,0,0]) scale([1,1,1]) cylinder(d=3.1,h=Bearing625Height()+pulley1H+pulley2H+35+isExpolode*45+5,$fn=16);
			color("red") translate([0,0,0]) cylinder(d=rolson_hex_nut_dia(3)+0.1,h=rolson_hex_nut_hi(3)+0.5,$fn=6);
		}

		translate([-48,-13,11]) 
		color("blue") rotate([0,0,0]) scale([1,1,1])
			cube([20,5,20]);

		color("red") translate([0,0,0.5]) cylinder(d=Bearing625Diameter()+b625RClearance,h=Bearing625Height());
		color("red") translate([0,0,-0.1]) cylinder(d=5+b625RClearance,h=5);

		translate([-28,-13,0]) rotate([180,180,0]) EndSwitchBody20x11(1);

		translate([-26,-20,-0.10]) 
					color("red") rotate([0,0,0]) scale([1,1,1]) cylinder(r=1.51,h=50,$fn=16);
		translate([-26,-20,5]) 
					color("red") rotate([0,0,0]) scale([1,1,1]) cylinder(d=rolson_hex_nut_dia(3)+0.1,h=50,$fn=6);

		translate([26,-20,-0.10]) 
					color("red") rotate([0,0,0]) scale([1,1,1]) cylinder(r=1.51,h=50,$fn=16);
		translate([26,-20,5]) 
					color("red") rotate([0,0,0]) scale([1,1,1]) cylinder(d=rolson_hex_nut_dia(3)+0.1,h=50,$fn=6);
		translate([42,-20,-0.10]) 
					color("red") rotate([0,0,0]) scale([1,1,1]) cylinder(r=1.51,h=50,$fn=16);
		translate([34,-14,-0.10]) 
					color("red") rotate([0,0,0]) scale([1,1,1]) cylinder(r=1.51,h=50,$fn=16);

		translate([42,-33,-0.10]) 
					color("red") rotate([0,0,0]) scale([1,1,1]) cylinder(r=1.51,h=50,$fn=16);
		translate([-42,-33,-0.10]) 
					color("red") rotate([0,0,0]) scale([1,1,1]) cylinder(r=1.51,h=50,$fn=16);

				// hhhh
				//#color ("silver") translate([0,0,24]) cylinder(r=outerRad+10,h=5,$fn=32);
				color ("silver") translate([0,0,13]) cylinder(r=outerRad+9.3,h=17,$fn=32);

		translate([-30.5,12,5]) 
					color("red") rotate([0,0,10]) scale([0.4,1,1]) cylinder(r=10,h=20,$fn=16);

		mirror() translate([-30.5,12,5]) 
					color("red") rotate([0,0,10]) scale([0.4,1,1]) cylinder(r=10,h=20,$fn=16);

  }
}

if( drawArray==[] || drawSwitchesAll==1)
{
	translate([0,0,Bearing625Height()+pulley1H+pulley2H+32+isExpolode*45]) 
	{
			translate([-12,18.5,-10]) rotate([-90,0,180]) EndSwitchBody20x11();
	}
}

// upper pulley+tube support for bearing
if( drawArray==[] || search(5,drawArray)!=[] )
{
  translate([0,0,Bearing625Height()+pulley1H+pulley2H+32+isExpolode*45]) 
  {
    height = Bearing608Height();
    difference()
    {
      color("blue") 
      union()
      {
				difference()
				{
					translate([-33,7,-22]) cube([21,5,29]);
					translate([-12,18.5,-10]) rotate([-90,0,180]) EndSwitchBody20x11(1);
				}
        cylinder(d=Bearing608Diameter()+12,h=Bearing608Height());
        difference()
        {
          hull()
          {
            translate([0,-8,0]) color("blue") cylinder(d=30,h=height);

            translate([40,0,0]) 
            color("red") rotate([0,0,0]) scale([1,1,1]) cylinder(d=15,h=height,$fn=16);

            translate([-40,0,0]) 
            color("red") rotate([0,0,0]) scale([1,1,1]) cylinder(d=15,h=height,$fn=16);
          }
          translate([-25,-35,-0.5]) cube([50,20,height+1]);
        }
        //
        rodsSupportH = 33.5;
        color("blue") translate([0,0,-rodsSupportH+height]) 
        {
          hull()
          {
            translate([rodOffsetX,rodOffsetY,-0]) cylinder(r=3+5,h=rodsSupportH);
            translate([40,0,0]) 
            color("red") rotate([0,0,0]) scale([1,1,1]) cylinder(d=15,h=rodsSupportH,$fn=16);
          }
          hull()
          {
            translate([-rodOffsetX,rodOffsetY,-0]) cylinder(r=3+5,h=rodsSupportH);
            translate([-40,0,0])color("red") rotate([0,0,0]) scale([1,1,1]) cylinder(d=15,h=rodsSupportH,$fn=16);
          }
          /////
          difference() 
          {
            hull()
            {
              height = 30;//Bearing625Height()+pulley1H+pulley2H+32;//30
              translate([0,-8,0]) color("blue") cylinder(d=30,h=height);

              translate([40,0,0]) 
              color("red") rotate([0,0,0]) scale([1,1,1]) cylinder(d=15,h=height,$fn=16);

              translate([-40,0,0]) 
              color("red") rotate([0,0,0]) scale([1,1,1]) cylinder(d=15,h=height,$fn=16);
            }
            translate([0,0,-0.1]) color("green") cylinder(d=60,h=Bearing625Height()+pulley1H+pulley2H+35+5+0.1);
          }
        }
      }
      color( "red") translate([0,0,2]) cylinder(d=Bearing608Diameter()+b608Clearance,h=Bearing608Height()+15);
      color( "red") translate([0,0,-1]) cylinder(d=9,h=Bearing608Height()+15);
      translate([-40,0,-50]) 
      color("red") rotate([0,0,0]) scale([1,1,1]) cylinder(d=3.1,h=100,$fn=16);

      translate([40,0,-50]) 
      color("red") rotate([0,0,0]) scale([1,1,1]) cylinder(d=3.1,h=100,$fn=16);

      // rods holes
      translate([-rodOffsetX,rodOffsetY,-23]) cylinder(r=3.2,h=35,$fn=16);
     translate([-rodOffsetX,rodOffsetY,-50]) cylinder(r=1.5,h=100,$fn=16);

      translate([-rodOffsetX-0.5,rodOffsetY-10,-23]) cube([1,10,40]);

      translate([-rodOffsetX-10,rodOffsetY-5,-0]) rotate([0,90,0]) cylinder(d=3.2,h=35,$fn=16);
      translate([-rodOffsetX+8,rodOffsetY-5,-0]) rotate([0,90,0]) rotate([0,0,30]) cylinder(d=rolson_hex_nut_dia(3)+1,h=5,$fn=6);

      translate([-rodOffsetX+67,rodOffsetY-5,-0]) rotate([0,90,0]) rotate([0,0,30]) cylinder(d=rolson_hex_nut_dia(3)+1,h=5,$fn=6);

      // rods holes
      translate([rodOffsetX,rodOffsetY,-23]) cylinder(r=3.2,h=35,$fn=16);
     translate([rodOffsetX,rodOffsetY,-50]) cylinder(r=1.5,h=100,$fn=16);

      translate([rodOffsetX-0.5,rodOffsetY-10,-23]) cube([1,10,40]);

      translate([rodOffsetX-10,rodOffsetY-5,-0]) rotate([0,90,0]) cylinder(d=3.2,h=35,$fn=16);
			
			translate([-10,15.5,-0.1]) cube([20,10,40]);
			translate([-13.7,12.5,-0.1]) cube([5,5,40]);
    }
		// wires holder
		//difference()
		{
			translate([22,-10,-7]) rotate([0,0,-5]) cube([2.5,15,10]);
			hull()
			{
				translate([26,-10,-14]) rotate([0,-45,-5]) cube([2.5,15,1]);
				translate([22.3,-10,-7.7]) rotate([0,-20,-5]) cube([2,15,1]);
			}
		}
  }
}

if( drawArray==[] )
{
	translate ([0,0,Bearing625Height()+pulley1H+pulley2H+34+isExpolode*65]) Bearing608(); 
}

// upper bearing mount
if( drawArray==[] || search(6,drawArray)!=[] )
{
  translate([0,0,Bearing625Height()+pulley1H+pulley2H+32+isExpolode*85+Bearing608Height()]) 
  {
    height = 2+3;
    difference()
    {
      color("blue") 
      union()
      {
        cylinder(d=Bearing608Diameter()+12,h=height);
        difference()
        {
          hull()
          {
            translate([0,-8,0]) color("blue") cylinder(d=30,h=height);

            translate([40,0,0]) 
            color("red") rotate([0,0,0]) scale([1,1,1]) cylinder(d=15,h=height,$fn=16);

            translate([-40,0,0]) 
            color("red") rotate([0,0,0]) scale([1,1,1]) cylinder(d=15,h=height,$fn=16);
          }
          translate([-25,-35,-0.5]) cube([50,20,height+1]);
        }
      }
			// bearing hole
      color( "red") translate([0,0,-Bearing608Height()+2]) cylinder(d=Bearing608Diameter()+b608Clearance,h=Bearing608Height()+0.2);
      color( "red") translate([0,0,-1]) cylinder(d=9,h=Bearing608Height()+15);
			// mount holes
      translate([-40,0,-50]) color("red") rotate([0,0,0]) scale([1,1,1]) cylinder(d=3.1,h=100,$fn=16);
      translate([40,0,-50])  color("red") rotate([0,0,0]) scale([1,1,1]) cylinder(d=3.1,h=100,$fn=16);
			// end stopper fit
			translate([-10,15.5,-0.1]) cube([20,10,40]);
			translate([-13.7,12.5,-0.1]) cube([5,5,40]);
			// rods fits
			translate([-45,5.5,-0.1]) cube([20,10,40]);
			translate([25,5.5,-0.1]) cube([20,10,40]);
    }
  }
}

if( drawArray==[] || search(17,drawArray)!=[] )
{
	offset = printLayout==1 ? 10 : 40;
	difference()
	{
		union()
		{
					translate([-offset,0,Bearing625Height()+pulley1H+pulley2H+32+isExpolode*85+Bearing608Height()+Bearing608Height()-2]) color("red") rotate([0,0,0]) scale([1,1,1]) cylinder(r1=5,r2=4,h=15,$fn=16);
					translate([offset,0,Bearing625Height()+pulley1H+pulley2H+32+isExpolode*85+Bearing608Height()+Bearing608Height()-2]) color("red") rotate([0,0,0]) scale([1,1,1]) cylinder(r1=5,r2=4,h=15,$fn=16);
		}
		// mount holes
		translate([-offset,0,50]) color("red") rotate([0,0,0]) scale([1,1,1]) cylinder(d=3.1,h=100,$fn=16);
		translate([offset,0,50])  color("red") rotate([0,0,0]) scale([1,1,1]) cylinder(d=3.1,h=100,$fn=16);
		// m5 nuts
		translate([-offset,0,Bearing625Height()+pulley1H+pulley2H+32+isExpolode*85+Bearing608Height()+Bearing608Height()-2-0.1]) color("red") rotate([0,0,0]) scale([1,1,1]) cylinder(d=rolson_hex_nut_dia(3)+1,h=rolson_hex_nut_hi(3),$fn=6);
		translate([offset,0,Bearing625Height()+pulley1H+pulley2H+32+isExpolode*85+Bearing608Height()+Bearing608Height()-2-0.1]) color("red") rotate([0,0,0]) scale([1,1,1]) cylinder(d=rolson_hex_nut_dia(3)+1,h=rolson_hex_nut_hi(3),$fn=6);
	}
}

// ramps bottom mount
if( drawArray==[] || search(18,drawArray)!=[] )
{
  translate([0,0,Bearing625Height()+pulley1H+pulley2H+32+isExpolode*95+Bearing608Height()+20]) 
  {
		difference()
		{
			hull()
			{
				color("green") rotate([90,0,0]) translate([-29,12.1,3]) cylinder(d=7,h=10,$fn=12);
				color("green") rotate([90,0,0]) translate([-29,5,3]) cylinder(d=9,h=10,$fn=12);
			}
			color("red") rotate([90,0,0]) translate([-29,12.1,0]) cylinder(d=3.1,h=20,$fn=12);
		}

		difference()
		{
			hull()
			{
				color("green") rotate([90,0,0]) translate([19.5,12.1,3]) cylinder(d=7,h=10,$fn=12);
				color("green") rotate([90,0,0]) translate([19.5,5,3]) cylinder(d=9,h=10,$fn=12);
			}
			color("red") rotate([90,0,0]) translate([19.5,11,0]) cylinder(d=3.1,h=20,$fn=12);
		}
    height = 2+3;
    difference()
    {
      color("blue") 
      union()
      {
        cylinder(d=8+3,h=height);
        difference()
        {
          hull()
          {
            translate([0,-16,0]) color("blue") cylinder(d=30,h=height);

            translate([40,0,0]) 
            color("red") rotate([0,0,0]) scale([1,1,1]) cylinder(d=15,h=height,$fn=16);
            translate([40,-5,0]) 
            color("red") rotate([0,0,0]) scale([1,1,1]) cylinder(d=15,h=height,$fn=16);

            translate([-40,0,0]) 
            color("red") rotate([0,0,0]) scale([1,1,1]) cylinder(d=15,h=height,$fn=16);
            translate([-40,-5,0]) 
            color("red") rotate([0,0,0]) scale([1,1,1]) cylinder(d=15,h=height,$fn=16);
          }
          translate([-25,-35,-0.5]) cube([50,20,height+1]);
        }
      }
			// bearing hole
      //color( "red") translate([0,0,-Bearing608Height()+2]) cylinder(d=Bearing608Diameter()+b608Clearance,h=Bearing608Height()+0.2);
      color( "red") translate([0,0,-1]) cylinder(d=9,h=Bearing608Height()+15);
			// mount holes
      translate([-40,0,-50]) color("red") rotate([0,0,0]) scale([1,1,1]) cylinder(d=3.1,h=100,$fn=16);
      translate([40,0,-50])  color("red") rotate([0,0,0]) scale([1,1,1]) cylinder(d=3.1,h=100,$fn=16);
			// end stopper fit
			translate([-10,15.5,-0.1]) cube([20,10,40]);
			translate([-13.7,12.5,-0.1]) cube([5,5,40]);
			// rods fits
			translate([-45,5.5,-0.1]) cube([20,10,40]);
			translate([25,5.5,-0.1]) cube([20,10,40]);
			// ramps fit
			translate([-50,-23,-0.1]) cube([100,10,40]);
			//
			//extra holes
      translate([-40,-8,-50]) color("red") rotate([0,0,0]) scale([1,1,1]) cylinder(d=3.1,h=100,$fn=16);
      translate([40,-8,-50]) color("red") rotate([0,0,0]) scale([1,1,1]) cylinder(d=3.1,h=100,$fn=16);
    }
  }
}

// ramps middle spacer
if( drawArray==[] || search(19,drawArray)!=[] )
{
	hs = 70;
	offset = printLayout ? 7 : 40;
	offset2 = printLayout ? hs/2 : 0;
	offsetY = printLayout ? 12 : 0;
	zoffset = Bearing625Height()+pulley1H+pulley2H+32+isExpolode*85+Bearing608Height()+Bearing608Height()+18;
	difference()
	{
		union()
		{
					translate([-offset,0,zoffset]) color("red") rotate([0,0,0]) scale([1,1,1]) cylinder(r1=5,r2=4,h=hs/2,$fn=16);
					translate([offset,0,zoffset]) color("red") rotate([0,0,0]) scale([1,1,1]) cylinder(r1=5,r2=4,h=hs/2,$fn=16);
					translate([-offset,offsetY,zoffset+hs/2-offset2]) color("red") rotate([0,0,0]) scale([1,1,1]) cylinder(r1=4,r2=4,h=hs/2,$fn=16);
					translate([offset,offsetY,zoffset+hs/2-offset2]) color("red") rotate([0,0,0]) scale([1,1,1]) cylinder(r1=4,r2=4,h=hs/2,$fn=16);
		}
		// mount holes
		translate([-offset,0,50]) color("red") rotate([0,0,0]) scale([1,1,1]) cylinder(d=3.1,h=100,$fn=16);
		translate([offset,0,50])  color("red") rotate([0,0,0]) scale([1,1,1]) cylinder(d=3.1,h=100,$fn=16);
		// mount holes
		translate([-offset,offsetY,50]) color("red") rotate([0,0,0]) scale([1,1,1]) cylinder(d=3.1,h=100,$fn=16);
		translate([offset,offsetY,50])  color("red") rotate([0,0,0]) scale([1,1,1]) cylinder(d=3.1,h=100,$fn=16);
		// m5 nuts
		translate([-offset,0,zoffset-0.1]) color("red") rotate([0,0,0]) scale([1,1,1]) cylinder(d=rolson_hex_nut_dia(3)+1,h=rolson_hex_nut_hi(3)+0.7,$fn=6);
		translate([offset,0,zoffset-0.1]) color("red") rotate([0,0,0]) scale([1,1,1]) cylinder(d=rolson_hex_nut_dia(3)+1,h=rolson_hex_nut_hi(3)+0.7,$fn=6);
	}
}


// ramps top mount
if( drawArray==[] || search(20,drawArray)!=[] )
{
  translate([0,0,Bearing625Height()+pulley1H+pulley2H+32+isExpolode*95+Bearing608Height()+95]) 
  {
		difference()
		{
			hull()
			{
				color("green") rotate([90,0,0]) translate([-29,12.1,3]) cylinder(d=7,h=10,$fn=12);
				color("green") rotate([90,0,0]) translate([-29,5,3]) cylinder(d=9,h=10,$fn=12);
			}
			color("red") rotate([90,0,0]) translate([-29,12.1,0]) cylinder(d=3.1,h=20,$fn=12);
		}

		difference()
		{
			hull()
			{
				color("green") rotate([90,0,0]) translate([19.5,18.5,3]) cylinder(d=7,h=10,$fn=12);
				color("green") rotate([90,0,0]) translate([19.5,5,3]) cylinder(d=9,h=10,$fn=12);
			}
			color("red") rotate([90,0,0]) translate([19.5,18.5,0]) cylinder(d=3.1,h=20,$fn=12);
		}
    height = 2+3;
    difference()
    {
      color("blue") 
      union()
      {
        cylinder(d=8+3,h=height);
        difference()
        {
          hull()
          {
            translate([0,-16,0]) color("blue") cylinder(d=30,h=height);

            translate([40,0,0]) 
            color("red") rotate([0,0,0]) scale([1,1,1]) cylinder(d=15,h=height,$fn=16);
            translate([40,-5,0]) 
            color("red") rotate([0,0,0]) scale([1,1,1]) cylinder(d=15,h=height,$fn=16);

            translate([-40,0,0]) 
            color("red") rotate([0,0,0]) scale([1,1,1]) cylinder(d=15,h=height,$fn=16);
            translate([-40,-5,0]) 
            color("red") rotate([0,0,0]) scale([1,1,1]) cylinder(d=15,h=height,$fn=16);
          }
          translate([-25,-35,-0.5]) cube([50,20,height+1]);
        }
      }
			// bearing hole
      //color( "red") translate([0,0,-Bearing608Height()+2]) cylinder(d=Bearing608Diameter()+b608Clearance,h=Bearing608Height()+0.2);
      color( "red") translate([0,0,-1]) cylinder(d=9,h=Bearing608Height()+15);
			// mount holes
      translate([-40,0,-50]) color("red") rotate([0,0,0]) scale([1,1,1]) cylinder(d=3.1,h=100,$fn=16);
      translate([40,0,-50])  color("red") rotate([0,0,0]) scale([1,1,1]) cylinder(d=3.1,h=100,$fn=16);
			// end stopper fit
			translate([-10,15.5,-0.1]) cube([20,10,40]);
			translate([-13.7,12.5,-0.1]) cube([5,5,40]);
			// rods fit
			translate([-45,5.5,-0.1]) cube([20,10,40]);
			translate([25,5.5,-0.1]) cube([20,10,40]);
			// ramps fit
			translate([-40,-23,-0.1]) cube([80,10,40]);
			//extra holes
      translate([-40,-8,-50]) color("red") rotate([0,0,0]) scale([1,1,1]) cylinder(d=3.1,h=100,$fn=16);
      translate([40,-8,-50]) color("red") rotate([0,0,0]) scale([1,1,1]) cylinder(d=3.1,h=100,$fn=16);
    }
  }
}

// ramps 1.4
if( drawArray==[] )
{
	//http://www.thingiverse.com/thing:34621
	translate ([0,-25,135]) rotate([0,-90,180]) import("STL/NonPrintedParts/RAMPS1_4.STL", convexity=3);
}


// extruder bottom spacer
if( drawArray==[] || search(28,drawArray)!=[] )
{
	hs = 28;
	offset = printLayout ? 7 : 40;
	offsetY = printLayout ? 12 : 0;
	zoffset = Bearing625Height()+pulley1H+pulley2H+32+isExpolode*85+Bearing608Height()+Bearing608Height()+18+75;
	difference()
	{
		union()
		{
					translate([-offset,0,zoffset]) color("red") rotate([0,0,0]) scale([1,1,1]) cylinder(r1=5,r2=4,h=hs,$fn=16);
					translate([offset,0,zoffset]) color("red") rotate([0,0,0]) scale([1,1,1]) cylinder(r1=5,r2=4,h=hs,$fn=16);
		}
		// mount holes
		translate([-offset,0,zoffset-1]) color("red") rotate([0,0,0]) scale([1,1,1]) cylinder(d=3.1,h=hs+2,$fn=16);
		translate([offset,0,zoffset-1])  color("red") rotate([0,0,0]) scale([1,1,1]) cylinder(d=3.1,h=hs+2,$fn=16);
		// m5 nuts
		translate([-offset,0,zoffset-0.1]) color("red") rotate([0,0,0]) scale([1,1,1]) cylinder(d=rolson_hex_nut_dia(3)+1,h=rolson_hex_nut_hi(3)+0.7,$fn=6);
		translate([offset,0,zoffset-0.1]) color("red") rotate([0,0,0]) scale([1,1,1]) cylinder(d=rolson_hex_nut_dia(3)+1,h=rolson_hex_nut_hi(3)+0.7,$fn=6);
	}
}

// extruder supprt
if( drawArray==[] || search(29,drawArray)!=[] )
{
  translate([0,0,Bearing625Height()+pulley1H+pulley2H+32+isExpolode*95+Bearing608Height()+95+33+armsExtruderExtra]) 
  {
    height = 2+2;
    difference()
    {
      color("green") 
      union()
      {
        cylinder(d=8+3,h=height);
        difference()
        {
          hull()
          {
            //translate([10,-10,0]) color("blue") cylinder(d=30,h=height);
            //translate([16,-16,0]) color("blue") cylinder(d=30,h=height);

            translate([40,0,0]) 
            color("red") rotate([0,0,0]) scale([1,1,1]) cylinder(d=15,h=height,$fn=16);
            translate([40,-5,0]) 
            color("red") rotate([0,0,0]) scale([1,1,1]) cylinder(d=15,h=height,$fn=16);

            translate([-40,0,0]) 
            color("red") rotate([0,0,0]) scale([1,1,1]) cylinder(d=15,h=height,$fn=16);
            translate([-40,-5,0]) 
            color("red") rotate([0,0,0]) scale([1,1,1]) cylinder(d=15,h=height,$fn=16);
          }
          //translate([-25,-35,-0.5]) cube([50,20,height+1]);
        }
          hull()
          {
            translate([13,-8,0]) color("blue") cylinder(d=30,h=height);
            translate([13,-28,0]) color("blue") cylinder(d=30,h=height);
            translate([32.5,-28,0]) color("blue") cylinder(d=30,h=height);
            translate([32.5,-8,0]) color("blue") cylinder(d=30,h=height);
					}
          hull()
          {
            translate([7,-41,4]) color("blue") cylinder(d=2,h=height);
            translate([35,-41,4]) color("blue") cylinder(d=2,h=height);
            translate([7,-33,0]) color("blue") cylinder(d=2,h=height);
            translate([35,-33,0]) color("blue") cylinder(d=2,h=height);
					}
      }
			// bearing hole
      //color( "red") translate([0,0,-Bearing608Height()+2]) cylinder(d=Bearing608Diameter()+b608Clearance,h=Bearing608Height()+0.2);
      color( "red") translate([0,0,-1]) cylinder(d=9,h=Bearing608Height()+15);
			// mount holes
      translate([-40,0,-50]) color("red") rotate([0,0,0]) scale([1,1,1]) cylinder(d=3.1,h=100,$fn=16);
      translate([40,0,-50])  color("red") rotate([0,0,0]) scale([1,1,1]) cylinder(d=3.1,h=100,$fn=16);
			// rods fit
			translate([-45,5.5,-0.1]) cube([20,10,40]);
			translate([25,5.5,-0.1]) cube([20,10,40]);
			//extra holes
      translate([-40,-8,-50]) color("red") rotate([0,0,0]) scale([1,1,1]) cylinder(d=3.1,h=100,$fn=16);
      translate([40,-8,-50]) color("red") rotate([0,0,0]) scale([1,1,1]) cylinder(d=3.1,h=100,$fn=16);
    }
  }
}

// top bearing spacer
if( drawArray==[] || search(30,drawArray)!=[] )
{
	hs = 42;
	offset = printLayout ? 7 : 40;
	offsetY = printLayout ? 12 : 0;
	zoffset = Bearing625Height()+pulley1H+pulley2H+32+isExpolode*85+Bearing608Height()+Bearing608Height()+18+75+32;
	difference()
	{
		union()
		{
					translate([-offset,0,zoffset]) color("red") rotate([0,0,0]) scale([1,1,1]) cylinder(r1=5,r2=4,h=hs,$fn=16);
					translate([offset,0,zoffset]) color("red") rotate([0,0,0]) scale([1,1,1]) cylinder(r1=5,r2=4,h=hs,$fn=16);
		}
		// mount holes
		translate([-offset,0,zoffset-1]) color("red") rotate([0,0,0]) scale([1,1,1]) cylinder(d=3.1,h=hs+2,$fn=16);
		translate([offset,0,zoffset-1])  color("red") rotate([0,0,0]) scale([1,1,1]) cylinder(d=3.1,h=hs+2,$fn=16);
		// m5 nuts
		translate([-offset,0,zoffset-0.1]) color("red") rotate([0,0,0]) scale([1,1,1]) cylinder(d=rolson_hex_nut_dia(3)+1,h=rolson_hex_nut_hi(3)+0.7,$fn=6);
		translate([offset,0,zoffset-0.1]) color("red") rotate([0,0,0]) scale([1,1,1]) cylinder(d=rolson_hex_nut_dia(3)+1,h=rolson_hex_nut_hi(3)+0.7,$fn=6);
	}
}

// upper bearing fixer
if( drawArray==[] || search(21,drawArray)!=[] )
{
  translate([0,0,armsZ-Bearing608Height()-UpperBearingMountH-3-UpperBearingMountOffset+armsExtruderExtra]) 
  {
		difference()
		{
			union()
			{
				cylinder(r=centerTubeFixerR,h=9);
				translate([0,0,9]) cylinder(r=centerTubeFixerRTop,h=13-9);
			}
			translate([0,0,-1]) cylinder(r=4,h=15+2);
			translate([-20,6,5]) rotate([0,90,0]) cylinder(d=3.1,h=45,$fn=16);
			translate([6.5,6,5]) rotate([0,90,0]) cylinder(d=rolson_hex_nut_dia(3)+0.7,h=45,$fn=6);
			translate([-10,6,5]) rotate([0,90,0]) cylinder(d=rolson_hex_nut_dia(3)+0.7,h=3,$fn=6);
			translate([0,0,-1]) cube([1,10,12]);
		}
	}
}

// upper bearing mount
if( drawArray==[] || search(22,drawArray)!=[] )
{
	height = UpperBearingMountH;
  translate([0,0,armsZ-UpperBearingMountH-UpperBearingMountOffset+armsExtruderExtra]) 
  {
    difference()
    {
      //
      union()
      {
        difference()
        {
					color("blue") union()
					{
						cylinder(d=Bearing608Diameter()+12,h=height);
						hull()
						{
							translate([0,-8,0]) color("blue") cylinder(d=30,h=height);

							translate([40,0,0]) 
								rotate([0,0,0]) scale([1,1,1]) cylinder(d=15,h=height,$fn=16);

							translate([-40,0,0]) 
								rotate([0,0,0]) scale([1,1,1]) cylinder(d=15,h=height,$fn=16);
						}
						hull()
						{
							translate([40,15,0]) 
								rotate([0,0,0]) scale([1,1,1]) cylinder(d=15,h=height,$fn=16);
							translate([40,0,0]) 
								rotate([0,0,0]) scale([1,1,1]) cylinder(d=15,h=height,$fn=16);
						}
						hull()
						{
							translate([-40,15,0]) 
								rotate([0,0,0]) scale([1,1,1]) cylinder(d=15,h=height,$fn=16);
							translate([-40,0,0]) 
								rotate([0,0,0]) scale([1,1,1]) cylinder(d=15,h=height,$fn=16);
						}
						translate([40,15,-3]) 
							rotate([0,0,0]) scale([1,1,1]) cylinder(d=15,h=height+3,$fn=16);
						translate([-40,15,-3]) 
							rotate([0,0,0]) scale([1,1,1]) cylinder(d=15,h=height+3,$fn=16);
					}
          translate([-25,-35,-0.5]) cube([50,20,height+1]);
					// rods holes
					color("red") translate([rodOffsetX,rodOffsetY,-3-0.1]) 
						rotate([0,0,0]) scale([1,1,1]) cylinder(d=6,h=height,$fn=16);
					color("red") translate([-rodOffsetX,rodOffsetY,-3-0.1]) 
						rotate([0,0,0]) scale([1,1,1]) cylinder(d=6,h=height,$fn=16);
					// cut 
					translate([-50,-23,-1]) cube([100,10,40]);
				}
				//
				/*
				hull()
				{
					translate([-3-2,-13,UpperBearingMountH-4/2]) color("blue") rotate([0,90,0]) cylinder(d=4,h=6);
					translate([-3-2,-13,UpperBearingMountH-4/2-20]) color("blue") rotate([0,90,0]) cylinder(d=4,h=6);
					translate([-3,-46,UpperBearingMountH-4/2]) color("blue") rotate([0,90,0]) cylinder(d=4,h=4);
					translate([-3,-49,UpperBearingMountH-4/2-3]) color("blue") rotate([0,90,0]) cylinder(d=4,h=4);
				}
				*/
				color( "magenta") hull()
				{
					clampSize = 6;
					translate([1,-10,height/2]) color("blue") rotate([0,90,0]) cylinder(d=height,h=clampSize);
					translate([1,-25,height/2+3.8]) color("blue") rotate([0,90,0]) cylinder(d=2.5,h=clampSize,$fn=12);
					translate([1,-15,height/2-6]) color("blue") rotate([0,90,0]) cylinder(d=3,h=clampSize);
					translate([1,-27,height/2-1]) color("blue") rotate([0,90,0]) cylinder(d=2.6,h=clampSize,$fn=12);
				}
				color( "green") hull()
				{
					clampSize = 6;
					translate([-9,-10,height/2]) color("blue") rotate([0,90,0]) cylinder(d=height,h=clampSize);
					translate([-9,-25,height/2+3.8]) color("blue") rotate([0,90,0]) cylinder(d=2.5,h=clampSize,$fn=12);
					translate([-9,-15,height/2-6]) color("blue") rotate([0,90,0]) cylinder(d=3,h=clampSize);
					translate([-9,-27,height/2-1]) color("blue") rotate([0,90,0]) cylinder(d=2.6,h=clampSize,$fn=12);
				}
				//translate([12.5,7.5,-8]) cube([20,5,18]);
      }
			// bearing hole
      color( "red") translate([0,0,height-Bearing608Height()]) cylinder(d=Bearing608Diameter()+b608Clearance,h=Bearing608Height()+5);
      color( "red") translate([0,0,-1]) cylinder(r=centerTubeFixerRTop+0.5,h=Bearing608Height()+15);
			// mount holes
      translate([-40,0,-50]) color("red") rotate([0,0,0]) scale([1,1,1]) cylinder(d=3.1,h=100,$fn=16);
      translate([40,0,-50])  color("red") rotate([0,0,0]) scale([1,1,1]) cylinder(d=3.1,h=100,$fn=16);
			// end stopper fit
			translate([-10,15.5,-0.1]) cube([20,10,40]);
			//translate([-13.7,12.5,-0.1]) cube([5,5,40]);
			//extruder mount
      translate([-20,-23,5.5]) color("red") rotate([0,90,0]) cylinder(d=3.1,h=50,$fn=16);
      translate([-20,-16,4]) color("red") rotate([0,90,0]) cylinder(d=3.1,h=50,$fn=16);
			// min switch			//translate([12,17.5,zminZCoord-(armsZ-UpperBearingMountH-UpperBearingMountOffset+armsExtruderExtra)]) rotate([-90,180,180]) EndSwitchBody20x11(1);
			// belt rope axis
      color( "red") translate([0,5,2+height-Bearing608Height()]) rotate([-90,0,0]) cylinder(d=3.05,h=50,$fn=12);
      color( "red") translate([0,8,2+height-Bearing608Height()]) rotate([-90,0,0]) cylinder(r=3,h=3,$fn=12);
      color( "red") translate([0,10.8,2+height-Bearing608Height()]) rotate([-90,0,0]) cylinder(r1=2.5,r2=1.5,h=2,$fn=12);
			//
      //color( "red") translate([17,3.5,-1]) rotate([-90,0,0]) cylinder(d=rolson_hex_nut_dia(3)+0.1,h=4,$fn=6);
      //color( "red") translate([26,3.5,-1]) rotate([-90,0,0]) cylinder(d=rolson_hex_nut_dia(3)+0.1,h=4,$fn=6);
    }
  }
}

if( drawArray==[] )
	translate ([0,0,armsZ-Bearing608Height()-UpperBearingMountOffset+armsExtruderExtra]) Bearing608(); 

if( drawArray==[] )
{
		translate ([0,20,1+armsZ-Bearing608Height()-UpperBearingMountOffset+1]) rotate([90,0,0])
		{		
				Bearing623(); 
				translate ([0,0,-4])Bearing623(); 
			}
}

// x stepper plaform
if( drawArray==[] || search(7,drawArray)!=[] )
{
	translate([xStepperX,xStepperY,xStepperZ])
	{
		holeDist = lookup(NemaDistanceBetweenMountingHoles, Nema17) * 0.5;
		difference()
		{
			union()
			{
				translate([0,0,-1]) cube([42,42,4],center=true);
				translate([-holeDist,holeDist,-xStepperZ+5]) cylinder(r=1.51+3,h=xStepperZ-5);
				translate([holeDist,-holeDist,-xStepperZ+5]) cylinder(r=1.51+3,h=xStepperZ-5);
				translate([holeDist,holeDist,-xStepperZ+5]) cylinder(r=1.51+3,h=xStepperZ-5);
				translate([-xStepperX+3,0,-xStepperZ+5+(xStepperZ-4)/2]) cube([6,42,xStepperZ-4],center=true);
			}
			rotate([0,0,-90]) Nema17_shaft24_Stepper(bSrewsOnly=1);
			extr = lookup(NemaRoundExtrusionDiameter, Nema17);
			color ("silver") translate([0,0,-3.01]) cylinder(d=extr,h=6,$fn=32);
			color ("silver") translate([-xStepperX+10,7,-xStepperZ/2+3])rotate([0,-90,0]) cylinder(d=3.1,h=20,$fn=32);
			color ("silver") translate([-xStepperX+10,-8,-xStepperZ/2+3])rotate([0,-90,0]) cylinder(d=3.1,h=20,$fn=32);
			// tensioner bearing place
			translate([-holeDist,-holeDist,-xStepperZ+5]) cylinder(d=Bearing623Diameter()+1,h=xStepperZ-7);
		}
		if( drawArray==[] )
		{
				translate([-holeDist,-holeDist,-xStepperZ+7]) Bearing623();
		}
	}
}
// y stepper plaform
if( drawArray==[] || search(8,drawArray)!=[] )
{
	translate([yStepperX,yStepperY,yStepperZ])
	{
		holeDist = lookup(NemaDistanceBetweenMountingHoles, Nema17) * 0.5;
		difference()
		{
			union()
			{
				translate([0,0,-1]) cube([42,42,4],center=true);
				translate([-holeDist,holeDist,-xStepperZ+5]) cylinder(r=1.51+3,h=xStepperZ-5);
				//translate([holeDist,-holeDist,-xStepperZ+5]) cylinder(r=1.51+3,h=xStepperZ-5);
				translate([holeDist,holeDist,-xStepperZ+5]) cylinder(r=1.51+3,h=xStepperZ-5);
				translate([-holeDist,-holeDist,-xStepperZ+5]) cylinder(r=1.51+3,h=xStepperZ-5);
				translate([-(-xStepperX+3),0,-xStepperZ+5+(xStepperZ-4)/2]) cube([6,42,xStepperZ-4],center=true);
			}
			rotate([0,0,-90]) Nema17_shaft24_Stepper(bSrewsOnly=1);
			extr = lookup(NemaRoundExtrusionDiameter, Nema17);
			color ("silver") translate([0,0,-3.01]) cylinder(d=extr,h=6,$fn=32);
			color ("silver") translate([-(-xStepperX-10),7,-xStepperZ/2+3])rotate([0,-90,0]) cylinder(d=3.1,h=20,$fn=32);
			color ("silver") translate([-(-xStepperX-10),-8,-xStepperZ/2+3])rotate([0,-90,0]) cylinder(d=3.1,h=20,$fn=32);
			// tensioner bearing place
			translate([holeDist,-holeDist,-xStepperZ+5]) cylinder(d=Bearing623Diameter()+1,h=xStepperZ-7);
		}
		if( drawArray==[] )
		{
				translate([holeDist,-holeDist,-xStepperZ+17]) Bearing623();
		}
	}
}

// base for xy steppers
if( drawArray==[] || search(9,drawArray)!=[] )
{
	difference()
	{
		color ("orange") 
		{
			//translate([-35,0,0]) cube([70,47,5]);
			hull()
			{
				translate([-47.5,85+3,0]) cube([95,3,5]);
				translate([-47.5,123,0]) cube([95,8,5]);
			}
		}
		translate([xStepperX,xStepperY,xStepperZ])
		{
				rotate([0,0,-90]) Nema17_shaft24_Stepper(bSrewsOnly=1);
				translate([xStepperX-10,0,-xStepperZ-0.1]) cylinder(r=1.51,h=10,$fn=12);
				translate([0,15,-xStepperZ-0.1]) cylinder(r=1.51,h=10,$fn=12);
				translate([0,-15,-xStepperZ-0.1]) cylinder(r=1.51,h=10,$fn=12);
				translate([0,0,-xStepperZ+0.5]) cylinder(d=Bearing625Diameter()+b625RClearance,h=10,$fn=12);
				translate([0,0,-xStepperZ-0.1]) cylinder(d=5.2,h=10,$fn=12);
		}
		translate([yStepperX,yStepperY,yStepperZ])
		{
				rotate([0,0,-90]) Nema17_shaft24_Stepper(bSrewsOnly=1);
				translate([-(xStepperX-10),0,-xStepperZ]) cylinder(r=1.51,h=10,$fn=12);
				translate([0,15,-xStepperZ]) cylinder(r=1.51,h=10,$fn=12);
				translate([0,-15,-xStepperZ]) cylinder(r=1.51,h=10,$fn=12);
				translate([0,0,-xStepperZ+0.5]) cylinder(d=Bearing625Diameter()+b625RClearance,h=10,$fn=12);
				translate([0,0,-xStepperZ-0.1]) cylinder(d=5.1,h=10,$fn=12);
		}
	}
	translate([22.5,82,0]) cube([6,6,6]);
	translate([-22.5-6,82,0]) cube([6,6,6]);
}


if( drawArray==[] ) 
	translate([xStepperX,xStepperY,0.5]) Bearing625();
if( drawArray==[] ) 
	translate([yStepperX,yStepperY,0.5]) Bearing625();



// base for z stepper
if( drawArray==[] || search(10,drawArray)!=[] )
{
	//color ("blue") 
	{
		//translate([-35,0,0]) cube([70,47,5]);
		difference()
		{
			color ("blue") union()
			{
				hull() 
				{
					translate([-47.5,85,0]) cube([95,3,5]);
					translate([-47.5,34,0]) cube([95,8,5]);
				}
				color ("blue") difference()
				{
					color ("green") translate([-24,34,0]) cube([48,5,70]);
					color ("red") translate([-20,33,5]) cube([40,10,20]);
				}
				hull()
				{
					color ("red") translate([-7.5,34,5]) cube([15,1,20]);
					color ("red") translate([-2.5,40,5]) cube([5,1,20]);
				}
				color ("green") translate([11.3,45,0]) cube([13,25,28]);
				color ("green") translate([-24.2,45,0]) cube([13,25,28]);

				color ("green") translate([-24.3,39,0]) cube([3,10,70]);
				color ("green") translate([24.3-3,39,0]) cube([3,10,70]);

				color ("green") translate([-24.3,65,24]) rotate([30,0,0]) cube([3,5,45]);
				color ("green") mirror() translate([-24.3,65,24]) rotate([30,0,0]) cube([3,5,45]);

			}
			translate([40,40,-0.2]) color("red") cylinder(r=1.51,h=10,$fn=16);
			translate([-40,40,-0.2]) color("red") cylinder(r=1.51,h=10,$fn=16);
			//
			translate([40,80,-0.2]) color("red") cylinder(r=1.51,h=10,$fn=16);
			translate([-40,80,-0.2]) color("red") cylinder(r=1.51,h=10,$fn=16);
			//
			translate([40,60,-0.2]) color("red") cylinder(r=1.51,h=10,$fn=16);
			translate([-40,60,-0.2]) color("red") cylinder(r=1.51,h=10,$fn=16);
			//
			translate([0,80,-0.2]) color("red") cylinder(r=1.51,h=10,$fn=16);
			translate([0,45,-0.2]) color("red") cylinder(r=1.51,h=10,$fn=16);
			translate([0,63,-0.2]) color("red") cylinder(r=5,h=10,$fn=12);
			//
			translate([22.5,82,-0.2]) cube([6,6,10]);
			translate([-22.5-6,82,-0.2]) cube([6,6,10]);
			//
			color("red") translate([0,48,8.5]) rotate([90,0,0]) scale([1,1,1]) cylinder(r=1.51,h=38,$fn=16);
			translate([0,83,49]) rotate([90,0,0])
			{
				translate( [0,0,45]) rotate([180,0,0]) Nema17_shaft24_Stepper(bSrewsOnly=1);
				color ("silver") translate([0,0,43]) cylinder(d=23,h=12,$fn=32);
			}
			color ("silver") translate([0,0,13]) cylinder(r=outerRad+9.3,h=17,$fn=32);

		}
	}
}

// bed
if( drawArray==[] )
{
	translate([-65,BedYOffset-BedYOffsetMarginY,65+BedZOffset+z]) color ([1,0.5,0.5,0.5]) cube([125,120+BedYOffsetMarginY,3]);
}


module ArmPulley(numBigHoles=0,numSmallHoles=0,smallHolesDist=10,smallHolesDia=1.5,bigHolesRadScale=1,bigHolesOffset=0,idlerH=1,retainerH=1)
{
	difference()
	{
		Pulley(
			teeth = 80,			// Number of teeth, standard Mendel T5 belt = 8, gives Outside Diameter of 11.88mm
			profile = 12,		// 1=MXL 2=40DP 3=XL 4=H 5=T2.5 6=T5 7=T10 8=AT5 9=HTD_3mm 10=HTD_5mm 11=HTD_8mm 12=GT2_2mm 13=GT2_3mm 14=GT2_5mm

			motor_shaft = 5.2,	// NEMA17 motor shaft exact diameter = 5
			m3_dia = 3.2,		// 3mm hole diameter
			m3_nut_hex = 1,		// 1 for hex, 0 for square nut
			m3_nut_flats = 5.7,	// normal M3 hex nut exact width = 5.5
			m3_nut_depth = 2.7,	// normal M3 hex nut exact depth = 2.4, nyloc = 4

			retainer = 1,		// Belt retainer above teeth, 0 = No, 1 = Yes
			retainer_ht = retainerH,	// height of retainer flange over pulley, standard = 1.5
			idler = 1,			// Belt retainer below teeth, 0 = No, 1 = Yes
			idler_ht = idlerH,		// height of idler flange over pulley, standard = 1.5

			pulley_t_ht = 7,	// length of toothed part of pulley, standard = 12
			pulley_b_ht = 0,		// pulley base height, standard = 8. Set to same as idler_ht if you want an idler but no pulley.
			pulley_b_dia = 20,	// pulley base diameter, standard = 20
			no_of_nuts = 1,		// number of captive nuts required, standard = 1
			nut_angle = 90,		// angle between nuts, standard = 90
			nut_shaft_distance = 1.2,	// distance between inner face of nut and shaft, can be negative.


			//	********************************
			//	** Scaling tooth for good fit **
			//	********************************
			//	To improve fit of belt to pulley, set the following constant. Decrease or increase by 0.1mm at a time. We are modelling the *BELT* tooth here, not the tooth on the pulley. Increasing the number will *decrease* the pulley tooth size. Increasing the tooth width will also scale proportionately the tooth depth, to maintain the shape of the tooth, and increase how far into the pulley the tooth is indented. Can be negative
			additional_tooth_width = 0.2, //mm

			//	If you need more tooth depth than this provides, adjust the following constant. However, this will cause the shape of the tooth to change.
			additional_tooth_depth = 0 //mm
		);
		cylinder(r = rolson_hex_nut_dia(5)/2+m5Rclearance,h = rolson_hex_nut_hi(5)+m5Hclearance, $fn=6);

		//echo(bigHoleRad);
		if( numBigHoles )
		{
			//echo(outerRad);
			bigHoleRad = (outerRad-5)*0.32;
			for (i = [0:numBigHoles-1]) 
			{
				rotate([0, 0, (360/numBigHoles)*i])
				translate([bigHoleRad/2+5+6+bigHolesOffset, 0, 0])
				cylinder(r=bigHoleRad*bigHolesRadScale,h=10+retainerH,$fn=16);
			}
		}

		//numSmallHoles = 3;
		if( numSmallHoles )
		{
			for (i = [0:numSmallHoles-1]) 
			{
				rotate([0, 0, (360/numSmallHoles)*i+60])
				translate([smallHolesDist, 0, 0])
				cylinder(r=smallHolesDia,h=10+retainerH,$fn=16);
			}
		}
	}
}

// modified by pavlo gryb
// adapted to small scara
// Tough Belt Clip
// Design by Marius Gheorghescu, December 2013


// how many teeth on each side
teeth = 3;

// width of the belt in mm incl clearance (use 6.25 for typical GT2 belt)
belt_width = 6.5;

// thickness of the belt in mm (use 1.5 for GT2 belt)
belt_thickness = 1.5;

// belt pitch in mm (use 2.0 for GT2 belt)
pitch = 2.0;

// this controls the strength of the bracket 
shell = 1;

/* [Hidden] */
cutout_width = 6 + belt_thickness + shell;
len = 2*teeth*pitch + cutout_width;
round_corner_epsilon = 1;
epsilon = 0.01;


module belt()
{
	// reinforcement
	//cube([len, 2, h], center=true);

	for(i=[pitch/4:pitch:len]) 
	{
		translate([i-len/2, 1.25, 0])
			cube([pitch - round_corner_epsilon, belt_thickness + round_corner_epsilon, belt_width], center=true);
	}
}

module clip() 
{
	difference()  
	{
		union() 
		{
			offset = -0.7;
			// general shape of the clip
			linear_extrude(belt_width + 2*shell, center=true) 
			{
				polygon(points=[
					[len/2,0],
					[3,-2.5], 
					[-3,-2.5], 
					[-len/2,0], 
					[-len/2, shell + belt_thickness+offset], 
					[len/2, shell + belt_thickness+offset]
				]);
			}
		}

		// left belt turn
		rotate([0,0,-45])
		translate([-3.2/2 - shell - belt_thickness/2,0,0])
			cube([belt_thickness, 20 + 2*shell, belt_width], center=true);

		// right belt turn
		rotate([0,0,45])
	//+ belt_thicknes/2 + shell
		translate([3.2/2 + shell + belt_thickness/2,0,0])
			cube([belt_thickness, 20 + 2*shell, belt_width], center=true);

		// m3 hole
		rotate([90,0,0])
			cylinder(r=1.51, h=10 + 2*shell, center=true,$fn=16);

		// hex nut
		translate([0, -2, 0])
		rotate([90,90,0])
			cylinder(r1=1.51,r2=3.51, h=2, center=true, $fn=12);
	}
}


module clipCover() 
{
	difference()  
	{
		union() 
		{
			// general shape of the clip
			linear_extrude(belt_width + 2*shell, center=true) 
			{
				polygon(points=[
					[len/2,0],
					[3,-1.5], 
					[-3,-1.5], 
					[-len/2,0], 
					[-len/2, shell + belt_thickness], 
					[len/2, shell + belt_thickness]
				]);
			}
		}

		// m3 hole
		rotate([90,0,0])
			cylinder(r=1.51, h=10 + 2*shell, center=true,$fn=16);

		// hex nut
		translate([0, -2.8, 0])
		rotate([90,90,0])
			cylinder(r=3.35, h=4, center=true, $fn=6);

		// belt teeth
		for(i=[1:1:teeth]) 
		{
			// left side
			color([1,0, 0])
			translate([len/2 + pitch/4 - i*pitch, shell + belt_thickness/2, 0])
				cube([pitch/2, belt_thickness + epsilon, belt_width], center=true);

			// right side 
			color([1,0, 0])
			translate([-len/2 - pitch/4 + i*pitch, shell + belt_thickness/2, 0])
				cube([pitch/2, belt_thickness + epsilon, belt_width], center=true);
		}
	}
}


module BeltClip(partsOffset=0,printLayout=0)
{
	a =  printLayout ?  180 : 0;
	translate([0,0,3]) rotate([0,0,90])
	{
		translate([0,-3,0]) rotate([0,0,a]) clip();
		translate([0,-0+partsOffset,0]) rotate([0,0,180+a]) clipCover();
	}
}
