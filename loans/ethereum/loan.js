import web3 from './web3';
import Loan from './build/Loan.json';

export default address => {
  return new web3.eth.Contract(JSON.parse(Loan.interface), address);
};