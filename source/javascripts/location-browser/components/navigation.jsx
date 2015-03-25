var ReactCSSTransitionGroup = React.addons.CSSTransitionGroup;

LocationBrowser = React.createClass({
  render: function () {
    var navList, locationDetails;

    if (this.props.locations.length > 0) {
      navList = <LocationNavList locations={this.props.locations}/>
    } else if (this.props.root) {
      locationDetails = <ReactCSSTransitionGroup transitionName="lb-list" component={LocationDetails} {...this.props.root}/>
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

    var locationImage;
    if (!!this.props.thumbnail) {
      locationImage = (
        <figure>
          <img src={this.props.thumbnail.replace("ptn_","")}/>
        </figure>
      );
    }

    return (
      <section className="lb-details">
        {locationImage}

        <div className="lb-details-inner">
          <h5>Address</h5>
          <Address {...addressProps}/>

          <h5>Phone</h5>
          <span className="phone-number value" itemProp="tel" title="858-554-9100">858-554-9100</span>

          <a className="location-link" href="/locations/hospitals__scripps-green-hospital">View Location Page</a>
          <hr/>
        </div>
      </section>
    );
  }
});

Address = React.createClass({
  render: function () {
    return (
      <div className="adr" itemProp="address" itemScope="itemscope" itemType="http://data-vocabulary.org/Address/">
        <span className="street-address" itemProp="street-address">{this.props.streetAddress}</span><br/>
        <span className="locality" itemProp="locality">{this.props.locality}</span>,
        <abbr className="region" itemProp="region" title={this.props.region}>{this.props.regionAbbr}</abbr> <span className="postal-code" itemProp="postal-code">{this.props.postalCode}</span>
        <abbr className="country-name" itemProp="country-name" title={this.props.country}>{this.props.countryAbbr}</abbr>
      </div>
    );
  }
});

LocationHeader = React.createClass({
  navBack: function (e) {
    locationFinder.trigger('changeParent', {id: this.props.parent_id})
  },

  render: function () {
    var headerText = this.props.name || "All Locations"
    var backButton = this.props.name ? <i className="icon-arrow-past" onClick={this.navBack}></i> : null
    return (
      <ReactCSSTransitionGroup component="header" className="lb-header" transitionName="lb-header">
        <h4 key={this.props.id}>
          {backButton}
          {headerText}
        </h4>
      </ReactCSSTransitionGroup>
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
    locationFinder.trigger('changeParent', {url: this.props.location.url});
    e.preventDefault();
  },

  render: function () {
    return (
      <li><a href="#" onClick={this.onClick}>{this.props.location.name}</a></li>
    );
  }
});
