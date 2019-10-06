import * as Yup from 'yup';

const validation = Yup.object().shape({
  // email: Yup.string()
  //   .matches(alpha, {message: "Enter Valid Name", excludeEmptyString: true })
  //   .required('reauired')
  //   .max(35, 'Please enter less than 35 characters'),
  email: Yup.string()
  .email('Please enter a valid email')
  .required('Please enter an email'),
  username: Yup.string()
  .required('Please enter username')
  .max(10, 'Please enter less than 10 characters')
});

export default validation;