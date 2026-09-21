#!/bin/sh

set -eu

script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)

node "$script_dir/scripts/render-keymap.js" --check
npm test --prefix "$script_dir/project-tools"

jq empty \
    "$script_dir/settings.json" \
    "$script_dir/keymap.json" \
    "$script_dir/keybindings.json" \
    "$script_dir/project-tools/package.json" \
    "$script_dir/project-tools/resources/keymap.json"

find "$script_dir/project-tools/src" "$script_dir/project-tools/test" "$script_dir/scripts" \
    -name '*.js' -print0 | xargs -0 -n1 node --check
sh -n "$script_dir/bootstrap-macos.sh"
sh -n "$script_dir/../install.sh"

if [ "$(uname -s)" = 'Darwin' ]; then
    "$script_dir/bootstrap-macos.sh" --check
fi
