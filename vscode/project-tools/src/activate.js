const { createCommands } = require('./commands');

async function activateWith(vscode, context) {
    const { commands, recordBuffer } = createCommands(vscode);
    for (const [id, handler] of Object.entries(commands)) {
        context.subscriptions.push(vscode.commands.registerCommand(id, handler));
    }
    context.subscriptions.push(vscode.window.onDidChangeActiveTextEditor(recordBuffer));
    recordBuffer(vscode.window.activeTextEditor);
    try {
        await vscode.commands.executeCommand('workbench.action.closeAuxiliaryBar');
    } catch {
        // The command is unavailable only on VS Code versions without the secondary side bar.
    }
}

module.exports = { activateWith };
