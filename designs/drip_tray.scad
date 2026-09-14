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

$fn = 64;

// --- Computed ---
inner_l = length - 2 * wall_thick;
inner_w = width - 2 * wall_thick;
inner_r = max(corner_radius - wall_thick, 0);

// --- Model ---

module drip_tray() {
    difference() {
        // Outer shell
        linear_extrude(height = height)
            rounded_rect_2d(length, width, corner_radius);

        // Inner cavity with sloped bottom
        intersection() {
            // Vertical bounds of inner space
            translate([wall_thick, wall_thick, 0])
                linear_extrude(height = height + 1)
                    rounded_rect_2d(inner_l, inner_w, inner_r);

            // Space above the sloped plane.
            // Plane is higher at the back (x≈0) and lower at the front (x≈length).
            translate([-length, -width, wall_thick + slope])
            rotate([0, atan(slope / length), 0])
                cube([length * 3, width * 3, height]);
        }

        // Single drain hole at the lowest point (front)
        translate([length - drain_offset, width / 2, -1])
            cylinder(h = wall_thick + 2, d = drain_d);

        // Funnel depression to help water collect at the drain
        translate([length - drain_offset, width / 2, wall_thick])
            cylinder(h = drain_d * 0.6, d1 = drain_d * 2.5, d2 = drain_d);
    }
}

drip_tray();
