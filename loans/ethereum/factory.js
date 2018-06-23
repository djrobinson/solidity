import web3 from './web3';
import LoanFactory from './build/LoanFactory.json';

const instance = new web3.eth.Contract(
  JSON.parse(LoanFactory.interface),
  '0x9643AfBDBAD3d9b75a642cEd90bC3573E6328e6E'
);

export default instance;