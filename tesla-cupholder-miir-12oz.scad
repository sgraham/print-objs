$fn = 50;

layer_width=0.44;

// Cup
cup_thickness=3*layer_width;
cup_diam_top=82.5; 
cup_diam_bottom=75.6; 
cup_depth = 67.0; 

// Holder
holder_diam_inner = 86;
holder_depth = 50;
holder_thickness=3*layer_width;
handle_width = 25;
handle_start_depth=10;

// Flare
flare_diam_bottom = cup_diam_top;
flare_diam_top = holder_diam_inner+2*holder_thickness;
flare_depth = 4;

module cupInside() {
    cylinder(h=cup_depth+.1, 
      d1=cup_diam_bottom-2*cup_thickness, 
      d2=cup_diam_top-2*cup_thickness, 
      center=true);
}
module cupOutside() {
    cylinder(h=cup_depth, 
      d1=cup_diam_bottom, 
      d2=cup_diam_top, 
      center=true);
}
module cup() {
    difference() {
      cupOutside();
      cupInside();
    }
}

module flareInside() {
    cylinder(h=flare_depth+.1, 
      d1=flare_diam_bottom-2*holder_thickness,
      d2=flare_diam_top,
      center=true);
}

module flareOutside() {
    cylinder(h=flare_depth+.1, 
      d1=flare_diam_bottom,
      d2=flare_diam_top,
      center=true);
}

module flare() {
    difference() {
        flareOutside();
        flareInside();
    }
}


module holderInside() {
    cylinder(h=holder_depth+.1, 
      d1=holder_diam_inner, 
      d2=holder_diam_inner, 
      center=true);
}

module holderOutside() {
    cylinder(h=holder_depth+.1, 
      d1=holder_diam_inner+2*holder_thickness, 
      d2=holder_diam_inner+2*holder_thickness, 
      center=true);
}

module handleCutout() {
    translate([0,holder_diam_inner/2,handle_start_depth]) cube([handle_width, 10, holder_depth], center=true);
}

module holder() {
    difference() {
        holderOutside();
        holderInside();
        handleCutout();
    }
}


union() {
    cup();
    translate([0,0,cup_depth/2+flare_depth/2]) flare();
    translate([0,0,cup_depth/2+flare_depth+holder_depth/2]) holder();
}