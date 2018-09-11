#! /usr/bin/env python
# -*- coding: utf-8 -*-
# vim:fenc=utf-8

import pytest
import glob
import yaml


@pytest.mark.parametrize("package", glob.glob('packages/*.yaml'))
def test_package(package):
    with open(package, 'r') as stream:
        package_info = yaml.load(stream)

        # Package name should have name and be 8 characters or less
        assert len(package_info['name']) <= 8

        # Package should have version and be 16 characters or less
        assert len(package_info['version']) <= 16

        # Package should have release and it must be integer
        assert isinstance(package_info['release'], int)

        # Package should have summary and be 80 characters or less
        assert len(package_info['version']) <= 80

        # Package should have author and be 128 characters or less
        assert len(package_info['author']) <= 128

        # Package should have package_author and be 128 characters or less
        assert len(package_info['package_author']) <= 128
