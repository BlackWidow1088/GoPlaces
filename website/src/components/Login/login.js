
import React, { Component } from 'react';
import authService from '../../services/auth.service';
import './login.scss';

import { Formik, Field } from 'formik';

class Login extends Component {
    renderFields(inputs, form) {
        return inputs.map(input => {
            return (
                <div key={input.name}>
                    <div>
                        <Field
                            name={input.name}
                            render={(props) => {
                                const { field } = props;
                                return (
                                    <div>
                                        <input
                                            className='gp-input'
                                            {...field}
                                            type={input.type}
                                            placeholder={input.placeholder}
                                        />
                                        {form.errors[input.name] &&  form.touched[input.name] && <div>{form.errors[input.name]}</div>}
                                    </div>
                                );
                            }}
                        />
                    </div>
                </div>
            );
        })
    }

    getInitialValues(inputs) {
        //declare an empty initialValues object
        const initialValues = {};
        //loop loop over fields array
        //if prop does not exit in the initialValues object,
        // pluck off the name and value props and add it to the initialValues object;
        inputs.forEach(field => {
            if (!initialValues[field.name]) {
                initialValues[field.name] = field.value;
            }
        });

        //return initialValues object
        return initialValues;
    }
    async login(values) {
        await authService.login({email: values.email, password: values.password});
    }
    render() {
        const initialValues = this.getInitialValues(this.props.fields);
        return (
            <div className="gp-login">
                <Formik
                    onSubmit={(values) => { this.login(values); }}
                    validationSchema={this.props.validation}
                    initialValues={initialValues}
                    render={(form) => {
                        return <div>
                            <form onSubmit={form.handleSubmit}>
                                {this.renderFields(this.props.fields, form)}
                                <button type='submit' className='gp-submit-btn'>Log In</button>
                            </form>
                        </div>
                    }}
                />
            </div>
        );
    }
}

export default Login;