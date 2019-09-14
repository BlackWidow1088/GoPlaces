/* eslint-disable no-unused-vars */
import { call, put, fork, takeEvery } from 'redux-saga/effects';

import { API } from 'modules/Core/services';
import {
  LOG_IN_REQUEST,
  logInSuccess,
  logInFailure,
} from '../actions';


function* authenticateUser({ authToken }) {
  try {
    const user = yield call(API.authenticateUser, { authToken });
    yield put(logInSuccess({ user }));
  } catch (error) {
    yield put(logInFailure({ error }));
  }
}


// ///////////////////
// WATCHERS /////////
// /////////////////
function* watchLogin() {
  yield takeEvery(LOG_IN_REQUEST, authenticateUser);
}

export default function () {
  return [fork(watchLogin)]
}
