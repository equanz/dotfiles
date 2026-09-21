const fs = require('node:fs');
const path = require('node:path');
const { pathFromInput } = require('./paths');

async function reconcileDirectoryInput({ value, currentDirectory, quickPick, setCurrentDirectory, update }) {
    const inputPath = pathFromInput(value, currentDirectory);
    if (!value.endsWith(path.sep)) {
        // Removing a committed trailing slash returns the candidate base to its parent.
        if (inputPath === currentDirectory) {
            const parent = path.dirname(currentDirectory);
            if (parent !== currentDirectory) {
                setCurrentDirectory(parent);
                await update();
                return true;
            }
        }
        return false;
    }
    if (!inputPath || inputPath === currentDirectory) return false;
    try {
        if (!(await fs.promises.stat(inputPath)).isDirectory()) return false;
        if (!quickPick.value.startsWith(value)) return false;
        setCurrentDirectory(inputPath);
        await update();
        return true;
    } catch {
        // Keep filtering until an existing directory is explicitly committed with '/'.
        return false;
    }
}

module.exports = { reconcileDirectoryInput };
