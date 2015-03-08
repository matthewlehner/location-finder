class Sparkle.Models.Location extends Backbone.Model
  initialize: ->
    @collection.on 'clearSearch', =>
      @set
        visible: true

  defaults: 
    'visible': true

  withinDistance: ->
    if @childrenWithinDistance()
      return true
    else if @addressesWithinDistance().length >= 1
      true
    else
      false

  childrenWithinDistance: ->
    if @hasChildren() and @collection
      childNearby = false

      for location_id in @get('descendant_ids') when childNearby is false
        location = @collection.get location_id
        childNearby = location?.addressesWithinDistance().length >= 1

      return childNearby

    else
      false

  directChildren: ->
    @cachedChildren ?= new Sparkle.Collections.Locations @collection.where
      parent_id: @id

  childrenFinder: ->
    return [] unless @collection?
    @collection.filter (location) =>
      return location.get('parent_id') is @id

  isRoot: ->
    return !@get('parent_id')?

  parent: ->
    return null if @isRoot()
    @collection.findWhere id: @get('parent_id')

  hasChildren: ->
    @get('descendant_ids').length > 0

  addressesWithinDistance: () ->
    if @collection.searchParams?['location'] and @collection.searchParams?['distance']
      latLng = @collection.searchParams['location']
      meters = @collection.searchParams['distance'] * 1609.34
      _.filter @get('addresses'), (address) ->
          locationLatLng = new google.maps.LatLng address['lat'], address['lng']
          google.maps.geometry.spherical.computeDistanceBetween(locationLatLng, latLng) < meters

    else
      @get('addresses')
