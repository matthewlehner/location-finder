class Sparkle.Views.MapCanvas extends Backbone.View
  el: '#lb-map'

  initialize: ->
    Sparkle.GoogleMaps.Loader()
    $(document).one 'mapsLoaded', @initializeMap

  initializeMap: =>
    @mapObject = new google.maps.Map @el, Sparkle.GoogleMaps.defaultMapOptions()
    @bounds = new google.maps.LatLngBounds()
    @markers = {}
    @listenTo @collection, 'reset changeScope', @resetAndCenter
    @listenTo @collection, 'selectLocation', @focusMarker
    @resetMarkers()

  resetAndCenter: =>
    @resetMarkers()

  resetMarkers: (center = null) ->
    @deleteMarkers()
    @bounds = new google.maps.LatLngBounds()
    @createMarkers(@collection.scopedLocationsWithAddresses())

    @setZoom()

  deleteMarkers: ->
    @clearMarkers()
    @markers = {}

  clearMarkers: ->
    for marker in _.values(@markers)
      marker.setMap(null)

  setZoom: ->
    @mapObject.fitBounds @bounds

  createMarkers: (locations) ->
    for location in locations
      for address in location.addressesWithinDistance()
        return false unless address['lat'] && address['lng']

        latLng = new google.maps.LatLng address['lat'], address['lng']
        marker = new google.maps.Marker
          position: latLng 
          map: @mapObject
          title: location.get('name')
        @markers[address['id']] = marker
        @createInfoWindow(location, address, marker)
        @bounds.extend latLng


  createInfoWindow: (location, address, marker) ->
    content = JST['location-browser/info-window'](location.toJSON())

    infoWindow = new google.maps.InfoWindow
      content: content

    google.maps.event.addListener infoWindow, 'closeclick', =>
      @collection.trigger 'infoWindowClosed'

    google.maps.event.addListener marker, 'click', =>
      unless infoWindow is @infoWindow
        @collection.trigger 'infoWindowOpen', location
        @infoWindow?.close()
        @infoWindow = infoWindow
        @infoWindow.open @mapObject, marker

  focusMarker: (location) ->
    firstAddress = _.first(location.get('addresses'))
    if firstAddress?
      currentMarker = @markers[firstAddress['id']]
      google.maps.event.trigger currentMarker, 'click'

  render: ->
    this

  resize: ->
    google.maps.event.trigger @mapObject, 'resize'

  redraw: ->
    @resize()
    @deleteMarkers()
