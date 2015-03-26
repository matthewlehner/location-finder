(function () {
'use strict';

var ReactCSSTransitionGroup = React.addons.CSSTransitionGroup;

window.LocationSearchForm = React.createClass({
  getInitialState: function () {
    return {height: "auto"}
  },

  componentDidMount: function () {
    var el = React.findDOMNode(this)
    this.originalElHeight = el.offsetHeight;
    this.setState({
      height: this.originalElHeight
    });
  },

  componentWillReceiveProps: function (nextProps) {
    if (nextProps.hidden) {
      this.setState({
        height: "0"
      });
    } else {
      this.setState({
        height: this.originalElHeight
      });
    }
  },

  handleSubmit: function (e) {
    e.preventDefault();
  },

  render: function () {
    var formStyle = {
      height: this.state.height,
      borderBottomColor: this.state.borderBottomColor
    }

    var className = "lb-search"
    if (this.props.hidden) {
      className += " hidden";
    }

    return (
      <form style={formStyle} className={className} onSubmit={this.handleSubmit}>
        <label>
          <span>Near:</span>
          <InputWithPlaceAutocomplete/>
        </label>
        <ReactCSSTransitionGroup transitionName="lb-range-select"
                                 component={RangeSelect}/>
      </form>
    );
  }
});

var InputWithPlaceAutocomplete = React.createClass({
  componentDidMount: function () {
    var el = React.findDOMNode(this)
    Sparkle.GoogleMaps.addAutoCompleteToField(el, this);
    var self = this;
    Sparkle.GoogleMaps.onMapsLoaded(function () {
      google.maps.event.addListener(self.autocomplete, 'place_changed', self.search);
    });
  },

  search: function () {
    var place = this.autocomplete.getPlace();

    if (place.geometry == null) { return };

    var params = {
      lat: place.geometry.location.lat(),
      lng: place.geometry.location.lng(),
      name: React.findDOMNode(this).value
    }

    locationFinder.trigger('setSearchParams', params)
  },

  render: function () {
    return (
      <input type="text"
             name="location"
             placeholder="Enter an address, city, or zip code" />
    );
  }
});

var RangeSelect = React.createClass({
  getInitialState: function () {
    return { value: "8047" }
  },

  handleChange: function (event) {
    this.setState({value: event.target.value});
    locationFinder.trigger('setSearchParams', {
      range: event.target.value
    });
  },

  render: function () {
    return (
      <label className="lb-range-select" key="lb-range-select">
        <span>Range:</span>
        <select name="range" value={this.state.value} onChange={this.handleChange}>
          <option value="1610">1 mile</option>
          <option value="8047">5 miles</option>
          <option value="16094">10 miles</option>
          <option value="24140">15 miles</option>
        </select>
      </label>
    );
  }
});

})();
