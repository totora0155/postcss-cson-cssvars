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
'font-size': '1.3rem'

color:
  base: '#f8f8f8'
  accent: '#91AD70'

headline: [
  '3.2rem'
  '2.4rem'
  '2rem'
]

```

Then, create `input.css`
(e.g.)
```css
body {
  font-size: $font-size;

  color: $color.accent;
  background: $color.base;
}

h1 { font-size: $headline[0]; }
h2 { font-size: $headline[1]; }
h3 { font-size: $headline[2]; }

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
 *     font-size: 1.3rem;
 *     color: #91AD70;
 *     background: #f8f8f8;
 *   }
 *   h1 { font-size: 3.2rem; }
 *   h2 { font-size: 2.4rem; }
 *   h3 { font-size: 2rem; }
 *
 */
```

## Options

- `filepath`  
  For read cson file path (e.g.) `csonCssvar({filepath: './css/css-variable.cson'})`  
  By default, it is `./cssvars.cson`
