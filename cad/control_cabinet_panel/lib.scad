module nineteen_inch_rack_rails(units) {
  difference() {
    // Rail
    square([rail_width, 44.45 * units], center = true);

    // Mounting holes
    for (unit = [0 : units - 1]) {
      unit_y = 44.45 * (unit - (units - 1) / 2);
      for (y = [-15.875, 0, 15.875]) {
        translate([0, unit_y + y]) {
          circle(d = 7, $fn = 18);
        }
      }
    }
  }
}

module neutrik_panel_mount_connector() {
    circle(d = 24, $fn = 32);

    dx = 19 / 2;
    dy = 24 / 2;
    for(p = [[dx, -dy], [-dx, dy]]) {
        translate(p) {
            circle(d = 3.2, $fn = 18);
        }
    }
}

module pluggable_terminal_block() {
    translate([0, -1.5]) {
        square([32.8, 13], center = true);
    }

    dx = 40 / 2;
    for (x = [-dx, dx]) {
        translate([x, 4.5]) {
            circle(d = 3.5, $fn = 18);
        }
    }
}

module access_control() {
    dx = 50 / 2;
    dy = 60 / 2;

    for (x = [-dx, dx]) {
        for (y = [-dy, dy]) {
            translate([x, y]) {
                circle(d = 3.2, $fn = 18);
            }
        }
    }
}

module fan_cutout(
    size = 80,
    hole_spacing = undef,
    hole_d = 4.5,
    fan_d = undef,
    hub_d = undef,
    rings = 3,
    ring_w = 2.5,
    spokes = 8,
    spoke_w = 2.5,
    grille = true
) {
    hs = is_undef(hole_spacing) ? (
        size == 120 ? 105 :
        size == 140 ? 125 :
        size == 92 ? 82.5 :
        size == 80 ? 71.5 :
        size == 60 ? 50 :
        size == 40 ? 32 :
        size - 15
    ) : hole_spacing;

    fd = is_undef(fan_d) ? (size == 120 ? 115 : size - 5) : fan_d;
    hd = is_undef(hub_d) ? (size == 120 ? 40 : fd * 0.35) : hub_d;
    s_spokes = is_undef(spokes) ? 8 : spokes;
    r_rings = is_undef(rings) ? 3 : rings;

    // Mounting holes
    dx = hs / 2;
    dy = hs / 2;
    for (x = [-dx, dx]) {
        for (y = [-dy, dy]) {
            translate([x, y]) {
                circle(d = hole_d, $fn = 18);
            }
        }
    }

    // Grille cutout
    if (grille) {
        difference() {
            circle(d = fd, $fn = 72);
            circle(d = hd, $fn = 36);

            // Radial spokes
            if (s_spokes > 0) {
                for (i = [0 : s_spokes - 1]) {
                    rotate([0, 0, i * 360 / s_spokes]) {
                        translate([fd / 4, 0]) {
                            square([fd / 2 + 1, spoke_w], center = true);
                        }
                    }
                }
            }

            // Concentric rings
            if (r_rings > 0) {
                r_step = ((fd - hd) / 2) / (r_rings + 1);
                for (i = [1 : r_rings]) {
                    r = (hd / 2) + i * r_step;
                    difference() {
                        circle(r = r + ring_w / 2, $fn = 72);
                        circle(r = r - ring_w / 2, $fn = 72);
                    }
                }
            }
        }
    } else {
        circle(d = fd, $fn = 72);
    }
}

module hex_grille_cutout(
    width = 50,
    height = 40,
    hex_d = 6,
    web = 1.5,
    border = 2
) {
    pitch_d = hex_d + web;
    pitch_x = pitch_d * 3 / 4;
    pitch_y = pitch_d * sqrt(3) / 2;
    columns = ceil(width / pitch_x / 2) + 1;
    rows = ceil(height / pitch_y / 2) + 1;
    grille_half_x = width / 2 - border;
    grille_half_y = height / 2 - border;
    hex_half_x = hex_d / 2;
    hex_half_y = hex_d * sqrt(3) / 4;

    union() {
        for (column = [-columns : columns]) {
            for (row = [-rows : rows]) {
                x = column * pitch_x;
                y = (row + (abs(column) % 2) / 2) * pitch_y;
                if (
                    abs(x) + hex_half_x <= grille_half_x &&
                    abs(y) + hex_half_y <= grille_half_y
                ) {
                    translate([x, y]) {
                        circle(d = hex_d, $fn = 6);
                    }
                }
            }
        }
    }
}

rail_thickness = 1.2 + 0.3; // rail + padding for front of cage nuts
rail_width = 15.875;

panel_size = [486, 264];
panel_thickness = 6;
panel_corner_cutout_size = [18, 42];

// Panel item positions
// TODO: check depth clearaces
panel_x_motor_position = [-200, 40];
panel_y_motor_position = [-160, 40];
panel_z_motor_position = [-120, 40];
panel_power_in_position = [200, 40];
panel_spindle_power_out_position = [200, 90];
panel_operate_led_position = [-120, 85];
panel_lv_connector_position = [-160, 85];
panel_usb_connector_position = [-200, 85];
panel_access_control_position = [100, -60];
panel_fan_position = [-40, 60];

module panel() {
	difference() {
		square(panel_size, center = true);

		// Mounting holes
		dx = 465.12 / 2;
		dy1 = ((31.75 * 4) + (12.7 * 3)) / 2;
		dy2 = ((31.75 * 2) + (12.7 * 1)) / 2;
		for (x = [-dx, dx]) {
			for (y = [-dy1, -dy2, dy1, dy2]) {
				translate([x, y, 0]) {
					circle(d = 7, $fn = 18);
				}
			}
		}

		// Cutouts around top and bottom 1U
		for (rot = [[0, 0], [180, 0], [0, 180], [180, 180]]) {
			rotate([rot[0], rot[1]]) {
				translate(panel_size / 2) {
					rotate([0, 0, 180]) {
						square(panel_corner_cutout_size);
					}
				}
			}
		}

		// Shield bracket mounting holes
		dy = (panel_size[1] / 2) - 10;
		for (x = [-120, 0, 120]) {
			for (dx = [-10, 10]) {
				for (y = [-dy, dy]) {
					translate([x + dx, y]) {
						circle(d = 3.2, $fn = 18);
					}
				}
			}
		}

		// Axis motor mounts
		for (pos = [
			panel_x_motor_position,
			panel_y_motor_position,
			panel_z_motor_position
		]) {
			translate(pos) {
				circle(d = 19.2, $fn = 32);
			}
		}

		// Power in
		translate(panel_power_in_position) {
			neutrik_panel_mount_connector();
		}

		// Spindle power out
		translate(panel_spindle_power_out_position) {
			neutrik_panel_mount_connector();
		}

		// Power/operate LED
		translate(panel_operate_led_position) {
			circle(d = 8, $fn = 24);
		}

		// LV connector
		translate(panel_lv_connector_position) {
		    rotate([0, 0, 90]) {
    			pluggable_terminal_block();
			}
		}

		// USB connector
		translate(panel_usb_connector_position) {
			neutrik_panel_mount_connector();
		}

		// Access control
		translate(panel_access_control_position) {
		    rotate([0, 0, 90]) {
    			access_control();
			}
		}

		// Fan
		translate(panel_fan_position) {
			fan_cutout(size = 92);
		}
	}
}

module panel_recesses() {
	// Axis motor mounts
	for (pos = [
		panel_x_motor_position,
		panel_y_motor_position,
		panel_z_motor_position
	]) {
		translate(pos) {
			circle(d = 35, $fn = 32);
		}
	}
}

module panel_3d() {
	difference() {
		linear_extrude(panel_thickness) {
			panel();
		}

		translate([0, 0, -0.1]) {
			linear_extrude((panel_thickness / 2) + 0.1) {
				panel_recesses();
			}
		}
	}
}

module shield_bracket_panel() {
	length = 40;
	face_width = 20;

	difference() {
		translate([length / 2, 0, 0]) {
			rotate([0, -90, 0]) {
				linear_extrude(length) {
					polygon([[0, 0], [face_width, 0], [0, face_width]]);
				}
			}
		}

		for (x = [-10, 10]) {
			translate([x, -0.1, face_width / 2]) {
				rotate([-90, 0, 0]) {
					cylinder(h = face_width + 0.2, d = 4.2, $fn = 8); // For M3 threaded brass insert
				}
			}

			translate([x, face_width / 2, -0.1]) {
				cylinder(h = face_width + 0.2, d = 4.2, $fn = 8); // For M3 threaded brass insert
			}
		}
	}
}

module shield_bracket_rail() {
	depth = 40;
	height = 44.45;

	difference() {
		translate([-rail_width / 2, 0, 0]) {
			rotate([90, 0, 90]) {
				linear_extrude(rail_width) {
					polygon([[0, 0], [depth, 0], [0, height]]);
				}
			}
		}

		for (z = [5, 5 + 31.75]) {
			translate([0, -0.1, z]) {
				rotate([-90, 0, 0]) {
					cylinder(h = depth + 0.2, d = 4.2, $fn = 8);
				}
			}
		}

		for (y = [15, 30]) {
			translate([0, y, -0.1]) {
				cylinder(h = height + 0.2, d = 4.2, $fn = 8);
			}
		}
	}
}

module panel_corner_insert() {
	clearance = 0.5;
	insert_size = panel_corner_cutout_size - [clearance, clearance];
	rail_x = 465.12 / 2;
	cutout_center_x = (panel_size[0] - panel_corner_cutout_size[0]) / 2;

	difference() {
		square(insert_size, center = true);

		for (y = [5, 5 + 31.75]) {
			translate([rail_x - cutout_center_x, y - panel_corner_cutout_size[1] / 2]) {
				circle(d = 3.2, $fn = 18);
			}
		}
	}
}

module shield(
	back, // Measured from front of mounting rail
) {
  width = 575;

	difference() {
		union() {
		  front = 47; // Measured from front of mounting rail
		  translate([0, -front / 2, 0]) {
  			square([width, front], center = true);
		  }

		  translate([0, back / 2, 0]) {
  			square([width, back], center = true);
		  }
		}

		// Panel bracket mounting holes
		for (x = [-120, 0, 120]) {
			for (dx = [-10, 10]) {
				translate([x + dx, 10]) {
					circle(d = 3.2, $fn = 18);
				}
			}
		}

		// Rail bracket mounting holes
		dx = 465.12 / 2;
		for (x = [-dx, dx]) {
			for (y = [15, 30]) {
				translate([x, rail_thickness + y]) {
					circle(d = 3.2, $fn = 18);
				}
			}
		}

		// Clearance for the ends of the rack rails
		for (x = [-dx, dx]) {
			translate([x, rail_thickness / 2]) {
				square([rail_width + 10, rail_thickness + 4], center = true);
			}
		}
	}
}

module shield_top() {
	shield(back = 44);
}

module shield_bottom() {
  difference() {
    shield(back = 70);

    // Vents
    dx = panel_size[0] / 2 - 65;
    for (x = [-dx, dx]) {
      translate([x, -26]) {
        hex_grille_cutout(width = 130, height = 45);
      }
    }
  }
}

// Assembly: main panel
color("cyan") {
  rotate([90, 0, 0]) {
    panel_3d();
  }
}

// Assembly: 19" rack mount
color("grey") {
  dx = 465.12 / 2;
  for (x = [-dx, dx]) {
    translate([x, rail_thickness, 0]) {
      rotate([90, 0, 0]) {
        linear_extrude(rail_thickness) {
          nineteen_inch_rack_rails(units = 6);
        }
      }
    }
  }
}

// Assembly: shield panel brackets
color("red") {
  for (x = [-120, 0, 120]) {
    for (a = [0, 180]) {
      rotate([0, a, 0]) {
        translate([x, 0, -panel_size[1] / 2]) {
          shield_bracket_panel();
        }
      }
    }
  }
}

// Assembly: shield rail brackets
color("red") {
  dx = 465.12 / 2;
  dz = panel_size[1] / 2;
  for (x = [-dx, dx]) {
    for (a = [0, 180]) {
      rotate([0, a, 0]) {
        translate([x, rail_thickness, -dz]) {
          shield_bracket_rail();
        }
      }
    }
  }
}

// Assembly: panel corner inserts
color("green") {
    cutout_center = (panel_size - panel_corner_cutout_size) / 2;

    translate([cutout_center[0], 0, cutout_center[1]]) {
		rotate([90, 0, 0]) {
		    linear_extrude(panel_thickness) {
                panel_corner_insert();
            }
		}
	}
}

// Assembly: shield
color("orange") {
  dz = (panel_size[1] / 2) + 3;
  translate([0, 0, -dz - 3]) {
    linear_extrude(6) {
      shield_bottom();
    }
  }
  translate([0, 0, dz - 3]) {
    linear_extrude(6) {
      shield_top();
    }
  }
}
