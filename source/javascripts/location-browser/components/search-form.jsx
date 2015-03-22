LocationSearchForm = React.createClass({
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
        <ReactCSSTransitionGroup transitionName="lb-range-select" className="lb-range-select" component="label">
          <span>Range:</span>
          <select name="range" value="5">
            <option value="1">1 mile</option>
            <option value="5">5 miles</option>
            <option value="10">10 miles</option>
            <option value="15">15 miles</option>
          </select>
        </ReactCSSTransitionGroup>
      </form>
    );
  }
});

InputWithPlaceAutocomplete = React.createClass({
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

    if (place.geometry == null) {
      return;
    }

    var params = {
      lat: place.geometry.location.lat(),
      lng: place.geometry.location.lng(),
      name: React.findDOMNode(this).value
    }

    var url = "?" + queryString.stringify(params);
    Backbone.history.navigate(url, true);
  },

  render: function () {
    return (
      <input type="text"
             name="location"
             placeholder="Enter an address, city, or zip code"/>
    );
  }
});
