echo(version=version());

// screw is 8.5mm long, approx 3mm in diameter, pan head ~6.7mm in diameter.

front_x = 34.5;
front_y = 17;
front_z = 12.5;

right_x = 2.7;
right_y = 30;
right_z = 24.5;

back_x = 12.7;
back_y = 31;
back_z = 2.7;

connect_x = 1.8;
connect_y = 31;
connect_z = 12;

connect_hole_height = 10; // anything
connect_hole_y = 3.45;
connect_hole_z = 4.8;

connect_offset_x = 18;
connect_offset_z = 36 - connect_z;

support_x = 9;
support_y = connect_y;
support_z = 8;

sub_step_x = 2.5;
sub_step_y = connect_y;
sub_step_z = 2.5;

sub_tri_x = 5.5;
sub_tri_y = connect_y;
sub_tri_z = 6.3;

pegbot_x = 5.8;
pegbot_y = 3.5;
pegbot_z = 5;

peg_offset_z = 5;

pegtop_r = 2.4;
pegtop_x = 2.3;
pegtop_embed = 0.2;


left_catch_x = 2.5;
left_catch_y = 18.4;
left_catch_z = 15;

module prism(l, w, h) {
   polyhedron(
           points=[[0,0,0], [l,0,0], [l,w,0], [0,w,0], [0,w,h], [l,w,h]],
           faces=[[0,1,2,3],[5,4,3,2],[0,4,5,1],[0,3,4],[5,2,1]]
           );
}

module halfcyl(h, r) {
    difference() {
        cylinder(h=h, r1=r, r2=r, $fn=360);
        translate([-r, 0, 0]) cube(size=[r*2, r*2, h]);
    }    
}

union() {
    color("blue")
        cube(size=[front_x,front_y,front_z]);
        
    color("red")
        translate([front_x-right_x, (front_y-right_y)/2, -right_z+front_z])
            cube(size=[right_x, right_y, right_z]);
            
    color("green")
        translate([front_x-back_x,(front_y-back_y)/2,front_z-right_z])
            cube(size=[back_x, back_y, back_z]);
    
    translate([connect_offset_x, (front_y-connect_y)/2, -connect_offset_z])
        difference() {
            color("magenta")
                cube(size=[connect_x, connect_y, connect_z]);
            union() {
                color("orange")
                    rotate(90, [0,1,0])
                        translate([-2.5, connect_y/2, 0])
                            cylinder(h=connect_hole_height, r1=connect_hole_y/2, r2=connect_hole_y/2, $fn=360);
                color("yellow")
                    rotate(90, [0,1,0])
                        translate([-2.5, (connect_y-connect_hole_y)/2, 0])
                            cube(size=[connect_hole_height, connect_hole_y, connect_hole_y]);
            }
        }
        
    difference() {
        color("white")
            translate([connect_offset_x, (front_y-support_y)/2, -support_z+(front_z-right_z)+back_z])
                cube(size=[support_x, support_y, support_z]);
        color("yellow")
            translate([connect_offset_x, (front_y-support_y)/2, (front_z-right_z)+back_z-sub_step_z])
                cube(size=[sub_step_x, sub_step_y, sub_step_z]);
        color("red")
            translate([connect_offset_x+support_x, (front_y-support_y)/2, (front_z-right_z)+back_z+sub_tri_x-support_z])
                rotate(90, [0,0,1])
                    rotate(90, [-1,0,0])
                        prism(sub_tri_y, sub_tri_x, sub_tri_z);
    }
        
    union() {
        color("cyan")
            translate([connect_offset_x - pegbot_x + connect_x, (front_y-connect_y)/2+(connect_y-pegbot_y), -connect_offset_z+peg_offset_z])
                cube(size=[pegbot_x, pegbot_y, pegbot_z]);
        color("black")
            translate([connect_offset_x - pegbot_x + connect_x, (front_y-connect_y)/2+(connect_y-pegbot_y), -connect_offset_z+peg_offset_z+pegtop_r])
                rotate(90, [0,-1,0])
                    rotate(180, [0,0,1])
                        halfcyl(pegtop_x, pegtop_r);            
    }

    union() {
        color("pink")
            translate([connect_offset_x - pegbot_x + connect_x, (front_y-connect_y)/2, -connect_offset_z+peg_offset_z])
                cube(size=[pegbot_x, pegbot_y, pegbot_z]);
    
        color("red")
            translate([connect_offset_x - pegbot_x + connect_x, (front_y-connect_y)/2+pegbot_y, -connect_offset_z+peg_offset_z+pegtop_r])
                rotate(90, [0,-1,0])
                    halfcyl(pegtop_x, pegtop_r);
    }

    color("black")
        translate([0, (front_y - left_catch_y)/2, front_z-left_catch_z])
            cube(size=[left_catch_x, left_catch_y, left_catch_z]);
}

