const { setContext } = require('../lib/quick-input');

function createExplorerCommands(vscode) {
    let activePrompt;
    function promptMoveToTrash() {
        if (activePrompt) return;
        const inputBox = vscode.window.createInputBox();
        const prompt = { inputBox, confirmed: false }; activePrompt = prompt;
        setContext(vscode, 'equanz.trashConfirm', true);
        inputBox.title = 'Move to Trash?'; inputBox.prompt = 'Type y to move the selected item to Trash, or n to cancel.';
        inputBox.placeholder = 'y/n'; inputBox.ignoreFocusOut = true;
        inputBox.onDidChangeValue((value) => { const answer = value.trim().toLowerCase(); inputBox.validationMessage = answer && answer !== 'y' && answer !== 'n' ? 'Enter y or n.' : undefined; });
        inputBox.onDidAccept(() => { const answer = inputBox.value.trim().toLowerCase(); if (answer === 'y') confirm(); else if (answer === 'n') inputBox.hide(); else inputBox.validationMessage = 'Enter y or n.'; });
        inputBox.onDidHide(() => { inputBox.dispose(); if (activePrompt === prompt) activePrompt = undefined; setContext(vscode, 'equanz.trashConfirm', false); if (prompt.confirmed) setTimeout(() => void vscode.commands.executeCommand('moveFileToTrash'), 0); });
        inputBox.show();
    }
    function confirm() { if (activePrompt) { activePrompt.confirmed = true; activePrompt.inputBox.hide(); } }
    return { 'equanz.explorer.cancelTrash': () => activePrompt?.inputBox.hide(), 'equanz.explorer.confirmTrash': confirm, 'equanz.explorer.moveToTrash': promptMoveToTrash };
}

module.exports = { createExplorerCommands };
