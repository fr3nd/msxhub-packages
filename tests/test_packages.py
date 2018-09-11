#! /usr/bin/env python
# -*- coding: utf-8 -*-
# vim:fenc=utf-8

import pytest
import glob
import yaml


@pytest.mark.parametrize("package", glob.glob('packages/*.yaml'))
def test_package(package):
    # Dummy test for testing
    assert True
