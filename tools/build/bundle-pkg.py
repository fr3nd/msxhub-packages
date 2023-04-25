#! /usr/bin/env python3
# -*- coding: utf-8 -*-
# vim:fenc=utf-8

"""
Script to build a package from a yaml file
Usage: build PACKAGE.yaml /path/to/output/directory
"""

import yaml
import sys
import os
import tempfile
import requests
import subprocess
import shutil
import glob
import re


if len(sys.argv) <= 1:
    print("*** ERROR: Pass the yaml file to import as parameter")
    sys.exit(1)

if len(sys.argv) <= 2:
    print("*** ERROR: Pass the destination directory as parameter")
    sys.exit(1)

with open(sys.argv[1], 'r') as stream:
    package_info = yaml.load(stream)

    with tempfile.TemporaryDirectory() as tmpdirname:
        print("- Created tmp directory: %s" % (tmpdirname))
        for f in package_info['files']:
            file_name = list(f.keys())[0]
            url = f[file_name].replace("%VERSION%", package_info['version'])
            print("- Downloading %s to %s..." % (url, file_name))
            headers = {'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/39.0.2171.95 Safari/537.36'}
            r = requests.get(url, allow_redirects=True, headers=headers)
            if not r.ok:
                print("ERROR: HTTP status: %i" % (r.status_code))
                sys.exit(1)
            open(tmpdirname + "/" + file_name, 'wb').write(r.content)
        with tempfile.NamedTemporaryFile() as script_file:
            print(script_file.name)
            with open(script_file.name, 'w') as fd:
                fd.write(package_info['build'])
            print("- Running script...")
            p = subprocess.Popen(['bash', '-l', script_file.name],
                                 cwd=tmpdirname)
            p.wait()
        print("- Checking generated package...")
        p = re.compile('^.{1,8}\.{0,1}.{0,3}$')
        for filename in glob.iglob(tmpdirname + '/package/**', recursive=True):
            basename = os.path.basename(filename)
            if basename == "":
                basename = os.path.basename(os.path.dirname(filename))
            if not p.match(basename):
                print("ERROR: File " + filename + " is not a valid DOS file.")
                sys.exit(1)

        print("- Generating ZIP file")
        shutil.make_archive(
            tmpdirname + '/' + package_info['name'],
            'zip',
            tmpdirname + "/package")

        print("- Moving package to destination directory...")
        try:
            os.mkdir(sys.argv[2])
        except FileExistsError:
            pass
        shutil.move(tmpdirname + "/package",
                    sys.argv[2] + "/" + package_info['name'])
        shutil.copy(tmpdirname + "/" + package_info['name'] + ".zip",
                    sys.argv[2])
