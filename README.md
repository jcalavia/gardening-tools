# gardening-tools

A growing collection of 3D-printable gardening accessories. Each model is parametric and designed for easy customization in OpenSCAD.

## Description

Current models:

- **Drip Tray** (`drip_tray`) — Rectangular plant drip tray with rounded corners, a sloped floor, flow-guiding ribs, a barbed hose nozzle, and side mounting holes. Available in two sizes:
  - **Small** (`drip_tray_small.stl`): 250 × 200 mm — fits most printer beds in one piece.
  - **Large** (`drip_tray_large_left.stl` + `drip_tray_large_right.stl`): 250 × 400 mm — split into two interlocking halves for printers with a 300 × 300 mm bed (e.g., Creality Ender 3 V3 Plus).

The two large halves connect with a **tongue-and-groove joint** along the long edge. The joint is positioned near the top of the wall, leaving a gap at the bottom so water can flow from the back half into the front half and out through the drain.

More tools (labels, brackets, hose guides, etc.) can be added under `designs/`.

## Print Settings

| Setting | Value |
|---------|-------|
| Layer height | 0.2–0.3 mm |
| Infill | 15–20 % (trays are largely hollow) |
| Supports | No |
| Orientation | Flat on build plate (base down) |
| Walls | 3 |

**Printer compatibility**

| Variant | Bed size needed | Example printer |
|---------|----------------|-----------------|
| Small (250 × 200 mm) | 250 × 200 mm | Any FDM printer |
| Large half (250 × 200 mm) | 250 × 200 mm | Creality Ender 3 V3 Plus (300 × 300) |

**Recommended filament**: PETG or PLA for outdoor use; PETG preferred for UV resistance.

## Assembly (large tray)

1. Print both halves (`drip_tray_large_left.stl` and `drip_tray_large_right.stl`).
2. Slide the **left half** tongue into the **right half** groove.
3. Apply a thin bead of silicone sealant along the inside joint if you want it fully watertight.
4. Hang the assembled tray using the side mounting holes (minimum 2 screws per side).

## Rendering

```bash
cd gardening-tools
make all        # Render all designs into stl/
make clean      # Remove stl/ and dist/
```

Requires [OpenSCAD](https://openscad.org/) (macOS auto-discovered if installed in `/Applications`).

## Adding a new design

1. Create a new `.scad` file in `designs/`.
2. Use `use <../lib/common.scad>` for shared utilities.
3. Run `make all` — the Makefile auto-discovers new files in `designs/`.

## License

CC-BY-4.0
