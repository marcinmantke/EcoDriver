angular.module('EcoApp').filter 'shortAddress', ()->
  (input)->
    words = input.split ","
    if !isNaN(words[words.length-1]) && words.length > 2
      return words[words.length-3] + ',' + words[words.length-2] + ',' + words[words.length-1]
    else
      if words[words.length-2] == 'Poland'
        words[words.length-2] = 'Polska'
        words[words.length-1] = ' droga nr' + words[words.length-1]
      return words[words.length-2] + ',' + words[words.length-1]
