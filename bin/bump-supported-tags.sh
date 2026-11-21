#!/usr/bin/env bash
#
# Bump supported tags.
#
# Usage:
#   bump-supported-tags.sh [flags]
#
# Examples:
#   bump-supported-tags.sh
#   bump-supported-tags.sh -d
#
# Flags:
#   -c, --commit    Commit changes
#   -d, --dry-run   Only check and don't apply or commit any changes
#   -h, --help      Show this help message
#
# Environment Variables:
#   NO_COLOR        Set to 1 to disable terminal colors
#                   (see no-color.org, default "0")
#
set -euo pipefail

# define constants
BASE_DIR="$(cd "$(dirname "$0")" && pwd)"
COMMIT_ID="$(git rev-parse --verify HEAD)"
COMMIT_MESSAGE='Change tags in DOCKERHUB.md and README.md'
DISTS=('debian')
HEADING_FOR_OVERVIEW='## Overview'
HEADING_FOR_TAGS="## Supported tags and respective \`Dockerfile\` links"
JSON="$(cat "${BASE_DIR}/../versions.json")"
LATEST_VERSIONS_KEYS=()
OFFICIAL_VERSIONS_KEYS=()
REPOSITORY='https://github.com/dstmodders/docker-klei-tools'

extract_and_sort_keys() {
  local key_path="$1"
  jq -r "${key_path} | keys[]" <<< "${JSON}" | sort -rV
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
readonly REPOSITORY

# shellcheck disable=SC1091
source "${BASE_DIR}/common.sh"

# define defaults for environment variables
NO_COLOR="${NO_COLOR:-0}"

# define flags
FLAG_COMMIT=0
FLAG_DRY_RUN=0

print_url() {
  local tags="$1"
  local commit="$2"
  local directory="$3"
  local url="[${tags}](${REPOSITORY}/blob/${commit}/${directory}/Dockerfile)"
  printf -- '- %s\n' "${url}"
}

# reference:
#   1.0.0-ktools-4.5.1-debian, 1.0.0-ktools-4.5.1, 1.0.0, debian, latest
#   1.0.0-ktools-4.5.0-debian, 1.0.0-ktools-4.5.0
print_latest_tags() {
  for key in "${LATEST_VERSIONS_KEYS[@]}"; do
    for dist in "${DISTS[@]}"; do
      ktools_version="$(jq -r ".latest | .[${key}] | .ktools_version" <<< "${JSON}")"
      latest="$(jq -r ".latest | .[${key}] | .latest" <<< "${JSON}")"
      version="$(jq -r ".latest | .[${key}] | .version" <<< "${JSON}")"

      if [ "${#version}" -eq 40 ]; then
        tag_version_ktools_version_dist="ktools-${ktools_version}-${dist}"
        tag_version_ktools_version="ktools-${ktools_version}"
        tag_version=''
        tag_dist="${dist}"
      else
        tag_version_ktools_version_dist="${version}-ktools-${ktools_version}-${dist}"
        tag_version_ktools_version="${version}-ktools-${ktools_version}"
        tag_version="${version}"
        tag_dist="${dist}"
      fi

      tags="\`${tag_version_ktools_version}\`, \`${tag_dist}\`"
      case "${dist}" in
        debian)
          tags="\`${tag_version_ktools_version_dist}\`, \`${tag_version_ktools_version}\`, \`${tag_version}\`, \`${tag_dist}\`"
          if [ "${latest}" = 'true' ]; then
            tags="${tags}, \`latest\`"
          fi
          ;;
      esac

      print_url "${tags}" "${COMMIT_ID}" "latest/${dist}"
    done
  done
}

# reference:
#   official-ktools-4.4.0-debian, official-ktools-4.4.0, official-debian, official-latest, official
print_official_tags() {
  for key in "${OFFICIAL_VERSIONS_KEYS[@]}"; do
    for dist in "${DISTS[@]}"; do
      prefix='official-'
      ktools_version="$(jq -r ".official | .[${key}] | .ktools_version" <<< "${JSON}")"
      latest="$(jq -r ".official | .[${key}] | .latest" <<< "${JSON}")"
      version="$(jq -r ".official | .[${key}] | .version" <<< "${JSON}")"

      if [ "${#version}" -eq 40 ]; then
        tag_version_ktools_version_dist="$(printf '%sktools' "${prefix}")-${ktools_version}-${dist}"
        tag_version_ktools_version="$(printf '%sktools' "${prefix}")-${ktools_version}"
        tag_version=''
        tag_dist="${prefix}${dist}"
      else
        tag_version_ktools_version_dist="${prefix}${version}-ktools-${ktools_version}-${dist}"
        tag_version_ktools_version="${prefix}${version}-ktools-${ktools_version}"
        tag_version="${prefix}${version}"
        tag_dist="${prefix}${dist}"
      fi

      tags="\`${tag_version_ktools_version}\`, \`${tag_dist}\`"
      case "${dist}" in
        debian)
          if [ "${#version}" -eq 40 ]; then
            tags="\`${tag_version_ktools_version_dist}\`, \`${tag_version_ktools_version}\`"
          else
            tags="\`${tag_version_ktools_version_dist}\`, \`${tag_version_ktools_version}\`, \`${tag_version}\`"
          fi

          if [ "${latest}" = 'true' ]; then
            tags="${tags}, \`${tag_dist}\`, \`$(printf '%slatest' "${prefix}")\`, \`official\`"
          fi
          ;;
      esac

      print_url "${tags}" "${COMMIT_ID}" "official/${dist}"
    done
  done
}

replace() {
  local content="$1"
  for file in ./DOCKERHUB.md ./README.md; do
    sed -i "/${HEADING_FOR_TAGS}/,/${HEADING_FOR_OVERVIEW}/ {
      /${HEADING_FOR_TAGS}/!{
        /${HEADING_FOR_OVERVIEW}/!d
      }
      /${HEADING_FOR_TAGS}/!b
      r /dev/stdin
      d
    }" "${file}" <<< "${content}"
  done
}

cd "${BASE_DIR}/.." || exit 1

while [ $# -gt 0 ]; do
  key="$1"
  case "${key}" in
    -c | --commit)
      FLAG_COMMIT=1
      ;;
    -d | --dry-run)
      FLAG_DRY_RUN=1
      ;;
    -h | --help)
      usage
      exit 0
      ;;
    -*)
      die 'unrecognized flag'
      ;;
    *)
      die 'unexpected argument'
      ;;
  esac
  shift 1
done

readonly FLAG_COMMIT
readonly FLAG_DRY_RUN

require_cmds jq

trap interrupt SIGINT

print_step_dotted 'Generating tags'
printf '\n'
print_separator

printf "%s\n\n" "${HEADING_FOR_TAGS}"

if [ "${FLAG_DRY_RUN}" -eq 1 ]; then
  print_latest_tags
  print_official_tags
  complete 3 'Dry-run completed'
fi

latest_tags="$(print_latest_tags)"
official_tags="$(print_official_tags)"
printf '%s\n' "${latest_tags}"
printf '%s\n' "${official_tags}"

print_separator
print_step_dotted 'Replacing'
replace "${HEADING_FOR_TAGS}"$'\n'$'\n'"${latest_tags}"$'\n'"${official_tags}"$'\n'
print_step_success

if [ "${FLAG_COMMIT}" -eq 1 ]; then
  print_step_dotted 'Committing'
  git add ./DOCKERHUB.md ./README.md
  if [ -n "$(git diff --cached --name-only)" ]; then
    printf '\n'
    print_separator
    git commit -m "${COMMIT_MESSAGE}"
  else
    print_step_skipped
  fi
fi

complete 2 'Bump completed'
