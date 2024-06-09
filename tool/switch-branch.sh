#! /usr/bin/env bash

base="$(dirname "$0")/../"
branch=$("$base/install.sh" --find_suitable_branch)
verstr=$(nano --version 2>/dev/null | awk '/GNU nano/ {print ($3=="version")? $4: substr($5,2)}')

echo "Current nano version: ${verstr}"
echo "Switching to ${branch}"
git checkout "${branch}"
