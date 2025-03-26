import React from 'react';
import ReactDOM from 'react-dom';
import App from './App';
var json = require("json!../objectTree.json");
console.log(json);
ReactDOM.render(<App root={json.tree}/>, document.getElementById('root'));
