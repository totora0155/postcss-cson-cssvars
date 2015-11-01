fs            = require 'fs'
path          = require 'path'
CSON          = require 'cson'
postcss       = require 'postcss'

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
      {}

  followVar = (varname) ->
    reNest = /[^\.]+/g
    result = vars
    while (key = reNest.exec varname)?
      result = result[key]
    result

  (css) ->
    css.replaceValues /\$([^;]+)/, {fast: '$'}, (m, varname) ->
      value = followVar varname

      if /^\$/.test value
        value = followVar value.match /[^\$]+/

      value

      # value = prop[varname]
      # varVar = value.match(/\$([^;]+)/)?[1]
      # if prop[varVar]? then prop[varVar]
      # else if value? then prop[varname]

module.exports = csonCssvars
