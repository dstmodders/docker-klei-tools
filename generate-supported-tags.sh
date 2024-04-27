#!/usr/bin/env bash

BASE_DIR="$(cd "$(dirname "$0")" && pwd)"
COMMIT_ID="$(git rev-parse --verify HEAD)"
DISTS=('debian')
JSON="$(cat ./versions.json)"
REPOSITORY='https://github.com/dstmodders/docker-klei-tools'
VERSIONS_KEYS=()

mapfile -t VERSIONS_KEYS < <(jq -r 'keys[]' <<< "$JSON")
# shellcheck disable=SC2207
IFS=$'\n' VERSIONS_KEYS=($(sort -rV <<< "${VERSIONS_KEYS[*]}")); unset IFS

readonly BASE_DIR
readonly COMMIT_ID
readonly DISTS
readonly JSON
readonly REPOSITORY
readonly VERSIONS_KEYS

function print_url() {
  local tags="$1"
  local commit="$2"
  local directory="$3"
  local url="[$tags]($REPOSITORY/blob/$commit/$directory/Dockerfile)"
  echo "- $url"
}

cd "$BASE_DIR" || exit 1

printf "## Supported tags and respective \`Dockerfile\` links\n\n"

# reference:
#   1.0.0-ktools-4.5.1-debian, 1.0.0-ktools-4.5.1, 1.0.0, debian, latest
#   1.0.0-ktools-4.5.0-debian, 1.0.0-ktools-4.5.0
#   official-ktools-4.4.0-debian, official-ktools-4.4.0, official, official-debian, official-latest
for key in "${VERSIONS_KEYS[@]}"; do
  for dist in "${DISTS[@]}"; do
    ktools=$(jq -r ".[$key] | .ktools" <<< "$JSON")
    latest=$(jq -r ".[$key] | .latest" <<< "$JSON")
    official=$(jq -r ".[$key] | .official" <<< "$JSON")
    previous=$(jq -r ".[$key] | .previous" <<< "$JSON")
    version=$(jq -r ".[$key] | .version" <<< "$JSON")

    if [ "${#version}" == 40 ]; then
      tag_dist="$dist"
      tag_full="ktools-$ktools"
      tag_full_dist="$tag_full-$dist"
      tag_version=""
    else
      tag_dist="$dist"
      tag_full="$version-ktools-$ktools"
      tag_full_dist="$tag_full-$dist"
      tag_version="$version"
    fi

    if [ "$official" == 'true' ]; then
      tag_dist="official-$tag_dist"
      tag_full="official-$tag_full"
      tag_full_dist="$tag_full-$dist"
      tag_version="official-$tag_version"
    fi

    tags="\`$tag_full\`, \`$tag_dist\`"
    case "$dist" in
      debian)
        if [ "$official" == 'true' ]; then
          tags="\`$tag_full_dist\`, \`$tag_full\`"
        else
          tags="\`$tag_full_dist\`, \`$tag_full\`, \`$tag_version\`"
        fi

        if [ "$latest" == 'true' ]; then
          if [ "$official" == 'true' ]; then
            tags="$tags, \`$tag_dist\`, \`official-latest\`, \`official\`"
          else
            tags="$tags, \`$tag_dist\`, \`latest\`"
          fi
        fi
        ;;
    esac

    if [ "$official" == 'true' ]; then
      print_url "$tags" "$COMMIT_ID" "official/$dist"
    else
      print_url "$tags" "$COMMIT_ID" "latest/$dist"
    fi
  done

  if [ "$previous" != "null" ]; then
    mapfile -t commits < <(jq -r 'keys[]' <<< "$previous")
    ktools=$(jq -c ".[].ktools" <<< "$previous" | xargs)

    for dist in "${DISTS[@]}"; do
      for commit in "${commits[@]}"; do
        tag_full="$version-ktools-$ktools"
        tag_full_dist="$tag_full-$dist"
        tags="\`$tag_full_dist\`, \`$tag_full\`"
        if [ "$official" == 'true' ]; then
          print_url "$tags" "$commit" "official/$dist"
        else
          print_url "$tags" "$commit" "latest/$dist"
        fi
      done
    done
  fi
done
