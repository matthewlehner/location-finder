LocationSearchForm = React.createClass({
  getInitialState: function () {
    return {height: "auto"}
  },

  componentDidMount: function () {
    this.originalelHeight = React.findDOMNode(this).offsetHeight;
    this.setState({
      height: this.originalelHeight
    });
  },

  componentWillReceiveProps: function (nextProps) {
    if (nextProps.hidden) {
      this.setState({
        height: "0"
      });
    } else {
      this.setState({
        height: this.originalelHeight
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
      </form>
    );
  }
});
