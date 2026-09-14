# Makefile for gardening-tools
# Auto-discovers .scad files in designs/ and renders them to stl/.

OPENSCAD ?= openscad

ifeq ($(shell command -v $(OPENSCAD) 2>/dev/null),)
  OPENSCAD := $(firstword $(wildcard /Applications/OpenSCAD*.app/Contents/MacOS/OpenSCAD))
  ifeq ($(OPENSCAD),)
    $(error OpenSCAD not found. Set OPENSCAD=<path> or install with: brew install openscad)
  endif
endif

DESIGNS_DIR := designs
STL_DIR := stl

DESIGN_FILES := $(wildcard $(DESIGNS_DIR)/*.scad)
STLS := $(patsubst $(DESIGNS_DIR)/%.scad,$(STL_DIR)/%.stl,$(DESIGN_FILES))

.PHONY: all clean

all: $(STLS)

$(STL_DIR)/%.stl: $(DESIGNS_DIR)/%.scad
	@mkdir -p $(STL_DIR)
	$(OPENSCAD) -o "$@" "$<"

clean:
	rm -rf $(STL_DIR) dist/
