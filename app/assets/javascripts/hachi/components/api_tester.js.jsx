const Form = JSONSchemaForm.default;
class ApiTester extends React.Component {
  constructor(props) {
    super(props);
    this.state = {};
    this.state.schema = this.props.schema;
    this.state.response = null;
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
        <div className='form-group'>
          <label htmlFor='accessToken'>Access Token</label>
          <input className='form-control' id='accessToken' onChange={this.onTokenChange.bind(this)} type='text' value={this.state.token} />
        </div>
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
        token: this.state.token,
        identity: this.state.identity,
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
