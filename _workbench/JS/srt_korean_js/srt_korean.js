#!/usr/bin/env node

import fs from 'fs-extra';
import chardet from 'chardet';
import iconv from 'iconv-lite';
import path from 'path';
import yargs from 'yargs';
import { hideBin } from 'yargs/helpers';

async function convertToKorean(inputFile, outputFile) {
    // Detect the file encoding
    const fileContent = await fs.readFile(inputFile);
    const fileEncoding = chardet.detect(fileContent);

    // Read the file with detected encoding
    const contentBuffer = await fs.readFile(inputFile);
    const content = iconv.decode(contentBuffer, fileEncoding);

    // Convert the content to EUC-KR encoding
    const convertedContent = iconv.encode(content, 'EUC-KR');

    // Write the content in EUC-KR encoding to a new file
    await fs.writeFile(outputFile, convertedContent);
}

async function main(directory) {
    // Get the list of files in the directory
    const files = await fs.readdir(directory);

    // Process each file in the directory
    for (const file of files) {
        if (file.endsWith('.srt') || file.endsWith('.smi')) {
            const inputFile = path.join(directory, file);
            const outputFile = path.join(directory, 'converted_' + file);
            await convertToKorean(inputFile, outputFile);
        }
    }
}

const argv = yargs(hideBin(process.argv))
    .option('d', {
        alias: 'directory',
        type: 'string',
        description: 'Directory containing sub files',
        demandOption: true
    })
    .argv;

main(argv.d).catch(console.error);
