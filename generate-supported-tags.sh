#!/usr/bin/env bash

BASE_DIR="$(cd "$(dirname "$0")" && pwd)"
COMMIT_ID="$(git rev-parse --verify HEAD)"
DISTS=('debian')
JSON="$(cat ./versions.json)"
LATEST_VERSIONS_KEYS=()
OFFICIAL_VERSIONS_KEYS=()
REPOSITORY='https://github.com/dstmodders/docker-klei-tools'

extract_and_sort_keys() {
  local key_path="$1"
  jq -r "$key_path | keys[]" <<< "$JSON" | sort -rV
}

mapfile -t LATEST_VERSIONS_KEYS < <(extract_and_sort_keys '.latest')
mapfile -t OFFICIAL_VERSIONS_KEYS < <(extract_and_sort_keys '.official')

readonly BASE_DIR
readonly COMMIT_ID
readonly DISTS
readonly JSON
readonly LATEST_VERSIONS_KEYS
readonly OFFICIAL_VERSIONS_KEYS
readonly REPOSITORY

print_url() {
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
for key in "${LATEST_VERSIONS_KEYS[@]}"; do
  for dist in "${DISTS[@]}"; do
    ktools_version=$(jq -r ".latest | .[$key] | .ktools_version" <<< "$JSON")
    latest=$(jq -r ".latest | .[$key] | .latest" <<< "$JSON")
    version=$(jq -r ".latest | .[$key] | .version" <<< "$JSON")

    if [ "${#version}" == 40 ]; then
      tag_version_ktools_version_dist="ktools-$ktools_version-$dist"
      tag_version_ktools_version="ktools-$ktools_version"
      tag_version=""
      tag_dist="$dist"
    else
      tag_version_ktools_version_dist="$version-ktools-$ktools_version-$dist"
      tag_version_ktools_version="$version-ktools-$ktools_version"
      tag_version="$version"
      tag_dist="$dist"
    fi

    tags="\`$tag_version_ktools_version\`, \`$tag_dist\`"
    case "$dist" in
      debian)
        tags="\`$tag_version_ktools_version_dist\`, \`$tag_version_ktools_version\`, \`$tag_version\`, \`$tag_dist\`"
        if [ "$latest" == 'true' ]; then
          tags="$tags, \`latest\`"
        fi
        ;;
    esac

    print_url "$tags" "$COMMIT_ID" "latest/$dist"
  done
done

# reference: official-ktools-4.4.0-debian, official-ktools-4.4.0, official, official-debian, official-latest
for key in "${OFFICIAL_VERSIONS_KEYS[@]}"; do
  for dist in "${DISTS[@]}"; do
    prefix='official-'
    ktools_version=$(jq -r ".official | .[$key] | .ktools_version" <<< "$JSON")
    latest=$(jq -r ".official | .[$key] | .latest" <<< "$JSON")
    version=$(jq -r ".official | .[$key] | .version" <<< "$JSON")

    if [ "${#version}" == 40 ]; then
      tag_version_ktools_version_dist="$(printf '%sktools' "$prefix")-$ktools_version-$dist"
      tag_version_ktools_version="$(printf '%sktools' "$prefix")-$ktools_version"
      tag_version=''
      tag_dist="$prefix$dist"
    else
      tag_version_ktools_version_dist="$prefix$version-ktools-$ktools_version-$dist"
      tag_version_ktools_version="$prefix$version-ktools-$ktools_version"
      tag_version="$prefix$version"
      tag_dist="$prefix$dist"
    fi

    tags="\`$tag_version_ktools_version\`, \`$tag_dist\`"
    case "$dist" in
      debian)
        if [ "${#version}" == 40 ]; then
          tags="\`$tag_version_ktools_version_dist\`, \`$tag_version_ktools_version\`"
        else
          tags="\`$tag_version_ktools_version_dist\`, \`$tag_version_ktools_version\`, \`$tag_version\`"
        fi

        if [ "$latest" == 'true' ]; then
          tags="$tags, \`$tag_dist\`, \`$(printf '%slatest' "$prefix")\`, \`official\`"
        fi
        ;;
    esac

    print_url "$tags" "$COMMIT_ID" "official/$dist"
  done
done
