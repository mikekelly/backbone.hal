# Support for async loading, adapted from https://github.com/umdjs/umd
((root, factory) ->
  if define?.amd then define ['backbone', 'underscore', 'uritemplate'], factory
  else root.HAL = factory Backbone, _, UriTemplate
) this, (Backbone, _, UriTemplate) ->
  processUriTemplate = (tmpl, params = {}) ->
    if !UriTemplate then return null
    template = UriTemplate.parse tmpl
    template.expand params
  class Model extends Backbone.Model
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

  class Collection extends Backbone.Collection
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

    reset: (obj, options = {}) ->
      # skip parsing if obj is an Array (i.e. reset items only)
      obj = @parse(_.clone obj) if not _.isArray(obj)
      options.parse = false
      return super(obj, options)

    url: ->
      if @links?.self?.templated then processUriTemplate(@links?.self?.href, @urlParameters) else @links?.self?.href

  {
    Model: Model
    Collection: Collection
  }



