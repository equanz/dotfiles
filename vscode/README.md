# VS Code

```
vscode/
├── settings.json              # VS Code and Marketplace-extension settings
├── keymap.json                # Source for keybindings and C-c h
├── keybindings.json           # Generated VS Code keybindings
├── extensions.txt             # Pinned Marketplace extensions
├── bootstrap-macos.sh         # Converges a macOS installation
├── verify.sh                  # Checks generated files and local extension
├── scripts/
│   └── render-keymap.js
└── project-tools/             # Dotfiles-owned local extension
    ├── src/
    ├── resources/
    ├── test/
    ├── package.json
    └── README.md
```

On macOS, the repository-root `./install.sh` installs this configuration when VS Code.app is already present. It does not install VS Code.app itself.

`./vscode/bootstrap-macos.sh --check` verifies symlinks and managed extension convergence without changing them. Reload the VS Code window after updating the local extension.

`./vscode/verify.sh` verifies generated keymaps, extension tests, syntax, and—on macOS—bootstrap convergence.

Edit `keymap.json`, never its generated outputs. Increment `project-tools/package.json` when changing the local extension manifest or runtime, then run `./vscode/verify.sh`.
