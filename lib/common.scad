// Common utilities for gardening-tools designs

// Rounded rectangle 2D profile
// l, w = outer dimensions (mm)
// r  = corner radius (mm)
module rounded_rect_2d(l, w, r) {
    offset(r = r)
        offset(r = -r)
            square([l, w]);
}
