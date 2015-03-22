class Sparkle.Models.Location extends Backbone.Model
  withinDistance: ->
    @childrenWithinDistance() or (@addressesWithinDistance().length > 0)

  childrenWithinDistance: ->
    if @hasChildren() and @collection
      childNearby = false

      for location_id in @get('descendant_ids') when childNearby is false
        location = @collection.get location_id
        childNearby = location?.addressesWithinDistance().length > 0

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
    return true if not @get('parent_id')?

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
