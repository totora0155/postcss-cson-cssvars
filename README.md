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

background: '$color.base'

headline: [
  '3.2rem'
  '2.4rem'
  '2rem'
]

'min-width': '600px'
'max-width': '900px'

```

Then, create `input.css`
(e.g.)
```css
body {
  font-size: $font-size;

  color: $color.accent;
  background: $color.base;
  background: $background;
}

h1 { font-size: $headline[0]; }
h2 { font-size: $headline[1]; }
h3 { font-size: $headline[2]; }

@media screen and (min-width: $min-width) and (max-width: $max-width) {
  /*...*/
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
 *     font-size: 1.3rem;
 *     color: #91AD70;
 *     background: #f8f8f8;
 *     background: #f8f8f8;
 *   }
 *
 *   h1 { font-size: 3.2rem; }
 *   h2 { font-size: 2.4rem; }
 *   h3 { font-size: 2rem; }
 *
 *   @media screen and (min-width: 600px) and (max-width: 900px) {
 *     ...
 *   }
 *
 */
```

## Options

- `filepath`  
  For read cson file path (e.g.) `csonCssvar({filepath: './css/css-variable.cson'})`  
  By default, it is `./cssvars.cson`

- `quiet`
  Hide catch error.
  By default, it is `false`
