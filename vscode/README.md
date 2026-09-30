# VS Code

An Emacs-inspired, keyboard-first VS Code setup. This repository is the source of truth for settings, keybindings, and pinned extensions; the macOS bootstrap links the settings and keybindings into VS Code and installs the extensions.

## Setup

From the repository root, run `./install.sh` for the full dotfiles setup. On macOS, it installs mise and Node.js 24 if needed, then applies the VS Code setup when VS Code is installed. To apply only the VS Code configuration after that, run `./vscode/bootstrap-macos.sh`.

Verify the configuration with:

```sh
mise exec node@24 -- ./vscode/verify.sh
```

## Maintenance

Edit `keymap.json`; regenerate `keybindings.json` with `mise exec node@24 -- node vscode/scripts/render-keymap.js`. When changing the local extension, increment `project-tools/package.json`'s version, then run the verification command above.

## Files

```
vscode/
├── settings.json
├── keymap.json
├── keybindings.json
├── extensions.txt
├── bootstrap-macos.sh
├── verify.sh
├── scripts/
│   └── render-keymap.js
└── project-tools/    # Dotfiles-owned VS Code extension
```
