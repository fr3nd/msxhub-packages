.PHONY: clean test emulator
DOCKER = docker run -it --rm -u $$(id -u) -v $$(pwd):/usr/src fr3nd/msxhub-packages:5
OPENMSX_ARGS ?= -machine "Boosted_MSXturboR_with_IDE" -ext msxdos2
#OPENMSX_ARGS ?= -machine "Boosted_MSX2+_JP" -ext msxdos2 -ext ide
ALL = $(subst .yaml,,$(subst packages/,,$(wildcard packages/*.yaml)))
ALL_ZIP = $(subst .yaml,.zip,$(subst packages/,,$(wildcard packages/*.yaml)))

all:
	@echo "Please, specify one package to build:"
	@echo $(ALL)

%:
	$(DOCKER) pytest-3 -k packages/$(@).yaml
	$(DOCKER) build packages/$(@).yaml files
	mkdir -p dsk/
	ln -rfs files/ dsk/
	rm -rf package

test:
	$(DOCKER) pytest-3 -v

emulator:
	openmsx $(OPENMSX_ARGS) -script emulation/boot.tcl

clean:
	rm -rf package DSK.dsk dsk/files files

# vim:ft=make
#
