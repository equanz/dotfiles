const fs = require('node:fs');
const os = require('node:os');
const path = require('node:path');
const { enableFuzzyMatching } = require('../lib/quick-input');

async function noteItems(directory, root) {
    const entries = await fs.promises.readdir(directory, { withFileTypes: true });
    const items = [];
    for (const entry of entries) {
        if (entry.isSymbolicLink()) continue;
        const candidate = path.join(directory, entry.name);
        if (entry.isDirectory()) items.push(...await noteItems(candidate, root));
        if (entry.isFile() && path.extname(entry.name).toLowerCase() === '.md') {
            items.push({ label: path.basename(entry.name, '.md'), description: path.relative(root, candidate), path: candidate });
        }
    }
    return items;
}

function newNotePath(value, root) {
    const input = value.trim();
    if (!input || path.isAbsolute(input)) return undefined;
    const extension = path.extname(input);
    if (extension && extension.toLowerCase() !== '.md') return undefined;
    const candidate = path.resolve(root, extension ? input : `${input}.md`);
    const relative = path.relative(root, candidate);
    return relative && relative !== '..' && !relative.startsWith(`..${path.sep}`) ? candidate : undefined;
}

function createNoteCommands(vscode) {
    const notesRoot = path.join(os.homedir(), 'Documents', 'notes');
    async function openNote() {
        try {
            await fs.promises.mkdir(notesRoot, { recursive: true });
            const metadata = await fs.promises.lstat(notesRoot);
            if (!metadata.isDirectory() || metadata.isSymbolicLink()) throw new Error('Notes root must be a directory.');
            const root = await fs.promises.realpath(notesRoot);
            const picker = vscode.window.createQuickPick();
            picker.title = 'Notes'; picker.placeholder = 'Choose a note or type a new name (C-j confirm, C-g cancel)';
            enableFuzzyMatching(picker);
            picker.items = (await noteItems(root, root)).sort((a, b) => a.description.localeCompare(b.description));
            const selected = await new Promise((resolve) => {
                let done = false;
                const finish = (value) => { if (!done) { done = true; resolve(value); } };
                picker.onDidAccept(() => { finish(picker.activeItems[0]?.path || { value: picker.value }); picker.hide(); });
                picker.onDidHide(() => { picker.dispose(); finish(undefined); }); picker.show();
            });
            if (!selected) return;
            const target = typeof selected === 'string' ? selected : newNotePath(selected.value, root);
            if (!target) throw new Error('Use a relative Markdown name inside ~/Documents/notes.');
            if (typeof selected !== 'string') {
                await fs.promises.mkdir(path.dirname(target), { recursive: true });
                const parent = await fs.promises.realpath(path.dirname(target));
                if (parent !== root && !parent.startsWith(`${root}${path.sep}`)) throw new Error('Note path escapes the notes root.');
                try {
                    const targetMetadata = await fs.promises.lstat(target);
                    if (!targetMetadata.isFile() || targetMetadata.isSymbolicLink()) throw new Error('Note must be a regular file inside the notes root.');
                } catch (error) {
                    if (error.code !== 'ENOENT') throw error;
                    await fs.promises.writeFile(target, '', { flag: 'wx' });
                }
            }
            await vscode.commands.executeCommand('vscode.open', vscode.Uri.file(target), { viewColumn: vscode.ViewColumn.Active, preserveFocus: false, preview: false });
        } catch (error) { vscode.window.showErrorMessage(`Could not open note: ${error.message}`); }
    }
    return { 'equanz.notes.open': openNote };
}

module.exports = { createNoteCommands, newNotePath, noteItems };
