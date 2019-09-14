import { all } from 'redux-saga/effects';
import authSaga from './authentication.saga';

export default function* rootSaga() {
    yield all([...authSaga()])
  }