class Sparkle.Collections.Locations extends Backbone.Collection
  model: Sparkle.Models.Location

  url: 'locations.json'

  initialize: (options) =>
    @currentParent = options?['parent']

    @on 'search', @search
    @on 'reset', @clearScope
    @on 'selectLocation', @changeParent
    @on 'unselectLocation', @changeToParent
    @on 'clearSearch', @clearSearch

  search: (params) =>
    @searchParams = params
    @searchScope = @filter (location) ->

      if location.withinDistance()
        location.set
          visible: true
        return true
      else
        location.set
          visible: false
        return false

    if _.intersection(@currentScope, @searchScope).length > 0
      @trigger 'changeScope'
    else
      delete @searchParams
      delete @searchScope
      @trigger 'noResults'

  clearSearch: =>
    unless _.isEmpty @searchScope
      delete @searchParams
      delete @searchScope
      @forEach (location) ->
        location.set
          visible: true
      @trigger 'changeScope'

  clearScope: =>
    delete @currentScope
    @trigger 'changeScope'

  changeParent: (model) =>
    @currentParent = model
    @clearScope()

  changeToParent: (model) =>
    @currentParent = model.parent()
    @trigger 'noLocationSelected' unless @currentParent?
    @clearScope()

  scopedLocations: ->
    @currentScope ?= @getScope()

    if @searchScope
      _.intersection(@currentScope, @searchScope)

    else
      @currentScope

  scopedLocationsWithAddresses: ->
    locations = _.filter @scopedLocations(), (location) ->
      true if location? and location.get('addresses').length >= 1

    locations.push(@currentParent) if @currentParent?.get('addresses').length >= 1

    return locations

  getScope: ->
    if @currentParent
      locations = _.map @currentParent.get('descendant_ids'), (id) =>
        @get(id)
    else
      @models

  roots: =>
    new Sparkle.Collections.Locations @filter (location) ->
      !location.get('parent_id')?

  currentList: ->
    if @currentParent
      @currentParent.directChildren().toJSON()
    else
      @roots().toJSON()
