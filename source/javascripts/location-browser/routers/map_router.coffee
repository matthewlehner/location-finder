class Sparkle.Routers.Map extends Backbone.Router
  initialize: ->
    @$container = $('#location-browser')
    return false unless @$container[0]?

    @initializeCollections()
    @setupViews()

  initializeCollections: ->
    @locations = new Sparkle.Collections.Locations
    @locations.fetch
      reset: true
    @locations.on 'noResults', @noResults

  setupViews: ->
    @locationSelector = new Sparkle.Views.LocationNavigation collection: @locations
    unless Sparkle.currentBreakpoint is 'mobile'
      @searchPanel      = new Sparkle.Views.LocationSearch collection: @locations
      @mapView          = new Sparkle.Views.MapCanvas collection: @locations

  noResults: =>
    @noResults = new Sparkle.Views.LocationNoResults
      collection: @locations

    @$container.append @noResults.render().el
