const HDwalletProvider = require('truffle-hdwallet-provider');
const Web3 = require('web3');
const compiledFactory = require('./build/CampaignFactory.json');
const { mnemonic, infuraApi} = require('../../secret');

const provider = new HDwalletProvider(
  mnemonic,
  infuraApi
);

const web3 = new Web3(provider);

const deploy = async () => {
  const accounts = await web3.eth.getAccounts();

  console.log('Attempting to deploy from account ', accounts[0]);

  const result = await new web3.eth.Contract(
      JSON.parse(compiledFactory.interface)
    )
    .deploy({ data: compiledFactory.bytecode })
    .send({ gas: '1000000', from: accounts[0] });

  console.log('Contract deployed to ', result.options.address);
};

deploy();

// Deployed at 0x8A99E2C1788558598B4A3a852dAAc2D3aB414225