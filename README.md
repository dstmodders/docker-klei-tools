# docker-klei-tools

[![Debian Size](https://img.shields.io/docker/image-size/dstmodders/klei-tools/debian?label=debian%20size)](https://hub.docker.com/r/dstmodders/klei-tools)
[![CI](https://img.shields.io/github/workflow/status/dstmodders/docker-klei-tools/CI?label=ci)](https://github.com/dstmodders/docker-klei-tools/actions/workflows/ci.yml)

> This repository uses a fork [dstmodders/klei-tools][] instead of the
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

| Name                        | Value                                    | Description                 |
| --------------------------- | ---------------------------------------- | --------------------------- |
| `DS_KTOOLS_KRANE`           | `/usr/local/bin/krane`                   | Path to [ktools][] `krane`  |
| `DS_KTOOLS_KTECH`           | `/usr/local/bin/ktech`                   | Path to [ktools][] `ktech`  |
| `DS_KTOOLS_VERSION`         | `4.5.1`                                  | [ktools][] version          |
| `DS_MOD_TOOLS_AUTOCOMPILER` | `/opt/klei-tools/mod_tools/autocompiler` | Path to `autocompiler`      |
| `DS_MOD_TOOLS_PNG`          | `/opt/klei-tools/mod_tools/png`          | Path to `png`               |
| `DS_MOD_TOOLS_SCML`         | `/opt/klei-tools/mod_tools/scml`         | Path to `scml`              |
| `DS_MOD_TOOLS_VERSION`      | `1.0.0`                                  | Version (release or commit) |
| `DS` or `DST`               | `/opt/dont_starve`                       | Path to the game directory  |
| `IMAGEMAGICK_VERSION`       | `7.1.0-7`                                | [ImageMagick][] version     |

## Usage

Fork [releases][] (recommended):

```shell
$ docker pull dstmodders/klei-tools # same tag: 1.0.0-ktools-4.5.1
```

Or you can also pick one of the [official releases][]:

```shell
$ docker pull dstmodders/klei-tools:official # same tag: official-ktools-4.4.0
```

See [tags][] for a list of all available versions.

### Interactive

```shell
$ docker run --rm --user=klei-tools --interactive --tty \
    --mount src='/path/to/game/',target='/opt/dont_starve/',type=bind \
    dstmodders/klei-tools
```

The same, but shorter:

```shell
$ docker run --rm -u klei-tools -itv '/path/to/game/:/opt/dont_starve/' dstmodders/klei-tools
```

### Non-interactive

```shell
$ docker run --rm --user=klei-tools \
    --mount src='/path/to/game/',target='/opt/dont_starve/',type=bind \
    dstmodders/klei-tools
```

The same, but shorter:

```shell
$ docker run --rm -u klei-tools -v '/path/to/game/:/opt/dont_starve/' dstmodders/klei-tools
```

### Linux & macOS

#### Shell/Bash

You can optionally set the game mods' directory as the `DST` environment
variable and then mount it if needed:

```shell
$ export DST="${HOME}/.steam/steam/steamapps/common/Don't Starve Together"
$ docker run --rm -u klei-tools -itv "${DST}:/opt/dont_starve/" dstmodders/klei-tools
```

### Windows

#### CMD

```cmd
C:\> docker run --rm -u klei-tools -itv "%CD%:/opt/dont_starve/" dstmodders/klei-tools
```

#### PowerShell

You can optionally set the game mods' directory as the `DST` environment
variable and then mount it if needed:

```powershell
PS C:\> $Env:DST = "C:\Program Files (x86)\Steam\steamapps\common\Don't Starve Together"
PS C:\> docker run --rm -u klei-tools -itv "$($Env:DST):/opt/dont_starve/" dstmodders/klei-tools
```

## License

Released under the [MIT License](https://opensource.org/licenses/MIT).

[docker]: https://www.docker.com/
[don't starve]: https://www.klei.com/games/dont-starve
[dstmodders/klei-tools]: https://github.com/dstmodders/klei-tools
[imagemagick]: https://imagemagick.org/index.php
[kleientertainment/ds_mod_tools]: https://github.com/kleientertainment/ds_mod_tools
[ktools]: https://github.com/dstmodders/ktools
[official releases]: https://github.com/kleientertainment/ds_mod_tools/releases
[releases]: https://github.com/dstmodders/klei-tools/releases
[tags]: https://hub.docker.com/r/dstmodders/klei-tools/tags
