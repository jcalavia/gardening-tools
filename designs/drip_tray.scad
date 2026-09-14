use <../lib/common.scad>

// --- Parameters ---
length = 250;       // mm, front-to-back (slope direction)
width = 200;        // mm, left-to-right (per half when split)
height = 18;        // mm, wall height
wall_thick = 2.0;   // mm, wall thickness
corner_radius = 8;  // mm, corner fillet
slope = 2.0;        // mm, total floor slope
drain_d = 8.0;      // mm, drain hole diameter
drain_offset = 15;  // mm, drain hole distance from front edge

// Flow ribs
rib_count = 5;      // number of ribs
rib_width = 1.2;    // mm
rib_height = 0.8;   // mm

// Hose barb
barb_length = 12;   // mm, barb extension below tray
barb_od = 10;       // mm, barb outer diameter
barb_count = 2;     // number of barb ridges

// Side mounting holes
mount_d = 6.0;          // mm, mounting hole diameter
mount_z = 5;            // mm, hole center distance from top edge
mount_count = 2;        // holes per side (minimum 2 for stability)
mount_margin = 30;      // mm, hole distance from tray ends

// Split / joint (for large trays that exceed printer bed)
split = false;          // set true to render one half of a large tray
half = "left";          // "left" or "right" half when split
joint_tol = 0.25;       // mm, assembly clearance

$fn = 64;

// --- Computed ---
inner_l = length - 2 * wall_thick;
inner_w = width - 2 * wall_thick;
inner_r = max(corner_radius - wall_thick, 0);
slope_angle = atan(slope / length);

// Joint geometry
joint_w = 6;            // tongue depth from wall face
joint_h = 8;            // tongue height
joint_z = height - joint_h - 2;  // positioned near top of wall

// --- Modules ---

module flow_rib(y_pos) {
    translate([0, y_pos - rib_width / 2, wall_thick + slope])
    rotate([0, slope_angle, 0])
        cube([length - drain_offset - 5, rib_width, rib_height]);
}

module hose_barb() {
    cylinder(h = barb_length, d = barb_od);
    ridge_h = 1.2;
    for (i = [1 : barb_count]) {
        z = i * (barb_length / (barb_count + 1)) - ridge_h / 2;
        translate([0, 0, z])
            cylinder(h = ridge_h, d1 = barb_od, d2 = barb_od + 1.5);
    }
}

module mounting_hole() {
    rotate([90, 0, 0])
        cylinder(h = wall_thick + 2, d = mount_d, center = true);
}

module tongue_feature() {
    // Male joint — projects from the mating wall
    translate([0, 0, joint_z])
        cube([length, joint_w, joint_h]);
}

module groove_feature() {
    // Female joint — cut into the mating wall
    translate([-1, -joint_tol, joint_z - joint_tol])
        cube([length + 2, joint_w + joint_tol * 2, joint_h + joint_tol * 2]);
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

            // Hose barb nozzle at bottom (front center)
            translate([length - drain_offset, width / 2, -barb_length])
                hose_barb();

            // Split joint — tongue on left half's right wall
            if (split && half == "left") {
                translate([0, width, 0])
                    tongue_feature();
            }
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

        // Funnel depression
        translate([length - drain_offset, width / 2, wall_thick])
            cylinder(h = drain_d * 0.6, d1 = drain_d * 2.5, d2 = drain_d);

        // Side mounting holes (left and right walls)
        for (y = [wall_thick / 2, width - wall_thick / 2]) {
            for (i = [0 : mount_count - 1]) {
                x = mount_margin + i * ((length - 2 * mount_margin) / max(mount_count - 1, 1));
                translate([x, y, height - mount_z])
                    mounting_hole();
            }
        }

        // Split joint — groove on right half's left wall
        if (split && half == "right") {
            translate([0, 0, 0])
                groove_feature();
        }
    }
}

drip_tray();
