use <../third-party/SCAD_Lib/din_rail/clip.scad>

psu_height = 128;
psu_depth = 63.5;

top_offset = -2;

height = psu_height + 20;
width = 25;
thickness = 8;

module bracket() {
  difference() {
    translate([0, width / 2, -thickness]) {
      rotate([90, 0, 0]) {
        linear_extrude(width) {
          difference() {
            union() {
              DinRailClip();

              translate([-height / 2, 0]) {
                square([height, thickness + psu_depth + top_offset]);
              }
            }

            translate([-psu_height / 2, thickness]) {
              square([psu_height, psu_depth]);
            }
          }
        }
      }
    }

    dx = (psu_height + (20 / 2)) / 2;
    for (x = [-dx, dx]) {
      translate([x, 0, psu_depth - 10 + top_offset]) {
        cylinder(h = 10.1, d = 4.2, $fn = 8);
      }
    }
  }
}

module cap() {
  difference() {
    square([height, width], center = true);

    dx = (psu_height + (20 / 2)) / 2;
    for (x = [-dx, dx]) {
      translate([x, 0]) {
        circle(d = 3.5, $fn = 24);
      }
    }
  }
}

bracket();
translate([0, 0, psu_depth + 5]) {
  cap();
}
