import * as Yup from 'yup';

const alpha = /^[a-zA-Z_]+( [a-zA-Z_]+)*$/;

const validation = Yup.object().shape({
  firstName: Yup.string()
    .matches(alpha, {message: "Enter Valid Name", excludeEmptyString: true })
    .required('reauired')
    .max(35, 'Please enter less than 35 characters'),
});

export default validation;