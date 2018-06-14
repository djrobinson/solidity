const HDWalletProvider = require("truffle-hdwallet-provider");
const { mnemonic, infuraApi} = require('./secret');

module.exports = {
  // See <http://truffleframework.com/docs/advanced/configuration>
  // to customize your Truffle configuration!
  networks: {
    rinkeby: {
      provider: () => new HDWalletProvider(mnemonic,infuraApi),
      network_id: "*",
    }
  }
};