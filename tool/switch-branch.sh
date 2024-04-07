#! /usr/bin/env bash

function version_to_num() {
    if [[ -z "$1" ]]; then
        return
    fi
    awk -F . '{printf("%d%02d%02d", $1, $2, $3)}' <<<"$1"
}


NANO_VER=$(version_to_num "$(nano --version 2>/dev/null | awk '/version/ {print $4}')")

if [[ -z "${NANO_VER}" ]]; then
    printf "Cannot determine nano's version\n" >&2
    exit 1
fi

echo "Found nano version ${NANO_VER} ($(nano --version | awk '/version/ {print $4}'))"

# fetch the available "pre*" branches
git fetch --prune origin
branches=()

#mapfile -t branches <<<"$(git branch -l -r --format='%(refname:short)' "origin/pre-*")"
while IFS= read -r line; do
    branches+=("$line")
done < <(git for-each-ref --format='%(refname:short)' 'refs/remotes/origin/pre-*')

# choose the suitable branch
target="master"

for b in "${branches[@]}"; do
    num=$(version_to_num "${b#*/pre-}")

    if ((NANO_VER < num)); then
        target="${b}"
        break
    fi
done

echo "Switching to branch ${target}"

git checkout "${target}"
