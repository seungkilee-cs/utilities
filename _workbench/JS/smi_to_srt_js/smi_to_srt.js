#!/usr/bin/env node

// Required modules
import fs from 'fs';
import path from 'path';
import subsrt from 'subsrt';
import chardet from 'chardet';
import yargs from 'yargs';
import iconv from 'iconv-lite';
import { hideBin } from 'yargs/helpers';

// Destructuring for easier use
const { readdir, readFileSync, writeFileSync } = fs;
const { extname, join, basename } = path;
const { convert } = subsrt;
const { detect } = chardet;

// Setting up command line arguments
const argv = yargs(hideBin(process.argv))
  .option('d', {
    alias: 'directory',
    description: 'Directory containing .smi files',
    type: 'string',
  })
  .help('h')
  .alias('h', 'help')
  .argv;

// Check if directory is passed
if (argv.d) {
    const directoryPath = argv.d;
    console.log(`Converting .smi files in directory ${directoryPath}`);

    // Reading directory
    readdir(directoryPath, function (err, files) {
        if (err) {
            return console.log('Unable to scan directory: ' + err);
        } 

        // Loop through all the files in the directory
        files.forEach(function (file) {
            // Check if file extension is .smi
            if (extname(file) === '.smi') {
                console.log(`Processing file ${file}`);
                const filePath = join(directoryPath, file);
                // Read file as a buffer
                const fileBuffer = readFileSync(filePath);
                // Detect encoding of the file
                const encoding = detect(fileBuffer);
                console.log(`Detected encoding ${encoding}`);
                
                // Decode the file content with detected encoding
                const smiContent = iconv.decode(fileBuffer, encoding);
                // Convert smi content to srt format
                const srtContent = convert(smiContent, { from: 'smi', to: 'srt' });
                
                // Prepare output file path
                const srtFilePath = join(directoryPath, basename(file, '.smi') + '.srt');
                // Write the converted content to output file with UTF-8 encoding
                writeFileSync(srtFilePath, srtContent, 'UTF-8');
                console.log(`Converted file saved as ${srtFilePath}`);
            }
        });
    });
} else {
    console.log('Please provide a directory path with the -d flag.');
}
