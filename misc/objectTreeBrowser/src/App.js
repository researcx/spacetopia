import React, { Component } from 'react';
import ObjectTree from './ObjectTree';
export default class App extends Component {
  render() {
    return (
      <ul><ObjectTree obj={this.props.root} name="root"/></ul>
    );
  }
}
