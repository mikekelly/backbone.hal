describe "HAL.Collection", ->
  beforeEach ->
    @hal_response = Helper.collection_response
    @col = new HAL.Collection @hal_response

  describe "when instantiated", ->
    it "strips out the _links and _embedded properties", ->
      expect(@col.get('_links') or @col.get('_embedded')).toBeUndefined()

    it "returns the correct URI from url() function", ->
      expect(@col.url()).toEqual @hal_response._links.self.href

    it "sets links property of instance correctly", ->
      expect(@col.links).toEqual @hal_response._links

    it "sets embedded property of instance correctly", ->
      expect(@col.embedded).toEqual @hal_response._embedded

    it "sets normal properties up as expected", ->
      expect([@col.attributes.prop, @col.attributes.other_prop]).
        toEqual [@hal_response.prop, @hal_response.other_prop]

  describe "when reset with #fetch()", ->
    beforeEach ->
      @server = sinon.fakeServer.create()
      @updated_response = Helper.updated_collection_response
      @server.respondWith [
        200
        { 'Content-Type': 'application/hal+json' }
        JSON.stringify @updated_response
      ]
      @col.fetch()
      @server.respond()

    afterEach ->
      @server.restore()

    it "updates the links property correctly", ->
      expect(@col.links).toEqual @updated_response._links

    it "updates the embedded property correctly", ->
      expect(@col.embedded.embed2).not.toBeUndefined()

    it "strips out _links and _embedded", ->
      expect(@col.get('_embedded') or @col.get('_links')).toBeUndefined()

    it "updates properties correctly", ->
      expect([@col.attributes.prop, @col.attributes.other_prop, @col.attributes.additional]).
        toEqual [@updated_response.prop, @updated_response.other_prop, @updated_response.additional]

  describe "when reset with #reset()", ->
    beforeEach ->
      @updated_response = Helper.updated_collection_response

    describe "called with a full HAL document", ->
      beforeEach ->
        @col.reset @updated_response

      it "updates the links property correctly", ->
        expect(@col.links).toEqual @updated_response._links

      it "updates the embedded property correctly", ->
        expect(@col.embedded.embed2).not.toBeUndefined()

      it "strips out _links and _embedded", ->
        expect(@col.get('_embedded') or @col.get('_links')).toBeUndefined()

      it "updates the items", ->
        console.log @updated_response
        expect(@col.models.length).toEqual @updated_response._embedded.items.length

      it "updates properties correctly", ->
        expect([@col.attributes.prop, @col.attributes.other_prop, @col.attributes.additional]).
          toEqual [@updated_response.prop, @updated_response.other_prop, @updated_response.additional]

    describe "called with just an array of items", ->
      beforeEach ->
        @col.reset @updated_response._embedded.items

      it "leaves the links property in-tact", ->
        expect(@col.links).not.toBeUndefined

      it "leaves the embedded property in-tact", ->
        expect(@col.embedded).not.toBeUndefined()

      it "updates the items", ->
        expect(@col.models.length).toEqual @updated_response._embedded.items.length
