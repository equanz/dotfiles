const fs = require('node:fs');
const os = require('node:os');
const path = require('node:path');
const { directoryInput, pathFromInput } = require('../lib/paths');
const { reconcileDirectoryInput } = require('../lib/directory-input');
const { pathPickerItems } = require('../lib/path-picker');
const { setContext } = require('../lib/quick-input');

async function fileEntries(directory) {
    const entries = await fs.promises.readdir(directory, { withFileTypes: true });
    const items = [];
    for (const entry of entries) {
        const candidate = path.join(directory, entry.name);
        try {
            const metadata = entry.isSymbolicLink() ? await fs.promises.stat(candidate) : entry;
            if (metadata.isDirectory()) items.push({ label: candidate, action: 'directory', path: candidate });
            else if (metadata.isFile()) items.push({ label: candidate, action: 'file', path: candidate });
        } catch {
            // Ignore dangling links and entries that cannot be read.
        }
    }
    return items.sort((left, right) => left.path.localeCompare(right.path));
}

async function itemsForFilePicker(directory) {
    try {
        return await fileEntries(directory);
    } catch (error) {
        return [{ label: '$(error) Cannot read this directory', description: error.message, action: 'error' }];
    }
}

function initialFileDirectory(vscode) {
    const editorUri = vscode.window.activeTextEditor?.document?.uri;
    if (editorUri?.scheme === 'file') return path.dirname(editorUri.fsPath);
    const workspaceFolder = vscode.workspace.workspaceFolders?.[0];
    if (workspaceFolder?.uri.scheme === 'file') return workspaceFolder.uri.fsPath;
    return os.homedir();
}

function createFileCommands(vscode) {
    let activePicker;

    function chooseFile() {
        const quickPick = vscode.window.createQuickPick();
        const picker = {
            currentDirectory: initialFileDirectory(vscode),
            quickPick,
            updateId: 0,
            loadedDirectory: undefined,
            entries: [],
            update: async (value) => {
                const updateId = ++picker.updateId;
                const directory = picker.currentDirectory;
                const needsInventory = picker.loadedDirectory !== directory;
                if (needsInventory) quickPick.busy = true;
                try {
                    const items = needsInventory ? await itemsForFilePicker(directory) : picker.entries;
                    if (updateId === picker.updateId) {
                        picker.entries = items;
                        picker.loadedDirectory = directory;
                        quickPick.items = pathPickerItems(items, value ?? quickPick.value, directory);
                        quickPick.title = 'Find File';
                        if (value !== undefined) {
                            quickPick.value = value;
                            quickPick.valueSelection = [value.length, value.length];
                        }
                    }
                } finally {
                    if (updateId === picker.updateId) quickPick.busy = false;
                }
            },
            enterSelected: async () => {
                const selected = quickPick.activeItems[0];
                if (selected?.action === 'directory') {
                    picker.currentDirectory = selected.path;
                    await picker.update(directoryInput(selected.path));
                }
            },
            goParent: async () => {
                const inputPath = pathFromInput(quickPick.value, picker.currentDirectory);
                const parent = path.dirname(inputPath || picker.currentDirectory);
                picker.currentDirectory = parent;
                await picker.update(directoryInput(parent));
            }
        };

        activePicker = picker;
        setContext(vscode, 'equanz.filePicker', true);
        quickPick.title = 'Find File';
        quickPick.placeholder = 'Path and fuzzy filter';
        quickPick.sortByLabel = false;

        return new Promise((resolve) => {
            quickPick.onDidChangeValue(async (value) => {
                const directoryChanged = await reconcileDirectoryInput({
                    value,
                    currentDirectory: picker.currentDirectory,
                    quickPick,
                    setCurrentDirectory: (directory) => { picker.currentDirectory = directory; },
                    update: picker.update
                });
                if (!directoryChanged) await picker.update();
            });
            quickPick.onDidAccept(async () => {
                const selected = quickPick.activeItems[0];
                const typedPath = pathFromInput(quickPick.value, picker.currentDirectory);
                const inputIsCurrentDirectory = typedPath === picker.currentDirectory;
                if (typedPath && !inputIsCurrentDirectory) {
                    try {
                        const metadata = await fs.promises.stat(typedPath);
                        if (metadata.isDirectory()) {
                            picker.currentDirectory = typedPath;
                            await picker.update(directoryInput(typedPath));
                            return;
                        }
                        if (metadata.isFile()) {
                            resolve({ path: typedPath, exists: true });
                            quickPick.hide();
                            return;
                        }
                        quickPick.validationMessage = 'The path is not a regular file.';
                        return;
                    } catch (error) {
                        if (error.code !== 'ENOENT') {
                            quickPick.validationMessage = error.message;
                            return;
                        }
                        if (!selected) {
                            try {
                                if (!(await fs.promises.stat(path.dirname(typedPath))).isDirectory()) {
                                    quickPick.validationMessage = 'The parent directory does not exist.';
                                    return;
                                }
                                resolve({ path: typedPath, exists: false });
                                quickPick.hide();
                                return;
                            } catch (parentError) {
                                quickPick.validationMessage = parentError.message;
                                return;
                            }
                        }
                    }
                }
                if (selected?.action === 'directory') return picker.enterSelected();
                if (selected?.action === 'file') {
                    resolve({ path: selected.path, exists: true });
                    quickPick.hide();
                    return;
                }
                quickPick.validationMessage = 'Select a file or type a path.';
            });
            quickPick.onDidHide(() => {
                quickPick.dispose();
                setContext(vscode, 'equanz.filePicker', false);
                if (activePicker === picker) activePicker = undefined;
                resolve(undefined);
            });
            quickPick.show();
            void picker.update(directoryInput(picker.currentDirectory));
        });
    }

    async function findFile() {
        try {
            const selected = await chooseFile();
            if (!selected) return;
            if (selected.exists) {
                await vscode.commands.executeCommand('vscode.open', vscode.Uri.file(selected.path), {
                    viewColumn: vscode.ViewColumn.Active, preserveFocus: false, preview: false
                });
                return;
            }
            const document = await vscode.workspace.openTextDocument(vscode.Uri.file(selected.path).with({ scheme: 'untitled' }));
            await vscode.window.showTextDocument(document, {
                viewColumn: vscode.ViewColumn.Active, preserveFocus: false, preview: false
            });
        } catch (error) {
            vscode.window.showErrorMessage(`Could not find file: ${error.message}`);
        }
    }

    return {
        'equanz.file.enterDirectory': () => activePicker?.enterSelected(),
        'equanz.file.find': findFile,
        'equanz.file.parentDirectory': () => activePicker?.goParent()
    };
}

module.exports = { createFileCommands, fileEntries, itemsForFilePicker };
