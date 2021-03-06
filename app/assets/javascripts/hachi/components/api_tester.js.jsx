const Form = JSONSchemaForm.default;
class ApiTester extends React.Component {
  constructor(props) {
    super(props);
    this.state = {};
    this.state.schema = this.props.schema;
    this.state.response = null;
    this.state.username = '';
    this.state.password = '';
    this.state.token = '';
    this.state.headers = this.props.headers;
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

  onUsernameChange(e) {
    this.setState({username: e.target.value});
  }

  onPasswordChange(e) {
    this.setState({password: e.target.value});
  }

  onTokenChange(e) {
    this.setState({token: e.target.value});
  }

  onHeaderChange(e, key) {
    this.setState({headers: Object.assign({}, this.state.headers, {[key]: e.target.value})});
  }

  render() {
    let schema = this.state.schema;
    return (
      <div className='api-tester'>
        <div className='form-group'>
          <label htmlFor='username'>Username</label>
          <input className='form-control' id='username' onChange={this.onUsernameChange.bind(this)} type='text' value={this.state.username} />
        </div>
         <div className='form-group'>
          <label htmlFor='password'>Password</label>
          <input className='form-control' id='password' type='password' onChange={this.onPasswordChange.bind(this)} type='text' value={this.state.password} />
        </div>
        <div className='form-group'>
          <label htmlFor='accessToken'>Access Token</label>
          <input className='form-control' id='accessToken' onChange={this.onTokenChange.bind(this)} type='text' value={this.state.token} />
        </div>
        {this.renderHeaders()}
        <div className='form-group'>
          <label htmlFor='endpoint'>Endpoint</label>
          <div className='input-group'>
            {this.endpoint}
          </div>
        </div>
        <Form
          onSubmit={this.sendRequest.bind(this)}
          schema={schema ? schema : {}}
         />
        {this.renderResponse()}
      </div>
    );
  }

  changeHandler(key) {
    return (e) => {
      this.onHeaderChange(e, key);
    };
  }

  renderHeaders() {
    if(!!!this.state.headers) {
      return null;
    }
    return Object.keys(this.state.headers).map(
      (key) => {
        const paramKey = `headers[${key}]`;
        return (
          <div className='form-group' key={key}>
            <label htmlFor={paramKey}>{key}</label>
            <input className='form-control' id={paramKey} onChange={this.changeHandler(key)} type='text' value={this.state.headers[key]} />
          </div>
        );
      }
    );
  }

  renderResponse() {
    return (
        <div className='response'>
          <div className='status'>Status: {this.state.response ? this.state.response.status : ''}</div>
          <pre>{this.state.response && this.state.response.body !== '' ? JSON.stringify(this.state.response.body, null, 2) : ''}</pre>
        </div>
    );
  }

  sendRequest(form) {
    const metas = document.getElementsByTagName('meta');
    let status = null;
    fetch(window.location.pathname, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-Token': metas['csrf-token']['content'],
      },
      body: JSON.stringify({
        username: this.state.username,
        password: this.state.password,
        token: this.state.token,
        identity: this.state.identity,
        headers: this.state.headers,
        payload: form.formData
      })
    }).then((response) => {
      status = response.status;
      return response.text();
    }).then((text) => {
      if(text.replace(/\s/, '') !== '') {
        this.setState({response: {status: status, body: JSON.parse(text)}});
      } else {
        this.setState({response: {status: status, body: ''}});
      }
    });
  }
}
