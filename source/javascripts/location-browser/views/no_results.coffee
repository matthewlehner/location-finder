class Sparkle.Views.LocationNoResults extends Backbone.View
  template: JST["location-browser/no-search-results"]
  className: 'no-results'

  events:
    'click button': 'resetSearch'

  initialize: ->
    @listenTo @collection, 'search', @removeView
    @listenTo @collection, 'changeScope', @removeView

  removeView: ->
    @remove()

  render: ->
    @$el.html @template()
    this

  resetSearch: =>
    @collection.changeSearchParams()
