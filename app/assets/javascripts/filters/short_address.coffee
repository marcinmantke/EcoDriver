angular.module('EcoApp').filter 'shortAddress', ()->
  (input)->
    words = input.split ","
    if !isNaN(words[words.length-1])
      return words[words.length-3] + ',' + words[words.length-2] + ',' + words[words.length-1]
    else
      return words[words.length-2] + ',' + words[words.length-1]
