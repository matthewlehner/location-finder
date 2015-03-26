class Sparkle.Routers.LocationFinder extends Backbone.Router
  routes:
    "": "noLocation"
    ":slug": "selectLocation"

  noLocation: =>
    @locations.changeParent null

  selectLocation: (slug) =>
    parentParams = url: "/locations/#{slug}"
    @locations.changeParent parentParams

  initialize: (@container, @locations) ->
    @locations.on 'changeScope', @renderLocationBrowser

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
