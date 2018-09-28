.PHONY: clean
DOCKER = docker run -it --rm -u $$(id -u) -v $$(pwd):/usr/src fr3nd/msxhub-packages

ALL = $(subst .yaml,,$(subst packages/,,$(wildcard packages/*.yaml)))

all: $(ALL)

%:
	test -d files/$(@) && exit 0 || true
	$(DOCKER) build packages/$(@).yaml $(@)
	rm -rf package


clean:
	rm -rf files package

# vim:ft=make
#
