const vscode = require('vscode');
const { activateWith } = require('./activate');

async function activate(context) {
    await activateWith(vscode, context);
}

function deactivate() {}

module.exports = { activate, deactivate };
