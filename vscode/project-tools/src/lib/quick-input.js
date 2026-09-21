function enableFuzzyMatching(picker) {
    picker.matchOnDescription = true;
    picker.matchOnDetail = true;
}

function setContext(vscode, name, value) {
    void vscode.commands.executeCommand('setContext', name, value);
}

module.exports = { enableFuzzyMatching, setContext };
