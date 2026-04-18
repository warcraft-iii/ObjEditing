# ObjEditing

A command-line tool for generating and modifying Warcraft III map object data
(`war3map.w3u`, `w3a`, `w3t`, `w3b`, `w3d`, `w3h`, `w3q`) from Lua scripts.

ObjEditing embeds Lua 5.3 in a small native host and exposes a fluent,
class-based API for declaring custom units, abilities, items, buffs,
destructables and upgrades. Object definitions are written as plain Lua,
making them easy to version, diff and reuse across maps.

## Features

- Read existing `war3map.*` object files from a map directory
- Define new objects or override existing ones via Lua scripts
- Strongly-typed setters with runtime checks (`checktype`, `checkenum`)
- Supports all six object editor categories:
  - Units (`UnitObjEditing`)
  - Abilities (`AbilityObjEditing`)
  - Items (`ItemObjEditing`)
  - Buffs (`BuffObjEditing`)
  - Destructables (`DestructableObjEditing`)
  - Upgrades (`UpgradeObjEditing`)
- Optional dump of built-in objects to Lua source for inspection
- Single self-contained executable, no runtime dependencies

## Building

Requirements:

- Windows with Visual Studio 2022
- [premake5](https://premake.github.io/) (a copy is expected at `bin/premake5.exe`)

Generate the Visual Studio solution and build:

```bat
init.bat
```

This runs `premake5 vs2022` and produces the solution under `.build/`.
Open `.build/ObjEditing.sln` in Visual Studio and build the `ObjEditing`
project (Debug or Release, x86).

## Usage

```
ObjEditing -m <map_dir> -o <output_dir> [-d] <script.lua> [more_scripts.lua ...]
```

Options:

| Flag           | Short | Description                                  |
| -------------- | ----- | -------------------------------------------- |
| `--map`        | `-m`  | Source map directory containing `war3map.*`  |
| `--output`     | `-o`  | Output directory for the generated files     |
| `--dump`       | `-d`  | Dump loaded built-in objects to Lua scripts  |

Trailing positional arguments are user Lua files that declare or modify
object definitions. Each file is executed with its directory as the current
working directory.

### Example

```bat
ObjEditing.exe -m .\mymap.w3x -o .\out scripts\units.lua scripts\abilities.lua
```

```lua
-- scripts/units.lua
local footman = W3UDefinition:new('H001', 'hfoo')
footman:setName('Elite Footman')
footman:setTooltipBasic('Train an |cffffcc00E|rlite Footman')
footman:setHotkey('E')
```

```lua
-- scripts/abilities.lua
local fireball = AbilityDefinition:new('A001', 'AHfb')
fireball:setName('Greater Fireball')
fireball:setHeroAbility(true)
```

## Project Layout

```
src/
  objediting.cpp        Native host: Lua state, CLI parsing, env setup
  luaapi.h / *.c        C functions exposed to Lua (e.g. os.chdir)
  lua/
    base/               class system, string/table extensions
    core/               readers, writers, buffers, object model
    object/             public DSL for each object editor category
    application.lua     Main pipeline: load -> execute -> save
3rd/
  lua/                  Lua 5.3 sources (built as LibLua static lib)
  cmdline/              Header-only command line parser
bin/
  build.lua             Build step that bakes Lua sources into C strings
test/                   Lua unit tests for buffers and read/write paths
```

At build time, every `.lua` file under `src/lua/` is converted by
`bin/build.lua` into a generated C source/header pair, so the final
executable embeds all scripts and has no external Lua dependency.

## Testing

The `test/` directory contains standalone Lua scripts that can be run with
any Lua 5.3 interpreter, for example:

```bat
lua test\main.lua
```

These cover the read/write buffers and the object read/write round-trip.

## License

Lua and the bundled `cmdline` library retain their respective licenses
(MIT). See `3rd/lua/` and `3rd/cmdline/LICENSE`.
