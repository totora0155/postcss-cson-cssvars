fs           = require 'fs'
path         = require 'path'
CSON         = require 'cson'
chai         = require 'chai'
expect       = chai.expect
postcss      = require 'postcss'

csonCssvars = require '..'

set = (dir, opts) ->
  stylePath = path.join 'test/cases/', dir, 'style.css'
  pluginPath = path.join 'test/cases/', dir, 'cssvars.cson'
  answerPath = path.join 'test/cases/', dir, 'answer.css'

  style: fs.readFileSync stylePath, 'utf-8'
  plugin: do ->
    if opts?
      opts.filepath = pluginPath
      csonCssvars opts
    else
      csonCssvars
        filepath: pluginPath
        quiet: false
  answer: fs.readFileSync answerPath, 'utf-8'

describe 'postcss-cson-cssvars', ->
  it 'expect replace variable', ->
    {style, plugin, answer} = set 'variable'

    result = postcss([plugin]).process(style)
    expect(result.css).to.equal(answer)

  it 'expect replace variable-variable', ->
    {style, plugin, answer} = set 'variable-variable'

    result = postcss([plugin]).process(style)
    expect(result.css).to.equal(answer)

  it 'expect replace nest-variable', ->
    {style, plugin, answer} = set 'nest-variable'

    result = postcss([plugin]).process(style)
    expect(result.css).to.equal(answer)

  it 'expect replace nest-variable-variable', ->
    {style, plugin, answer} = set 'nest-variable-variable'

    result = postcss([plugin]).process(style)
    expect(result.css).to.equal(answer)

  it 'expect replace variable-array', ->
    {style, plugin, answer} = set 'variable-array'

    result = postcss([plugin]).process(style)
    expect(result.css).to.equal(answer)

  it 'expect replace undefined-value', ->
    {style, plugin, answer} = set 'undefined-value'

    result = postcss([plugin]).process(style)
    expect(result.css).to.equal(answer)

  it 'expect replace media-value', ->
    {style, plugin, answer} = set 'media-value'

    result = postcss([plugin]).process(style)
    expect(result.css).to.equal(answer)

  it 'expect dont replace in the case $', ->
    {style, plugin, answer} = set '$-only'

    result = postcss([plugin]).process(style)
    expect(result.css).to.equal(answer)

  it 'expect quiet', ->
    {style, plugin, answer} = set 'quiet-option', {quiet: true}

    result = postcss([plugin]).process(style)
    expect(result.css).to.equal(answer)

  it 'expect replace multi value', ->
    {style, plugin, answer} = set 'multi-value'

    result = postcss([plugin]).process(style)
    expect(result.css).to.equal(answer)
