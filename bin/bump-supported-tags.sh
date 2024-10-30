#!/usr/bin/env bash

# define constants
BASE_DIR="$(cd "$(dirname "$0")" && pwd)"
COMMIT_ID="$(git rev-parse --verify HEAD)"
COMMIT_MESSAGE='Change tags in DOCKERHUB.md and README.md'
DISTS=('debian')
HEADING_FOR_OVERVIEW='## Overview'
HEADING_FOR_TAGS="## Supported tags and respective \`Dockerfile\` links"
JSON="$(cat ./versions.json)"
LATEST_VERSIONS_KEYS=()
OFFICIAL_VERSIONS_KEYS=()
PROGRAM="$(basename "$0")"
REPOSITORY='https://github.com/dstmodders/docker-klei-tools'

extract_and_sort_keys() {
  local key_path="$1"
  jq -r "$key_path | keys[]" <<< "$JSON" | sort -rV
}

mapfile -t LATEST_VERSIONS_KEYS < <(extract_and_sort_keys '.latest')
mapfile -t OFFICIAL_VERSIONS_KEYS < <(extract_and_sort_keys '.official')

readonly BASE_DIR
readonly COMMIT_ID
readonly COMMIT_MESSAGE
readonly DISTS
readonly HEADING_FOR_OVERVIEW
readonly HEADING_FOR_TAGS
readonly JSON
readonly LATEST_VERSIONS_KEYS
readonly OFFICIAL_VERSIONS_KEYS
readonly PROGRAM
readonly REPOSITORY

# define flags
FLAG_COMMIT=0
FLAG_DRY_RUN=0

usage() {
  cat <<EOF
Bump supported tags.

Usage:
  $PROGRAM [flags]

Flags:
  -c, --commit    commit changes
  -d, --dry-run   only check and don't apply or commit any changes
  -h, --help      help for $PROGRAM
EOF
}

print_bold() {
  local value="$1"
  local output="${2:-1}"

  if [ "$DISABLE_COLORS" = '1' ] || ! [ -t 1 ]; then
    printf '%s' "$value" >&"$output"
  else
    printf "$(tput bold)%s$(tput sgr0)" "$value" >&"$output"
  fi
}

print_bold_color() {
  local color="$1"
  local value="$2"
  local output="${3:-1}"

  if [ "$DISABLE_COLORS" = '1' ] || ! [ -t 1 ]; then
    printf '%s' "$value" >&"$output"
  else
    printf "$(tput bold)$(tput setaf "$color")%s$(tput sgr0)" "$value" >&"$output"
  fi
}

print_error() {
  print_bold_color 1 "error: $1" 2
  echo '' >&2
}

print_url() {
  local tags="$1"
  local commit="$2"
  local directory="$3"
  local url="[$tags]($REPOSITORY/blob/$commit/$directory/Dockerfile)"
  echo "- $url"
}

# reference:
#   1.0.0-ktools-4.5.1-debian, 1.0.0-ktools-4.5.1, 1.0.0, debian, latest
#   1.0.0-ktools-4.5.0-debian, 1.0.0-ktools-4.5.0
print_latest_tags() {
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
}

# reference: official-ktools-4.4.0-debian, official-ktools-4.4.0, official, official-debian, official-latest
print_official_tags() {
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
}

replace() {
  local content="$1"
  for file in ./DOCKERHUB.md ./README.md; do
    sed -i "/$HEADING_FOR_TAGS/,/$HEADING_FOR_OVERVIEW/ {
      /$HEADING_FOR_TAGS/!{
        /$HEADING_FOR_OVERVIEW/!d
      }
      /$HEADING_FOR_TAGS/!b
      r /dev/stdin
      d
    }" "$file" <<< "$content"
  done
}

cd "$BASE_DIR/.." || exit 1

while [ $# -gt 0 ]; do
  key="$1"
  case "$key" in
    -c|--commit)
      FLAG_COMMIT=1
      ;;
    -d|--dry-run)
      FLAG_DRY_RUN=1
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    -*)
      print_error 'unrecognized flag'
      exit 1
      ;;
    *)
      ;;
  esac
  shift 1
done

# define extra constants
readonly FLAG_COMMIT
readonly FLAG_DRY_RUN

printf "%s\n\n" "$HEADING_FOR_TAGS"

if [ "$FLAG_DRY_RUN" -eq 1 ]; then
  print_latest_tags
  print_official_tags
  exit 0
else
  latest_tags="$(print_latest_tags)"
  official_tags="$(print_official_tags)"
  echo "$latest_tags"
  echo "$official_tags"

  echo '---'
  printf 'Replacing...'
  replace "$HEADING_FOR_TAGS"$'\n'$'\n'"$latest_tags"$'\n'"$official_tags"$'\n'
  printf ' Done\n'

  if [ "$FLAG_COMMIT" -eq 1 ]; then
    printf 'Committing...'
    git add ./DOCKERHUB.md ./README.md
    if [ -n "$(git diff --cached --name-only)" ]; then
      printf '\n'
      echo '---'
      git commit -m "$COMMIT_MESSAGE"
    else
      printf ' Skipped\n'
    fi
  fi
fi
