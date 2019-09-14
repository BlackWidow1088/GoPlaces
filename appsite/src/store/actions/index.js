// AUTHENTICATION
export const LOG_IN_REQUEST = 'LOG_IN_REQUEST';
export const LOG_IN_SUCCESS = 'LOG_IN_SUCCESS';
export const LOG_IN_FAILURE = 'LOG_IN_FAILURE';
export const LOG_OUT = 'LOG_OUT';

export const logInRequest = ({ authToken }) => ({
    type: LOG_IN_REQUEST,
    authToken,
});

export const logInSuccess = ({ user }) => ({
    type: LOG_IN_SUCCESS,
    user,
});

export const logInFailure = ({ error }) => ({
    type: LOG_IN_FAILURE,
    error,
});

export const logOut = () => ({
    type: LOG_OUT,
});

// MAIN