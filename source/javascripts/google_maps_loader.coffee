class Sparkle.GoogleMaps
  @Loader: ->
    if window.google?.maps?
      $(document).trigger 'mapsLoaded'
    else
      _.extend Sparkle,
        mapsLoaded : ->
          $(document).trigger 'mapsLoaded'
          delete Sparkle['mapsLoaded']

      @loadMapScript('Sparkle.mapsLoaded')

  @loadMapScript: (callback) ->
    script = document.createElement("script")
    script.type = "text/javascript"
    params = "?v=3.18&libraries=places,geometry&callback=#{callback}"
    script.src = "//maps.googleapis.com/maps/api/js#{params}"
    document.body.appendChild(script)

  @onMapsLoaded: (fn) ->
    if window.google?.maps?
      fn()
    else
      $(document).one 'mapsLoaded', fn

  @addAutoCompleteToField: (input, parentScope ) ->
    @initAutoComplete = =>
      return false if parentScope.autocomplete

      bounds = new google.maps.LatLngBounds
      bounds.extend new google.maps.LatLng(33.505025, -116.08094) #NE
      bounds.extend new google.maps.LatLng(32.528832, -117.611081) #SW

      options =
        types: ['geocode']
        componentRestrictions:
          country: 'us'
        bounds: bounds

      parentScope.autocomplete = new google.maps.places.Autocomplete( input, options )
      delete @['initAutoComplete']

    Sparkle.GoogleMaps.onMapsLoaded @initAutoComplete

  @mapOptions: (options) ->
    options || (options = {})
    _.defaults(options, @defaultMapOptions())

  @defaultMapOptions: ->
    zoom: 10
    maxZoom: 18
    center: new google.maps.LatLng(32.7153, -117.1564)
    mapTypeId: google.maps.MapTypeId.ROADMAP
    scrollwheel: false
    disableDefaultUI: true
    zoomControl: true
    zoomControlOptions:
      style: google.maps.ZoomControlStyle.SMALL
      position: google.maps.ControlPosition.RIGHT_BOTTOM
