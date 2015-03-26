class Sparkle.Collections.Locations extends Backbone.Collection
  model: Sparkle.Models.Location
  searchParams: {}
  currentParent: null
  url: '/locations.json'

  initialize: ->
    @on 'reset', @resetScope

  resetScope: =>
    @currentParent = @findWhere(@parentParams)
    @currentScope = null
    @trigger 'changeScope'

  changeParent: (@parentParams) ->
    @resetScope()

  changeSearchParams: (@searchParams) ->
    @resetScope()

  currentList: ->
    new Sparkle.Collections.Locations @filter (location) =>
      parentMatches = location.get('parent_id') is @currentParent?.id
      return parentMatches and location.withinDistance()

  ###*
  # Older functions – try to refactor?
  ###

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

