{print} = require 'util'
{exec} = require 'child_process'

compile = () ->
  coffee = exec 'coffee --compile --output ./ ./lib/'
  coffee.stdout.on 'data', (data) -> print data.toString()
  coffee.stderr.on 'data', (data) -> print data.toString()

task 'compile', 'compile coffeescripts', ->
  compile()
