function createMarkdownCommands(vscode) {
    async function previewToSide() {
        await vscode.commands.executeCommand('markdown.showPreviewToSide');
        await vscode.commands.executeCommand('workbench.action.focusPreviousGroup');
    }

    return {
        'equanz.markdown.previewToSide': previewToSide
    };
}

module.exports = { createMarkdownCommands };
