#
# Makefile for msxhub-packages
#
DOCKER ?= docker
OPENMSX ?= openmsx
OPENMSX_ARGS ?= -machine "Boosted_MSXturboR_with_IDE" -ext msxdos2
OPENMSX_SPEED ?= $(if $(findstring turboR,$(OPENMSX_ARGS)),100,333)
MSXHUB_API ?= https://msxhub.com/api

ifeq ($(OS),Windows_NT)
	MH_RM = del /F /Q
	MH_RMDIR = rmdir /S /Q
	MH_MKDIR = mkdir
	MH_COPY = xcopy /s /q /y /i
	MSXHUB_CACHE ?=%LOCALAPPDATA%/msxhub/repro-v0
	DOCKER_ARGS = run -it --rm -v "%cd%":/usr/src fr3nd/msxhub-packages:4
else
	MH_RM = rm -f
	MH_RMDIR = rm -rf
	MH_MKDIR = mkdir -p
	MH_COPY = cp -r
	MSXHUB_CACHE ?=~/.cache/msxhub/repro-v0
	DOCKER_ARGS = run -it --rm -u $$(id -u) -v $$(pwd):/usr/src fr3nd/msxhub-packages:6
endif

define _mh_lowercase
$(subst A,a,$(subst B,b,$(subst C,c,$(subst D,d,$(subst E,e,$(subst F,f,$(subst G,g,$(subst H,h,$(subst I,i,$(subst J,j,$(subst K,k,$(subst L,l,$(subst M,m,$(subst N,n,$(subst O,o,$(subst P,p,$(subst Q,q,$(subst R,r,$(subst S,s,$(subst T,t,$(subst U,u,$(subst V,v,$(subst W,w,$(subst X,x,$(subst Y,y,$(subst Z,z,$(1)))))))))))))))))))))))))))
endef
define _msxhub_file_fetch
	$(if $(wildcard $(dir $(MSXHUB_CACHE)/$(subst $(MSXHUB_API)/,,$(1)))),,$(MH_MKDIR) $(dir $(MSXHUB_CACHE)/$(subst $(MSXHUB_API)/,,$(1))))
	$(if $(wildcard $(MSXHUB_CACHE)/$(subst $(MSXHUB_API)/,,$(1))),,$(DOCKER) $(DOCKER_ARGS) curl -o files/download $(1))
	$(MH_COPY) files/download $(MSXHUB_CACHE)/$(subst $(MSXHUB_API)/,,$(1))
	$(MH_RM) files/download
endef
define msxhub_file 
	$(if $(wildcard $(MSXHUB_CACHE)/$(2)),,$(call _msxhub_file_fetch,$(MSXHUB_API)/$(2)))
	$(if $(wildcard $(1)/$(call _mh_lowercase,$(notdir $(2)))),,$(MH_COPY) $(MSXHUB_CACHE)/$(2) $(1)/$(call _mh_lowercase,$(notdir $(2))))
	$(if $(filter true,$(3)),$(MH_COPY) $(MSXHUB_CACHE)/$(2) $(1)/$(call _mh_lowercase,$(notdir $(2))))
endef
define msxdos_clean
	-$(MH_RM) dsk/nextor.sys
	-$(MH_RM) dsk/msxdos.sys
	-$(MH_RM) dsk/msxdos2.sys
	-$(MH_RM) dsk/command.com
	-$(MH_RM) dsk/command2.com
endef
define openmsx_run
	$(call msxhub_file,tools/openmsx,OMSXCTL/1.0-1/get/OMSXCTL/omsxctl.tcl)
	SPEED=$(OPENMSX_SPEED) $(OPENMSX) $(OPENMSX_ARGS) -script tools/openmsx/omsxctl.tcl -script tools/openmsx/init.tcl -control stdio < tools/openmsx/stdio.xml
endef

.SUFFIXES:
.PHONY: all
all:
	@echo "Please, specify one package to build:"
	@echo "clean test emulator emulator-dos1 emulator-dos2 emulator-nextor"
	@echo $(subst .yaml,,$(subst packages/,,$(wildcard packages/*.yaml)))

.PHONY: clean
clean:
	$(MH_RMDIR) files/
	$(MH_RMDIR) dsk/
	$(MH_RM) DSK.dsk
	$(MH_RM) tools/openmsx/omsxctl.tcl

dsk:
	$(MH_MKDIR) dsk/

dsk/files: | dsk
	$(MH_MKDIR) dsk/files

# TODO: remove sofarom folder after: https://github.com/fr3nd/msxhub-packages/issues/92
dsk/sofarom: | dsk
	$(MH_MKDIR) dsk/sofarom

dsk/utils: | dsk
	$(MH_MKDIR) dsk/utils

dsk/utils/shutdown.bat: | dsk/utils
	$(MH_COPY) tools/emulator/shutdown.bat dsk/utils/

dsk/utils/mouse.bat: | dsk/utils
	$(MH_COPY) tools/emulator/mouse.bat dsk/utils/

dsk/utils/z80.bat: | dsk/utils
	$(MH_COPY) tools/emulator/z80.bat dsk/utils/

dsk/utils/omsxctl.com: | dsk/utils
	$(call msxhub_file,dsk/utils,OMSXCTL/1.0-1/get/OMSXCTL/omsxctl.com)

dsk/utils/more.com: | dsk/utils
	$(call msxhub_file,dsk/utils,MSXDOS2T/1.0-1/get/MSXDOS2T/MORE.COM)

dsk/utils/dump.com: | dsk/utils
	$(call msxhub_file,dsk/utils,MSXDOS2T/1.0-1/get/MSXDOS2T/DUMP.COM)

dsk/utils/turbo.com: | dsk/utils
	$(call msxhub_file,dsk/utils,TURBO/2.1-1/get/TURBO/turbo.com)

dsk/sofarom/srom.com: | dsk/sofarom
	$(call msxhub_file,dsk/sofarom,SOFAROM/3.2-1/get/SOFAROM/SROM.COM)

dsk/sofarom/srom.ini: | dsk/sofarom
	$(call msxhub_file,dsk/sofarom,SOFAROM/3.2-1/get/SOFAROM/SROM.INI)

.PHONY: dsk-dep-bat
dsk-dep-bat: | dsk/utils/shutdown.bat dsk/utils/mouse.bat dsk/utils/z80.bat

.PHONY: dsk-dep-utils
dsk-dep-utils: | dsk/utils/omsxctl.com dsk/utils/more.com dsk/utils/dump.com dsk/utils/turbo.com

.PHONY: dsk-dep-srom
dsk-dep-srom: | dsk/sofarom/srom.com dsk/sofarom/srom.ini

.PHONY: dsk-dep
dsk-dep: | dsk/files dsk-dep-bat dsk-dep-utils dsk-dep-srom

# TODO: Find "CD.COM" and remove the flattening copies.
# As MF-DOS and misix and 103+Himem all did not work.
# It currently does work, but makes a mess of the dsk folder.
.PHONY: emulator-dos1
emulator-dos1: | dsk-dep
	$(call msxdos_clean)
	$(MH_COPY) tools/emulator/autoexec-dos1.bat dsk/autoexec.bat
	$(call msxhub_file,dsk,MSXDOS1/1.03-2/get/MSXDOS1/MSXDOS.SYS,true)
	$(call msxhub_file,dsk,MSXDOS1/1.03-2/get/MSXDOS1/COMMAND.COM,true)
	$(MH_COPY) dsk/utils/* dsk/
	$(MH_COPY) dsk/sofarom/* dsk/
	-$(MH_COPY) dsk/files/*/* dsk/
	@echo *** Please run a manual make clean before running dos2 or nextor.
	$(call openmsx_run)

.PHONY: emulator-dos2
emulator-dos2: | dsk-dep
	$(call msxdos_clean)
	$(MH_COPY) tools/emulator/autoexec-dos2.bat dsk/autoexec.bat
	$(call msxhub_file,dsk,MSXDOS2/2.20-1/get/MSXDOS2/MSXDOS2.SYS,true)
	$(call msxhub_file,dsk,MSXDOS2/2.20-1/get/MSXDOS2/COMMAND2.COM,true)
	$(call openmsx_run)

.PHONY: emulator-nextor
emulator-nextor: | dsk-dep
	$(call msxdos_clean)
	$(MH_COPY) tools/emulator/autoexec-dos2.bat dsk/autoexec.bat
	$(call msxhub_file,dsk,NEXTOR/2.1.0-1/get/NEXTOR/NEXTOR.SYS,true)
	$(call msxhub_file,dsk,NEXTOR/2.1.0-1/get/NEXTOR/COMMAND2.COM,true)
	$(call openmsx_run)

.PHONY: emulator
emulator: | emulator-nextor

%: | dsk/files
	-$(MH_RMDIR) dsk/files/$(call _mh_lowercase,$(@))
	-$(MH_RMDIR) dsk/files/$(@)
	-$(MH_RMDIR) files/$(@)
	$(DOCKER) $(DOCKER_ARGS) pytest-3 -k packages/$(@).yaml
	$(DOCKER) $(DOCKER_ARGS) python3 tools/build/bundle-pkg.py packages/$(@).yaml files
	$(MH_MKDIR) dsk/files/$(@)
	$(MH_COPY) files/$(@)/* dsk/files/$(@)
	$(DOCKER) $(DOCKER_ARGS) python3 tools/build/dir-tolower.py dsk/files/$(@)
	$(DOCKER) $(DOCKER_ARGS) ls -l
	$(DOCKER) $(DOCKER_ARGS) find files/$(@) -type f -exec md5sum '{}' \;

.PHONY: test
test:
	$(DOCKER) $(DOCKER_ARGS) pytest-3 -v

# vim:ft=make
#
