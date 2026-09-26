const fs = require('node:fs');
const os = require('node:os');
const path = require('node:path');
const { directoryInput, expandedProjectRoot, pathFromInput, projectRootValue } = require('../lib/paths');
const { reconcileDirectoryInput } = require('../lib/directory-input');
const { projectFilePath, readProjects, writeProjects } = require('../lib/project-store');
const { pathPickerItems } = require('../lib/path-picker');
const { enableFuzzyMatching, setContext } = require('../lib/quick-input');

async function directoryEntries(directory) {
    const entries = await fs.promises.readdir(directory, { withFileTypes: true });
    const directories = [];
    for (const entry of entries) {
        if (!entry.isDirectory() && !entry.isSymbolicLink()) continue;
        const child = path.join(directory, entry.name);
        try {
            if ((await fs.promises.stat(child)).isDirectory()) directories.push({ name: entry.name, path: child });
        } catch {
            // Ignore dangling links and unreadable directories.
        }
    }
    return directories.sort((left, right) => left.name.localeCompare(right.name));
}

function createProjectCommands(vscode) {
    let activeDirectoryPicker;
    let activeMenu;
    let activeDeletePrompt;

    async function itemsForDirectory(directory) {
        try {
            return (await directoryEntries(directory)).map((entry) => ({
                label: entry.path, action: 'directory', path: entry.path
            }));
        } catch (error) {
            return [{ label: '$(error) Cannot read this directory', description: error.message, action: 'error' }];
        }
    }

    function chooseDirectory() {
        const quickPick = vscode.window.createQuickPick();
        const picker = {
            currentDirectory: path.resolve(os.homedir()), quickPick, updateId: 0,
            loadedDirectory: undefined, entries: [],
            update: async (value) => {
                const updateId = ++picker.updateId;
                const directory = picker.currentDirectory;
                const needsInventory = picker.loadedDirectory !== directory;
                if (needsInventory) quickPick.busy = true;
                try {
                    const items = needsInventory ? await itemsForDirectory(directory) : picker.entries;
                    if (updateId === picker.updateId) {
                        picker.entries = items;
                        picker.loadedDirectory = directory;
                        quickPick.items = pathPickerItems(items, value ?? quickPick.value, directory);
                        quickPick.title = `Add Project: ${picker.currentDirectory}`;
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
                const parent = path.dirname(picker.currentDirectory);
                if (parent !== picker.currentDirectory) {
                    picker.currentDirectory = parent;
                    await picker.update(directoryInput(parent));
                }
            }
        };
        activeDirectoryPicker = picker;
        setContext(vscode, 'equanz.projectDirectoryPicker', true);
        quickPick.title = `Add Project: ${picker.currentDirectory}`;
        quickPick.placeholder = 'Path and fuzzy filter';
        quickPick.sortByLabel = false;
        return new Promise((resolve) => {
            quickPick.onDidAccept(async () => {
                const typedPath = pathFromInput(quickPick.value, picker.currentDirectory);
                const selected = quickPick.activeItems[0];
                if (selected?.action === 'directory') {
                    resolve(selected.path); quickPick.hide(); return;
                }
                if (typedPath) {
                    try {
                        if ((await fs.promises.stat(typedPath)).isDirectory()) {
                            resolve(typedPath); quickPick.hide(); return;
                        }
                    } catch {
                        // Validation below.
                    }
                }
                quickPick.validationMessage = 'Select a directory or type a valid directory path.';
            });
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
            quickPick.onDidHide(() => {
                quickPick.dispose();
                setContext(vscode, 'equanz.projectDirectoryPicker', false);
                if (activeDirectoryPicker === picker) activeDirectoryPicker = undefined;
                resolve(undefined);
            });
            quickPick.show();
            void picker.update(directoryInput(picker.currentDirectory));
        });
    }

    async function refreshProjects() {
        try { await vscode.commands.executeCommand('projectManager.refreshProjects'); } catch { /* watcher reloads it */ }
    }

    async function addProject() {
        try {
            const directory = await chooseDirectory();
            if (!directory) return;
            const defaultName = path.basename(directory) || directory;
            const name = await vscode.window.showInputBox({ title: 'Add Project', prompt: 'Project name', value: defaultName, placeHolder: defaultName });
            if (name === undefined || !name.trim()) return;
            const filePath = projectFilePath(vscode);
            const projects = await readProjects(filePath);
            const rootPath = projectRootValue(directory);
            const resolvedDirectory = expandedProjectRoot(rootPath);
            if (projects.some((project) => expandedProjectRoot(project.rootPath) === resolvedDirectory)) {
                vscode.window.showInformationMessage(`Project already registered: ${name.trim()}`); return;
            }
            if (projects.some((project) => project.name.toLowerCase() === name.trim().toLowerCase())) {
                vscode.window.showErrorMessage(`Project name already exists: ${name.trim()}`); return;
            }
            projects.push({ name: name.trim(), rootPath, tags: [], enabled: true });
            await writeProjects(filePath, projects);
            await refreshProjects();
            vscode.window.showInformationMessage(`Project added: ${name.trim()}`);
        } catch (error) {
            vscode.window.showErrorMessage(`Could not add project: ${error.message}`);
        }
    }

    async function projectItems() {
        return (await readProjects(projectFilePath(vscode))).filter((project) =>
            project.enabled !== false && typeof project.name === 'string' && typeof project.rootPath === 'string'
        ).map((project) => ({ label: project.name, description: expandedProjectRoot(project.rootPath), project }));
    }

    function promptProjectDelete(project) {
        if (activeDeletePrompt) return;
        const inputBox = vscode.window.createInputBox();
        const prompt = { inputBox, project, confirmed: false };
        activeDeletePrompt = prompt;
        setContext(vscode, 'equanz.projectDeleteConfirm', true);
        inputBox.title = 'Remove Project Registration?';
        inputBox.prompt = `Remove "${project.name}" from the project list? The directory is not deleted. (y/n)`;
        inputBox.placeholder = 'y/n'; inputBox.ignoreFocusOut = true;
        inputBox.onDidChangeValue((value) => { const answer = value.trim().toLowerCase(); inputBox.validationMessage = answer && answer !== 'y' && answer !== 'n' ? 'Enter y or n.' : undefined; });
        inputBox.onDidAccept(() => { const answer = inputBox.value.trim().toLowerCase(); if (answer === 'y') confirmDelete(); else if (answer === 'n') inputBox.hide(); else inputBox.validationMessage = 'Enter y or n.'; });
        inputBox.onDidHide(() => {
            inputBox.dispose(); if (activeDeletePrompt === prompt) activeDeletePrompt = undefined;
            setContext(vscode, 'equanz.projectDeleteConfirm', false);
            if (prompt.confirmed) void removeProjectRecord(prompt.project);
        });
        inputBox.show();
    }

    function confirmDelete() { if (activeDeletePrompt) { activeDeletePrompt.confirmed = true; activeDeletePrompt.inputBox.hide(); } }
    function cancelDelete() { activeDeletePrompt?.inputBox.hide(); }

    async function removeProjectRecord(project) {
        try {
            const filePath = projectFilePath(vscode);
            const projects = await readProjects(filePath);
            const index = projects.findIndex((candidate) => candidate.name === project.name && typeof candidate.rootPath === 'string' && expandedProjectRoot(candidate.rootPath) === expandedProjectRoot(project.rootPath));
            if (index === -1) { vscode.window.showInformationMessage(`Project is no longer registered: ${project.name}`); return; }
            projects.splice(index, 1); await writeProjects(filePath, projects); await refreshProjects();
            vscode.window.showInformationMessage(`Project registration removed: ${project.name}`);
        } catch (error) { vscode.window.showErrorMessage(`Could not remove project: ${error.message}`); }
    }

    async function deleteProject() {
        try {
            const selected = await vscode.window.showQuickPick(await projectItems(), { matchOnDescription: true, matchOnDetail: true, placeHolder: 'Remove project registration (C-j select, C-g cancel)' });
            if (selected) promptProjectDelete(selected.project);
        } catch (error) { vscode.window.showErrorMessage(`Could not remove project: ${error.message}`); }
    }

    async function switchProject() {
        const selected = await vscode.window.showQuickPick(await projectItems(), { matchOnDescription: true, matchOnDetail: true, placeHolder: 'Switch project (C-j confirm, C-g cancel)' });
        if (selected) await vscode.commands.executeCommand('vscode.openFolder', vscode.Uri.file(expandedProjectRoot(selected.project.rootPath)), { forceNewWindow: true });
    }

    async function runMenuAction(action) {
        const menu = activeMenu;
        if (menu) { menu.quickPick.hide(); await menu.closed; }
        if (action === 'add') await addProject();
        if (action === 'delete') await deleteProject();
        if (action === 'switch') await switchProject();
    }

    function showMenu() {
        if (activeMenu) return;
        const quickPick = vscode.window.createQuickPick();
        const menu = { quickPick };
        activeMenu = menu;
        setContext(vscode, 'equanz.projectMenu', true);
        quickPick.title = 'Project'; quickPick.placeholder = 'a: add project  p: switch project  C-g: cancel';
        enableFuzzyMatching(quickPick);
        quickPick.items = [
            { label: 'a  Add project', description: 'Choose an arbitrary directory', action: 'add' },
            { label: 'p  Switch project', description: 'Open a registered project', action: 'switch' },
            { label: 'd  Remove project registration', description: 'Remove only the bookmark, not the directory', action: 'delete' }
        ];
        menu.closed = new Promise((resolve) => quickPick.onDidHide(() => { quickPick.dispose(); if (activeMenu === menu) activeMenu = undefined; setContext(vscode, 'equanz.projectMenu', false); resolve(); }));
        quickPick.onDidAccept(() => { const selected = quickPick.activeItems[0]; if (selected?.action) void runMenuAction(selected.action); });
        quickPick.show();
    }

    return {
        'equanz.project.add': addProject,
        'equanz.project.addFromMenu': () => runMenuAction('add'),
        'equanz.project.cancelDelete': cancelDelete,
        'equanz.project.confirmDelete': confirmDelete,
        'equanz.project.deleteFromMenu': () => runMenuAction('delete'),
        'equanz.project.enterDirectory': () => activeDirectoryPicker?.enterSelected(),
        'equanz.project.menu': showMenu,
        'equanz.project.parentDirectory': () => activeDirectoryPicker?.goParent(),
        'equanz.project.switchFromMenu': () => runMenuAction('switch')
    };
}

module.exports = { createProjectCommands, directoryEntries };
