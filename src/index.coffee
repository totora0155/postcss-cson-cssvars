fs            = require 'fs'
path          = require 'path'
CSON          = require 'cson'
postcss       = require 'postcss'
colors        = require 'colors'

csonCssvars = postcss.plugin 'postcss-cson-cssvars', (opts) ->
  cwd = process.env.INIT_CWD || process.cwd()
  opts or=
    filepath: path.join cwd, 'cssvars.cson'

  vars =
    try
      do ->
        str = fs.readFileSync opts.filepath, 'utf-8'
        CSON.parse str
    catch e
      console.warn colors.red '[postcss-cson-cssvars]'
      console.warn colors.red e.code + ':' if e.code?
      console.warn colors.red "\t" + e.toString().match(/[^:]+$/)[0]
      {}

  followVar = (varname) ->
    re = /[^\[\]\.]+/g
    result = vars

    while (key = re.exec varname)?
      result = result[key[0]]

    if not result?
      throw new ReferenceError """

        \t#{varname} is not defined

      """

    result

  handler = (m, varname) ->
    result = null

    try
      result = followVar varname
      while /^\$/.test result
        result = followVar result[1..]
    catch e
      console.warn colors.red '[postcss-cson-cssvars]'
      console.warn colors.red e.toString()

    result

  (css) ->
    css.replaceValues /\$([^;]+)/, {fast: '$'}, handler

    css.walkAtRules 'media', (rule) ->
      rule.params = rule.params.replace /\$([^\)]+)/g, handler

module.exports = csonCssvars
