include <threads.scad>;


bracket_length = 120.02;
bracket_width_length = 112.78;
bottom_tab_width = 10.19;
bracket_width = 18.29;
bracket_depth = 1.2; // base bracket depth


bracket_reinforce_width = bracket_width * .1;
bracket_reinforce_length = bracket_length * .75;
bracket_reinforce_depth = 0.5;
bracket_reinforce_offset_x = -8;
bracket_reinforce_offset_y = -2;
bracket_cross_reinforce_width = 2;
bracket_cross_reinforce_length = bracket_width * 0.4;
bracket_cross_vec_x = [
    bracket_length * .5 - bracket_cross_reinforce_width / 2,
    bracket_length * .25 - bracket_cross_reinforce_width / 2,
    bracket_length * .75 - bracket_cross_reinforce_width / 2
    ];


bracket_hole_dia = 4.75;
bracket_hole_distance = 107.01;

bracket_bottom_tab_angle_length = (bracket_width - bottom_tab_width) / 2;

screw_mount_width = 9;
screw_mount_length = 8.5 + bracket_depth;
screw_mount_depth = bracket_depth * 3;
screw_mount_thread_dia = 0.1120; // inches
screw_mount_thread_tpi = 40;
screw_mount_thread_distance = 5.33 + bracket_depth;
screw_mount_bulk_r = 2.5;
screw_mount_bulk_depth = 1;
screw_mount_caulking = 2;

first_mount_x = 31.75;
second_mount_x = first_mount_x + 56.52;

notch_width = 2.79;
notch_length = notch_width;

shiftover_width = 2.79;
shiftover_length = shiftover_width;

top_tab_width = 18.01 + bracket_depth / 3; // had to fudge this
top_tab_length = 11.43;

top_tab_y = notch_width;
top_tab_screw_groove_dia = 4.42;
top_tab_screw_groove_fudge = -0.4; // kinda came out looking wrong so I'm faking it a bit here
top_tab_screw_groove_center = 3.18 + top_tab_screw_groove_fudge;
top_tab_screw_groove_distance = 6.35;
top_tab_screw_groove_translate_z = top_tab_length - top_tab_screw_groove_dia / 2 - top_tab_screw_groove_distance;

top_tab_useless_notch_length = 3.05;
top_tab_useless_notch_width = top_tab_screw_groove_distance - top_tab_screw_groove_dia / 2;
top_tab_useless_notch_z = top_tab_length - top_tab_useless_notch_width;
top_tab_useless_notch_y = top_tab_useless_notch_width / 2 + 8.05 - top_tab_useless_notch_length / 2;

module prism(l, w, h){
       polyhedron(
               points=[[0,0,0], [l,0,0], [l,w,0], [0,w,0], [0,w,h], [l,w,h]],
               faces=[[0,1,2,3],[5,4,3,2],[0,4,5,1],[0,3,4],[5,2,1]]
               );
}

// top tab

translate([0, -top_tab_y, 0]) difference() {
    cube([bracket_depth, top_tab_width, top_tab_length + bracket_depth]);
    translate([-.5, -1, top_tab_screw_groove_translate_z + bracket_depth]) {
        cube([bracket_depth + 1, top_tab_screw_groove_center * 2, top_tab_screw_groove_dia]);
        translate([1, top_tab_screw_groove_center * 2, top_tab_screw_groove_dia / 2])
            rotate([0, 90, 0])
            cylinder(r=top_tab_screw_groove_dia / 2, h=2, $fn=20, center=true);
    }
    translate([-.5, top_tab_useless_notch_y, top_tab_useless_notch_z + bracket_depth]) {
        cube([bracket_depth + 1, top_tab_useless_notch_length, top_tab_useless_notch_width + 1]);
    }
}

// screw mounts
module screwmount(x) {
    translate([x - screw_mount_width / 2, bracket_width, -screw_mount_length + bracket_depth])
        // cut out the threads
        difference() {
            union() {
                cube([screw_mount_width, screw_mount_depth, screw_mount_length]);
                translate([screw_mount_width / 2, screw_mount_depth, screw_mount_length - screw_mount_thread_distance])
                    rotate([0, 90, 90])
                    cylinder(r=screw_mount_bulk_r, h=screw_mount_bulk_depth, $fn=6);
                // add just a tiny bit of stuff to make the connection better
                difference() {
                    translate([0, -.5 * screw_mount_caulking, screw_mount_length - screw_mount_caulking * .5])
                        rotate(a=-45, v=[1, 0, 0]) cube([screw_mount_width, screw_mount_depth, screw_mount_caulking]);
                    translate([-5, -5, screw_mount_length]) cube([15, 15, 1]);
                }
            }
            translate([screw_mount_width / 2, -2, screw_mount_length - screw_mount_thread_distance])
                rotate([0, 90, 90]) english_thread(
                    diameter=screw_mount_thread_dia,
                    threads_per_inch=screw_mount_thread_tpi, length=screw_mount_depth / 5);
        }
}

screwmount(first_mount_x);
screwmount(second_mount_x);

// reinforce bracket body
minkowski() {
    union() {
        translate([
            bracket_length / 2 - bracket_reinforce_length / 2 + bracket_reinforce_offset_x,
            bracket_width / 2 - bracket_reinforce_width / 2 + bracket_reinforce_offset_y,
            -bracket_reinforce_depth])
            cube([bracket_reinforce_length, bracket_reinforce_width, bracket_reinforce_depth]);
        // x-reinforce bracket body
        for(x = [0:2]) {
            translate([
                bracket_cross_vec_x[x] + bracket_reinforce_offset_x,
                bracket_width / 2 - bracket_cross_reinforce_length / 2,
                -bracket_reinforce_depth])
                rotate(a=45, v=[0, 0, 1]) cube([bracket_cross_reinforce_width, bracket_cross_reinforce_length, bracket_reinforce_depth]);
        }
    }
    sphere(r=1, $fa=5, $fs=0.5);
}



// build up the shiftover
translate([0, -shiftover_width, 0]) cube([shiftover_length, shiftover_width + .1, bracket_depth]);
translate([
    shiftover_length,
    -shiftover_width,
    bracket_depth])
    rotate([0, 90, 0])  
    prism(bracket_depth, shiftover_width, shiftover_width);   

// Main bracket part
difference() {
    // the base bracket
    cube([bracket_length, bracket_width, bracket_depth]);
    
    // shape the tab at the bottom
    translate([bracket_width_length - 0.05, -.05, -.5])
        cube([bracket_length - bracket_width_length + 0.1, bracket_bottom_tab_angle_length + .1, bracket_depth + 1.05]);
    translate([bracket_width_length - 0.05, bracket_bottom_tab_angle_length + bottom_tab_width,-.5])
        cube([bracket_length - bracket_width_length + 0.1, bracket_bottom_tab_angle_length + 0.1, bracket_depth + 1]);

    // carve out the angles
    translate([
        bracket_width_length,
        bracket_bottom_tab_angle_length - .05,
        2])
        rotate([0, 90, 0])
        rotate([180, 0, 0])    
        prism(bracket_bottom_tab_angle_length, bracket_bottom_tab_angle_length, bracket_bottom_tab_angle_length + 0.1);
    // other side
    translate([
        bracket_width_length + 0.1,
        bracket_bottom_tab_angle_length + bottom_tab_width + .05,
        -2])
        rotate([0, 90, 0])
        rotate([180, 0, 180])    
        prism(bracket_bottom_tab_angle_length, bracket_bottom_tab_angle_length, bracket_bottom_tab_angle_length + 0.1);    
    
    // ornamental hole
    translate([bracket_hole_distance, bracket_width / 2, -1.5])
        cylinder(r=bracket_hole_dia / 2, h=3, $fn=20);
    
    // notch out the shiftover
    translate([-0.95, bracket_width - notch_width, -1])
        cube([notch_length + 1, notch_width + .1, bracket_depth + 2]);
    translate([
        notch_length,
        bracket_width - notch_width,
        2])
        rotate([0, 90, 0])  
        prism(notch_width, notch_width + .2, notch_width);     
}
