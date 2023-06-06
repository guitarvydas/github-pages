ODIN_FLAGS ?= -debug -o:none
all:
	rm -f /tmp/front*.md
	odin run . $(ODIN_FLAGS)
