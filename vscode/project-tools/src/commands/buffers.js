function createBufferCommands(vscode) {
    const recentBuffers = [];
    let killPrompt;
    function recordBuffer(editor) {
        const uri = editor?.document?.uri;
        if (!uri) return;
        const key = uri.toString();
        const index = recentBuffers.indexOf(key);
        if (index !== -1) recentBuffers.splice(index, 1);
        recentBuffers.unshift(key);
    }
    function openBufferItems() {
        const items = new Map();
        for (const group of vscode.window.tabGroups.all) {
            for (const tab of group.tabs) {
                const input = tab.input;
                const uri = input?.uri;
                if (!(uri instanceof vscode.Uri)) continue;
                const viewType = input.viewType === 'vscode.markdown.preview.editor' ? input.viewType : undefined;
                const key = `${uri.toString()}\u0000${viewType || 'text'}`;
                if (items.has(key)) continue;
                items.set(key, {
                    key,
                    label: viewType ? `Preview ${tab.label}` : tab.label,
                    description: uri.scheme === 'file' ? uri.fsPath : uri.toString(),
                    uri,
                    viewType,
                    order: recentBuffers.indexOf(uri.toString())
                });
            }
        }
        return [...items.values()].sort((left, right) =>
            (left.order < 0 ? Infinity : left.order) - (right.order < 0 ? Infinity : right.order) ||
            left.uri.toString().localeCompare(right.uri.toString()) ||
            Number(Boolean(left.viewType)) - Number(Boolean(right.viewType))
        );
    }
    async function openBuffer(selected) {
        const options = { viewColumn: vscode.ViewColumn.Active, preserveFocus: false, preview: false };
        if (selected.viewType) {
            await vscode.commands.executeCommand('vscode.openWith', selected.uri, selected.viewType, options);
        } else {
            await vscode.commands.executeCommand('vscode.open', selected.uri, options);
        }
    }
    async function switchBuffer() {
        const selected = await vscode.window.showQuickPick(openBufferItems(), { matchOnDescription: true, matchOnDetail: true, placeHolder: 'Switch buffer in this editor group (C-j confirm, C-g cancel)' });
        if (!selected) return;
        await openBuffer(selected);
    }
    async function killBuffer() {
        const group = vscode.window.tabGroups.activeTabGroup;
        const tab = group?.activeTab;
        if (!tab) return;
        if (!tab.isDirty) {
            await vscode.window.tabGroups.close(tab);
            return;
        }
        if (killPrompt) return;
        const inputBox = vscode.window.createInputBox();
        const prompt = { inputBox, group, tab, confirmed: false };
        killPrompt = prompt;
        void vscode.commands.executeCommand('setContext', 'equanz.bufferKillConfirm', true);
        inputBox.title = 'Kill Modified Buffer?';
        inputBox.prompt = `Discard unsaved changes in "${tab.label}" and close it? (y/n)`;
        inputBox.placeholder = 'y/n';
        inputBox.ignoreFocusOut = true;
        inputBox.onDidChangeValue((value) => {
            const answer = value.trim().toLowerCase();
            inputBox.validationMessage = answer && answer !== 'y' && answer !== 'n' ? 'Enter y or n.' : undefined;
        });
        inputBox.onDidAccept(() => {
            const answer = inputBox.value.trim().toLowerCase();
            if (answer === 'y') confirmKill();
            else if (answer === 'n') cancelKill();
            else inputBox.validationMessage = 'Enter y or n.';
        });
        inputBox.onDidHide(() => {
            inputBox.dispose();
            if (killPrompt === prompt) killPrompt = undefined;
            void vscode.commands.executeCommand('setContext', 'equanz.bufferKillConfirm', false);
            if (prompt.confirmed && vscode.window.tabGroups.activeTabGroup === group && group.activeTab === tab) {
                void vscode.commands.executeCommand('workbench.action.revertAndCloseActiveEditor');
            }
        });
        inputBox.show();
    }
    function confirmKill() {
        if (!killPrompt) return;
        killPrompt.confirmed = true;
        killPrompt.inputBox.hide();
    }
    function cancelKill() { killPrompt?.inputBox.hide(); }
    return {
        commands: {
            'equanz.buffer.switch': switchBuffer,
            'equanz.buffer.kill': killBuffer,
            'equanz.buffer.confirmKill': confirmKill,
            'equanz.buffer.cancelKill': cancelKill
        },
        recordBuffer
    };
}

module.exports = { createBufferCommands };
