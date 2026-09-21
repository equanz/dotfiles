#!/usr/bin/env node

const fs = require('node:fs');
const path = require('node:path');

const vscodeDirectory = path.resolve(__dirname, '..');
const sourcePath = path.join(vscodeDirectory, 'keymap.json');
const keybindingsPath = path.join(vscodeDirectory, 'keybindings.json');
const resourcePath = path.join(vscodeDirectory, 'project-tools', 'resources', 'keymap.json');
const manifestPath = path.join(vscodeDirectory, 'project-tools', 'package.json');
const check = process.argv.includes('--check');

function json(value) {
    return `${JSON.stringify(value, null, 4)}\n`;
}

function fail(message) {
    throw new Error(`Invalid keymap.json: ${message}`);
}

function commandForBinding(bindings, bindingKey) {
    const binding = bindings.find((candidate) =>
        candidate.key === bindingKey &&
        typeof candidate.command === 'string' &&
        !candidate.command.startsWith('-')
    );
    if (!binding) fail(`help entry references missing executable binding: ${bindingKey}`);
    return binding;
}

function validateLocalCommands(bindings, localCommands) {
    for (const binding of bindings) {
        if (typeof binding.command === 'string' &&
            !binding.command.startsWith('-') &&
            binding.command.startsWith('equanz.') &&
            !localCommands.has(binding.command)) {
            fail(`keybinding references command missing from project-tools/package.json: ${binding.command}`);
        }
    }
}

function renderHelp(entries, bindings, prefix = '') {
    if (!Array.isArray(entries)) fail('help must be an array');
    return entries.map((entry) => {
        if (typeof entry?.key !== 'string' || typeof entry?.name !== 'string') {
            fail('every help entry needs key and name');
        }
        if (Array.isArray(entry.bindings)) {
            return {
                key: entry.key,
                name: entry.name,
                type: 'bindings',
                bindings: renderHelp(entry.bindings, bindings, `${prefix}${entry.key} `)
            };
        }
        if (typeof entry.binding !== 'string') fail(`help entry ${prefix}${entry.key} needs binding`);
        const binding = commandForBinding(bindings, entry.binding);
        return {
            key: entry.key,
            name: entry.name,
            type: 'command',
            command: binding.command,
            ...(binding.args === undefined ? {} : { args: binding.args })
        };
    });
}

function writeOrCheck(target, content) {
    const current = fs.existsSync(target) ? fs.readFileSync(target, 'utf8') : undefined;
    if (current === content) return;
    if (check) {
        throw new Error(`Generated file is stale: ${path.relative(vscodeDirectory, target)}`);
    }
    fs.mkdirSync(path.dirname(target), { recursive: true });
    fs.writeFileSync(target, content, 'utf8');
}

const source = JSON.parse(fs.readFileSync(sourcePath, 'utf8'));
if (!Array.isArray(source.keybindings)) fail('keybindings must be an array');
const manifest = JSON.parse(fs.readFileSync(manifestPath, 'utf8'));
const localCommands = new Set((manifest.contributes?.commands || []).map((entry) => entry.command));
validateLocalCommands(source.keybindings, localCommands);
const help = renderHelp(source.help, source.keybindings);
writeOrCheck(keybindingsPath, json(source.keybindings));
writeOrCheck(resourcePath, json({ bindings: help }));
