# MSXHub packages

This is the MSXHub packages repository containing the package definitions for all the software available in [MSXHub](https://msxhub.com).

A package in MSXHub is just a [YAML](https://en.wikipedia.org/wiki/YAML) file with metadata and instructions on how to generate it. Once approved it will be automatically uploaded to [MSXHub](https://msxhub.com).

## Requirements

To build and test a package in your own PC some software is required:

* GNU make
* Docker

## How to create a package

A MSXHub package is just a YAML file in the [packages/](https://github.com/fr3nd/msxhub-packages/tree/master/packages) directory. This file contains the package information and the script required to build it.

## The PACKAGE.yaml file

### File Name

The file has to be the same as the package name (in uppercase) plus the `yaml` extension in lowercase.

### Package syntax

A package file contains several mandatory fields defining the package itself.

#### name

The name of the package itself.

Restrictions:
* Capital letters
* No longer than 8 characters

#### version

The version of the software being packaged.

Restrictions:
* No longer than 16 characters
* Cannot contain the following characters `-`, `:`

#### release

Release number of the package.
It starts with 1 and it's increased every time a new package with the same version number is created.
Every time a new version is package, the release number should be back to 1.

Restrictions:
* Must be an integer number

#### summary

Short description of the package.

Restrictions:
* No longer than 80 characters

#### author

Name of the author or authors of the packaged software. Can be a personal name or a company name.

Restrictions:
* No longer than 128 characters

#### package_author

Name of the author of the package itself. That's you! :)

Restrictions:
* No longer than 128 characters

#### license

License of the packaged software.

Restrictions:
* Should be in the list defined in [msxhub.com/list_licenses](https://msxhub.com/list_licenses)

Please, [open an issue](https://github.com/fr3nd/msxhub-packages/issues/new) if the required license is not in the list.

#### category

#### system

#### requirements

#### url

#### description

#### installdir

#### files

#### build

#### changelog


## How to build a package
