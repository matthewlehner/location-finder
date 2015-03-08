Sparkle.Views.LocationNavigation = Backbone.View.extend({
  el: '.lb-nav',
  template: JST["location-browser/location-nav-list"],

  events: {
    'click a.lb-location-link': 'selectLocation',
    'click li.selected': 'unselectLocation'
  },

  initialize: function () {
    this.listenTo(this.collection, "reset", this.render);
    this.listenTo(this.collection, "selectLocation", this.render);
    this.listenTo(this.collection, "unselectLocation", this.render);
    this.listenTo(this.collection, "changeScope", this.render);
  },

  templateJSON: function () {
    return {
      locations: this.collection.currentList().toJSON(),
      parent: (this.collection.currentParent && this.collection.currentParent.toJSON())
    }
  },

  render: function () {
    var content = this.template(this.templateJSON());
    this.el.innerHTML = content;
    return this;
  },

  selectLocation: function (e) {
    e.preventDefault();
    var locationId = e.currentTarget.dataset["id"],
        location = this.collection.get(locationId);
    this.collection.trigger("selectLocation", location);
  },

  unselectLocation: function (e) {
    var locationId = e.currentTarget.dataset["id"],
        location = this.collection.get(locationId);
    this.collection.trigger("unselectLocation", location);
  }
});
