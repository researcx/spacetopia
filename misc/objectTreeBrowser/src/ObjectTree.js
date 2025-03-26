import React, { Component } from 'react';
import _ from 'lodash';

export default class ObjectTree extends Component {
    constructor(props) {
        super(props);
        this.state = {expanded: false};
    }
    componentWillMount() {
        if (this.props.startExpanded) {
            this.setState({expanded: true});
        }
    }
    render() {
        var name = this.props.name || this.props.obj.name;
        var path = this.props.obj.path || (this.props.parent.path + '/' + name);
        if (this.state.expanded) {
            if (this.props.obj instanceof Array) {
                return <li key={path}>
                    <a onClick={this.toggle.bind(this)}>{name}</a>: {path}
                    <ul>
                        {this.props.obj.map(function(o) {
                            return <ObjectTree obj={o} parent={this.props.obj}/>
                        }.bind(this))}
                    </ul>
                </li>
            } else if (typeof this.props.obj === 'object') {
                return <li key={path}><a onClick={this.toggle.bind(this)}>{name}</a>: {path}
                    <ul>
                        {_.pairs(_.omit(this.props.obj, 'name')).map(
                            function (t) {
                                if (t[1] instanceof Array) {
                                    return <ObjectTree obj={t[1]} name={t[0]} parent={this.props.obj}/>
                                } else if (t[1] !== null && typeof t[1] === 'object') {
                                    return <ObjectTree obj={t[1]} parent={this.props.obj}/>
                                } else if (t[1] !== null) {
                                    return <li>{t[0]}:{t[1].toString()}</li>
                                } else {
                                    return <li>{t[0]}: null</li>
                                }
                            }.bind(this)
                        )}
                    </ul>
                </li>;
            }
        } else {
            var t = 'object';
            if (this.props.obj instanceof Array) {
                t = 'array [' + this.props.obj.length + ']';
            }
            return <li key={path}><a onClick={this.toggle.bind(this)}>{name}: <i>{t}</i></a> {path}</li>
        }
    }
    toggle() {
        this.setState({expanded: !this.state.expanded});
    }
}
ObjectTree.defaultProps = {
    obj: {name: 'null', path: ''},
    parent: {name: 'null', path: ''},
    startExpanded: false
};
