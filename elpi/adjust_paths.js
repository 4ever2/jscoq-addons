/**
 * This scripts adjusts the paths of `.elpi` files referenced
 * from other `.elpi` files in the implementation of coq-elpi.
 * Because when it is built with Dune, the current working directory
 * is the workspace root, not `workdir`.
 */
var fs = require('fs'),
    child_process = require('child_process');

function findCoqFiles() {
    var c = child_process.spawnSync('find',
        ['workdir', '-name', '*.elpi'], {encoding: 'utf-8'});
    return c.output[1].split(/\s+/).filter(x => x);
}

function processFile(filename) {
    var text = fs.readFileSync(filename, 'utf-8');

    text = text.replace(/^(accumulate )(.*?)([.])/gm,
        (_, pre, fn, suf) => {
        let fn_ = fn.replace(/^elpi[/]/, '');
        console.log('>> ', fn, '->', fn_);
        return (pre + fn_ + suf);
    });
    fs.writeFileSync(filename, text);
}

function main() {
    var l = findCoqFiles();
    for (let fn of l) {
        console.log(fn);
        processFile(fn);
    }
}

main();
