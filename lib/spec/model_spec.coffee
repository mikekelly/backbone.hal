describe "HAL.Model", ->
  beforeEach ->
    @hal_response = Helper.model_response
    @collection = new HAL.Collection()
    @model = new HAL.Model @hal_response, { collection: @collection }

  describe "when instantiated", ->
    it "strips out the _links and _embedded properties", ->
      expect(@model.get('_links') or @model.get('_embedded')).toBeUndefined()

    it "returns the correct URI from url() function", ->
      expect(@model.url()).toEqual @hal_response._links.self.href

    it "sets links property of instance correctly", ->
      expect(@model.links).toEqual @hal_response._links

    it "sets embedded property of instance correctly", ->
      expect(@model.embedded).toEqual @hal_response._embedded

    it "sets normal properties up as expected", ->
      expect([@model.get('prop'), @model.get('other_prop')]).
        toEqual [@hal_response.prop, @hal_response.other_prop]

    it "returns false for isNew when self-link present", ->
      expect(@model.isNew()).toEqual false

    it "sets the collection from the Model options", ->
      expect(@model.collection).toEqual @collection

  describe "when reset with #fetch()", ->
    beforeEach ->
      @server = sinon.fakeServer.create()
      @updated_response = Helper.updated_model_response
      @server.respondWith [
        200
        { 'Content-Type': 'application/hal+json' }
        JSON.stringify @updated_response
      ]
      @model.fetch()
      @server.respond()

    afterEach ->
      @server.restore()

    it "updates the links property correctly", ->
      expect(@model.links).toEqual @updated_response._links

    it "updates the embedded property correctly", ->
      expect(@model.embedded).toEqual @updated_response._embedded

    it "strips out _links and _embedded", ->
      expect(@model.get('_embedded') or @model.get('_links')).toBeUndefined()

    it "updates properties correctly", ->
      expect([@model.get('prop'), @model.get('other_prop'), @model.get('additional')]).
        toEqual [@updated_response.prop, @updated_response.other_prop, @updated_response.additional]
