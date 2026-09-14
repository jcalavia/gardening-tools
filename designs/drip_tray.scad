use <../lib/common.scad>

// --- Parameters ---
length = 120;       // mm, overall length
width = 80;         // mm, overall width
height = 15;        // mm, wall height
wall_thick = 2.0;   // mm, wall thickness
corner_radius = 8;  // mm, corner fillet
slope = 2.0;        // mm, floor slopes down from back to front
drain_d = 8.0;      // mm, drain hole diameter
drain_offset = 12;  // mm, drain hole distance from front edge

// Flow ribs
rib_count = 5;      // number of ribs
rib_width = 1.0;    // mm
rib_height = 0.8;   // mm

// Hose barb
barb_length = 12;   // mm, barb extension below tray
barb_od = 10;       // mm, barb outer diameter
barb_count = 2;     // number of barb ridges

// Side mounting slots
mount_d = 6.0;      // mm, mounting hole diameter
mount_z = 4;        // mm, hole center distance from top edge
mount_slot_l = 8;   // mm, slot length

$fn = 64;

// --- Computed ---
inner_l = length - 2 * wall_thick;
inner_w = width - 2 * wall_thick;
inner_r = max(corner_radius - wall_thick, 0);
slope_angle = atan(slope / length);

// --- Modules ---

module flow_rib(y_pos) {
    // Rib runs from back to front, following the sloped floor
    translate([0, y_pos - rib_width / 2, wall_thick + slope])
    rotate([0, slope_angle, 0])
        cube([length - drain_offset - 5, rib_width, rib_height]);
}

module hose_barb() {
    // Main tube
    cylinder(h = barb_length, d = barb_od);

    // Barbed ridges (flared outward so tube grips)
    ridge_h = 1.2;
    for (i = [1 : barb_count]) {
        z = i * (barb_length / (barb_count + 1)) - ridge_h / 2;
        translate([0, 0, z])
            cylinder(h = ridge_h, d1 = barb_od, d2 = barb_od + 1.5);
    }
}

module keyhole_slot() {
    // Circular hole for screw head + narrow upward slot for shaft
    union() {
        cylinder(h = wall_thick + 2, d = mount_d, center = true);
        translate([0, mount_slot_l / 2, 0])
            cube([mount_d * 0.5, mount_slot_l, wall_thick + 2], center = true);
    }
}

module drip_tray() {
    difference() {
        union() {
            // Outer shell
            linear_extrude(height = height)
                rounded_rect_2d(length, width, corner_radius);

            // Flow ribs on sloped floor
            for (i = [0 : rib_count - 1]) {
                y = wall_thick + (inner_w / (rib_count - 1)) * i;
                flow_rib(y);
            }

            // Hose barb nozzle at bottom
            translate([length - drain_offset, width / 2, -barb_length])
                hose_barb();
        }

        // Inner cavity with sloped bottom
        intersection() {
            translate([wall_thick, wall_thick, 0])
                linear_extrude(height = height + 1)
                    rounded_rect_2d(inner_l, inner_w, inner_r);

            translate([-length, -width, wall_thick + slope])
            rotate([0, slope_angle, 0])
                cube([length * 3, width * 3, height]);
        }

        // Drain hole through tray floor and barb
        translate([length - drain_offset, width / 2, -barb_length - 1])
            cylinder(h = wall_thick + barb_length + 2, d = drain_d);

        // Funnel depression to help water collect at the drain
        translate([length - drain_offset, width / 2, wall_thick])
            cylinder(h = drain_d * 0.6, d1 = drain_d * 2.5, d2 = drain_d);

        // Side mounting keyhole slots (left and right walls)
        for (y = [wall_thick / 2, width - wall_thick / 2]) {
            translate([length / 2, y, height - mount_z])
                rotate([90, 0, 0])
                    keyhole_slot();
        }
    }
}

drip_tray();
