import web3 from './web3';
import CampaignFactory from './build/CampaignFactory.json';

const instance = new web3.eth.Contract(
  JSON.parse(CampaignFactory.interface),
  '0x3D6dB09e45C6636AE9bf14321cE4875e6C5E125e'
);

export default instance;