require("@nomicfoundation/hardhat-toolbox");
require ("@openzeppelin/hardhat-upgrades");
require("dotenv").config();

const mnemonic = process.env.PRIVATE_KEY;
const apiKey = process.env.API_ETHERSCAN;
const INFURA = process.env.INFURA_KEY;
/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.17",
  networks: {
    goerli:{
      url: `https://goerli.infura.io/v3/${INFURA}`,
      accounts: [mnemonic],
      gas: 5500000,
      gasPrice: 70000000000,
      blockGasLimit: 15000000,
      timeout: 200000,
    },
    testnet: {
      url: "https://data-seed-prebsc-2-s1.binance.org:8545",
      chainId: 97,
      gasPrice: 10000000000,
      accounts: [mnemonic],
      gas: 9000000,
      timeout: 200000,
    },
    mainnet: {
      url: "https://data-seed-prebsc-1-s1.binance.org:8545",
      chainId: 56,
      gasPrice: 10000000000,
      accounts: [mnemonic],
      gasLimit: 200000,
    },
  },
  etherscan: {
    apiKey: apiKey,
  },
};
