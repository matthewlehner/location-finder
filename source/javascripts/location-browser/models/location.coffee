class Sparkle.Models.Location extends Backbone.Model
  withinDistance: ->
    @childrenWithinDistance() or (@addressesWithinDistance().length > 0)

  childrenWithinDistance: ->
    childNearby = false

    if @hasChildren() and @collection
      for location_id in @get('descendant_ids') when childNearby is false
        location = @collection.get location_id
        childNearby = location?.addressesWithinDistance().length > 0

    return childNearby

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
    {latLng, range} = @collection.searchParams
    if latLng and range
      _.filter @get('addresses'), (address) ->
        locationLatLng = new google.maps.LatLng address['lat'], address['lng']
        google.maps.geometry.spherical.computeDistanceBetween(locationLatLng, latLng) < range

    else
      @get('addresses')
