// Generated by CoffeeScript 1.10.0
(function() {
  var CSON, colors, csonCssvars, fs, path, postcss;

  fs = require('fs');

  path = require('path');

  CSON = require('cson');

  postcss = require('postcss');

  colors = require('colors');

  csonCssvars = postcss.plugin('postcss-cson-cssvars', function(opts) {
    var createPropRe, cwd, defs, e, followProp, handler, vars;
    if (opts == null) {
      opts = {};
    }
    cwd = process.env.INIT_CWD || process.cwd();
    defs = {
      filepath: path.join(cwd, 'cssvars.cson'),
      quiet: false
    };
    if (opts.filepath == null) {
      opts.filepath = defs.filepath;
    }
    if (opts.quiet == null) {
      opts.quiet = defs.quiet;
    }
    vars = (function() {
      var error;
      try {
        return (function() {
          var str;
          str = fs.readFileSync(opts.filepath, 'utf-8');
          return CSON.parse(str);
        })();
      } catch (error) {
        e = error;
        if (!opts.quiet) {
          console.warn(colors.red('[postcss-cson-cssvars]'));
          if (e.code != null) {
            console.warn(colors.red(e.code + ':'));
          }
          console.warn(colors.red("\t" + e.toString().match(/[^:]+$/)[0]));
        }
        return {};
      }
    })();
    followProp = function(prop) {
      var key, re, result;
      re = /[^\[\]\.]+/g;
      result = vars;
      while ((key = re.exec(prop)) != null) {
        result = result[key[0]];
      }
      if ((result == null) && !opts.quiet) {
        throw new ReferenceError("\n\t" + prop + " is not defined\n");
      }
      return result;
    };
    createPropRe = function(str) {
      return new RegExp(str.replace(/(\$|\[|\])/g, "\\$1"));
    };
    handler = function(matched) {
      var arg, error, prop, re, result, value;
      re = /\$[^\s)]+/g;
      result = matched;
      if (/"|'/.test(matched)) {
        return matched;
      }
      while ((arg = re.exec(matched))) {
        prop = arg[0];
        try {
          value = followProp(prop.slice(1));
          while (/^\$/.test(value)) {
            value = followProp(value.slice(1));
          }
          result = result.replace(createPropRe(prop), value);
        } catch (error) {
          e = error;
          if (!opts.quiet) {
            console.warn(colors.red('[postcss-cson-cssvars]'));
            console.warn(colors.red(e.toString()));
          }
          return matched;
        }
      }
      return result;
    };
    return function(css) {
      css.replaceValues(/.+/, {
        fast: '$'
      }, handler);
      return css.walkAtRules(function(rule) {
        return rule.params = handler(rule.params);
      });
    };
  });

  module.exports = csonCssvars;

}).call(this);
