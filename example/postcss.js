var fs = require('fs');
var postcss = require('postcss');
var csonCssvar = require('..');
var css = fs.readFileSync('input.css', 'utf8');

var output = postcss()
  .use(csonCssvar({filepath: './cssvars.cson'}))
  .process(css)
  .css;

console.log(output);
