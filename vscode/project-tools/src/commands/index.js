const { createBufferCommands } = require('./buffers');
const { createExplorerCommands } = require('./explorer');
const { createFileCommands } = require('./files');
const { createFrameCommands } = require('./frames');
const { createKeymapCommands } = require('./keymap');
const { createMarkdownCommands } = require('./markdown');
const { createNoteCommands } = require('./notes');
const { createProjectCommands } = require('./projects');

function createCommands(vscode) {
    const buffers = createBufferCommands(vscode);
    return {
        commands: {
            ...createProjectCommands(vscode),
            ...createFileCommands(vscode),
            ...buffers.commands,
            ...createNoteCommands(vscode),
            ...createFrameCommands(vscode),
            ...createKeymapCommands(vscode),
            ...createMarkdownCommands(vscode),
            ...createExplorerCommands(vscode)
        },
        recordBuffer: buffers.recordBuffer
    };
}

module.exports = { createCommands };
