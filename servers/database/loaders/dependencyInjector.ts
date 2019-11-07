import { Container } from 'typedi';
import LoggerInstance from './logger';

export default ({ postgressConnection }: { postgressConnection; }) => {
  try {
    // TODO: add cron job scheduling. might need mongo db database to support agenda.js
    Container.set('db', postgressConnection);
    Container.set('logger', LoggerInstance);
    // TODO: emailclient to be added like mailchimp-js

    LoggerInstance.info('✌️ Agenda injected into container');
  } catch (e) {
    LoggerInstance.error('🔥 Error on dependency injector loader: %o', e);
    throw e;
  }
};
