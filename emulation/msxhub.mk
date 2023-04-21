
# OS cmds
ifeq ($(OS),Windows_NT)
	MH_RM = del /F /Q
	MH_RMDIR = RMDIR /S /Q
	MH_MKDIR = mkdir
	MH_COPY = copy
	MH_ERRIGNORE = 2>NUL || true
	MH_SEP=\\
	MH_CACHE?=%LOCALAPPDATA%
	MH_FETCH?=todo
else
	MH_RM = rm -f
	MH_RMDIR = rm -rf
	MH_MKDIR = mkdir -p
	MH_COPY = cp
	MH_ERRIGNORE = 2>/dev/null
	MH_SEP=/
	MH_CACHE?=~/.cache
	MH_FETCH?=wget -O
endif

define _mh_copy
	$(MH_COPY) $(1) $(2)
endef
define _mh_mkdir
	$(MH_MKDIR) $(1)
endef
define _mh_fetch
	$(MH_FETCH) $(1) $(2)
endef

MH_MSXHUB_API   ?= https://msxhub.com/api
MH_MSXHUB_CACHE ?= $(MH_CACHE)/msxhub/repro-v0

# NOTE: with HDD import/export we get duplicate files after openMSX run, so force to lowercase.
define _mh_lowercase
$(subst A,a,$(subst B,b,$(subst C,c,$(subst D,d,$(subst E,e,$(subst F,f,$(subst G,g,$(subst H,h,$(subst I,i,$(subst J,j,$(subst K,k,$(subst L,l,$(subst M,m,$(subst N,n,$(subst O,o,$(subst P,p,$(subst Q,q,$(subst R,r,$(subst S,s,$(subst T,t,$(subst U,u,$(subst V,v,$(subst W,w,$(subst X,x,$(subst Y,y,$(subst Z,z,$(1)))))))))))))))))))))))))))
endef

define _msxhub_fetch_file
	@echo === Fetch msxhub file
	$(call _mh_mkdir,$(dir $(MH_MSXHUB_CACHE)/$(subst $(MH_MSXHUB_API)/,,$(1))))
	test -f $(MH_MSXHUB_CACHE)/$(subst $(MH_MSXHUB_API)/,,$(1)) || $(call _mh_fetch,$(MH_MSXHUB_CACHE)/$(subst $(MH_MSXHUB_API)/,,$(1)),$(1))
endef

define msxhub_file
	$(if $(wildcard $(MH_MSXHUB_CACHE)/$(subst $(MH_MSXHUB_API)/,,$(2))),,$(call _msxhub_fetch_file,$(2)))
	$(if $(wildcard $(dir $(1))$(call _mh_lowercase,$(notdir $(1)))),,$(call _mh_copy,$(MH_MSXHUB_CACHE)/$(subst $(MH_MSXHUB_API)/,,$(2)),$(dir $(1))$(call _mh_lowercase,$(notdir $(1)))))
endef
	
define msxhub_get_nextor
	$(call msxhub_file,$(1)/MSXDOS2.SYS,$(MH_MSXHUB_API)/MSXDOS2/2.20-1/get/MSXDOS2/MSXDOS2.SYS)
	$(call msxhub_file,$(1)/COMMAND2.COM,$(MH_MSXHUB_API)/MSXDOS2/2.20-1/get/MSXDOS2/COMMAND2.COM)
	$(call msxhub_file,$(1)/NEXTOR.SYS,$(MH_MSXHUB_API)/NEXTOR/2.1.0-1/get/NEXTOR/NEXTOR.SYS)
	$(call msxhub_file,$(1)/NSYSVER.COM,$(MH_MSXHUB_API)/NEXTOR/2.1.0-1/get/NEXTOR/NSYSVER.COM)
endef
