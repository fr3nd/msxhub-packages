.PHONY: clean test emulator
DOCKER = docker run -it --rm -u $$(id -u) -v $$(pwd):/usr/src fr3nd/msxhub-packages:6
OPENMSX_ARGS ?= -machine "Boosted_MSXturboR_with_IDE" -ext msxdos2
#OPENMSX_ARGS ?= -machine "Boosted_MSX2+_JP" -ext msxdos2 -ext ide
ALL = $(subst .yaml,,$(subst packages/,,$(wildcard packages/*.yaml)))
ALL_ZIP = $(subst .yaml,.zip,$(subst packages/,,$(wildcard packages/*.yaml)))

include emulation/msxhub.mk

all:
	@echo "Please, specify one package to build:"
	@echo $(ALL)

%:
	$(DOCKER) pytest-3 -k packages/$(@).yaml
	$(DOCKER) build packages/$(@).yaml files
	mkdir -p dsk/
	ln -rfs files/ dsk/
	rm -rf package
	ls -l dsk/files/$(@)
	find dsk/files/$(@) -type f -exec md5sum '{}' \;

test:
	$(DOCKER) pytest-3 -v

emulator:
	$(call msxhub_get_nextor,dsk)
	openmsx $(OPENMSX_ARGS) -script emulation/boot.tcl

clean:
	rm -rf package DSK.dsk dsk/files files

# vim:ft=make
#
