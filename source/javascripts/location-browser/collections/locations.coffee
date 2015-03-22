class Sparkle.Collections.Locations extends Backbone.Collection
  model: Sparkle.Models.Location

  url: '/locations.json'

  initialize: ->
    @on 'search', @search
    @on 'reset', @resetScope
    @on 'clearSearch', @clearSearch

  search: (params) =>
    @searchParams = params
    @searchScope = @filter (location) ->
      location.withinDistance()

    if _.intersection(@currentScope, @searchScope).length > 0
      @trigger 'changeScope'
    else
      @trigger 'noResults'
      @clearSearch()

  clearSearch: =>
    unless _.isEmpty @searchScope
      @searchParams = null
      @searchScope = null
      @trigger 'changeScope'

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

  resetScope: =>
    @currentParent = @findWhere(@parentParams)
    @currentScope = null
    @trigger 'changeScope'

  changeParent: (params) ->
    @parentParams = params
    @resetScope()

  currentList: ->
    # This needs to return a scoped list based on parent and search results
    new Sparkle.Collections.Locations @where
      parent_id: @currentParent?.get('id')
