use <third-party/SCAD_Lib/din_rail/clip.scad>

height = 100;
width = 12;
thickness = 8;
screw_centres = 85;
stand_height = 3;

difference() {
  union() {
    translate([0, width / 2, -thickness]) {
      rotate([90, 0, 0]) {
        linear_extrude(width) {
          union() {
            DinRailClip();

            translate([-height / 2, 0]) {
              square([height, thickness]);
            }
          }
        }
      }
    }

    for(x = [-screw_centres / 2, screw_centres / 2]) {
      translate([x - 7, -width / 2, 0]) {
        cube([14, width, stand_height]);
      }
    }
  }

  for(x = [-screw_centres / 2, screw_centres / 2]) {
    translate([x, 0, -thickness - 0.1]) {
      cylinder(h = thickness + stand_height + 0.2, d = 4.2); // For M3 threaded brass insert
    }
  }

  for(x = [-screw_centres / 2, screw_centres / 2]) {
    translate([x - 2, -(width / 2) - 0.1, 0]) {
      cube([4, width + 0.2, stand_height + 0.1]);
    }
  }
}

