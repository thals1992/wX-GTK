#!/usr/bin/env python3
#
# generate meson.build when using gtk4
# scans source files in src/ and resourceCreation/
#

from typing import List
import glob

cppFiles: List[str] = glob.glob("src/*.vala") + glob.glob("resourceCreation/*.c") + glob.glob("src/*/*.vala")

targetFile: str = "meson.build.gtk4"
header: str = """project('wxgtk', ['c', 'vala'])

vapi_dir = meson.current_source_dir() / 'src/vapi'
add_project_arguments(['--vapidir', vapi_dir, '-D', 'GTK4'], language: 'vala')
# add_project_arguments(['-D', 'GTK4'], language: 'vala')
# add_project_arguments(['--enable-experimental-non-null', '--vapidir', vapi_dir], language: 'vala')

glib_dep = dependency('glib-2.0')
gobject_dep = dependency('gobject-2.0')
lgee = dependency('gee-0.8')
lgio = dependency('gio-2.0')
lgtk3 = dependency('gtk4')
lsoup = dependency('libsoup-2.4')
# lsoup = dependency('libsoup-3.0')
cc = meson.get_compiler('c')
lmath = cc.find_library('m', required : false)
llbz2 = cc.find_library('bz2', required : false)
lbz2 = meson.get_compiler('vala').find_library('bzlib')
lposix = meson.get_compiler('vala').find_library('posix')

wx_src = [
"""

footer: str = """]

executable('wxgtk', wx_src,
  dependencies: [glib_dep, gobject_dep, lgee, lmath, llbz2, lbz2, lposix, lgio, lgtk3, lsoup])
"""

fh = open(targetFile, "w")
fh.write(header)
for cpp in sorted(cppFiles):
    fh.write(" " * 4 + "'" + cpp + "'," + '\n')

fh.write(footer)
fh.close()
