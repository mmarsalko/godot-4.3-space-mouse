# Forked from MrVolans and recompiled for Godot 4.3

- Windows and Linux libraries are bundled. Feel free to contribute libraries for other platforms.
- only supports perspective mode, inputs are disabled while in orthogonal projection mode due to bugs
- Updates will be slow, as I had no GDExtension experience prior to this project.

## Building from source on Windows
You need Scons, godot-cpp (GDExtension) and the HIDAPI library

Update the bundeled Sconstruct to locate the HIDAPI library you downloaded, and build the godot-cpp repo to create the headers for GDExtension.

Then build the Spacemouse sconstruct.

The library will be placed inside the addons/bin ready to be used.

lastly update the spacemouse.GDExtension to include the path for the library suited for your platform. 

When building with Scons it is likely that the libraries will be placed under "spacemouse_test/addons/spacemouse", if not they will be located under "addons/bin"

## Building from source on Linux
1. Clone this repo (with submodules) and install scons:
```
git clone --recurse-submodules <git_branch>
apt install scons
```
2. If your distro doesn't have hidpi libs, build hidpi from source
```
cd linux/
make -f Makefile-manual
```
3. Run scons from the root directory

## Adding newly released mice on Linux
1. Get the `vendor_id:product_id` pair for your device:
```
lsusb | grep -i spacemouse
# Example output (take the 2 hex values):
Bus 001 Device 021: ID 256f:c63a 3Dconnexion SpaceMouse Wireless BT
```

2. Add the hex values to `addons/spacemouse/bin/70-space-mouse.rules` and `src/spacemouse.h`

## LICENSE

MIT License

Copyright (c) 2024 Andres Hernandez
Copyright (c) 2024 Matthew Hunt

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
