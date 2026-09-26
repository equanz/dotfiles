const path = require('node:path');
const { directoryInput } = require('./paths');

function pathQuery(value, directory) {
    const base = directoryInput(directory);
    if (value.startsWith(base)) return value.slice(base.length);
    return path.basename(value);
}

function fuzzyScore(query, name) {
    const needle = query.toLocaleLowerCase();
    const haystack = name.toLocaleLowerCase();
    if (!needle) return 0;
    if (haystack === needle) return 0;
    if (haystack.startsWith(needle)) return 1;
    const contiguous = haystack.indexOf(needle);
    if (contiguous !== -1) return 2 + contiguous;
    let previous = -1;
    let gaps = 0;
    for (const character of needle) {
        const next = haystack.indexOf(character, previous + 1);
        if (next === -1) return Infinity;
        if (previous !== -1) gaps += next - previous - 1;
        previous = next;
    }
    return 100 + gaps;
}

function pathPickerItems(items, value, directory) {
    const query = pathQuery(value, directory);
    return items.map((item) => ({
        ...item,
        label: item.path
            ? `${path.basename(item.path)}${item.action === 'directory' ? path.sep : ''}`
            : item.label,
        alwaysShow: true,
        score: item.path ? fuzzyScore(query, path.basename(item.path)) : Infinity
    })).filter((item) => item.score !== Infinity || item.action === 'error')
        .sort((left, right) => left.score - right.score ||
            path.basename(left.path ?? left.label).localeCompare(path.basename(right.path ?? right.label)))
        .map(({ score, ...item }) => item);
}

module.exports = { fuzzyScore, pathPickerItems, pathQuery };
