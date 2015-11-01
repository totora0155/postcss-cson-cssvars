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
      console.error e
      {}

  console.log vars

  (css) ->
    css.replaceValues /\$([^;]+)/, {fast: '$'}, (m, varname) ->
      value = vars[varname]
      varVar = value.match(/\$([^;]+)/)?[1]
      if vars[varVar]? then vars[varVar]
      else if value? then vars[varname]

module.exports = csonCssvars
