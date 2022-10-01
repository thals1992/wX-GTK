#!/usr/bin/env python3
#
#
# build project from scratch
#
# TODO FIXME options to rebuild meson only and resouces
#
# if downloading zip for git clone for first time
# run this to fully setup and run
# after, just run "./run.bash"
#

import argparse
import glob
import os
from pathlib import Path
import shutil
import sys
import subprocess
from subprocess import Popen, PIPE
from typing import Tuple, List

mesonHeader: str = """project('wxgtk', ['c', 'vala'])
vapi_dir = meson.current_source_dir() / 'src/vapi'
glib_dep = dependency('glib-2.0')
gobject_dep = dependency('gobject-2.0')
lgee = dependency('gee-0.8')
lgio = dependency('gio-2.0')
lgtk = dependency('gtk+-3.0')
lsoup = dependency('libsoup-2.4')
cc = meson.get_compiler('c')
lmath = cc.find_library('m', required : false)
llbz2 = cc.find_library('bz2', required : false)
lbz2 = meson.get_compiler('vala').find_library('bzlib')
lposix = meson.get_compiler('vala').find_library('posix')
vapi_dir = meson.current_source_dir() / 'src/vapi'
add_project_arguments(['--vapidir', vapi_dir], language: 'vala')
#GTK4 add_project_arguments(['-D', 'GTK4'], language: 'vala')
#SOUP30 add_project_arguments(['-D', 'SOUP30'], language: 'vala')
wx_src = [
"""

mesonFooter: str = """]
executable('wxgtk', wx_src, install: true, dependencies: [glib_dep, gobject_dep, lgee, lmath, llbz2, lbz2, lposix, lgio, lgtk, lsoup])
"""

#
# helper function to run command
#
def runMe(cmd: str) -> Tuple[str, str, int]:
    p = subprocess.Popen(cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE, shell=True)
    output, err = p.communicate()
    exitCode = p.wait()
    return output.decode("utf-8"), err.decode("utf-8"), exitCode

def run(command: str):
    process = Popen(command, stdout=PIPE, shell=True)
    while True:
        line = process.stdout.readline().decode("utf-8").rstrip()
        if not line:
            break
        yield line

def makeMeson():
    valaFiles: List[str] = glob.glob("src/*.vala") + glob.glob("resourceCreation/*.c") + glob.glob("src/*/*.vala")
    mesonTargetFile: str = "meson.build"
    with open(mesonTargetFile, "w") as fh:
        header: str = mesonHeader
        footer: str = mesonFooter
        if args.soup30:
            header = header.replace("libsoup-2.4", "libsoup-3.0")
            header = header.replace("#SOUP30 ", "")
        if args.gtk4:
            header = header.replace("gtk+-3.0", "gtk4")
            header = header.replace("#GTK4 ", "")
        fh.write(header)
        for cpp in sorted(valaFiles):
            fh.write(" " * 4 + "'" + cpp + "'," + '\n')
        fh.write(footer)

if __name__ == "__main__":
    # for path in run("ping -c 5 google.com"):
    #     print(path)

    parser = argparse.ArgumentParser()
    parser.add_argument('--soup30', action='store_true')
    parser.add_argument('--gtk4', action='store_true')
    parser.add_argument('--singleThread', action='store_true')
    parser.add_argument('--meson', action='store_true')
    args = parser.parse_args()

    if not args.meson:
        #
        # resouce creation
        #
        os.chdir("resourceCreation")
        runMe("./makeAll.py")
        os.chdir("..")
        #
        # "build" dir - remove
        #
        buildDir: str = "build"
        if Path(buildDir).is_dir():
            shutil.rmtree(buildDir)

    #
    # make meson file
    #
    makeMeson()
    if args.meson:
        sys.exit(0)
    # makeMesonArg: str = ""
    # if args.gtk4:
    #     makeMesonArg += " --gtk4"
    # if args.soup30:
    #     makeMesonArg += " --soup30"
    # out, err, returnCode = runMe("./makeMesonGtk.py" + makeMesonArg)
    # print(returnCode, ":", out + err)
    #
    # build project
    #
    out, err, returnCode = runMe("meson build")
    print(returnCode, ":", out + err)
    if returnCode != 0:
        print("meson issue")
        sys.exit(returnCode)
    # FIXME TODO this takes arg for low resouce
    runArg: str = ""
    if args.singleThread:
        runArg = " 1"
    out, err, returnCode = runMe("./make.bash" + runArg)
    print(returnCode, ":", out + err)

# FIXME TODO is this needed, was before make meson
# if [ "$(uname)" == "Darwin" ]; then
#     export PKG_CONFIG_PATH="/usr/local/opt/icu4c/lib/pkgconfig:/opt/homebrew/opt/libsoup@2/lib/pkgconfig"
# fi
