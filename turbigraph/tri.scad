include <arduino.scad>

$fn=60;

//Arduino boards
//You can create a boxed out version of a variety of boards by calling the arduino() module
//The default board for all functions is the Uno

dueDimensions = boardDimensions( DUE );
unoDimensions = boardDimensions( UNO );

difference(){
enclosure(boardType = UNO, wall = 3, offset = 3, heightExtension = 20, cornerRadius = 0, mountType = TAPHOLE);

    translate([-4,-4,34]){     //port for the second floor
        cube([sec_floor_wid,sec_floor_len,7]);

//translate([0, 0, 75]) {
//	enclosureLid();
    }
}



// Now we are making the chambers part
sec_floor_th = 3; // this is the thickness of the 2nd floor
sec_floor_wid = 61.2;
sec_floor_len = 76.5;

//First define the cable holes 
cab_hole_w=3;
cab_hole_l=8;
module cable_hole() {
    cube([cab_hole_w,cab_hole_l,sec_floor_th+1]);
}
//Making cylinders for the chambers
c_h = 52; //height
c_d = 29; //diameter
c_wall_th = 1.5; // wall thickness
//Make the ports
// First the port for the sensor on a pcb
s_pcb_h = 11;
s_pcb_w = 21;
s_wall_t = 1;
module clip(){ // for rubber bands, place in the middle of an object
translate([-3,0,0]){
    union(){
    cube([6,1,1.5]);
    translate([-1,0,1.5]){
        cube([8,1,2]);
    }
}
}
}
module s_port(){
    translate([-(s_pcb_h+2*s_wall_t)/2,0,0]){
union(){
    translate([0,1,14]){
        cube([7,3,3]);
    }
    translate([0,1,1]){
        cube([7,3,5]);
    }
    translate([11+1-3,1,1]){
        cube([3,3,2]);
    }
    translate([11+1-3,1,1+21-2]){
        cube([3,3,2]);
    }
    translate([13/2,0,23]){
        clip();
    }
    translate([13/2,0,0]){
        rotate([0,180,0])
        clip();
    }
    difference(){
    cube([s_pcb_h+s_wall_t*2,4,s_pcb_w+s_wall_t*2]); // outer walls
    translate([s_wall_t,0,s_wall_t]){ //inner depth
        cube([s_pcb_h,3,s_pcb_w]);
    }
    
    translate([s_wall_t+2,0,s_wall_t+6]){ //window
        cube([6,10,6]);
    }
}
}
}
}
// and a port for the led
led_outer_dim = 3.55; //this one is cut 
led_outer_d = 4; //outer diameter
led_inner_d = 3;
led_l = 5.5;
led_hat_l = 1;
led_wall = 0.5;

module led_port(){
    //difference(){
        rotate([0,90,0]){
            
            difference(){
                union(){
                    cylinder(h=led_l, d=led_outer_d+2*led_wall);
                    translate([led_outer_d/2,-1.5,0]){
                    difference(){
                        cube([led_l,3,led_l]);
                        translate([6,0,0]){
                            rotate([0,-45,0]){
                                cube([led_l+5,3,led_l+5]);
                            }}
                        }
                    }
                }
                translate([0,0,led_l-led_hat_l]){
                    cylinder(h=led_hat_l,d=led_outer_d);
                }
                cylinder(h=led_l,d=led_inner_d);
            }
        }
    //}
}
//Now put it together to form a chamber type A
module chamber(){
        union(){
            translate([0,c_d/2,16]){
                rotate([0,0,90]){
                led_port();
                }
            }
            translate([c_d/2,0,16]){
                rotate([0,0,0]){
                led_port();
                }
            }
        translate([0,0,c_h/2]){
        difference(){
            cylinder(h = c_h, d = c_d+2*c_wall_th, center=true);
            cylinder(h = c_h, d = c_d, center=true);
        translate([-3.5,-c_d/2-4,-c_h/2+13]){
             cube([6,20,6]);
        }
        translate([0,c_d/2-1,-c_h/2+16]){
            rotate([0,90,90]){
                cylinder(h=led_l+2,d=led_inner_d);
            }
        }
        translate([c_d/2-1,0,-c_h/2+16]){
            rotate([0,90,0]){
                cylinder(h=led_l+2,d=led_inner_d);
            }
        }
    }
}
    translate([0,-(c_d+2*c_wall_th)/2-2.5,6]){
        s_port();
    }
}

}
//Putting the whole floor together
translate([-4,-4,54]){
//translate([-4,-4,0]){     // second floor
//cable holes
    difference(){
        cube([sec_floor_wid-off,sec_floor_len-off,sec_floor_th]);  //plate for this floor       
        translate([sec_floor_wid-cab_hole_w,sec_floor_len/2+2,0]){  // hole A
        cable_hole();
        }
       // translate([sec_floor_wid-cab_hole_w,sec_floor_len/2-cab_hole_l-2,0]){  // hole B
        //cable_hole();
        //}
        translate([0,sec_floor_len/3,0]){  // hole C
        cable_hole();
        }
       
    }
    //CHAMBERS NEED TO TOUCH THE RIM 
    //translate([(c_d/2+c_wall_th),sec_floor_len/4,0]){
    //    chamber();
   // }
    translate([(sec_floor_wid-(c_d/2+c_wall_th)-off),sec_floor_len/4+3,0]){
        rotate([0,0,180]){
        chamber();
        }
    }
    translate([(c_d/2+c_wall_th),sec_floor_len*3/4-3,0]){
        
            chamber();
        
    }
  
  
//translate([0,0,-15]){ 
   // difference(){
       // translate([-third_wall_t,-third_wall_t,0]){
           // cube([sec_floor_wid-off+2*third_wall_t,sec_floor_len-off+2*third_wall_t,third_h+third_wall_t]);
        //}
        //translate([-off/2,-off/2,-third_wall_t]){
           // cube([sec_floor_wid,sec_floor_len,third_h]);
        //}
    //}
    //grid();
//}

    //make the two blockers on the side of the second floor
    translate([sec_floor_wid/4,0,0]){
        cube([10,3,20]);
    }
    
    translate([sec_floor_wid*3/4-10,sec_floor_len-3-off,0]){
        cube([10,3,20]);
    }
      
}
//Third floor 
third_h = 75;
third_wall_t = 1.7;

//making the grid
grid_wall_t = 1 ;
off = 0.3;

module grid(){
    translate([(sec_floor_wid/2)-(grid_wall_t/2),0,0]){
        cube([grid_wall_t,sec_floor_len,third_h]);
    }
    translate([0,sec_floor_len/2-grid_wall_t/2,0]){
        cube([sec_floor_wid,grid_wall_t,third_h]);
    }
}
 //making the hut
translate([0,0,third_h+200]){
rotate([0,180,0]){
    wall=3;
    difference() {
      boundingBox(boardType = UNO, height = third_h, offset = wall + wall, include=PCB, cornerRadius = wall);
  
      //translate([ 0, 0, wall]) {
        //Interior of lid
       translate([-4,-4,-2]){
           cube([sec_floor_wid,sec_floor_len,third_h]);
      }
  }
   translate([-4,-4,0]){
       rotate([0,0,-38]){
  cube([grid_wall_t,sec_floor_len+23,third_h]);
  }
  }
  }
  }