.PHONY: clean
DOCKER = docker run -it --rm -u $$(id -u) -v $$(pwd):/usr/src fr3nd/msxhub-packages

ALL = $(subst .yaml,,$(subst packages/,,$(wildcard packages/*.yaml)))

all: $(ALL)

%:
	pytest -k packages/$(@).yaml
	$(DOCKER) build packages/$(@).yaml $(@)
	rm -rf package


clean:
	rm -rf package $(ALL)

# vim:ft=make
#
