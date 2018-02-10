const HDwalletProvider = require('truffle-hdwallet-provider');
const Web3 = require('web3');
const { interface, bytecode } = require('./compile');
const { mnemonic, infuraApi} = require('../secret');

const provider = new HDwalletProvider(
  mnemonic,
  infuraApi
);

const web3 = new Web3(provider);