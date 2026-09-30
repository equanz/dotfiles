#!/bin/sh

set -eu

if [ "$(uname -s)" != 'Darwin' ]; then
    echo 'This bootstrap script supports macOS only.' >&2
    exit 1
fi

mode=apply
case "${1:-}" in
    '') ;;
    --check) mode=check ;;
    *) echo "Usage: $0 [--check]" >&2; exit 2 ;;
esac

script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
user_dir="${HOME}/Library/Application Support/Code/User"
project_state_dir="${HOME}/.local/state/vscode/project-manager"
drift=0

mark_drift() {
    echo "Needs update: $1" >&2
    drift=1
}

code_cli() {
    if command -v code >/dev/null 2>&1; then
        command -v code
    elif [ -x '/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code' ]; then
        echo '/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code'
    else
        return 1
    fi
}

code_bin=$(code_cli) || {
    echo 'VS Code CLI was not found. Install VS Code or run "Shell Command: Install code command in PATH".' >&2
    exit 1
}

if ! command -v mise >/dev/null 2>&1; then
    echo 'mise is required; run the repository-root install.sh first.' >&2
    exit 1
fi
if ! mise where node@24 >/dev/null 2>&1; then
    echo 'Node.js 24 must be installed through mise; run the repository-root install.sh first.' >&2
    exit 1
fi
if [ "$mode" = check ]; then
    mise exec node@24 -- node "$script_dir/scripts/render-keymap.js" --check
else
    mise exec node@24 -- node "$script_dir/scripts/render-keymap.js"
fi

link_is_current() {
    target_path=$1
    source_path=$2
    [ -L "$target_path" ] && [ "$(readlink "$target_path")" = "$source_path" ]
}

ensure_link() {
    source_path=$1
    target_path=$2
    if link_is_current "$target_path" "$source_path"; then
        echo "Verified link: $target_path"
        return
    fi
    mark_drift "$target_path"
    if [ "$mode" = check ]; then return; fi
    mkdir -p "$(dirname "$target_path")"
    if [ -e "$target_path" ] || [ -L "$target_path" ]; then
        backup_path="${target_path}.backup.$(date '+%Y%m%d%H%M%S')"
        backup_index=0
        while [ -e "$backup_path" ] || [ -L "$backup_path" ]; do
            backup_index=$((backup_index + 1))
            backup_path="${target_path}.backup.$(date '+%Y%m%d%H%M%S').${backup_index}"
        done
        mv "$target_path" "$backup_path"
        echo "Backed up: $target_path -> $backup_path"
    fi
    ln -s "$source_path" "$target_path"
    echo "Linked: $target_path -> $source_path"
}

code_with_profile() {
    if [ -n "${VSCODE_PROFILE:-}" ]; then
        "$code_bin" "$@" --profile "$VSCODE_PROFILE"
    else
        "$code_bin" "$@"
    fi
}

list_extensions() {
    code_with_profile --list-extensions --show-versions
}

installed_extensions=$(list_extensions)

extension_is_current() {
    expected=$1
    printf '%s\n' "$installed_extensions" | grep -Fqx "$expected"
}

refresh_extensions() {
    installed_extensions=$(list_extensions)
}

install_extension() {
    extension=$1
    code_with_profile --install-extension "$extension" --force
    refresh_extensions
}

ensure_extension() {
    expected=$1
    source=${2:-$expected}
    if extension_is_current "$expected"; then
        echo "Verified VS Code extension: $expected"
        return
    fi
    mark_drift "extension $expected"
    if [ "$mode" = check ]; then return; fi
    install_extension "$source"
    if ! extension_is_current "$expected"; then
        echo "Failed to verify installed extension: $expected" >&2
        exit 1
    fi
    echo "Installed VS Code extension: $expected"
}

ensure_link "$script_dir/settings.json" "$user_dir/settings.json"
ensure_link "$script_dir/keybindings.json" "$user_dir/keybindings.json"

if [ -d "$project_state_dir" ]; then
    echo "Verified project state directory: $project_state_dir"
else
    mark_drift "$project_state_dir"
    if [ "$mode" = apply ]; then
        mkdir -p "$project_state_dir"
        echo "Created project state directory: $project_state_dir"
    fi
fi

local_extension_source="$script_dir/project-tools"
local_extension_version=$(mise exec node@24 -- node -e 'const fs = require("node:fs"); const manifest = JSON.parse(fs.readFileSync(process.argv[1], "utf8")); process.stdout.write(manifest.version);' "$local_extension_source/package.json")
expected_local_extension="equanz.equanz-project-tools@${local_extension_version}"
if extension_is_current "$expected_local_extension"; then
    echo "Verified VS Code extension: $expected_local_extension"
else
    mark_drift "extension $expected_local_extension"
    if [ "$mode" = apply ]; then
        temporary_extension_dir=$(mktemp -d "${TMPDIR:-/tmp}/equanz-project-tools.XXXXXX")
        trap 'rm -rf "$temporary_extension_dir"' EXIT HUP INT TERM
        local_extension_vsix="$temporary_extension_dir/${expected_local_extension}.vsix"
        (
            CDPATH= cd "$local_extension_source"
            npm_config_cache="$temporary_extension_dir/npm-cache" mise exec node@24 -- npx --yes '@vscode/vsce@3.9.2' package \
                --no-dependencies --allow-missing-repository --skip-license --out "$local_extension_vsix"
        )
        install_extension "$local_extension_vsix"
        if ! extension_is_current "$expected_local_extension"; then
            echo "Failed to verify installed extension: $expected_local_extension" >&2
            exit 1
        fi
        echo "Installed VS Code extension: $expected_local_extension"
    fi
fi

while IFS= read -r extension || [ -n "$extension" ]; do
    case "$extension" in ''|'#'*) continue ;; esac
    ensure_extension "$extension"
done < "$script_dir/extensions.txt"

if [ "$mode" = check ]; then
    if [ "$drift" -ne 0 ]; then
        echo 'VS Code bootstrap check failed: installation has drift.' >&2
        exit 1
    fi
    echo 'VS Code bootstrap check passed.'
    exit 0
fi

if [ "$drift" -ne 0 ]; then
    exec "$0" --check
fi
echo 'VS Code bootstrap completed; installation was already current.'
