class Sparkle.Routers.LocationFinder extends Backbone.Router
  routes:
    "": "noLocation"
    ":slug": "selectLocation"

  noLocation: =>
    @locations.changeParent()

  selectLocation: (slug) =>
    url = "/locations/" + slug
    location = @locations.where(url: url)[0]
    @locations.changeParent(location)

  initialize: ->
    @container = document.getElementById('location-browser')
    return false unless @container?

    @initializeCollections()
    @setupViews()

  initializeCollections: ->
    @locations = new Sparkle.Collections.Locations
    @locations.fetch reset: true
    # @locations.on 'noResults', @noResults
    @locations.on 'reset, changeScope', @renderLocationBrowser

  setupViews: ->
    @renderLocationBrowser()

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
