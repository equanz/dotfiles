# equanz Project Tools

Dotfiles-owned VS Code commands for keyboard-only project selection, keymap discovery, Explorer confirmation prompts, buffer switching, frames, and memos. Command implementations live below `src/`; pure filesystem and state helpers are covered by `npm test`.

This extension is packaged and installed by `../bootstrap-macos.sh`. Its `package.json` version must be incremented whenever its manifest or runtime code changes. `../keymap.json` is the source for both VS Code keybindings and the bundled C-c h resource; run `node ../scripts/render-keymap.js` after changing it.

Project registrations are machine-local state at `~/.local/state/vscode/project-manager/projects.json`, not dotfiles data. The location is configured through `projectManager.projectsLocation`.

Add Project is a directory chooser. Its candidates are plain absolute paths; `/` commits a directory component and removing that trailing slash returns to the parent candidates. `C-j` enters the selected directory, `C-l` returns to its parent, and Enter selects a directory.

`C-x b` lists open URI-backed editors and opens the selected buffer in the currently active editor group. A Markdown source and its full preview are separate entries, labelled `Edit` and `Preview`; selecting a full preview keeps it as a preview. Side previews are VS Code webviews and cannot be addressed through the public tab API. It does not move or close the source editor, so a buffer may remain visible in more than one group.

For a Markdown source editor, `C-c v` opens a preview to the side while keeping focus in the source editor, and `C-c V` replaces the source editor with a full preview. Use `C-x b` to return to a full preview in the active editor group.

`C-x k` closes the active editor. A modified buffer asks whether to discard its unsaved changes: `y` discards and closes, while `n` or `C-g` keeps it open. Save first if the changes should be kept.

`C-x C-f` is a filesystem picker, not workspace-only Quick Open. It begins with the active file's directory (otherwise the workspace root, then home) prefilled in the input box, and lists only that directory's immediate children as plain absolute paths. The input is both the editable path and the fuzzy filter. Normal input only filters; typing `/` commits the preceding existing directory component and replaces the candidates with its children without rewriting the input. Removing that trailing `/` returns candidates to the parent directory. `C-j` also enters a selected or exactly typed directory, or opens a selected file. `C-l` removes the final path component from the input and lists that parent directory. `C-f` and `C-b` remain input-editing keys. A missing file whose parent exists opens as an associated untitled buffer; it is created only when saved.

Window operations are `C-x o` (next editor group), `C-x 2` / `C-x 3` (split), `C-x 0` (close group), and `C-x 1` (keep one group). Selecting a project always opens its folder workspace in a new window, preserving the current project window. `C-x 5 2` opens the current single-folder workspace or saved `.code-workspace` in a new window; it rejects an untitled multi-root workspace instead of creating a window that will later prompt to save workspace configuration. `C-x 5 0` closes the current window.

`C-c m` opens a memo picker rooted at `~/Documents/notes`, independent of the workspace. Select an existing Markdown memo or type a relative name and confirm with `C-j`; a name without an extension becomes `.md`. The directory is created only on the first use. Symlinks are not followed while indexing or opening a typed memo.
