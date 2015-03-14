class Sparkle.Routers.Map extends Backbone.Router
  initialize: ->
    @container = document.getElementById('location-browser')
    return false unless @container?

    @initializeCollections()
    @setupViews()

  initializeCollections: ->
    @locations = new Sparkle.Collections.Locations
    @locations.fetch
      reset: true
    @locations.on 'noResults', @noResults

  setupViews: ->
    @locationBrowser = React.render(
      React.createElement(LocationBrowser, {collection: @locations}),
      @container.firstElementChild
    )

    # @locationSelector = new Sparkle.Views.LocationNavigation collection: @locations
    unless Sparkle.currentBreakpoint is 'mobile'
    #   @searchPanel      = new Sparkle.Views.LocationSearch collection: @locations
      @mapView          = new Sparkle.Views.MapCanvas collection: @locations

  noResults: =>
    @noResults = new Sparkle.Views.LocationNoResults
      collection: @locations

    @$container.append @noResults.render().el
