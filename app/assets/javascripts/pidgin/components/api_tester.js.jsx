const Form = JSONSchemaForm.default;
class ApiTester extends React.Component {
  constructor(props) {
    super(props);
    this.state = {};
    this.state.schema = this.props.schema;
    this.state.response = {};
  }

  get endpoint() {
    if(this.props.href.match(/{/)) {
      return (<span>TODO</span>);
    } else {
      return (<span>{this.props.href}</span>);
    }
  }

  render() {
    let schema = this.state.schema;
    return (
      <div className='api-tester'>
        <div>{this.endpoint}</div>
        <Form
          onSubmit={this.sendRequest.bind(this)}
          schema={schema ? schema : {}}
          />
      </div>
    );
  }

  sendRequest(formData) {
    console.log(formData);
  }
}
