_ = require "underscore"
Backbone = require "backbone"

class @ArrayController
  constructor: (objects, options) ->
    @array = []
    @length = 0
    @add objects, options if objects

  add: (objects, options = {}) ->
    objects = if _.isArray(objects) then objects.slice() else [objects]

    @length += objects.length
    Array::splice.apply(@array, [@array.length, 0].concat(objects))
    @sort({silent: true})

    if !options.silent
      for object in objects
        @trigger('add', object, this, options)

  remove: (objects, options = {}) ->
    objects = if _.isArray(objects) then objects.slice() else [objects]

    for object in objects
      index = @indexOf(object)
      if index >= 0
        @length -= 1
        @array.splice(index, 1)
        @trigger('remove', object, this, options) if !options.silent

  reset: (objects = [], options = {}) ->
    @array = []
    @length = 0
    @add(objects, _.extend({silent: true}, options))
    @trigger('reset', this, options) if !options.silent

  at: (index) ->
    return @array[index]

  comparator: (a, b) ->
    a.toLowerCase() > b.toLowerCase()

  sort: (options = {}) ->
    boundComparator = _.bind(@comparator, this)
    if @comparator.length == 1
      @array = @sortBy(boundComparator);
    else
      @array.sort(boundComparator);
    
    @trigger('reset', this, options) if !options.silent
    
    this

  _.extend(@prototype, Backbone.Events)
  methods = ['forEach', 'each', 'map', 'reduce', 'reduceRight', 'find',
      'detect', 'filter', 'select', 'reject', 'every', 'all', 'some', 'any',
      'include', 'contains', 'invoke', 'max', 'min', 'sortBy', 'sortedIndex',
      'toArray', 'size', 'first', 'initial', 'rest', 'last', 'without', 'indexOf',
      'shuffle', 'lastIndexOf', 'isEmpty', 'groupBy'];

  # Mix in each Underscore method as a proxy to `ArrayController#array`.
  _.each(methods, (method) =>
    @::[method] = ->
      return _[method].apply(_, [@array].concat(_.toArray(arguments)));
  )

if typeof module != 'undefined' && module.exports
  module.exports = @ArrayController