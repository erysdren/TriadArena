# Triad Arena

Rise of the Triad (1994)'s multiplayer modes reimplemented in the [FTEQW](https://www.fteqw.org/) engine.

There is an official packages repository for additional levels and goodies,
which can be found [here](https://github.com/erysdren/TriadArena-Packages).

This project is **heavily work-in-progress** and no functionality is guaranteed.
Use at your own risk.

**NOTE**: An OpenGL build of FTEQW is required. DirectX and Vulkan builds are
unsupported.

## Todo

- [x] Add support for loading ROTT:LE mapset files.
- [ ] Create package for [Dakkijam: The Precursor](https://steamcommunity.com/sharedfiles/filedetails/?id=3389350415).
- [ ] Add support for using shareware game data instead of registered.

## Required Files

Triad Arena has limited Steam integration for finding and loading existing
Rise of the Triad installations. The following games, if installed, will be
loaded:

- [Rise of the Triad: Dark War](https://store.steampowered.com/app/358410/)
- [Rise of the Triad: Ludicrous Edition](https://store.steampowered.com/app/1421490/)

If the engine fails to find Steam or you don't have the required games
installed, you can provide the game data in `triadarena/data/`.

The bare minimum files required for running the game are:

```
471a7b77fd03bbdd43a2dec3ca56034981bcab2eff8d4046bfbaa7b57a186b66  darkwar.rtc
78761bdc78cb2340b71e3b7b320dbe47e3f7dbcd0eb456fc084973acd582edeb  darkwar.wad
```

## Credits

- ROTT Central for playtesting and support
- Spike for the wonderful FTEQW engine
- id Software for making Quake
- Apogee Software for making Rise of the Triad

## License

GNU GPL v2

Copyright (C) 1994-1995 Apogee Software, Ltd.

Copyright (C) 1996-1997 Id Software, Inc.

Copyright (C) 2023-2025 erysdren (it/its)

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation; either version 2
of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
