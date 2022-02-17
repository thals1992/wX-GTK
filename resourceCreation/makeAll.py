#!/usr/bin/env python3
#
# make c files from XML using glib-compile-resources
#
# https://developer.gnome.org/gtkmm-tutorial/stable/sec-gio-resource.html.en
#
from typing import List, Tuple
import glob
import os.path
import subprocess

#
# helper function to run command
#
def runMe(cmd: str) -> Tuple[str, str, int]:
    p = subprocess.Popen(cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE, shell=True)
    (output, err) = p.communicate()
    p.wait()
    return output.decode("utf-8"), err.decode("utf-8"), p.returncode

#
# make xml for res
#
bigFiles: List[str] = ["res/hwv4ext.bin", "res/hwv4.bin", "res/lakesv3.bin"]

fh = open("resourcesRes.xml", "w")
print('<?xml version="1.0" encoding="UTF-8"?>', file=fh)
print("<gresources>", file=fh)
print('  <gresource prefix="/">', file=fh)
files: List[str] = glob.glob("res/*")
for f in files:
    if not f in bigFiles:
        print("    <file>" + f + "</file>", file=fh)
print("   </gresource>", file=fh)
print("</gresources>", file=fh)
fh.close()

for index, bigFile in enumerate(bigFiles):
    fh = open("res" + str(index) + ".xml", "w")
    print('<?xml version="1.0" encoding="UTF-8"?>', file=fh)
    print("<gresources>", file=fh)
    print('  <gresource prefix="/">', file=fh)
    print("    <file>" + bigFile + "</file>", file=fh)
    print("   </gresource>", file=fh)
    print("</gresources>", file=fh)
    fh.close()

#
# make xml for images
#
numFiles: int = 2
filesHandles = []

for i in range(numFiles):
    filesHandles.append(open("images" + str(i) + ".xml", "w"))
    print('<?xml version="1.0" encoding="UTF-8"?>', file=filesHandles[i])
    print("<gresources>", file=filesHandles[i])
    print('  <gresource prefix="/">', file=filesHandles[i])

files: List[str] = glob.glob("images/*")
for i, f in enumerate(sorted(files)):
    if i < 100:
        print("    <file>" + f + "</file>", file=filesHandles[0])
    else:
        print("    <file>" + f + "</file>", file=filesHandles[1])

for i in range(numFiles):
    print("   </gresource>", file=filesHandles[i])
    print("</gresources>", file=filesHandles[i])
    filesHandles[i].close()

#   
# convert xml files to c files
#
files: List[str] = glob.glob("*.xml")
for file in files:
    base = os.path.splitext(file)
    out, err, exitCode = runMe("glib-compile-resources --target=" + base[0] + ".c --generate-source " + base[0] + ".xml")
    if exitCode != 0:
        print(out, err)
