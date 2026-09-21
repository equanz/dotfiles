const { setContext } = require('../lib/quick-input');

function createFrameCommands(vscode) {
    let activeMenu;
    function reopenableWorkspaceUri() {
        const workspaceFile = vscode.workspace.workspaceFile;
        if (workspaceFile?.scheme === 'file') return workspaceFile;
        const folders = vscode.workspace.workspaceFolders;
        if (folders?.length === 1 && folders[0].uri.scheme === 'file') return folders[0].uri;
        return undefined;
    }
    async function openFrame() {
        const workspaceUri = reopenableWorkspaceUri();
        if (!workspaceUri) {
            vscode.window.showErrorMessage('C-x 5 2 requires one folder or a saved .code-workspace. Save an untitled multi-root workspace first.');
            return;
        }
        await vscode.commands.executeCommand('vscode.openFolder', workspaceUri, { forceNewWindow: true });
    }
    async function runAction(action) {
        activeMenu?.hide();
        if (action === 'new') await openFrame();
        if (action === 'close') await vscode.commands.executeCommand('workbench.action.closeWindow');
    }
    function showMenu() {
        if (activeMenu) return;
        const picker = vscode.window.createQuickPick(); activeMenu = picker;
        setContext(vscode, 'equanz.frameMenu', true);
        picker.title = 'Frame'; picker.placeholder = '2: open this folder/workspace in a new window  0: close this window  C-g: cancel';
        picker.items = [
            { label: '2  New frame', detail: 'Open the current folder or saved workspace in a new window', action: 'new' },
            { label: '0  Delete frame', detail: 'Close this window', action: 'close' }
        ];
        picker.onDidAccept(() => void runAction(picker.activeItems[0]?.action));
        picker.onDidHide(() => { picker.dispose(); if (activeMenu === picker) activeMenu = undefined; setContext(vscode, 'equanz.frameMenu', false); });
        picker.show();
    }
    return { 'equanz.frame.close': () => runAction('close'), 'equanz.frame.menu': showMenu, 'equanz.frame.new': openFrame };
}

module.exports = { createFrameCommands };
