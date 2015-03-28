(function () {
'use strict';

var ReactCSSTransitionGroup = React.addons.CSSTransitionGroup;

window.LocationSearchForm = React.createClass({
  handleSubmit: function (e) {
    e.preventDefault();
  },

  render: function () {
    var className = "lb-search"
    if (this.props.hidden) {
      className += " hidden";
    }

    return (
      <form className={className} onSubmit={this.handleSubmit}>
        <label>
          <span>Near:</span>
          <InputWithPlaceAutocomplete/>
          <InputClear/>
        </label>
        <ReactCSSTransitionGroup transitionName="lb-range-select"
                                 component={RangeSelect}/>
      </form>
    );
  }
});

var InputClear = React.createClass({
  getInitialState: function () {
    return {
      hidden: true
    }
  },

  componentDidMount: function () {
    var self = this;
    locationFinder.collection.on("changeScope", function () {
      var params = locationFinder.collection.searchParams;
      if (params == undefined || _.isEmpty(params)) {
        self.setState({hidden: true});
      } else {
        self.setState({hidden: false});
      }
    });
  },

  render: function () {
    if ( this.state.hidden ) {
      return null;
    } else {
      return (
        <span className="form-control clear" onClick={this.handleClick}>
          &times;
        </span>
      );
    }
  },

  handleClick: function (event) {
    locationFinder.trigger('setSearchParams');
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

    locationFinder.collection.on("changeScope", function () {
      var params = locationFinder.collection.searchParams;
      if (params == undefined || _.isEmpty(params)) {
        React.findDOMNode(self).value = "";
      }
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
    return {
      value: "8047",
      hidden: true
    }
  },

  componentDidMount: function () {
    var self = this;
    locationFinder.collection.on("changeScope", function () {
      var params = locationFinder.collection.searchParams;
      if (params == undefined || _.isEmpty(params)) {
        self.setState({hidden: true});
      } else {
        self.setState({hidden: false});
      }
    });
  },

  handleChange: function (event) {
    this.setState({value: event.target.value});
    locationFinder.trigger('setSearchParams', {
      range: event.target.value
    });
  },

  render: function () {
    if (this.state.hidden) {
      return (
        <label className="lb-range-select hidden" key="lb-range-select-hidden"></label>
      );
    } else {
      return (
        <label className="lb-range-select" key="lb-range-select">
          <span>Range:</span>
          <select name="range" value={this.state.value} onChange={this.handleChange}>
            <option value="8047">5 miles</option>
            <option value="16094">10 miles</option>
            <option value="24140">15 miles</option>
            <option value="32187">20 miles</option>
          </select>
        </label>
      );
    }
  }
});

})();
