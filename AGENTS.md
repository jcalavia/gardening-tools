# gardening-tools — AGENTS.md

Repo-specific rules and design decisions for the 3D-printable gardening accessories collection.
Applies on top of the parent [`/Users/jcalavia/Development/Github/3d-design/AGENTS.md`](../AGENTS.md) conventions.

## Purpose

Functional, parametric garden parts (currently: plant drip trays). Everything prints on a
Creality Ender 3 V3 Plus (300 × 300 mm bed → keep single pieces within ~250 × 250 mm usable
footprint; anything larger must be split).

## Repo Layout

```
designs/                 # OpenSCAD sources (one file per model)
  drip_tray.scad         # Drip tray — parametric, renders all sizes/cuts via -D overrides
lib/                     # Shared OpenSCAD helpers
  common.scad            # rounded_rect_2d (double-offset rounded rectangle)
stl/                     # Generated STLs (gitignored — NEVER commit)
Makefile                 # `make all` auto-discovers designs/ + explicit drip_tray variants
.github/workflows/render.yml   # CI renders STLs on pushes touching designs/ or lib/
```

STL naming: lowercase with underscores; parametric variants append the override value
(e.g. `drip_tray_small.stl`, `drip_tray_large_left_upside.stl`).

## Design Decisions (read before changing geometry)

### Printer-bed splitting (parent-standard rule)

- The small tray (250 × 200) prints as a single piece. The large tray (250 × 400) is split
  into **two 250 × 200 halves** because no single piece may exceed the ~250 × 250 usable bed.
- Split halves MUST NOT be printable-only halves: `drip_tray_large_left.stl` +
  `drip_tray_large_right.stl` interlock through a tongue-and-groove joint along the long edge.
- The joint carries `joint_tol = 0.25` mm assembly clearance and sits **near the top of the
  wall**, leaving a deliberate gap at the bottom so water flows from the back half to the
  front half and out the drain. Do not seal the joint full-height.

### Print orientation / upside variants

- The barb hangs 12 mm below the tray. Slicing the "right side up" model makes the first
  layers a thin barb tube (fragile, mis-sized).
- Therefore every variant also ships as `*_upside.stl` — the same model pre-rotated 180°
  about X via `rotate_model = 180` so the rim sits on the build plate and the barb points up.
- README tells users to prefer `_upside.stl`; keep that guidance in sync when adding variants.

### Drip-tray geometry (invariants)

- Wall/floor thickness: `wall_thick = 3.0` mm. Floor slopes 2 mm toward the drain.
- Drain: 8 mm hole at the front; a funnel depression (2.5× drain diameter) feeds it; the hose
  barb (11 mm OD ≈ 1.5 mm wall over the drain hole) hangs below with 2 ridges.
- Flow ribs: 5 ribs on the sloped floor, **added AFTER the cavity-cut difference** — ribs
  placed inside the earlier union were fully consumed by the inner-cavity subtraction.
  Keep that ordering: cavity cut first, then union the ribs onto the result.
- `flow_rib` sinks 0.05 mm into the floor to avoid coplanar-face rendering artifacts on union.
- Side mounting holes: 2 per side, 6 mm, centered `mount_z = 5` mm below the top edge,
  positioned from the tray ends via `mount_margin`.
- Shared 2D profile comes from `lib/common.scad` (`rounded_rect_2d` via double `offset`).
- `$fn = 64` for final renders (keep as-is; do not drop for preview-only tricks).

## Working Rules for Agents

- All changes go through the Makefile workflow; never hand-craft STL paths. The Makefile
  auto-discovers `designs/*.scad` → `stl/*.stl`; parametric variants (sizes, split, rotation)
  are declared explicitly with `-D` overrides — follow that pattern for new variants.
- Declare tunable parameters at the top of each `.scad` with `//` comments; metric mm only.
- Comments: Spanish or English both fine in `.scad` and `render.sh`; docs and commits in English.
- New models live in `designs/`; share reusable geometry via `lib/` (use `use <...>`, not include).
- Splits: include assembly clearance (`joint_tol`, ~0.2–0.3 mm), keep functional continuity
  (e.g. water flow) across the seam, and document assembly in README.
- Verify after geometry changes: render with `make stl/<target>.stl`, confirm the variant
  exists and the part still fits the printer-bed rule; report STL list to the user.
- Docs split: **README.md** holds maker-facing facts (parts, print settings incl. the
  `_upside.stl` guidance, assembly); **AGENTS.md** holds author-facing knowledge. Do not
  state the same fact in both — cross-reference instead.
- Commits: semantic English messages (`feat:`/`fix:`/`chore:`/`test:`), one concern per commit.
- The repo may be mid-edit by the user (e.g. Makefile/README/drip_tray changes pending):
  never commit or revert unrelated working-tree changes; only stage and commit your own files.