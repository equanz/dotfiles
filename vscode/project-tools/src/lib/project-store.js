const fs = require('node:fs');
const os = require('node:os');
const path = require('node:path');
const { expandHome } = require('./paths');

function projectFilePath(vscode) {
    const configured = vscode.workspace.getConfiguration('projectManager').get('projectsLocation');
    const location = expandHome(configured || '');
    if (location) return path.join(location, 'projects.json');
    return path.join(os.homedir(), 'Library', 'Application Support', 'Code', 'User', 'projects.json');
}

async function readProjects(filePath) {
    try {
        const projects = JSON.parse(await fs.promises.readFile(filePath, 'utf8'));
        if (!Array.isArray(projects)) throw new Error('projects.json must contain an array');
        return projects;
    } catch (error) {
        if (error.code === 'ENOENT') return [];
        throw error;
    }
}

async function writeProjects(filePath, projects) {
    await fs.promises.mkdir(path.dirname(filePath), { recursive: true });
    const temporaryPath = `${filePath}.${process.pid}.tmp`;
    await fs.promises.writeFile(temporaryPath, `${JSON.stringify(projects, null, 4)}\n`, 'utf8');
    await fs.promises.rename(temporaryPath, filePath);
}

module.exports = { projectFilePath, readProjects, writeProjects };
