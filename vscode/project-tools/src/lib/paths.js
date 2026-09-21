const os = require('node:os');
const path = require('node:path');

function expandHome(value) {
    const home = os.homedir();
    if (typeof value !== 'string') return '';
    if (value === '$home' || value === '~') return home;
    if (value.startsWith('$home/')) return path.join(home, value.slice('$home/'.length));
    if (value.startsWith('~/')) return path.join(home, value.slice(2));
    return value;
}

function projectRootValue(directory) {
    const home = path.resolve(os.homedir());
    const resolved = path.resolve(directory);
    if (resolved === home) return '$home';
    if (resolved.startsWith(`${home}${path.sep}`)) {
        return `$home/${path.relative(home, resolved).split(path.sep).join('/')}`;
    }
    return resolved;
}

function expandedProjectRoot(rootPath) {
    return path.resolve(expandHome(rootPath));
}

function pathFromInput(value, currentDirectory) {
    const expanded = expandHome(value.trim());
    if (!expanded) return undefined;
    return path.resolve(path.isAbsolute(expanded) ? expanded : path.join(currentDirectory, expanded));
}

function isExplicitPathInput(value) {
    const input = value.trim();
    return input.startsWith('/') || input.startsWith('~') || input.startsWith('./') || input.startsWith('../') || input.includes('/');
}

function directoryInput(directory) {
    const resolved = path.resolve(directory);
    return resolved === path.parse(resolved).root ? resolved : `${resolved}${path.sep}`;
}

module.exports = {
    directoryInput,
    expandHome,
    expandedProjectRoot,
    isExplicitPathInput,
    pathFromInput,
    projectRootValue
};
