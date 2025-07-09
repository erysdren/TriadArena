# Triad Arena

## Configuring

Note: Change `Release` to `Debug` for debug builds.

Note: The "Unix Makefiles" generator is required due to a [CMake limitation regarding `IMPLICIT_DEPENDS`](https://cmake.org/cmake/help/latest/command/add_custom_command.html).

```sh
cmake -G"Unix Makefiles" -DCMAKE_BUILD_TYPE=Release -Bbuild -S.
```

## Building

It is advised to follow these steps in this order. Once you are done, the
compiled game will be in the repo in the `game` folder.

```sh
# tools
cmake --build build --target fteqcc

# engine and required plugins
cmake --build build --target fteqw plug_rott

# dedicated server
cmake --build build --target fteqw-sv

# copy librequake assets
cmake --build build --target librequake

# game code
cmake --build build --target qwprogs csprogs menu
```
