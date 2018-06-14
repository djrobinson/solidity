import { Connect, SimpleSigner } from 'uport-connect';
import { uportSigner } from '../../secret';

export const uport = new Connect('Test App', {
  clientId: '2oyAyBVenNjFhG8ujJishDfSVk2i39LZj1o',
  network: 'rinkeby',
  signer: SimpleSigner(uportSigner)
})


export const web3 = uport.getWeb3()
