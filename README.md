# docker-ds-mod-tools

[![Debian Size](https://img.shields.io/docker/image-size/viktorpopkov/ds-mod-tools/debian?label=debian%20size)](https://hub.docker.com/r/viktorpopkov/ds-mod-tools)
[![CI](https://img.shields.io/github/workflow/status/victorpopkov/docker-ds-mod-tools/CI?label=CI)](https://github.com/victorpopkov/docker-ds-mod-tools/actions/workflows/ci.yml)

> This repository uses a fork [victorpopkov/ds-mod-tools][] instead of the
> original [kleientertainment/ds_mod_tools][]. All tags prefixed with "official"
> point to [official releases][]. See [releases][] and [tags][] to learn more.

## Overview

[Docker][] images for modding tools of Klei Entertainment's game
[Don't Starve][].

- [Environment variables](#environment-variables)
- [Usage](#usage)
  - [Linux & macOS](#linux--macos)
  - [Windows](#windows)

## Environment variables

| Name                        | Value                                      | Description                 |
| --------------------------- | ------------------------------------------ | --------------------------- |
| `DS_KTOOLS_KRANE`           | `/usr/local/bin/krane`                     | Path to [ktools][] `krane`  |
| `DS_KTOOLS_KTECH`           | `/usr/local/bin/ktech`                     | Path to [ktools][] `ktech`  |
| `DS_KTOOLS_VERSION`         | `4.5.0`                                    | [ktools][] version          |
| `DS_MOD_TOOLS_AUTOCOMPILER` | `/opt/ds-mod-tools/mod_tools/autocompiler` | Path to `autocompiler`      |
| `DS_MOD_TOOLS_PNG`          | `/opt/ds-mod-tools/mod_tools/png`          | Path to `png`               |
| `DS_MOD_TOOLS_SCML`         | `/opt/ds-mod-tools/mod_tools/scml`         | Path to `scml`              |
| `DS_MOD_TOOLS_VERSION`      | `1.0.0`                                    | Version (release or commit) |
| `DS` or `DST`               | `/opt/dont_starve`                         | Path to the game directory  |
| `IMAGEMAGICK_VERSION`       | `7.1.0-5`                                  | [ImageMagick][] version     |

## Usage

Fork [releases][] (recommended):

```shell
$ docker pull viktorpopkov/ds-mod-tools # same tag: 1.0.0-ktools-4.5.0
```

Or you can also pick one of the [official releases][]:

```shell
$ docker pull viktorpopkov/ds-mod-tools:official # same tag: official-ktools-4.4.0
```

See [tags][] for a list of all available versions.

### Interactive

```shell
$ docker run --rm --user=ds-mod-tools --interactive --tty \
    --mount src='/path/to/game/',target='/opt/dont_starve/',type=bind \
    viktorpopkov/ds-mod-tools
```

The same, but shorter:

```shell
$ docker run --rm -u ds-mod-tools -itv '/path/to/game/:/opt/dont_starve/' viktorpopkov/ds-mod-tools
```

### Non-interactive

```shell
$ docker run --rm --user=ds-mod-tools \
    --mount src='/path/to/game/',target='/opt/dont_starve/',type=bind \
    viktorpopkov/ds-mod-tools
```

The same, but shorter:

```shell
$ docker run --rm -u ds-mod-tools -v '/path/to/game/:/opt/dont_starve/' viktorpopkov/ds-mod-tools
```

### Linux & macOS

#### Shell/Bash

You can optionally set the game mods' directory as the `DST_MODS` environment
variable and then mount it if needed:

```shell
$ export DST="${HOME}/.steam/steam/steamapps/common/Don't Starve Together"
$ docker run --rm -u ds-mod-tools -itv "${DST}:/opt/dont_starve/" viktorpopkov/ds-mod-tools
```

### Windows

#### CMD

```cmd
C:\> docker run --rm -u ds-mod-tools -itv "%CD%:/opt/dont_starve/" viktorpopkov/ds-mod-tools
```

#### PowerShell

You can optionally set the game mods' directory as the `DST_MODS` environment
variable and then mount it if needed:

```powershell
PS C:\> $Env:DST = "C:\Program Files (x86)\Steam\steamapps\common\Don't Starve Together"
PS C:\> docker run --rm -u ds-mod-tools -itv "$($Env:DST):/opt/dont_starve/" viktorpopkov/ds-mod-tools
```

## License

Released under the [MIT License](https://opensource.org/licenses/MIT).

[docker]: https://www.docker.com/
[don't starve]: https://www.klei.com/games/dont-starve
[imagemagick]: https://imagemagick.org/index.php
[kleientertainment/ds_mod_tools]: https://github.com/kleientertainment/ds_mod_tools
[ktools]: https://github.com/victorpopkov/ktools
[official releases]: https://github.com/kleientertainment/ds_mod_tools/releases
[releases]: https://github.com/victorpopkov/ds-mod-tools/releases
[tags]: https://hub.docker.com/r/viktorpopkov/ds-mod-tools/tags
[victorpopkov/ds-mod-tools]: https://github.com/victorpopkov/ds-mod-tools
