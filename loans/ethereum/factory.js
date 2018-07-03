import web3 from './web3';
import LoanFactory from './build/LoanFactory.json';

const instance = new web3.eth.Contract(
  JSON.parse(LoanFactory.interface),
  '0xa1D7CC24A6e3be3F1Fe2f65c1537136f31c6681c'
);

export default instance;