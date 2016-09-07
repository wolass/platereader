$fn=100;
/* Plate dimentions
*/
p_width=127.6;
p_depth=85.75;
p_height=14.3;
A=14.3;
B=9;
C=11.36;
well_d=6.21;
well_hood=10;
well_h=11.7;
hood_th = 2; //hood wall thickness for both walls (so divide by 2)

module well() {
    cylinder(d=well_d,center=false,h=well_h);
}

module well2() {
        translate([-well_hood/2,-well_hood/2,0]){
            difference(){
                cube(well_hood,center=false);            
                translate([(+hood_th)/2,(hood_th)/2,0]){
                cube([well_hood-hood_th,well_hood-hood_th,well_hood]);
                }
            }
    }
    }


module row(){
    translate([A,C,p_height-well_h]){
        cylinder(d=well_d,center=false,h=well_h);
        translate([B,0,0]){
            well();
            translate([B,0,0]){
            well();
                translate([B,0,0]){
                well();
                    translate([B,0,0]){
                    well();
                        translate([B,0,0]){
                well();
                            translate([B,0,0]){
                well();
                                translate([B,0,0]){
                well();
                                    translate([B,0,0]){
                well();
                                        translate([B,0,0]){
                well();
                                            translate([B,0,0]){
                well();
                                                translate([B,0,0]){
                well();
                }
                }
                }
                }
                }
                }
                }
                    }
                }
            }
        }
    }
}

module row2(){
    translate([A,C,0]){
        well2();
        translate([B,0,0]){
            well2();
            translate([B,0,0]){
            well2();
                translate([B,0,0]){
                well2();
                    translate([B,0,0]){
                    well2();
                        translate([B,0,0]){
                well2();
                            translate([B,0,0]){
                well2();
                                translate([B,0,0]){
                well2();
                                    translate([B,0,0]){
                well2();
                                        translate([B,0,0]){
                well2();
                                            translate([B,0,0]){
                well2();
                                                translate([B,0,0]){
                well2();
                }
                }
                }
                }
                }
                }
                }
                    }
                }
            }
        }
    }
}

module all_wells(){
    row();
    translate([0,B,0]){
        row();
     translate([0,B,0]){
        row();
        translate([0,B,0]){
        row();
        translate([0,B,0]){
        row();
        translate([0,B,0]){
        row();
        translate([0,B,0]){
        row();
        translate([0,B,0]){
        row();
        
    }
    }
    }
    }
    }
    }   
    }
}

module all_wells2(){
    row2();
    translate([0,B,0]){
        row2();
     translate([0,B,0]){
        row2();
        translate([0,B,0]){
        row2();
        translate([0,B,0]){
        row2();
        translate([0,B,0]){
        row2();
        translate([0,B,0]){
        row2();
        translate([0,B,0]){
        row2();
        
    }
    }
    }
    }
    }
    }   
    }
}

/*plate 
*/
module plate(){
difference(){
cube([p_width,p_depth,p_height]);
    all_wells();
}
}

/*the sensors screen 
*/
module screen() {
translate([0,0,-5])
difference(){
cube([p_width,p_depth,2]);
    translate([0,0,-4])
    all_wells();
}
}

/*the lower case*/
wall_th= 2;
rim_th = 2;
side_box_width=40;
connection_hole_y=20;
connection_hole_z=15;
finger_holes_d=45;
finger_holes_z=15;

module lower_c(){
translate([0,0,-50]){
    union(){
        difference(){
            cube([p_width+(2*wall_th),p_depth+(2*wall_th),p_height*3]);//outer case
            translate([wall_th,wall_th,2*p_height-2]){
                cube([p_width,p_depth,p_height+2]); //upper part/
            }
            translate([wall_th+2,wall_th+2,wall_th,]){
                cube([p_width-4,p_depth-4 ,2*p_height]);//lower part
            }
            translate([p_width-2,connection_hole_y,wall_th]){ //the hole for the connection cables
            cube([10,p_depth+2*wall_th-2*connection_hole_y,connection_hole_z]);
            }
            translate([0,(p_depth+(2*wall_th))/2,3*p_height+finger_holes_z]){
                rotate([0,90,0])
            cylinder(d=finger_holes_d,h=wall_th,center=false);
            }
            translate([p_width+wall_th,(p_depth+(2*wall_th))/2,3*p_height+finger_holes_z]){
                rotate([0,90,0])
            cylinder(d=finger_holes_d,h=wall_th,center=false);
            }
        }
        translate([p_width+2*wall_th,0,0]){ //the side box
            difference(){
                cube([side_box_width,p_depth+2*wall_th,3*p_height]); //outer
                translate([0,wall_th,wall_th])
                cube([side_box_width-wall_th,p_depth,3*p_height-wall_th]); //inner
            }
        }
        translate([-2,-2,2*p_height]){
            difference(){
                cube([p_width+side_box_width+2*rim_th+2*wall_th,p_depth+2*wall_th+2*rim_th,rim_th]);//the rim
                translate([rim_th,rim_th,0]){ //inner hole in the rim     
                    cube([p_width+side_box_width+2*wall_th,p_depth+2*wall_th,rim_th]);
                }
            }
        }
    }
}
}

//The LEDs grid

module leds_grid(){
    union(){
        translate([0,0,5])
        screen();
        all_wells2();
    }
}

//The upper lid
offset=0.1;
slide=1;
outer_dim_x =p_width+                               //outer x dimention of the lid
                            side_box_width+
                            2*rim_th+
                            2*wall_th;  
outer_dim_y =p_depth+
                            2*wall_th+
                            2*rim_th;
inside_dim_x=outer_dim_x-
                            2*rim_th-
                            2*offset;
inside_dim_y=outer_dim_y-
                            2*rim_th-
                            2*offset;
slide_out_x=inside_dim_x-
                        side_box_width; // tthis is the main cube for the slide
slide_out_y=inside_dim_y;
                        
module upper_c(){
    difference(){
        cube([outer_dim_x,outer_dim_y,3*p_height]);//outer dimention of the lid
        translate([rim_th,rim_th,wall_th]) //move inside for the length of rim
        cube([inside_dim_x,inside_dim_y,3*p_height]);//inner dimention of the lid 
    }
    translate([wall_th,wall_th,p_height]){ //move inside the rim and plot the body
        difference(){
            cube([slide_out_x,slide_out_y,2]);//main body
            translate([rim_th-offset,rim_th-offset,0]){ //moved inside the walls and to the roof
                cube([p_width+2*offset,p_depth+2*offset,0.5]); //cuts the hole for the plate
                translate([0,slide,0.5]){//hole leaving the slides
                cube([p_width+2*offset,p_depth-2*slide+2*offset,2]);
                    translate([0,slide,-3])//destroy the bridge and leave tiny bits on sides = slides to fix plate
                    cube([p_width+2*offset+2,p_depth+2*offset-4*slide,5]);
                }
            
        }
        }
    }
}

screen();
lower_c();
translate([-rim_th,2*rim_th+wall_th+p_depth,17]){
rotate([180,0,0]){
    !upper_c();
    translate([rim_th+wall_th,rim_th+wall_th,p_height])
    leds_grid();
}
}
