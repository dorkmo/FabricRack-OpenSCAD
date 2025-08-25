//Fabric Rack
//For CNC Cutting
//Written by Dorkmo

//Input Board
X = 48;
Y = 96;
Z = 0.75;

D = 0.25; //cutting tool Dia
DP= 0.0625;
ZP= 0.0625; //buffer
z = Z+ZP;

//Variables
w=16; //distance between uprights
W=24; //feet width
h=76; //total height of upright
a=81; //angle of racks
dU=(X/2)-(D*2); //nominal depth of upright

d=10; //depth of each rack
s=4; //vertical space between racks
t=1.5; //verical thickness of rack arms
T=.75; //vertical thickness at tip

g=4; //height off ground to first rack

$fn=36; //circle definition

//add an option for display mode or ct mode

translate([dU+0.25,0.25,0])
mirror([1,0,0])
Upright();

translate([X-dU,0.25,0])
Upright();

translate([(X/2)-(W/2),Y,0])
mirror([0,1,0])
FootBig();

translate([(X/2)-(W/2),Y-(g*2)-1,0])
mirror([0,1,0])
FootSmall();

module FootBig(){
    hull(){
    cube([W,g,Z]);
    translate([(W-(w+2))/2,g,0])    
    cube([w+2,g,Z]);
    }
}

module FootSmall(){
    hull(){
    cube([W,g/2,Z]);
    translate([(W-(w+2))/2,g/2,0])    
    cube([w+2,g/2,Z]);
    }
}

module Upright(){
difference(){
cube([dU,h,Z]);
    //front feet cut
    translate([g,0,0])
    cube([z,g/2,Z]);
    //back feet cut
    translate([dU-(2*g),0,0])
    cube([z,g,Z]);
    //brace cuts
    translate([dU-(3*Z),(h/10)*4,0])
    cube([z,3*Z,Z]);
    translate([dU-(3*Z),(h/10)*6,0])
    cube([z,3*Z,Z]);
   
    //start rack cuts
    rotate([0,0,a-90])

for(i=[1:round(h/(s+t))])
    //translate([0,g,0])
    translate([0,i*(s+t),0])
    RackCut();
   
   
}//end difference
}


module RackCut(){
    union(){
    
        //bottom side of arm
        difference(){
            translate([0,s,0])
            cube([d-(s/8),t*(2/3),Z]);
            translate([d-(s/8),s+(t*(2/3)),0])
            resize([(d-(s/8))*2,(t*(2/3))*2,Z])
            cylinder(h = Z, r = t*(2/3));
        }//end dif
        
        //main shelf cut
    hull(){
        cube([s/8,s,Z]);
       
        translate([d-(s/4),(s/4),0])
        cylinder(h = Z, r = s/4);
        translate([d-(s/8),s-(s/8),0])
        cylinder(h = Z, r = s/8);
       
    } //end hull
    
    //top side of arm
    difference(){
        translate([0,-t/8,0])
        cube([t/8,t/8,Z]);
        translate([t/8,-t/8,0])
        cylinder(h = Z, r = t/8);
        
    } //end diff of top cut
    
    translate([-dU,-(s+t),0])
    cube([dU,(s+t)*3,Z]);
    
}//end union
}//end module
