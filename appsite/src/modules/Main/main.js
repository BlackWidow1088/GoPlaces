import React, { Component } from 'react'
import { connect } from 'react-redux'
import './main.scss';

export class Main extends Component {
    render() {
        return (
            <div>
                MAin
            </div>
        )
    }
}

const mapStateToProps = (state) => ({
    
})

const mapDispatchToProps = {
    
}

export default connect(mapStateToProps, mapDispatchToProps)(Main)
