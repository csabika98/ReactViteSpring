import express from 'express';
import { createProxyMiddleware } from 'http-proxy-middleware';
import { spawn } from 'child_process';
import path from 'path';
import process from 'process';
import { fileURLToPath } from 'url';
import fs from 'fs';

const app = express();


const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);


function findProjectRoot(currentDir, targetFolderName) {
    const root = path.parse(currentDir).root;
    while (currentDir !== root) {
        let possiblePath = path.join(currentDir, targetFolderName);
        if (fs.existsSync(possiblePath)) {
            return currentDir; 
        }
        currentDir = path.dirname(currentDir);
    }
    return null; 
}

const projectRoot = findProjectRoot(__dirname, 'ReactViteSpring');
const javaProjectPath = path.join(projectRoot, 'ReactViteSpring');
console.log(`Building Java project at path: ${javaProjectPath}`);

let javaProcess;

const userHome = process.env.USERPROFILE;
const mvnCommand = path.join(userHome, 'scoop', 'apps', 'maven', 'current', 'bin', 'mvn.cmd');

const runJavaApp = () => {
    if (javaProcess) {
        console.log('Stopping existing Java application...');
        javaProcess.kill(); 
        javaProcess = null;
    }
    console.log('Starting Java application...');

    
    const mvnPath = path.join(userHome, 'scoop', 'apps', 'maven', 'current', 'bin', 'mvn.cmd');
    console.log('Using Maven at:', mvnPath);
    console.log('Executing command:', mvnPath, ['spring-boot:run', '-f', path.join(javaProjectPath, 'pom.xml')]);

    javaProcess = spawn(mvnPath, ['spring-boot:run', '-f', path.join(javaProjectPath, 'pom.xml')], {
        stdio: 'inherit',
        shell: true 
    });

    javaProcess.on('error', (err) => {
        console.error('Failed to start Java application:', err);
    });

    javaProcess.on('close', (code) => {
        console.log(`Java process exited with code ${code}`);
    });
};


const buildAndStartJava = () => {
    console.log(`Building Java project at path: ${javaProjectPath}`);
    const mvnBuild = spawn(mvnCommand, ['clean', 'install', '-f', path.join(javaProjectPath, 'pom.xml')], {
        stdio: 'inherit', 
        shell: true 
    });

    mvnBuild.on('close', (code) => {
        if (code === 0) {
            console.log('Maven build completed successfully, starting Java application...');
            runJavaApp();
        } else {
            console.error(`Maven build failed with exit code ${code}`);
        }
    });
};


buildAndStartJava();


app.use((req, res, next) => {
    console.log(`Request received: ${req.method} ${req.url}`);
    next();
});


app.use('/api/', createProxyMiddleware({
    target: 'http://localhost:8080/', 
    changeOrigin: true,
    ws: true
}));


app.use('/', createProxyMiddleware({
    target: 'http://localhost:5173/', 
    changeOrigin: true,
    ws: false 
}));

const PORT = 8888;
app.listen(PORT, () => {
    console.log(`Proxy server running on http://localhost:${PORT}`);
});

process.on('exit', () => {
    if (javaProcess) {
        console.log('Stopping Java application due to script exit...');
        javaProcess.kill();
    }
});



