window.HAL = {}

class HAL.Model extends Backbone.Model
  constructor: (attrs) ->
    super @parse(_.clone attrs)

  parse: (attrs = {}) ->
    @links = attrs._links || {}
    delete attrs._links
    @embedded = attrs._embedded || {}
    delete attrs._embedded

    return attrs

  url: ->
    @links?.self?.href || super()

class HAL.Collection extends Backbone.Collection
  constructor: (obj, options) ->
    super @parse(_.clone obj), options

  parse: (obj = {}) ->
    @links = obj._links || {}
    delete obj._links
    @embedded = obj._embedded || {}
    delete obj._embedded
    @attributes = obj || {}

    if @itemRel?
      items = @embedded[@itemRel]
    else
      items = @embedded.items

    return items

  reset: (obj, options) ->
    # skip parsing if obj is an Array (i.e. reset items only)
    obj = @parse(_.clone obj) if not _.isArray(obj)
    return super(obj, options)

  url: ->
    @links?.self?.href
