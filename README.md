# postcss-cson-cssvars

[PostCSS](https://github.com/postcss/postcss) plugin that read cson file to variable


## Install

```
npm i -D postcss-cson-cssvars
npm i -D postcss # if still
```

## Usage

First, create `cssvars.cson`
(e.g.)
```cson
color: '#131313'
```

Then, create `input.css`
(e.g.)
```css
body {
  color: $color;
}
```

Finally, use postcss-cson-cssvars plugin in PostCSS
(e.g.)
```javascript
var fs = require('fs');
var postcss = require('postcss');
var csonCssvar = require('postcss-cson-cssvars');
var css = fs.readFileSync('input.css', 'utf8');

var output = postcss()
  .use(csonCssvar())
  .process(css)
  .css;

console.log(output);
/* output:
 *
 *   body {
 *     color: #131313;
 *   }
 */
```

## Options

- `filepath`  
  For read cson file path (e.g.) `csonCssvar({filepath: './css/css-variable.cson'})`  
  By default, it is `./cssvars.cson`
