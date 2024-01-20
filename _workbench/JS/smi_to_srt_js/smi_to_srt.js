import fs from 'fs';
import path from 'path';
import subsrt from 'subsrt';
import chardet from 'chardet';
import yargs from 'yargs';
import { hideBin } from 'yargs/helpers';

const { readdir, readFileSync, writeFileSync } = fs;
const { extname, join, basename } = path;
const { convert } = subsrt;
const { detect } = chardet;

const argv = yargs(hideBin(process.argv))
  .option('d', {
    alias: 'directory',
    description: 'Directory containing .smi files',
    type: 'string',
  })
  .help('h')
  .alias('h', 'help')
  .argv;

if (argv.d) {
    const directoryPath = argv.d;
    console.log(`Converting .smi files in directory ${directoryPath}`);

    readdir(directoryPath, function (err, files) {
        if (err) {
            return console.log('Unable to scan directory: ' + err);
        } 

        files.forEach(function (file) {
            if (extname(file) === '.smi') {
                console.log(`Processing file ${file}`);
                const filePath = join(directoryPath, file);
                const fileContent = readFileSync(filePath);
                const encoding = detect(fileContent);
                console.log(`Detected encoding ${encoding}`);
                
                const smiContent = readFileSync(filePath, encoding);
                const srtContent = convert(smiContent, { from: 'smi', to: 'srt' });
                
                const srtFilePath = join(directoryPath, basename(file, '.smi') + '.srt');
                writeFileSync(srtFilePath, srtContent, encoding);
                console.log(`Converted file saved as ${srtFilePath}`);
            }
        });
    });
} else {
    console.log('Please provide a directory path with the -d flag.');
}
