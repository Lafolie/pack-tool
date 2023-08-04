# Pack Tool

Pack Tool combines the singular textures from Minecraft texture packs into atlases, and vice-versa.

Pack Tool is designed for texture artists who find dealing with many individual files tedious. It is particularly useful for creating resourcepacks that override the textures in modded content (which is often the case if you don't use vanilla textures).

# Features

Pack Tool can read resourcepacks in zip or directory form. You can then perform the following actions:

* Export atlases for easy editing
* Import edited atlases
* Split (export) edited atlases to a resourcepack
* View original & edited atlasses
* Merge packs (useful for updating)

Atlases are created for each type (block, item, entity, etc.) in each namespace (minecraft/modid).

Atlases are much easier to work with, removing the need to open multiple files in an image editor.

# Build / Run Instructions

Pack Tool is a [LÖVE](https://love2d.org) application. It requires LÖVE version 11 or greater.

1. Make sure LÖVE is installed
2. Clone the repo
3. In the root dir, run `love .` (assuming `love` is on your PATH)

# Shared Modules

Pack Tool is multi-threaded program. [LÖVE threads](love2d.org/wiki/love.thread) use channels with distinct Lua environments; non-userdata values can not be shared between threads, and must be passed via [channels](love2d.org/wiki/Channel). Modules must be require'd in each thread, and several LÖVE modules are only available in the main thread.

Code duplication is avoided via the `share/` dir. These modules are used by both threads. 

For clarity and simplicity, resource modules are split into two parts. An example of this is the `Pack` module. `Pack` is a "class" that contains meta information for packs, such as their type, paths, and `.mcmeta` info:

* `share/resource/pack/pack.lua` contains `Pack` is usable by **both threads**
* `mainThread/resource/packMain.lua` is a subclass of `Pack`, and is usable only by the **main thread**

# Usage Instructions

TODO

# License

Pack Tool is licensed under the GNU General Public License v.3