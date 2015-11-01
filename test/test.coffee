fs           = require 'fs'
path         = require 'path'
CSON         = require 'cson'
chai         = require 'chai'
expect       = chai.expect
postcss      = require 'postcss'

csonCssvars = require '..'

set = (dir) ->
  stylePath = path.join 'test/cases/', dir, 'style.css'
  pluginPath = path.join 'test/cases/', dir, 'cssvars.cson'
  answerPath = path.join 'test/cases/', dir, 'answer.css'

  style: fs.readFileSync stylePath, 'utf-8'
  plugin: csonCssvars {filepath: pluginPath}
  answer: fs.readFileSync answerPath, 'utf-8'

describe 'postcss-cson-cssvars', ->
  it 'expect replace variable', ->
    {style, plugin, answer} = set 'variable'

    result = postcss([plugin]).process(style)
    expect(result.css).to.equal(answer)

  it 'expect replace variable variable', ->
    {style, plugin, answer} = set 'variable-variable'

    result = postcss([plugin]).process(style)
    expect(result.css).to.equal(answer)
