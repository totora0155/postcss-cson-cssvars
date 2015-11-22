fs            = require 'fs'
path          = require 'path'
CSON          = require 'cson'
postcss       = require 'postcss'
colors        = require 'colors'

csonCssvars = postcss.plugin 'postcss-cson-cssvars', (opts = {}) ->
  cwd = process.env.INIT_CWD || process.cwd()

  defs =
    filepath: path.join cwd, 'cssvars.cson'
    quiet: false

  unless opts.filepath?
    opts.filepath = defs.filepath
  unless opts.quiet?
    opts.quiet = defs.quiet

  # TODO: [SyntaxError: Syntax error on line undefined, column undefined: One top level value expected]
  vars =
    try
      do ->
        str = fs.readFileSync opts.filepath, 'utf-8'
        CSON.parse str
    catch e
      if not opts.quiet
        console.warn colors.red '[postcss-cson-cssvars]'
        console.warn colors.red e.code + ':' if e.code?
        console.warn colors.red "\t" + e.toString().match(/[^:]+$/)[0]
      {}

  followProp = (prop) ->
    re = /[^\[\]\.]+/g
    result = vars

    while (key = re.exec prop)?
      result = result[key[0]]

    if not result? and not opts.quiet
      throw new ReferenceError """

        \t#{prop} is not defined

      """

    result

  createPropRe = (str) ->
    new RegExp str.replace /(\$|\[|\])/g, "\\$1"

  handler = (matched) ->
    re = /\$[^\s)]+/g
    result = matched

    return matched if /"|'/.test matched

    while (arg = re.exec matched)
      prop = arg[0]
      try
        value = followProp prop[1..]
        while /^\$/.test value
          value = followProp value[1..]
        result = result.replace createPropRe(prop), value
      catch e
        if not opts.quiet
          console.warn colors.red '[postcss-cson-cssvars]'
          console.warn colors.red e.toString()
        return matched

    result

  (css) ->
    css.replaceValues /.+/, {fast: '$'}, handler
    css.walkAtRules (rule) -> rule.params = handler rule.params

module.exports = csonCssvars
