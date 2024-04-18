# docker-klei-tools

[![Debian Size]](https://hub.docker.com/r/dstmodders/klei-tools)
[![CI]](https://github.com/dstmodders/docker-klei-tools/actions/workflows/ci.yml)
[![Build]](https://github.com/dstmodders/docker-klei-tools/actions/workflows/build.yml)

> [!NOTE]
> This repository uses a fork [dstmodders/klei-tools] instead of the original
> [kleientertainment/ds_mod_tools]. All tags prefixed with "official" point to
> [official releases]. See [fork releases] to learn more.

## Supported tags and respective `Dockerfile` links

- [`1.0.0-ktools-4.5.1-debian`, `1.0.0-ktools-4.5.1`, `1.0.0`, `debian`, `latest`](https://github.com/dstmodders/docker-klei-tools/blob/8ba754446789fff5d78bd09ba1436cac8cf62b41/latest/debian/Dockerfile)
- [`1.0.0-ktools-4.5.0-debian`, `1.0.0-ktools-4.5.0`](https://github.com/dstmodders/docker-klei-tools/blob/4d1d19aa55df22515a280acb9126c7fa988cc072/latest/debian/Dockerfile)
- [`official-ktools-4.4.0-debian`, `official-ktools-4.4.0`, `official`, `official-debian`, `official-latest`](https://github.com/dstmodders/docker-klei-tools/blob/8ba754446789fff5d78bd09ba1436cac8cf62b41/official/debian/Dockerfile)

## Overview

[Docker] images for modding tools of Klei Entertainment's game [Don't Starve].

- [Environment variables](#environment-variables)
- [Usage](#usage)
- [Build](#build)

## Environment variables

| Name                        | Value                                    | Description                 |
| --------------------------- | ---------------------------------------- | --------------------------- |
| `DS_KTOOLS_KRANE`           | `/usr/local/bin/krane`                   | Path to [ktools] `krane`    |
| `DS_KTOOLS_KTECH`           | `/usr/local/bin/ktech`                   | Path to [ktools] `ktech`    |
| `DS_KTOOLS_VERSION`         | `4.5.1`                                  | [ktools] version            |
| `DS_MOD_TOOLS_AUTOCOMPILER` | `/opt/klei-tools/mod_tools/autocompiler` | Path to `autocompiler`      |
| `DS_MOD_TOOLS_PNG`          | `/opt/klei-tools/mod_tools/png`          | Path to `png`               |
| `DS_MOD_TOOLS_SCML`         | `/opt/klei-tools/mod_tools/scml`         | Path to `scml`              |
| `DS_MOD_TOOLS_VERSION`      | `1.0.0`                                  | Version (release or commit) |
| `DS` or `DST`               | `/opt/dont_starve`                       | Path to the game directory  |
| `IMAGEMAGICK_VERSION`       | `7.1.1-6`                                | [ImageMagick] version       |

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
$ docker run --rm -u klei-tools -v "${DST_DIR}:/opt/dont_starve/" dstmodders/klei-tools
```

#### CMD (Windows)

```cmd
> set DST_DIR='C:\Path\To\Game'
> docker run --rm -u klei-tools -v "%DST_DIR%:/opt/dont_starve/" dstmodders/klei-tools
```

#### PowerShell (Windows)

```powershell
PS:\> $Env:DST_DIR = 'C:\Path\To\Game'
PS:\> docker run --rm -u klei-tools -v "$($Env:DST_DIR):/opt/dont_starve/" dstmodders/klei-tools
```

## Build

To build images locally:

```shell
$ docker build ./latest/debian/ --tag='dstmodders/klei-tools:latest'
$ docker build ./official/debian/ --tag='dstmodders/klei-tools:official'
```

To build images locally using [buildx] to target multiple platforms, ensure that
your builder is running. If you are using [QEMU] emulation, you may also need to
enable [qemu-user-static].

In overall, to create your builder and enable [QEMU] emulation:

```shell
$ docker buildx create --name mybuilder --use --bootstrap
$ docker run --rm --privileged multiarch/qemu-user-static --reset -p yes
```

Respectively, to build multi-platform images locally:

```shell
$ docker buildx build ./latest/debian/ --platform='linux/amd64,linux/386' --tag='dstmodders/klei-tools:latest'
$ docker buildx build ./official/debian/ --platform='linux/amd64,linux/386' --tag='dstmodders/klei-tools:official'
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
[kleientertainment/ds_mod_tools]: https://github.com/kleientertainment/ds_mod_tools
[ktools]: https://github.com/dstmodders/ktools
[official releases]: https://github.com/kleientertainment/ds_mod_tools/releases
[qemu-user-static]: https://github.com/multiarch/qemu-user-static
[qemu]: https://www.qemu.org/
[tags]: https://hub.docker.com/r/dstmodders/klei-tools/tags
