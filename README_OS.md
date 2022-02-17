[TOC]

# OS Specific install instructions

Generall speaking the program relies on the following to compile/run:
* GTK3 or GTK4 development files
* valac (compiler)
* meson (build system)
* libgee (data structure library for vala)
* libsoup (C library for HTTPS downloads accessed by vala source code)

#### Ubuntu 20.4/Debian 11/Linux Mint 20.4
```bash
sudo apt install meson
sudo apt install valac
sudo apt install libgtk-3-dev
sudo apt install libgee-0.8-dev
sudo apt install libbz2-dev
sudo apt install libsoup2.4-dev
```
#### elementary OS 6
```
sudo apt install elementary-sdk
sudo apt install libsoup2.4-dev
sudo apt install libbz2-dev

# sudo apt install meson
# sudo apt install g++
# sudo apt install valac
# sudo apt install libgee-0.8-dev
# sudo apt install libgtk-3-dev
```
#### Ubuntu 21.10 GTK3/GTK4
```
sudo apt install gcc meson valac libgtk-3-dev libgee-0.8-dev libbz2-dev libsoup2.4-dev libgtk-4-dev
```
#### Fedora 35 GTK3 and GTK4
```
sudo yum install vala meson cmake gtk3-devel gtk4-devel libsoup-devel
sudo yum install libgee-devel
```
#### openSuSE GTK3 (Oct 2021)
```
sudo zypper in gtk3-devel
sudo zypper in meson
sudo zypper in vala
sudo zypper in libgee-devel
sudo zypper in libsoup2-devel
```
#### openSuSE GTK4 (Oct 2021)
```
sudo zypper in gtk4-devel
sudo zypper in meson
sudo zypper in vala
sudo zypper in libgee-devel
sudo zypper in libsoup2-devel
```
#### Manjaro (KDE) GTK3
```
# https://wiki.manjaro.org/index.php?title=Pacman_Overview
# update all: sudo pacman -Syu
# search repo: pacman -Ss gtkmm3
# search installed:  pacman -Qs gtkmm3
# get more info from repo: pacman -Si gtkmm3
# list all installed: pacman -Ql
sudo pacman -S meson gcc vala libgee
```
#### Manjaro (KDE) GTK4
```
sudo pacman -S gtk4
```
#### chromeos (incomplete instructions) - support for macOS is incomplete
```bash
sudo apt install gvfs-backends 
#
# if during the makeAll.bash it errors out, you can do the following
# this might be needed if your system does not have enough memory 
# and thus you can force to compile one object at a time instead of four
#
cd build
ninja -j 1
cd ..
./run.bash
```
#### macOS notes - tested only on the latest version of MacOS
```bash
brew install vala
brew install gtk+3
brew install libsoup@2
brew link libsoup@2
brew install meson
brew install libgee
brew install cmake
brew install icu4c
brew link icu4c --force
vi $HOME/.zprofile
export PATH=$PATH:"/Applications/Visual Studio Code.app/Contents/Resources/app/bin"

#--------
# macOS GTK4
#--------
xcode-select --install
brew install gtk4
```
#### Windows GTK3 via MSYS2
```
pacman -Syu
pacman -S --needed base-devel mingw-w64-x86_64-toolchain
pacman -S mingw-w64-x64_64-meson
pacman -S mingw-w64-x64_64-cmake
pacman -S mingw-w64-x86_64-vala
pacman -S mingw-w64-x64_64-libgee
pacman -S mingw-w64-x64_64-libsoup
pacman -S mingw-w64-x86_64-gtk3
pacman -S mingw-w64-x86_64-glib2
pacman -S mingw-w64-x86_64-python3

#
# if /mingw64/lib/pkgconfig/libsoup-2.4.pc is empty
# FYI, it's not clear to me what all of the variables in this file
# should be but the file copied into place does allow wxgtk to compile and run
#
cp doc/libsoup-2.4.pc /mingw64/lib/pkgconfig/libsoup-2.4.pc
```
