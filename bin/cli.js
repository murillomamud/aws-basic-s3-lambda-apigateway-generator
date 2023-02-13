#!/usr/bin/env node
import * as commander from 'commander';
import fs from 'fs-extra';
import path from 'path';
import inquirer from 'inquirer';

const program = commander.program
  .version('0.0.1')
  .description('A Node.js CLI application that generates a Node.js application template')
  .command('start')
  .alias('s')
  .description('Generates a Node.js application template')
  .action(async () => {
    const answers = await inquirer.prompt([
      {
        type: 'input',
        name: 'project_name',
        message: 'Enter the name of the project:',
        default: 'my-node-app'
      },
      {
        type: 'input',
        name: 'description',
        message: 'Enter a description of the project:',
        default: 'A Node.js application'
      },
      {
        type: 'input',
        name: 'lambda_name',
        message: 'Enter a Lambda Name:',
        default: 'Lambda Name'
      },
      {
        type: 'list',
        name: 'lambda_language',
        message: 'Select a Lambda Language:',
        choices: ['node', 'python']
      },
      {
        type: 'input',
        name: 'backend_bucket',
        message: 'Enter your S3 Backend Bucket Name:',
        default: 'MY-AWS-BUCKET'
      },        
    ]);

    
    const projectDirectoryUp = path.join(process.cwd(), '..');
    const projectDirectory = path.join(projectDirectoryUp, answers.project_name);
    await fs.ensureDir(projectDirectory);

    const packageJson = {
      name: answers.project_name,
      version: '1.0.0',
      description: answers.description,
      scripts: {
        start: 'node index.js'
      },
      dependencies: {}
    };
    await fs.writeFile(
      path.join(projectDirectory, 'package.json'),
      JSON.stringify(packageJson, null, 2)
    );

    let filename = '';
    let extension = '';

    if (answers.lambda_language === 'node') {
      extension = 'js';
      filename = 'index.js';
    } else if (answers.lambda_language === 'python') {
      extension = 'py';
      filename = 'lambda_function.py';
    }

    const indexTemplateFilePath = path.join(process.cwd(), 'templates', `index-template.${extension}`);
    const indexJsFile = (await fs.readFile(indexTemplateFilePath, 'utf-8'))
      .replace(/{project_name}/g, answers.project_name)
      .replace(/{description}/g, answers.description);

    const lambdaDirectory = path.join(projectDirectory, 'src/lambdas/', answers.lambda_language, answers.lambda_name);
    await fs.ensureDir(lambdaDirectory);

    const lambdaFile = (await fs.readFile(indexTemplateFilePath, 'utf-8'))
        .replace(/{project_name}/g, answers.project_name)
        .replace(/{description}/g, answers.description);

    await fs.writeFile(path.join(lambdaDirectory, filename), lambdaFile);


    const terraformDirectory = path.join(projectDirectory, 'terraform');
    await fs.ensureDir(terraformDirectory);

    
    const terraformTemplateDirectory = path.join(process.cwd(), 'templates', 'terraform');
    const terraformTemplateFiles = await fs.readdir(terraformTemplateDirectory);

    for (const terraformTemplateFile of terraformTemplateFiles) {

        if (answers.lambda_language === 'node') {
            if (terraformTemplateFile.includes('python')) {
                continue;
            }
        }else{
            if (terraformTemplateFile.includes('node')) {
                continue;
            }
        }

        const terraformTemplateFileContents = await fs.readFile(path.join(terraformTemplateDirectory, terraformTemplateFile), 'utf-8');
        const terraformFileContents = terraformTemplateFileContents
            .replace(/{project_name}/g, answers.project_name)
            .replace(/{backend_bucket}/g, answers.backend_bucket)
            .replace(/{lambda_name}/g, answers.lambda_name)
            .replace(/{lambda_language}/g, answers.lambda_language)
            .replace(/{description}/g, answers.description);
    
        await fs.writeFile(path.join(terraformDirectory, terraformTemplateFile), terraformFileContents);
    }
    
    
    const githubDirectory = path.join(projectDirectory, '.github/workflows');
    await fs.ensureDir(githubDirectory);

    const githubTemplateDirectory = path.join(process.cwd(), 'templates', '.github/workflows');
    const githubTemplateFiles = await fs.readdir(githubTemplateDirectory);

    let githubTemplateFilesFiltered = '';
    if (extension === 'py') {
        githubTemplateFilesFiltered = githubTemplateFiles.filter(file => file.includes('python'));
    }else{
        githubTemplateFilesFiltered = githubTemplateFiles.filter(file => file.includes('node'));
    }
    
    const pipelineFile = (await fs.readFile(path.join(githubTemplateDirectory, githubTemplateFilesFiltered[0]), 'utf-8'))
        .replace(/{project_name}/g, answers.project_name)
        .replace(/{lambda_name}/g, answers.lambda_name)
        .replace(/{lambda_language}/g, answers.lambda_language)
        .replace(/{backend_bucket}/g, answers.backend_bucket);

    await fs.writeFile(path.join(githubDirectory, githubTemplateFilesFiltered[0]), pipelineFile);

});

program.parse(process.argv);