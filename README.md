# postcss-cson-cssvars

[PostCSS](https://github.com/postcss/postcss) plugin that read cson file to variable


## Install

```
npm i postcss-cson-cssvars

# if still
npm i postcss
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

pad:
  vertical: '1em'
  horizontal: '.5em'

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
  padding: $pad.vertical $pad.horizontal;
  color: $color.accent;
  background: $color.base;
  background: $background;
}

h1 { font-size: $headline[0]; }
h2 { font-size: $headline[1]; }
h3 { font-size: $headline[2]; }

@media screen and (min-width: $min-width) and (max-width: $max-width) {}

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
```

`output` will be

```css
body {
  font-size: 1.3rem;
  padding: 1em .5em;
  color: #91AD70;
  background: #f8f8f8;
  background: #f8f8f8;
}

h1 { font-size: 3.2rem; }
h2 { font-size: 2.4rem; }
h3 { font-size: 2rem; }

@media screen and (min-width: 600px) and (max-width: 900px) {}

```

## Options

- `filepath`  
  For read cson file path (e.g.) `csonCssvar({filepath: './css/css-variable.cson'})`  
  By default, it is `./cssvars.cson`

- `quiet`
  Hide catch error.
  By default, it is `false`

## Example

**1** Clone this repository

```
git clone git@github.com:totora0155/postcss-cson-cssvars.git
```

**2** Change directory & Install modules

```
cd postcss-cson-cssvars && npm install --production
```

**3** Change example/ directory
```
cd example
```

**4** Run postcss.js

```
node postcss.js
```
