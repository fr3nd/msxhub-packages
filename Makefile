.PHONY: clean test
DOCKER = docker run -it --rm -u $$(id -u) -v $$(pwd):/usr/src fr3nd/msxhub-packages

ALL = $(subst .yaml,,$(subst packages/,,$(wildcard packages/*.yaml)))

all:
	@echo "Please, specify one package to build:"
	@echo $(ALL)

%:
	$(DOCKER) pytest-3 -k packages/$(@).yaml
	$(DOCKER) build packages/$(@).yaml $(@)
	rm -rf package

test:
	$(DOCKER) pytest-3 -v

clean:
	rm -rf package $(ALL)

# vim:ft=make
#
