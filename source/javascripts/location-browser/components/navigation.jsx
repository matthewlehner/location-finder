LocationBrowser = React.createClass({
  componentDidMount: function () {
    this.props.collection.on('reset', this.updateLocations);
    this.props.collection.on('changeScope', this.updateLocations);
  },

  updateLocations: function (collection) {
    if (collection) {
      this.setProps({
        locations: collection.currentList()
      });
    }
  },

  render: function () {
    return (
      <div>
        <header>
          <h4>All Locations</h4>
        </header>
        <LocationSearchForm/>
        <LocationNavList locations={this.props.locations}/>
      </div>
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
      return(<li><a href="#">{location.name}</a></li>);
    };

    return(
      <ul>{this.props.locations.map(createLocation)}</ul>
      //   <li><a href="#">Hospitals</a></li>
      //   <li><a href="#">Scripps Clinic</a></li>
      //   <li><a href="#">Scripps Coastal Medical Center</a></li>
      //   <li><a href="#">Specialty Centers</a></li>
      //   <li><a href="#">Well Being Centers</a></li>
      //   <li><a href="#">Corporate Office</a></li>
      // </ul>
    );
  }
});

LocationNavItem = React.createClass({
  render: function () {
    return (
      <li><a href="#">{this.props.location.name}</a></li>
    );
  }
});
