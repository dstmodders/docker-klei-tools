# docker-klei-tools

[![Debian Size]](https://hub.docker.com/r/dstmodders/klei-tools)
[![CI]](https://github.com/dstmodders/docker-klei-tools/actions/workflows/ci.yml)
[![Build]](https://github.com/dstmodders/docker-klei-tools/actions/workflows/build.yml)

> [!NOTE]
> This repository uses a fork [dstmodders/klei-tools] instead of the original
> [kleientertainment/ds_mod_tools]. All tags prefixed with "official" point to
> [official releases]. See [fork releases] to learn more.

## Supported tags and respective `Dockerfile` links

- [`1.0.0-ktools-4.5.1-debian`, `1.0.0-ktools-4.5.1`, `1.0.0`, `debian`, `latest`](https://github.com/dstmodders/docker-klei-tools/blob/bfbff346ff56d70ada5cd99d0bb46edec2412253/latest/debian/Dockerfile)
- [`official-ktools-4.4.0-debian`, `official-ktools-4.4.0`, `official-debian`, `official-latest`, `official`](https://github.com/dstmodders/docker-klei-tools/blob/bfbff346ff56d70ada5cd99d0bb46edec2412253/official/debian/Dockerfile)

## Overview

[Docker] images for modding tools of Klei Entertainment's game [Don't Starve].

- [Usage](#usage)
- [Supported environment variables](#supported-environment-variables)
- [Supported build arguments](#supported-build-arguments)
- [Supported architectures](#supported-architectures)
- [Build](#build)

## Usage

[Fork releases] (recommended):

```shell
$ docker pull dstmodders/klei-tools:latest
# or
$ docker pull ghcr.io/dstmodders/klei-tools:latest
```

Or you can also pick one of the [official releases]:

```shell
$ docker pull dstmodders/klei-tools:official
# or
docker pull ghcr.io/dstmodders/klei-tools:official
```

See [tags] for a list of all available versions.

For your convenience, create an environment variable, such as `DST_DIR`, which
points to the game directory. This variable will simplify the process of
mounting the game directory to the container. Common paths include:

- `C:\Program Files (x86)\Steam\steamapps\common\Don't Starve Together` _Windows/Steam_
- `~/.steam/steam/steamapps/common/Don't Starve Together` _Linux/Steam_
- `~/.var/app/com.valvesoftware.Steam/data/Steam/steamapps/common/Don't Starve Together` _Linux/Steam (Flatpak)_
- `~/Library/Application Support/Steam/steamapps/common/Don't Starve Together` _macOS/Steam_

#### Shell/Bash (Linux & macOS)

```shell
$ export DST_DIR='/path/to/game/'
$ docker run --rm -v "${DST_DIR}:/opt/dont_starve/" dstmodders/klei-tools
```

#### CMD (Windows)

```cmd
> set DST_DIR='C:\Path\To\Game'
> docker run --rm -v "%DST_DIR%:/opt/dont_starve/" dstmodders/klei-tools
```

#### PowerShell (Windows)

```powershell
PS:\> $Env:DST_DIR = 'C:\Path\To\Game'
PS:\> docker run --rm -v "$($Env:DST_DIR):/opt/dont_starve/" dstmodders/klei-tools
```

## Supported environment variables

| Name                        | Value                                    | Description                              |
| --------------------------- | ---------------------------------------- | ---------------------------------------- |
| `DS_KTOOLS_KRANE`           | `/usr/local/bin/krane`                   | [ktools] `krane` path                    |
| `DS_KTOOLS_KTECH`           | `/usr/local/bin/ktech`                   | [ktools] `ktech` path                    |
| `DS_KTOOLS_VERSION`         | `4.5.1`                                  | [ktools] version                         |
| `DS_MOD_TOOLS_AUTOCOMPILER` | `/opt/klei-tools/mod_tools/autocompiler` | [klei-tools] `autocompiler` path         |
| `DS_MOD_TOOLS_PNG`          | `/opt/klei-tools/mod_tools/png`          | [klei-tools] `png` path                  |
| `DS_MOD_TOOLS_SCML`         | `/opt/klei-tools/mod_tools/scml`         | [klei-tools] `scml` path                 |
| `DS_MOD_TOOLS_VERSION`      | `1.0.0`                                  | [klei-tools] version (release or commit) |
| `DS` or `DST`               | `/opt/dont_starve`                       | Game directory path                      |
| `IMAGEMAGICK_VERSION`       | `7.1.1-6`                                | [ImageMagick] version                    |

## Supported build arguments

| Name                | Image                    | Default              | Description           |
| ------------------- | ------------------------ | -------------------- | --------------------- |
| `DS_KTOOLS_VERSION` | `latest`<br />`official` | `4.5.1`<br />`4.4.0` | Sets [ktools] version |

## Supported architectures

| Image      | Architecture(s)            |
| ---------- | -------------------------- |
| `latest`   | `linux/amd64`, `linux/386` |
| `official` | `linux/amd64`, `linux/386` |

## Build

To build images locally:

```shell
$ docker build --tag='dstmodders/klei-tools:latest' ./latest/debian/
$ docker build --tag='dstmodders/klei-tools:official' ./official/debian/
```

Respectively, to build multi-platform images using [buildx]:

```shell
$ docker buildx build --platform='linux/amd64,linux/386' --tag='dstmodders/klei-tools:latest' ./latest/debian/
$ docker buildx build --platform='linux/amd64,linux/386' --tag='dstmodders/klei-tools:official' ./official/debian/
```

## License

Released under the [MIT License](https://opensource.org/licenses/MIT).

[build]: https://img.shields.io/github/actions/workflow/status/dstmodders/docker-klei-tools/build.yml?branch=main&label=build&logo=github
[buildx]: https://github.com/docker/buildx
[ci]: https://img.shields.io/github/actions/workflow/status/dstmodders/docker-klei-tools/ci.yml?branch=main&label=ci&logo=github
[debian size]: https://img.shields.io/docker/image-size/dstmodders/klei-tools/debian?label=debian%20size&logo=docker
[docker]: https://www.docker.com/
[don't starve]: https://www.klei.com/games/dont-starve
[dstmodders/klei-tools]: https://github.com/dstmodders/klei-tools
[fork releases]: https://github.com/dstmodders/klei-tools/releases
[imagemagick]: https://imagemagick.org/index.php
[klei-tools]: https://github.com/dstmodders/klei-tools
[kleientertainment/ds_mod_tools]: https://github.com/kleientertainment/ds_mod_tools
[ktools]: https://github.com/dstmodders/ktools
[official releases]: https://github.com/kleientertainment/ds_mod_tools/releases
[tags]: https://hub.docker.com/r/dstmodders/klei-tools/tags
