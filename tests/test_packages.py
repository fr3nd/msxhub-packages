#! /usr/bin/env python
# -*- coding: utf-8 -*-
# vim:fenc=utf-8

import pytest
import glob
import yaml
from urllib.parse import urlparse

allowed_licenses = [
    "AFL-3.0",
    "AGPL-3.0",
    "Apache-2.0",
    "Artistic-2.0",
    "BSD-2-Clause",
    "BSD-3-Clause",
    "BSD-3-Clause-Clear",
    "BSL-1.0",
    "CC0",
    "CC BY-SA",
    "CC BY-ND",
    "CC BY-NC-SA",
    "CC BY-NC-ND",
    "CC BY-NC",
    "CC BY",
    "ECL-2.0",
    "EPL-1.0",
    "EPL-2.0",
    "EUPL-1.1",
    "EUPL-1.2",
    "GPL-2.0",
    "GPL-3.0",
    "ISC",
    "LGPL-2.1",
    "LGPL-3.0",
    "LPPL-1.3c",
    "MIT",
    "MPL-2.0",
    "MS-PL",
    "MS-RL",
    "NCSA",
    "OFL-1.1",
    "OSL-3.0",
    "PostgreSQL",
    "Proprietary",
    "Public domain",
    "Unknown",
    "Unlicense",
    "UPL-1.0",
    "WTFPL",
    "Zlib",
]

allowed_categories = [
    "Editors",
    "Files",
    "Games",
    "Graphics",
    "Internet",
    "Programming",
    "Sound",
    "System",
    "Tools",
]

allowed_systems = [
    "MSX",
    "MSX2",
    "MSX2+",
    "MSX Turbo-R",
]

allowed_requirements = [
    "MSX-DOS2",
    "MSX-DOS",
    "SCC",
    "OPL4",
    "ROM",
    "MSX-MUSIC",
    "MSX-AUDIO",
    "V9990",
    "NEXTOR",
]


def uri_validator(x):
    try:
        result = urlparse(x)
        return result.scheme != '' \
            and result.netloc != '' \
            and result.path != ''
    except:
        return False


@pytest.mark.parametrize("package", glob.glob('packages/*.yaml'))
def test_package(package):
    with open(package, 'r') as stream:
        package_info = yaml.load(stream)

        # Package name should have name and be 8 characters or less
        assert len(package_info['name']) <= 8
        # Package name should be in capital letters
        assert all(x.isupper() or x.isdigit() for x in package_info['name'])

        # Package should have version and be 16 characters or less
        assert len(package_info['version']) <= 16
        # Version should not contain '-'
        assert '-' not in package_info['version']
        # Version should not contain ':'
        assert ':' not in package_info['version']

        # Package should have release and it must be integer
        assert isinstance(package_info['release'], int)

        # Package should have summary and be 80 characters or less
        assert len(package_info['summary']) <= 80

        # Package should have author and be 128 characters or less
        assert len(package_info['author']) <= 128

        # Package should have package_author and be 128 characters or less
        assert len(package_info['package_author']) <= 128

        # Package should have license and be one of the allowed ones
        assert package_info['license'] in allowed_licenses

        # Package should have category and be one of the allowed ones
        assert package_info['category'] in allowed_categories

        # Package should have system and be one of the allowed ones
        assert package_info['system'] in allowed_systems

        # Package should have system and be one of the allowed ones
        assert package_info['system'] in allowed_systems

        # If package has requirements, need to be a list of allowed ones
        if 'requirements' in package_info.keys():
            for r in package_info['requirements']:
                assert r in allowed_requirements

        # Package should have url and be 256 characters or less
        assert len(package_info['url']) <= 256

        # Package should have description
        assert package_info['description']

        # Package should have installdir and start with \
        assert package_info['installdir'][0] == '\\'
        # installdir should not have subdirs
        assert package_info['installdir'].count('\\') == 1

        # Package should have files and be a list of dictionaries with pairs:
        # file: url
        for f in package_info['files']:
            assert len(f.keys()) == 1
            key = list(f.keys())[0]
            assert uri_validator(f[key])

        # First line of build should be mkdir -p package/
        assert 'mkdir -p package/' == package_info['build'].splitlines()[0]

        # Build needs at least two lines to be valid
        assert len(package_info['build'].splitlines()) >= 2

        # Changelog needs at least two lines
        assert len(package_info['changelog'].splitlines()) >= 2
