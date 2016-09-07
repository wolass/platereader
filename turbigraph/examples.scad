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
cab_hole_l=7;
module cable_hole() {
    cube([cab_hole_w,cab_hole_l,sec_floor_th+1]);
}
//Making cylinders for the chambers
c_h = 50; //height
c_d = 25; //diameter
c_wall_th = 1; // wall thickness
//Make the ports
// First the port for the sensor on a pcb
// and a port for the led
module chamber(){
    translate([0,0,c_h/2]){
        difference(){
            cylinder(h = c_h, d = c_d+2*c_wall_th, center=true);
            cylinder(h = c_h, d = c_d, center=true);
        }
    }
}
//Putting the whole floor together
translate([-4,-4,54]){     // second floor
//cable holes
    difference(){
        cube([sec_floor_wid-off,sec_floor_len-off,sec_floor_th]);  //plate for this floor       
        translate([sec_floor_wid-cab_hole_w,sec_floor_len/2+2,0]){  // hole A
        cable_hole();
        }
        translate([sec_floor_wid-cab_hole_w,sec_floor_len/2-cab_hole_l-2,0]){  // hole B
        cable_hole();
        }
        translate([0,sec_floor_len/2+2,0]){  // hole C
        cable_hole();
        }
        translate([0,sec_floor_len/2-cab_hole_l-2,0]){  // hole D
        cable_hole();
        }
    }
    //CHAMBERS NEED TO TOUCH THE RIM 
    translate([(c_d/2+c_wall_th),sec_floor_len/4,0]){
        chamber();
    }
    translate([(sec_floor_wid-(c_d/2+c_wall_th)-off),sec_floor_len/4,0]){
        chamber();
    }
    translate([(c_d/2+c_wall_th),sec_floor_len*3/4,0]){
        chamber();
    }
    translate([(sec_floor_wid-(c_d/2+c_wall_th)-off),sec_floor_len*3/4,0]){
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
    translate([sec_floor_wid/4,sec_floor_len-3-off,0]){
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
translate([0,0,150]){
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
  grid();
  }
  }