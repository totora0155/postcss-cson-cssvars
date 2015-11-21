// Generated by CoffeeScript 1.10.0
(function() {
  var CSON, colors, csonCssvars, fs, path, postcss;

  fs = require('fs');

  path = require('path');

  CSON = require('cson');

  postcss = require('postcss');

  colors = require('colors');

  csonCssvars = postcss.plugin('postcss-cson-cssvars', function(opts) {
    var cwd, defs, e, followVar, handler, vars;
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
    followVar = function(varname) {
      var key, re, result;
      re = /[^\[\]\.]+/g;
      result = vars;
      while ((key = re.exec(varname)) != null) {
        result = result[key[0]];
      }
      if ((result == null) && !opts.quiet) {
        throw new ReferenceError("\n\t" + varname + " is not defined\n");
      }
      return result;
    };
    handler = function(m, varname) {
      var error, result;
      result = null;
      if (/"|'/.test(varname)) {
        return '$' + varname;
      }
      try {
        result = followVar(varname);
        while (/^\$/.test(result)) {
          result = followVar(result.slice(1));
        }
      } catch (error) {
        e = error;
        if (!opts.quiet) {
          console.warn(colors.red('[postcss-cson-cssvars]'));
          console.warn(colors.red(e.toString()));
        }
        result = '$' + varname;
      }
      return result;
    };
    return function(css) {
      css.replaceValues(/\$([^;]+)/, {
        fast: '$'
      }, handler);
      return css.walkAtRules('media', function(rule) {
        return rule.params = rule.params.replace(/\$([^\)]+)/g, handler);
      });
    };
  });

  module.exports = csonCssvars;

}).call(this);
