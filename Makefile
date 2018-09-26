.PHONY: clean
DOCKER = docker run -it --rm -u $$(id -u) -v $$(pwd):/usr/src fr3nd/msxhub-packages

ALL = $(wildcard packages/*.yaml)

%:
	mkdir -p files
	$(DOCKER) build packages/$(@).yaml files/$(@)
	rm -rf package


clean:
	rm -rf files package

# vim:ft=make
#
