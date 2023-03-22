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

The name of the package to be created.

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

Category of the packaged software.

Restrictions:
* Should be in the list defined in [msxhub.com/categories](https://msxhub.com/categories)

Please, [open an issue](https://github.com/fr3nd/msxhub-packages/issues/new) if the required category is not in the list.

#### system

Minimum system required to run the software.

Restrictions:
* Should be in the list defined in [msxhub.com/list_systems](https://msxhub.com/list_systems)

Please, [open an issue](https://github.com/fr3nd/msxhub-packages/issues/new) if the required system is not in the list.

#### requirements

List of required extensions to run the software.

Restrictions:
* Should be in the list defined in [msxhub.com/list_requirements](https://msxhub.com/list_requirements)

Please, [open an issue](https://github.com/fr3nd/msxhub-packages/issues/new) if the required extension is not in the list.

#### url

Web URL where to find more information of the packaged software. In some cases, the packaged software doesn't have an official website. Just use a relevant URL in such cases.

Restrictions:
* No longer than 256 characters

#### description

Long description of the packaged software. [Markdown](https://en.wikipedia.org/wiki/Markdown) format can be used to add style to the text.

#### installdir

Default directory where to install the packaged software in MSX-DOS format. Do not specify the drive letter as it will be automatically added by MSXHub.

Restrictions:
* Should start with `\`

Examples:
* `\VI` will be installed in `A:\VI`
* `\MSXDOS2T` will be installed in `A:\MSXDOS2T`

#### files

Before building the package, the required files need to be downloaded. This list field define all the files required to build the package and the URLs where to get it them.

Use the following format:

```
files:
  - vi.zip: 'https://github.com/fr3nd/msx-vi/releases/download/v%VERSION%/vi.zip'
```

First define the name of the file and then the URL where to fetch it.

The string `%VERSION%` will be automatically replaced by the content defined in the field `version`.

#### build

[GNU Bash](https://en.wikipedia.org/wiki/Bash_(Unix_shell)) script to generate the package.

The script needs to have all the commands to uncompress the downloaded file and place all the required files in the `package/` directory.

In some cases, `BAT` or `BAS` files need to be created. In such cases, [here documents](https://www.tldp.org/LDP/abs/html/here-docs.html) may be used. Do not forget to convert the resulting file to DOS format after it's been created:

```
cat > package/RUNME.BAT << EOF
basic LOADER.BAS
EOF
unix2dos package/RUNME.BAT
```

Requirements:
* The first line should be `mkdir -p package` to create the directory where all the files will be stored.

Example:
```
build: |
  mkdir -p package/
  unzip alien8.zip
  mv Alien8msx2.rom package/alien8.rom
  cat > package/alien8.bat << EOF
  srom alien8.rom
  EOF
  unix2dos package/alien8.bat
```

#### changelog

Simple changelog of the package in [Markdown](https://en.wikipedia.org/wiki/Markdown) format.

Example:
```
changelog: |
  - 1.0.0-1 2018-09-02
    - First release
```

## How to build a package

Once the PACKAGE.yaml file has been created, run `make PACKAGE` to build it in your own computer. [GNU Make](https://www.gnu.org/software/make/) and [Docker](https://www.docker.com/) are required.

### make targets

* `make PACKAGE` (replace PACKAGE by your package name in capital letters): Test and build the specified package.
* `make clean`: Clean all generated files.
* `make emulator`: Run OpenMSX with the generated packages under the `\FILES` directory for testing.

Optional override the OPENMSX_ARGS environment variable to define an other machine and/or extra hardware;

* `OPENMSX_ARGS="-machine Philips_NMS_8250 -ext ide -ext moonsound" make emulator`
