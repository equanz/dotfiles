const keymap = require('../../resources/keymap.json');

function flattenKeymap(bindings, prefix = '') {
    if (!Array.isArray(bindings)) return [];
    return bindings.flatMap((binding) => {
        const key = `${prefix}${binding.key}`;
        if (binding.type === 'bindings') return flattenKeymap(binding.bindings, `${key} `);
        if (!binding.command) return [];
        return [{ label: `${key}  ${binding.name}`, description: binding.command, command: binding.command, args: binding.args }];
    });
}

function createKeymapCommands(vscode) {
    async function showKeymap() {
        const items = flattenKeymap(keymap.bindings);
        const selected = await vscode.window.showQuickPick(items, { placeHolder: 'Keymap (C-j confirm, C-g cancel)' });
        if (selected) await vscode.commands.executeCommand(selected.command, selected.args);
    }
    return { 'equanz.keymap.show': showKeymap };
}

module.exports = { createKeymapCommands, flattenKeymap };
