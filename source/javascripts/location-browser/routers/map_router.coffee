class Sparkle.Routers.LocationFinder extends Backbone.Router
  routes:
    "": "noLocation"
    ":slug": "selectLocation"

  noLocation: (queryParams) =>
    @parseQueryParams(queryParams)
    @locations.changeParent()

  selectLocation: (slug, queryParams) =>
    @parseQueryParams(queryParams)
    url = "/locations/" + slug
    @locations.changeParent(url: url)

  parseQueryParams: (queryParams) ->
    {lat, lng, name} = queryString.parse(queryParams)
    if lat? and lng?
      latLng = new google?.maps.LatLng lat, lng
      range = 8047
      @locations.changeSearchParams(latLng, range)

  initialize: ->
    @container = document.getElementById('location-browser')
    return false unless @container?

    @locations = new Sparkle.Collections.Locations
    @locations.fetch reset: true
    @locations.on 'reset, changeScope', @renderLocationBrowser

    unless Sparkle.currentBreakpoint is 'mobile'
      @mapView = new Sparkle.Views.MapCanvas collection: @locations

  renderLocationBrowser: =>
    props =
      root: @locations.currentParent?.toJSON()
      locations: @locations.currentList().toJSON()

    @locationBrowser = React.render(
      React.createElement(LocationBrowser, props),
      @container.firstElementChild
    )

  noResults: =>
    @noResults = new Sparkle.Views.LocationNoResults
      collection: @locations

    @$container.append @noResults.render().el
