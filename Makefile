#
# Makefile for msxhub-packages
#
ifeq ($(OS),Windows_NT)
	MH_RM = del /F /Q
	MH_RMDIR = rmdir /S /Q
	MH_MKDIR = mkdir
	MH_COPY = copy
	MH_LS = dir
	MSXHUB_CACHE ?=%LOCALAPPDATA%/msxhub/repro-v0
	MH_FETCH=_fetch_ps
	DOCKER_ARGS= run -it --rm -v "%cd%":/usr/src fr3nd/msxhub-packages:4
	LIST_MD5= echo nop
else
	MH_RM = rm -f
	MH_RMDIR = rm -rf
	MH_MKDIR = mkdir -p
	MH_COPY = cp
	MH_LS = ls -l
	MSXHUB_CACHE ?=~/.cache/msxhub/repro-v0
	MH_FETCH=_fetch_wget
	DOCKER_ARGS= run -it --rm -u $$(id -u) -v $$(pwd):/usr/src fr3nd/msxhub-packages:6
	LIST_MD5= find dsk/files/$(@) -type f -exec md5sum '{}' \;
endif
define _fetch_ps
	powershell.exe $ProgressPreference = 'SilentlyContinue'; Invoke-WebRequest $(1) -OutFile $(2)
endef
define _fetch_wget
	wget -O $(2) $(1)
endef
# NOTE: with HDD import/export we get duplicate files after openMSX run, so force to lowercase.
define _mh_lowercase
$(subst A,a,$(subst B,b,$(subst C,c,$(subst D,d,$(subst E,e,$(subst F,f,$(subst G,g,$(subst H,h,$(subst I,i,$(subst J,j,$(subst K,k,$(subst L,l,$(subst M,m,$(subst N,n,$(subst O,o,$(subst P,p,$(subst Q,q,$(subst R,r,$(subst S,s,$(subst T,t,$(subst U,u,$(subst V,v,$(subst W,w,$(subst X,x,$(subst Y,y,$(subst Z,z,$(1)))))))))))))))))))))))))))
endef
define _msxhub_file_fetch
	$(MH_MKDIR) $(dir $(MSXHUB_CACHE)/$(subst $(MSXHUB_API)/,,$(1)))
	test -f $(MSXHUB_CACHE)/$(subst $(MSXHUB_API)/,,$(1)) || $(call $(MH_FETCH),$(1),$(MSXHUB_CACHE)/$(subst $(MSXHUB_API)/,,$(1)))
endef
define msxhub_file
	$(if $(wildcard $(MSXHUB_CACHE)/$(2)),,$(call _msxhub_file_fetch,$(MSXHUB_API)/$(2)))
	$(if $(wildcard $(1)/$(call _mh_lowercase,$(notdir $(2)))),,$(MH_COPY) $(MSXHUB_CACHE)/$(2) $(1)/$(call _mh_lowercase,$(notdir $(2))))
endef

DOCKER ?= docker
OPENMSX ?= openmsx
OPENMSX_ARGS ?= -machine "Boosted_MSXturboR_with_IDE" -ext msxdos2
MSXHUB_API ?= https://msxhub.com/api

.SUFFIXES:
.PHONY: all
all:
	@echo "Please, specify one package to build:"
	@echo "clean test emulator"
	@echo $(subst .yaml,,$(subst packages/,,$(wildcard packages/*.yaml)))

.PHONY: clean
clean:
	$(MH_RMDIR) dsk/files
	$(MH_RM) DSK.dsk

%:
	$(MH_MKDIR) dsk/files
	$(MH_RMDIR) dsk/files/$(@)
	$(DOCKER) $(DOCKER_ARGS) pytest-3 -k packages/$(@).yaml
	$(DOCKER) $(DOCKER_ARGS) build packages/$(@).yaml dsk/files
	$(MH_RMDIR) package
	$(MH_RMDIR) dsk/files/$(@)/package
	$(MH_LS) dsk/files/$(@)
	$(LIST_MD5)

.PHONY: test
test:
	$(DOCKER) pytest-3 -v

.PHONY: emulator
emulator:
	$(call msxhub_file,dsk,NEXTOR/2.1.0-1/get/NEXTOR/NEXTOR.SYS)
	$(call msxhub_file,dsk,NEXTOR/2.1.0-1/get/NEXTOR/COMMAND2.COM)
	$(call msxhub_file,dsk,OMSXCTL/1.0-1/get/OMSXCTL/omsxctl.com)
	$(call msxhub_file,tools,OMSXCTL/1.0-1/get/OMSXCTL/omsxctl.tcl)
	$(if $(wildcard dsk/SOFAROM),,$(MH_MKDIR) dsk/SOFAROM)
	$(call msxhub_file,dsk/SOFAROM,SOFAROM/3.2-1/get/SOFAROM/SROM.COM)
	$(call msxhub_file,dsk/SOFAROM,SOFAROM/3.2-1/get/SOFAROM/SROM.INI)
	$(OPENMSX) $(OPENMSX_ARGS) -script tools/omsxctl.tcl -script tools/boot.tcl -control stdio < tools/boot_stdio.xml

# vim:ft=make
#
