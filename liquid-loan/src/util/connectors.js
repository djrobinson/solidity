import { Connect, SimpleSigner } from 'uport-connect';
import { uportSigner } from '../../secret';
import Web3 from 'web3';

export const uport = new Connect('Test App', {
  clientId: '2oyAyBVenNjFhG8ujJishDfSVk2i39LZj1o',
  network: 'rinkeby',
  signer: SimpleSigner(uportSigner)
});


const uportWeb3 = uport.getWeb3()

export const web3 = new Web3(uportWeb3)
