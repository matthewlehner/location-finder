LocationSearchForm = React.createClass({
  getInitialState: function () {
    return {height: "auto"}
  },

  componentDidMount: function () {
    this.originalElHeight = React.findDOMNode(this).offsetHeight;
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
      <form style={formStyle} className={className}>
        <label>
          <span>Near:</span>
          <input type="text" name="location" placeholder="Enter an address, city, or zip code"/>
        </label>
        <ReactCSSTransitionGroup className="lb-range-select" component="label">
          <span>Range:</span>
          <select name="range">
            <option value="1">1 mile</option>
            <option value="5" selected>5 miles</option>
            <option value="10">10 miles</option>
            <option value="15">15 miles</option>
          </select>
        </ReactCSSTransitionGroup>
      </form>
    );
  }
});
