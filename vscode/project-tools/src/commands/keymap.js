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
    async function showBindings(bindings, placeHolder) {
        const selected = await vscode.window.showQuickPick(flattenKeymap(bindings), { placeHolder });
        if (selected) await vscode.commands.executeCommand(selected.command, selected.args);
    }
    return {
        'equanz.keymap.show': () => showBindings(keymap.bindings, 'Keymap (C-j confirm, C-g cancel)'),
        'equanz.keymap.showExplorer': () => showBindings(
            keymap.bindings.find((entry) => entry.key === 'x').bindings,
            'Explorer keymap (C-j confirm, C-g cancel)'
        )
    };
}

module.exports = { createKeymapCommands, flattenKeymap };
