class Sparkle.Views.LocationSearch extends Backbone.View
  el: '.lb-search'
  @cachedInputLength = 0

  events:
    'submit' : 'catchSubmit'
    'input .lb-location-input-field': 'inputChange'

  initialize: ->
    @inputField = @$el.find('.lb-location-input-field')
    Sparkle.GoogleMaps.addAutoCompleteToField( @inputField[0], this )
    Sparkle.GoogleMaps.onMapsLoaded =>
      google.maps.event.addListener @autocomplete, 'place_changed', @search

    @resetControl = new Sparkle.Views.SearchControlReset collection: @collection
    @listenTo @collection, 'clearSearch', @clearFields
    @listenTo @collection, 'selectLocation', @hideSearch
    @listenTo @collection, 'noLocationSelected', @showSearch
    @listenTo @collection, 'infoWindowOpen', @hideSearch
    @listenTo @collection, 'infoWindowClosed', @showSearch

  params: ->
    'location': @autocomplete.getPlace()?.geometry?.location ? @inputField.val()
    'distance': 5 # @$el.find('.distance select').val()

  search: =>
    if @autocomplete.getPlace()?.geometry?
      ga('send', 'event', 'Location Browser', 'Search', @inputField.val())
      @collection.trigger 'search', @params()

  catchSubmit: (event) ->
    event.preventDefault()

  clearFields: ->
    @hideClear()
    @inputField.val('')

  inputChange: (e) =>
    if @inputField.val().length > 0
      @showClear()
    else
      @hideClear()

  showClear: ->
    @resetControl.fadeIn()

  hideClear: ->
    @resetControl.fadeOut()

  hideSearch: ->
    @$el.addClass('lb-search-hidden')

  showSearch: ->
    @$el.removeClass('lb-search-hidden')

class Sparkle.Views.SearchControlReset extends Backbone.View
  el: '.lb-clear-search'

  controlEvents:
    'click' : 'clearSearch'

  clearSearch: (event) ->
    event.preventDefault()
    @collection.trigger 'clearSearch'

  fadeIn: ->
    unless @visible
      @delegateEvents(@controlEvents)
      @$el.velocity 'fadeIn',
        duration: 100
        easing: 'ease'
      @visible = true

  fadeOut: ->
    if @visible
      @$el.velocity 'fadeOut',
        duration: 100
        easing: 'ease'
      @undelegateEvents()
      @visible = false

class Sparkle.Views.LocationNoResults extends Backbone.View
  template: JST["location-browser/no-search-results"]
  className: 'no-results'

  events:
    'click button': 'resetSearch'

  initialize: ->
    @listenTo @collection, 'search', @removeView
    @listenTo @collection, 'clearSearch', @removeView

  removeView: ->
    @remove()
    delete this

  render: ->
    @$el.html @template()
    this

  resetSearch: =>
    @collection.trigger 'clearSearch'
