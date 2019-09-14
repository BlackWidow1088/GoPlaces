import React, { Component } from 'react'
import { connect } from 'react-redux'
import './login.scss';

export class Login extends Component {
    render() {
        return (
            <div>
                login
            </div>
        )
    }
}

const mapStateToProps = (state) => ({
    
})

const mapDispatchToProps = {
    
}

export default connect(mapStateToProps, mapDispatchToProps)(Login)

