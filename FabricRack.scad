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
z = Z+ZP;  //to cut for inserting perpendicular attachments

//Variables
w=16; //distance between uprights
W=23.5; //feet width
h=76; //total height of upright
a=81; //angle of racks
dU=(X/2)-(D*2); //nominal depth of upright

d=10; //depth of each rack
s=4; //vertical space between racks
t=1.5; //verical thickness of rack arms
T=.75; //vertical thickness at tip

g=4; //height off ground to first rack
o=1.5; //distrance from upright to outside of brace

$fn=36; //circle definition

//add an option for display mode or ct mode

// Helper module for cutting tool radius compensation at concave corners
module toolRadius(x, y, z=Z) {
    translate([x, y, 0])
    cylinder(h = z, r = D/2);
}

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

translate([(X/2)-(W/2),Y-(g*2)-1-g-1,0])
mirror([0,1,0])
Brace();

translate([X,Y,0])
BraceLock();

module FootBig(){
    difference(){
    hull(){
    cube([W,g,Z]);
    translate([(W-(w+2))/2,g,0])    
    cube([w+2,g,Z]);
    } //end hull
    
    translate([(W/2)+(w/2),2*g,0])
    mirror([0,1,0])
    mirror([1,0,0])
    cube([z,g,Z]);
    
    translate([(W/2)-(w/2),2*g,0])
    mirror([0,1,0])
    cube([z,g,Z]);
    
    // Tool radius compensation for concave corners
    // Right slot corners (only internal corners)
    toolRadius((W/2)+(w/2), g);
    toolRadius((W/2)+(w/2)-z, g);
    
    // Left slot corners (only internal corners)
    toolRadius((W/2)-(w/2), g);
    toolRadius((W/2)-(w/2)+z, g);
    
}//end dif
}//end FootBig

module FootSmall(){
    difference(){
    hull(){
    cube([W,g/2,Z]);
    translate([(W-(w+2))/2,g/2,0])    
    cube([w+2,g/2,Z]);
    }//end hull
        
    translate([(W/2)+(w/2),g,0])
    mirror([0,1,0])
    mirror([1,0,0])
    cube([z,g/2,Z]);
    
    translate([(W/2)-(w/2),g,0])
    mirror([0,1,0])
    cube([z,g/2,Z]);
    
    // Tool radius compensation for concave corners
    // Right slot corners (only internal corners)
    toolRadius((W/2)+(w/2), g/2);
    toolRadius((W/2)+(w/2)-z, g/2);
    
    // Left slot corners (only internal corners)
    toolRadius((W/2)-(w/2), g/2);
    toolRadius((W/2)-(w/2)+z, g/2);
        
    }//end dif
}//end FootSmall

module Brace(){
    difference(){
    cube([W,((h/10)*2)+(3*Z),Z]);
        
    cube([(W/2)-(w/2)-o,((h/10)*2)+(3*Z),Z]); //cut off side
    
    translate([W,0,0])   
    mirror([1,0,0])
    cube([(W/2)-(w/2)-o,((h/10)*2)+(3*Z),Z]);  //cut off side   
    
    translate([(W/2)+(w/2),0,0])
    mirror([1,0,0])
    cube([z,Z*2,Z]);
    translate([(W/2)-(w/2),0,0])
    cube([z,Z*2,Z]);
        
    translate([(W/2)-(w/2)+z,Z*3*1.75,0])
    mirror([1,0,0])
    cube([z+o,(((h/10)*2)+(3*Z))-(Z*3*1.75*2),Z]);
    translate([(W/2)+(w/2)-z,Z*3*1.75,0])
    cube([z+o,(((h/10)*2)+(3*Z))-(Z*3*1.75*2),Z]);

    translate([(W/2)+(w/2),(((h/10)*2)+(3*Z))-(Z*3*1.75*2)+(Z*3*1.75),0])
    mirror([1,0,0])
    cube([z,Z*2,Z]);
    translate([(W/2)-(w/2),(((h/10)*2)+(3*Z))-(Z*3*1.75*2)+(Z*3*1.75),0])
    cube([z,Z*2,Z]);       
    
    // Tool radius compensation for concave corners only
    
    // Bottom slot corners (internal corners only)
    toolRadius((W/2)+(w/2)-z, Z*2);
    toolRadius((W/2)-(w/2)+z, Z*2);
    toolRadius((W/2)-(w/2), Z*2);
    toolRadius((W/2)+(w/2), Z*2);
    
    // Middle cut corners (internal corners)
    toolRadius((W/2)-(w/2)+z, Z*3*1.75);
    toolRadius((W/2)+(w/2)-z, Z*3*1.75);
    toolRadius((W/2)-(w/2), (((h/10)*2)+(3*Z))-(Z*3*1.75*2)+(Z*3*1.75));
    toolRadius((W/2)+(w/2), (((h/10)*2)+(3*Z))-(Z*3*1.75*2)+(Z*3*1.75));
    
    // Top slot corners (internal corners only)
    toolRadius((W/2)-(w/2)+z, (((h/10)*2)+(3*Z))-(Z*3*1.75*2)+(Z*3*1.75)+(Z*2));
    toolRadius((W/2)+(w/2)-z, (((h/10)*2)+(3*Z))-(Z*3*1.75*2)+(Z*3*1.75)+(Z*2));
    
    }//end difference    
} //end Brace

module BraceLock(){
   difference(){
   cube ([Z*6,((6*Z)-(Z*3*1.75))*2,Z]); 
   cube ([(Z*6)-o,((6*Z)-(Z*3*1.75)),Z]);
   
   // Tool radius compensation for concave corners
   toolRadius((Z*6)-o, 0);
   toolRadius((Z*6)-o, ((6*Z)-(Z*3*1.75)));
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
    cube([z,6*Z,Z]);
    translate([dU-(3*Z),(h/10)*6,0])
    cube([z,6*Z,Z]);
   
    //start rack cuts
    rotate([0,0,a-90])

for(i=[1:round(h/(s+t))])
    //translate([0,g,0])
    translate([0,i*(s+t),0])
    RackCut();
   
    // Tool radius compensation for concave corners
    // Front feet cut corners (only internal corners)
    toolRadius(g, g/2);
    toolRadius(g+z, g/2);
    
    // Back feet cut corners (only internal corners)
    toolRadius(dU-(2*g), g);
    toolRadius(dU-(2*g)+z, g);
    
    // Brace cut corners
    toolRadius(dU-(3*Z), (h/10)*4);
    toolRadius(dU-(3*Z)+z, (h/10)*4);
    toolRadius(dU-(3*Z), (h/10)*4+6*Z);
    toolRadius(dU-(3*Z)+z, (h/10)*4+6*Z);
    toolRadius(dU-(3*Z), (h/10)*6);
    toolRadius(dU-(3*Z)+z, (h/10)*6);
    toolRadius(dU-(3*Z), (h/10)*6+6*Z);
    toolRadius(dU-(3*Z)+z, (h/10)*6+6*Z);
   
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
