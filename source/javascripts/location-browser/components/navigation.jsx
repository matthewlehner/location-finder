LocationBrowser = React.createClass({
  render: function () {
    var searchForm;
    if (!this.props.root) {
      searchForm = <LocationSearchForm/>
    } else {
      searchForm = ""
    }

    return (
      <div>
        <LocationHeader location={this.props.root}/>
        {searchForm}
        <LocationNavList locations={this.props.locations}/>
      </div>
    );
  }
});

LocationHeader = React.createClass({
  render: function () {
    var headerText = this.props.location ? this.props.location.name : "All Locations"
    return (
      <header>
        <h4>{headerText}</h4>
      </header>
    );
  }
});

LocationSearchForm = React.createClass({
  render: function () {
    return (
      <form className="lb-search">
        <label>
          <span>Near:</span>
          <input type="text" name="location" placeholder="Enter an address, city, or zip code"/>
        </label>
      </form>
    );
  }
});

LocationNavList = React.createClass({
  getDefaultProps: function () {
    return {
      locations: []
    }
  },

  render: function () {
    var createLocation = function (location) {
      return(<LocationNavItem location={location}/>);
    };

    return(
      <ul>{this.props.locations.map(createLocation)}</ul>
    );
  }
});

LocationNavItem = React.createClass({
  onClick: function (e) {
    var slug = this.props.location.url.replace("/locations/", "");
    Backbone.history.navigate(slug, true);
    e.preventDefault();
  },

  render: function () {
    return (
      <li><a href="#" onClick={this.onClick}>{this.props.location.name}</a></li>
    );
  }
});
