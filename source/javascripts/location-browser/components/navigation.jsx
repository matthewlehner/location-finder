var ReactCSSTransitionGroup = React.addons.CSSTransitionGroup;

LocationBrowser = React.createClass({
  render: function () {
    var navList, locationDetails;

    if (this.props.locations.length > 0) {
      navList = <LocationNavList locations={this.props.locations}/>
    } else if (this.props.root) {
      locationDetails = <LocationDetails {...this.props.root}/>
    }

    return (
      <div>
        <LocationHeader {...this.props.root}/>
        <LocationSearchForm hidden={!!this.props.root}/>
        {navList}
        {locationDetails}
      </div>
    );
  }
});

LocationDetails = React.createClass({
  render: function () {
    var address = this.props.addresses[0];
    var addressProps = {
      streetAddress: address.address,
      locality: address.city,
      region: address.full_state_name,
      regionAbbr: address.state,
      postalCode: address.postal_code,
      country: address.full_country_name,
      countryAbbr: address.country
    }

    return (
      <section className="location-details">
        <figure>
          <img src="http://lorempixel.com/327/119"/>
        </figure>

        <h4>Address</h4>
        <Address {...addressProps}/>


        <h4>Phone</h4>
        <p>
          <span className="phone-number value" itemProp="tel" title="858-554-9100">858-554-9100</span>
        </p>

        <a className="location-link" href="/locations/hospitals__scripps-green-hospital">View Location Page</a>
      </section>
    );
  }
});

Address = React.createClass({
  render: function () {
    return (
      <p className="adr" itemProp="address" itemScope="itemscope" itemType="http://data-vocabulary.org/Address/">
        <span className="street-address" itemProp="street-address">{this.props.streetAddress}</span><br/>
        <span className="locality" itemProp="locality">{this.props.locality}</span>,
        <abbr className="region" itemProp="region" title={this.props.region}>{this.props.regionAbbr}</abbr>
        <span className="postal-code" itemProp="postal-code">{this.props.postalCode}</span>
        <abbr className="country-name" itemProp="country-name" title={this.props.country}>{this.props.countryAbbr}</abbr>
      </p>
    );
  }
});

LocationHeader = React.createClass({
  render: function () {
    var headerText = this.props.name || "All Locations"
    return (
      <header className="lb-header">
          <ReactCSSTransitionGroup transitionName="lb-header">
            <h4 key={headerText}>
              {headerText}
            </h4>
          </ReactCSSTransitionGroup>
      </header>
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
      return(<LocationNavItem key={location.id} location={location}/>);
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
