.PHONY: clean test emulator
DOCKER = docker run -it --rm -u $$(id -u) -v $$(pwd):/usr/src fr3nd/msxhub-packages

ALL = $(subst .yaml,,$(subst packages/,,$(wildcard packages/*.yaml)))

all:
	@echo "Please, specify one package to build:"
	@echo $(ALL)

%:
	$(DOCKER) pytest-3 -k packages/$(@).yaml
	$(DOCKER) build packages/$(@).yaml $(@)
	mkdir -p dsk/files/
	ln -rs $(@) dsk/files/
	rm -rf package

test:
	$(DOCKER) pytest-3 -v

emulator:
	openmsx -machine "Boosted_MSXturboR_with_IDE" -ext msxdos2 -diska dsk/ -script emulation/boot.tcl

clean:
	rm -rf package dsk/files $(ALL)

# vim:ft=make
#
