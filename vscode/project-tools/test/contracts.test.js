const assert = require('node:assert/strict');
const fs = require('node:fs');
const os = require('node:os');
const path = require('node:path');
const test = require('node:test');
const { execFileSync } = require('node:child_process');
const { activateWith } = require('../src/activate');
const { createBufferCommands } = require('../src/commands/buffers');
const { createFileCommands, fileEntries } = require('../src/commands/files');
const { createKeymapCommands } = require('../src/commands/keymap');
const { createMarkdownCommands } = require('../src/commands/markdown');
const { createProjectCommands } = require('../src/commands/projects');
const { directoryInput, isExplicitPathInput, pathFromInput } = require('../src/lib/paths');
const { pathPickerItems } = require('../src/lib/path-picker');
const { readProjects, writeProjects } = require('../src/lib/project-store');

const extensionRoot = path.resolve(__dirname, '..');
const vscodeRoot = path.resolve(extensionRoot, '..');

async function waitFor(predicate, message) {
    const deadline = Date.now() + 1000;
    while (!predicate()) {
        if (Date.now() >= deadline) throw new Error(message);
        await new Promise((resolve) => setImmediate(resolve));
    }
}

test('manifest command contract is explicit and startup activation remains singular', () => {
    const manifest = JSON.parse(fs.readFileSync(path.join(extensionRoot, 'package.json'), 'utf8'));
    const contributed = manifest.contributes.commands.map((entry) => entry.command).sort();
    assert.equal(new Set(contributed).size, contributed.length);
    assert.deepEqual(manifest.activationEvents, ['onStartupFinished']);
});

test('startup closes the auxiliary bar without writing VS Code state database', async () => {
    const executed = [];
    const registered = [];
    const vscode = {
        commands: {
            executeCommand: async (command) => { executed.push(command); },
            registerCommand: (id) => { registered.push(id); return { dispose() {} }; }
        },
        window: {
            activeTextEditor: undefined,
            onDidChangeActiveTextEditor: () => ({ dispose() {} }),
            tabGroups: { all: [] }
        }
    };
    const context = { subscriptions: [] };
    await activateWith(vscode, context);
    const manifest = JSON.parse(fs.readFileSync(path.join(extensionRoot, 'package.json'), 'utf8'));
    assert.deepEqual(registered.sort(), manifest.contributes.commands.map((entry) => entry.command).sort());
    assert.ok(executed.includes('workbench.action.closeAuxiliaryBar'));
    const settings = JSON.parse(fs.readFileSync(path.join(vscodeRoot, 'settings.json'), 'utf8'));
    assert.equal(settings['workbench.secondarySideBar.defaultVisibility'], 'hidden');
});

test('keymap renderer is current and every help binding resolves', () => {
    execFileSync(process.execPath, [path.join(vscodeRoot, 'scripts', 'render-keymap.js'), '--check'], { stdio: 'pipe' });
    const source = JSON.parse(fs.readFileSync(path.join(vscodeRoot, 'keymap.json'), 'utf8'));
    const manifest = JSON.parse(fs.readFileSync(path.join(extensionRoot, 'package.json'), 'utf8'));
    const rendered = JSON.parse(fs.readFileSync(path.join(extensionRoot, 'resources', 'keymap.json'), 'utf8'));
    assert.ok(source.keybindings.length > 0);
    assert.ok(rendered.bindings.length > 0);
    const projectEnter = source.keybindings.find((binding) =>
        binding.key === 'ctrl+j' && binding.command === 'equanz.project.enterDirectory' &&
        binding.when === 'equanz.projectDirectoryPicker && inQuickInput'
    );
    const genericAccept = source.keybindings.find((binding) =>
        binding.key === 'ctrl+j' && binding.command === 'quickInput.accept'
    );
    assert.ok(projectEnter);
    assert.match(genericAccept.when, /!equanz\.projectDirectoryPicker/);
    assert.ok(source.keybindings.some((binding) =>
        binding.key === 'ctrl+l' && binding.command === 'equanz.project.parentDirectory' &&
        binding.when === 'equanz.projectDirectoryPicker && inQuickInput'
    ));
    assert.ok(source.keybindings.some((binding) =>
        binding.key === 'ctrl+c v' && binding.command === 'equanz.markdown.previewToSide' &&
        binding.when === 'editorLangId == markdown && editorTextFocus'
    ));
    assert.ok(source.keybindings.some((binding) =>
        binding.key === 'ctrl+c shift+v' && binding.command === 'markdown.reopenAsPreview' &&
        binding.when === 'editorLangId == markdown && editorTextFocus'
    ));
    assert.ok(source.keybindings.some((binding) =>
        binding.key === 'ctrl+g' && binding.command === 'closeFindWidget' && binding.when === 'findWidgetVisible'
    ));
    assert.ok(source.keybindings.some((binding) =>
        binding.key === 'ctrl+x n' && binding.command === 'workbench.action.nextEditorInGroup' && binding.when === '!terminalFocus'
    ));
    assert.ok(source.keybindings.some((binding) =>
        binding.key === 'ctrl+x p' && binding.command === 'workbench.action.previousEditorInGroup' && binding.when === '!terminalFocus'
    ));
    assert.equal(source.keybindings.some((binding) => binding.command === 'equanz.buffer.next' || binding.command === 'equanz.buffer.previous'), false);
    const settings = JSON.parse(fs.readFileSync(path.join(vscodeRoot, 'settings.json'), 'utf8'));
    assert.equal(settings['emacs-mcx.cursorMoveOnFindWidget'], true);
    const localCommands = new Set(manifest.contributes.commands.map((entry) => entry.command));
    for (const binding of source.keybindings) {
        if (binding.command?.startsWith('equanz.')) assert.ok(localCommands.has(binding.command), binding.command);
    }
    const resourceCommands = [];
    const visit = (entries) => entries.forEach((entry) => {
        if (entry.type === 'bindings') visit(entry.bindings);
        else if (entry.command?.startsWith('equanz.')) resourceCommands.push(entry.command);
    });
    visit(rendered.bindings);
    for (const command of resourceCommands) assert.ok(localCommands.has(command), command);
});

test('path minibuffer helpers preserve explicit paths and directory input', () => {
    assert.equal(isExplicitPathInput('pulsar'), false);
    assert.equal(isExplicitPathInput('pulsar/'), true);
    assert.equal(pathFromInput('child', '/tmp/base'), path.resolve('/tmp/base/child'));
    assert.equal(directoryInput('/tmp/base'), `${path.resolve('/tmp/base')}${path.sep}`);
});

test('file picker inventory is immediate children only', async () => {
    const root = await fs.promises.mkdtemp(path.join(os.tmpdir(), 'equanz-file-picker-'));
    try {
        await fs.promises.mkdir(path.join(root, 'directory'));
        await fs.promises.mkdir(path.join(root, 'directory', 'nested'));
        await fs.promises.writeFile(path.join(root, 'file.txt'), 'x');
        const items = await fileEntries(root);
        assert.deepEqual(items.map((item) => item.path), [path.join(root, 'directory'), path.join(root, 'file.txt')]);
    } finally {
        await fs.promises.rm(root, { recursive: true, force: true });
    }
});

test('path picker ranks filename subsequences and keeps the path tail visible', () => {
    const root = '/tmp/very/long/directory';
    const items = ['pulsar-client-node', 'pulsar', 'other'].map((name) => ({
        label: path.join(root, name), path: path.join(root, name), action: 'file'
    }));
    const filtered = pathPickerItems(items, `${root}/plsr`, root);
    assert.deepEqual(filtered.map((item) => item.label), ['pulsar', 'pulsar-client-node']);
    assert.ok(filtered.every((item) => item.alwaysShow));
    assert.deepEqual(pathPickerItems(items, `${root}/pulsar`, root).map((item) => item.label), [
        'pulsar', 'pulsar-client-node'
    ]);
    const mixed = pathPickerItems([
        { path: path.join(root, 'source'), action: 'directory' },
        { path: path.join(root, 'source.txt'), action: 'file' }
    ], `${root}/source`, root);
    assert.deepEqual(mixed.map(({ label, path: itemPath }) => [label, itemPath]), [
        ['source/', path.join(root, 'source')],
        ['source.txt', path.join(root, 'source.txt')]
    ]);
});

test('file picker commits a typed directory only after slash', async () => {
    const root = await fs.promises.mkdtemp(path.join(os.tmpdir(), 'equanz-file-picker-slash-'));
    let quickPick;
    const callbacks = {};
    const vscode = {
        commands: { executeCommand: async () => undefined },
        workspace: { workspaceFolders: undefined },
        window: {
            activeTextEditor: undefined,
            createQuickPick: () => {
                quickPick = {
                    activeItems: [], items: [], value: '', busy: false,
                    onDidAccept: (callback) => { callbacks.accept = callback; },
                    onDidChangeValue: (callback) => { callbacks.change = callback; },
                    onDidHide: (callback) => { callbacks.hide = callback; },
                    show() {}, hide() { callbacks.hide(); }, dispose() {}
                };
                return quickPick;
            }
        },
        QuickPickItemKind: { Separator: -1 }
    };
    try {
        await fs.promises.mkdir(path.join(root, 'pulsar'));
        await fs.promises.writeFile(path.join(root, 'pulsar', 'child.txt'), 'x');
        await fs.promises.mkdir(path.join(root, 'pulsar-client-node'));
        await fs.promises.mkdir(path.join(root, '.hidden'));
        vscode.window.activeTextEditor = { document: { uri: { scheme: 'file', fsPath: path.join(root, 'current.txt') } } };
        const commands = createFileCommands(vscode);
        const pending = commands['equanz.file.find']();
        await waitFor(() => quickPick.items.length === 3, 'file picker did not finish its initial inventory');
        assert.deepEqual(quickPick.items.map((item) => item.label), ['.hidden/', 'pulsar/', 'pulsar-client-node/']);
        quickPick.value = path.join(root, 'pulsar');
        await callbacks.change(quickPick.value);
        assert.deepEqual(quickPick.items.map((item) => item.path), [path.join(root, 'pulsar'), path.join(root, 'pulsar-client-node')]);
        quickPick.value = `${root}${path.sep}.`;
        await callbacks.change(quickPick.value);
        assert.deepEqual(quickPick.items.map((item) => item.label), ['.hidden/']);
        quickPick.value = `${path.join(root, 'pulsar')}${path.sep}`;
        await callbacks.change(quickPick.value);
        assert.deepEqual(quickPick.items.map((item) => item.path), [path.join(root, 'pulsar', 'child.txt')]);
        quickPick.value = path.join(root, 'pulsar');
        await callbacks.change(quickPick.value);
        assert.deepEqual(quickPick.items.map((item) => item.path), [path.join(root, 'pulsar'), path.join(root, 'pulsar-client-node')]);
        quickPick.hide();
        await pending;
    } finally {
        await fs.promises.rm(root, { recursive: true, force: true });
    }
});

test('project picker uses the same slash commit and trailing slash rollback', async () => {
    const root = await fs.promises.mkdtemp(path.join(os.tmpdir(), 'equanz-project-picker-'));
    let quickPick;
    let nameInput;
    const callbacks = {};
    const vscode = {
        commands: { executeCommand: async () => undefined },
        workspace: { getConfiguration: () => ({ get: () => undefined }) },
        window: {
            createQuickPick: () => {
                quickPick = {
                    activeItems: [], items: [], value: '', busy: false,
                    onDidAccept: (callback) => { callbacks.accept = callback; },
                    onDidChangeValue: (callback) => { callbacks.change = callback; },
                    onDidHide: (callback) => { callbacks.hide = callback; },
                    show() {}, hide() { callbacks.hide(); }, dispose() {}
                };
                return quickPick;
            },
            showErrorMessage() {}, showInformationMessage() {},
            showInputBox: async (options) => { nameInput = options; return undefined; }
        },
        QuickPickItemKind: { Separator: -1 }
    };
    try {
        await fs.promises.mkdir(path.join(root, 'project'));
        await fs.promises.mkdir(path.join(root, 'project', 'child'));
        await fs.promises.mkdir(path.join(root, 'project', '.hidden'));
        await fs.promises.mkdir(path.join(root, 'project-other'));
        const commands = createProjectCommands(vscode);
        const pending = commands['equanz.project.add']();
        quickPick.value = `${path.join(root, 'project')}${path.sep}`;
        await callbacks.change(quickPick.value);
        assert.ok(quickPick.items.some((item) => item.path === path.join(root, 'project', 'child')));
        quickPick.value = path.join(root, 'project');
        await callbacks.change(quickPick.value);
        assert.ok(quickPick.items.some((item) => item.path === path.join(root, 'project')));
        assert.ok(quickPick.items.some((item) => item.path === path.join(root, 'project-other')));
        quickPick.activeItems = [quickPick.items.find((item) => item.path === path.join(root, 'project'))];
        await commands['equanz.project.enterDirectory']();
        assert.equal(quickPick.value, `${path.join(root, 'project')}${path.sep}`);
        assert.ok(quickPick.items.some((item) => item.path === path.join(root, 'project', 'child')));
        quickPick.value = `${path.join(root, 'project')}${path.sep}.`;
        await callbacks.change(quickPick.value);
        assert.deepEqual(quickPick.items.map((item) => item.label), ['.hidden/']);
        await commands['equanz.project.parentDirectory']();
        assert.equal(quickPick.value, `${root}${path.sep}`);
        assert.ok(quickPick.items.some((item) => item.path === path.join(root, 'project-other')));
        quickPick.activeItems = [quickPick.items.find((item) => item.path === path.join(root, 'project'))];
        quickPick.value = path.join(root, 'project-other');
        await callbacks.accept();
        await pending;
        assert.equal(nameInput.value, 'project');
    } finally {
        await fs.promises.rm(root, { recursive: true, force: true });
    }
});

test('C-x k closes clean tabs and uses y/n only for dirty tabs', async () => {
    const executed = [];
    const closed = [];
    const callbacks = {};
    const tab = { label: 'draft.txt', isDirty: false };
    const group = { activeTab: tab };
    const vscode = {
        commands: { executeCommand: async (id, value) => { executed.push([id, value]); } },
        window: {
            tabGroups: { activeTabGroup: group, close: async (target) => { closed.push(target); return true; } },
            createInputBox: () => ({
                value: '',
                onDidChangeValue: (callback) => { callbacks.change = callback; },
                onDidAccept: (callback) => { callbacks.accept = callback; },
                onDidHide: (callback) => { callbacks.hide = callback; },
                show() {}, hide() { callbacks.hide(); }, dispose() {}
            })
        }
    };
    const { commands } = createBufferCommands(vscode);
    await commands['equanz.buffer.kill']();
    assert.deepEqual(closed, [tab]);

    tab.isDirty = true;
    await commands['equanz.buffer.kill']();
    commands['equanz.buffer.cancelKill']();
    assert.equal(executed.filter(([id]) => id === 'workbench.action.revertAndCloseActiveEditor').length, 0);

    await commands['equanz.buffer.kill']();
    commands['equanz.buffer.confirmKill']();
    assert.equal(executed.filter(([id]) => id === 'workbench.action.revertAndCloseActiveEditor').length, 1);
    assert.deepEqual(closed, [tab]);
});

test('C-x b distinguishes and reopens Markdown source and full preview buffers', async () => {
    class Uri {
        constructor(value) { this.value = value; this.scheme = 'file'; this.fsPath = value; }
        toString() { return this.value; }
    }
    const uri = new Uri('/tmp/example.md');
    const commands = [];
    let items;
    const vscode = {
        Uri,
        ViewColumn: { Active: 1 },
        commands: { executeCommand: async (...args) => { commands.push(args); } },
        window: {
            tabGroups: {
                all: [{
                    tabs: [
                        { label: 'example.md', input: { uri } },
                        { label: 'example.md', input: { uri, viewType: 'vscode.markdown.preview.editor' } }
                    ]
                }]
            },
            showQuickPick: async (candidates) => {
                items = candidates;
                return candidates.find((candidate) => candidate.viewType === 'vscode.markdown.preview.editor');
            }
        }
    };
    const { commands: bufferCommands } = createBufferCommands(vscode);
    await bufferCommands['equanz.buffer.switch']();
    assert.deepEqual(items.map((item) => item.label), ['example.md', 'Preview example.md']);
    assert.deepEqual(commands, [[
        'vscode.openWith', uri, 'vscode.markdown.preview.editor',
        { viewColumn: 1, preserveFocus: false, preview: false }
    ]]);
});

test('buffer commands retain name-based switching and no longer implement tab cycling', async () => {
    class Uri {
        constructor(value) { this.value = value; this.scheme = 'file'; this.fsPath = value; }
        toString() { return this.value; }
    }
    const a = new Uri('/tmp/a.md');
    const b = new Uri('/tmp/b.md');
    const group = {
        tabs: [
            { label: 'a.md', input: { uri: a } },
            { label: 'a.md', input: { uri: a, viewType: 'vscode.markdown.preview.editor' } },
            { label: 'b.md', input: { uri: b } }
        ]
    };
    group.activeTab = group.tabs[0];
    const executed = [];
    const vscode = {
        Uri,
        ViewColumn: { Active: 1 },
        commands: {
            executeCommand: async (...args) => {
                executed.push(args);
                const viewType = args[0] === 'vscode.openWith' ? args[2] : undefined;
                group.activeTab = group.tabs.find((tab) => tab.input.uri === args[1] && tab.input.viewType === viewType);
            }
        },
        window: { tabGroups: { all: [group], activeTabGroup: group } }
    };
    const { commands } = createBufferCommands(vscode);
    assert.equal(commands['equanz.buffer.next'], undefined);
    assert.equal(commands['equanz.buffer.previous'], undefined);
    vscode.window.showQuickPick = async (items) => items.find((item) => item.viewType);
    await commands['equanz.buffer.switch']();
    assert.deepEqual(executed.map(([id, uri]) => [id, uri.fsPath]), [['vscode.openWith', '/tmp/a.md']]);
    assert.ok(executed.every((call) => call.at(-1).viewColumn === 1));
});

test('C-c v opens a side preview and restores source-editor focus', async () => {
    const executed = [];
    const vscode = {
        commands: { executeCommand: async (id) => { executed.push(id); } }
    };
    await createMarkdownCommands(vscode)['equanz.markdown.previewToSide']();
    assert.deepEqual(executed, [
        'markdown.showPreviewToSide',
        'workbench.action.focusPreviousGroup'
    ]);
});

test('project store writes an array atomically readable by Project Manager', async () => {
    const root = await fs.promises.mkdtemp(path.join(os.tmpdir(), 'equanz-project-store-'));
    const target = path.join(root, 'projects.json');
    try {
        const projects = [{ name: 'example', rootPath: '$home/example', tags: [], enabled: true }];
        await writeProjects(target, projects);
        assert.deepEqual(await readProjects(target), projects);
    } finally {
        await fs.promises.rm(root, { recursive: true, force: true });
    }
});

test('macOS root installer owns the VS Code bootstrap and its Node dependency', () => {
    const installer = fs.readFileSync(path.join(vscodeRoot, '..', 'install.sh'), 'utf8');
    assert.match(installer, /brew install git hub tmux zsh node/);
    assert.match(installer, /vscode\/bootstrap-macos\.sh/);
    assert.match(installer, /VS Code setup failed/);
    assert.match(installer, /VS Code is not installed; skipped VS Code setup/);
});

test('bootstrap has no database mutation or legacy cleanup path', () => {
    const bootstrap = fs.readFileSync(path.join(vscodeRoot, 'bootstrap-macos.sh'), 'utf8');
    assert.doesNotMatch(bootstrap, /state\.vscdb|sqlite3|uninstall-extension|custom-ui-style/);
    assert.match(bootstrap, /--check/);
    assert.match(bootstrap, /render-keymap\.js/);
});
