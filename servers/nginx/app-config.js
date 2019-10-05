const dotenv=require('dotenv');
const path=require('path');
const parent = path.resolve(__dirname, '../../');
dotenv.config({ path: path.join(parent, '.env') });