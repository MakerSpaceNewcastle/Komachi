use <third-party/SCAD_Lib/din_rail/clip.scad>

height = 110;
width = 37;
thickness = 8;

difference() {
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

  for(p = [[51.5, -10], [-50, -11]]) {
    translate([p[0], p[1], -thickness - 0.1]) {
      cylinder(h = thickness + 0.2, d = 4.2); // For M3 threaded brass insert
    }
  }
}
