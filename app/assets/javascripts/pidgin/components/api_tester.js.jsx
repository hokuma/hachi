const Form = JSONSchemaForm.default;
class ApiTester extends React.Component {
  constructor(props) {
    super(props);
    this.state = {};
    this.state.schema = this.props.schema;
    this.state.response = {};
    this.state.token = '';
    this.state.identity = {};
    this.props.path.split('/').forEach((dir) => {
      if(dir.match(/:/)) {
        this.state.identity[dir] = '';
      }
    });
  }

  get endpoint() {
    return this.props.path.split('/').map((dir) => {
      if(dir.match(/:/)) {
        return ['/', <input onChange={this.onIndentityChange.bind(this, dir)} type='text' name={dir} />];
      } else {
        return dir.length > 0 ? `/${dir}` : '';
      }
    });
  }

  onIndentityChange(dir, e) {
    this.setState({identity: Object.assign(this.state.identity, {[dir]: e.target.value})});
  }

  onTokenChange(e) {
    this.setState({token: e.target.value});
  }

  render() {
    let schema = this.state.schema;
    return (
      <div className='api-tester'>
        <div>oauth_token: <input onChange={this.onTokenChange.bind(this)} type='text' value={this.state.token} /></div>
        <div>{this.endpoint}</div>
        <Form
          onSubmit={this.sendRequest.bind(this)}
          schema={schema ? schema : {}}
          />
        <div className='response'>
          <pre>{this.state.response}</pre>
        </div>
      </div>
    );
  }

  sendRequest(form) {
    const metas = document.getElementsByTagName('meta');
    fetch(window.location.pathname, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-Token': metas['csrf-token']['content'],
      },
      body: JSON.stringify({
        token: this.state.token,
        identity: this.state.identity,
        payload: form.formData
      })
    }).then((response) => {
      return resposne.json();
    }).then((json) => {
      this.setState({response: json});
    });
  }
}
