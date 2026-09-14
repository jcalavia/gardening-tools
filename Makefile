# Makefile for gardening-tools
# Auto-discovers .scad files in designs/ and renders them to stl/.
# Parametric variants for drip_tray are defined explicitly below.

OPENSCAD ?= openscad

ifeq ($(shell command -v $(OPENSCAD) 2>/dev/null),)
  OPENSCAD := $(firstword $(wildcard /Applications/OpenSCAD*.app/Contents/MacOS/OpenSCAD))
  ifeq ($(OPENSCAD),)
    $(error OpenSCAD not found. Set OPENSCAD=<path> or install with: brew install openscad)
  endif
endif

DESIGNS_DIR := designs
STL_DIR := stl

# Auto-discovered designs
DESIGN_FILES := $(wildcard $(DESIGNS_DIR)/*.scad)
STLS := $(patsubst $(DESIGNS_DIR)/%.scad,$(STL_DIR)/%.stl,$(DESIGN_FILES))

# Parametric variants for drip_tray
STLS += \
	$(STL_DIR)/drip_tray_small.stl \
	$(STL_DIR)/drip_tray_large_left.stl \
	$(STL_DIR)/drip_tray_large_right.stl

# Exclude the base drip_tray.stl (rendered via variants instead)
STLS := $(filter-out $(STL_DIR)/drip_tray.stl,$(STLS))

.PHONY: all clean

all: $(STLS)

# Auto-discovered designs
$(STL_DIR)/%.stl: $(DESIGNS_DIR)/%.scad
	@mkdir -p $(STL_DIR)
	$(OPENSCAD) -o "$@" "$<"

# Drip tray variants
$(STL_DIR)/drip_tray_small.stl: $(DESIGNS_DIR)/drip_tray.scad
	@mkdir -p $(STL_DIR)
	$(OPENSCAD) -o "$@" \
		-D 'length=250' -D 'width=200' -D 'height=18' \
		-D 'split=false' "$<"

$(STL_DIR)/drip_tray_large_left.stl: $(DESIGNS_DIR)/drip_tray.scad
	@mkdir -p $(STL_DIR)
	$(OPENSCAD) -o "$@" \
		-D 'length=250' -D 'width=200' -D 'height=18' \
		-D 'split=true' -D 'half="left"' "$<"

$(STL_DIR)/drip_tray_large_right.stl: $(DESIGNS_DIR)/drip_tray.scad
	@mkdir -p $(STL_DIR)
	$(OPENSCAD) -o "$@" \
		-D 'length=250' -D 'width=200' -D 'height=18' \
		-D 'split=true' -D 'half="right"' "$<"

clean:
	rm -rf $(STL_DIR) dist/
