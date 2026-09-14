# gardening-tools

A growing collection of 3D-printable gardening accessories. Each model is parametric and designed for easy customization in OpenSCAD.

## Description

Current models:

- **Drip Tray** (`drip_tray`) — Rectangular plant drip tray with rounded corners, a sloped floor, flow-guiding ribs, and a barbed hose nozzle. Tunable length, width, height, wall thickness, slope, drain diameter, and barb size.

More tools (labels, brackets, hose guides, etc.) can be added under `designs/`.

## Print Settings

| Setting | Value |
|---------|-------|
| Layer height | 0.2–0.3 mm |
| Infill | 15–20 % (trays are largely hollow) |
| Supports | No |
| Orientation | Flat on build plate (base down) |
| Walls | 3 |

**Recommended filament**: PETG or PLA for outdoor use; PETG preferred for UV resistance.

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
