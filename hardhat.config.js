require('dotenv').config();
require('@nomiclabs/hardhat-waffle');
require("@nomiclabs/hardhat-ethers");
require("@nomiclabs/hardhat-etherscan");
require("@openzeppelin/hardhat-upgrades");
if (process.env.REPORT_GAS) {
  require('hardhat-gas-reporter');
}

const { PRIVATE_KEY, POLYGON_API_KEY } = process.env;

module.exports = {
  solidity: {
    version: '0.8.19',
    settings: {
      optimizer: {
        enabled: true,
        runs: 100,
      },
      viaIR: true,
    },
  },
  defaultNetwork: "hardhat",
  networks: {
    hardhat: {},
    polygonMumbai: {
      url: `https://polygon-mumbai.blockpi.network/v1/rpc/public`,
      accounts: [`0x${PRIVATE_KEY}`],
      gasPrice: 3000000000
    }
  },
  etherscan: {
    apiKey: {
      polygonMumbai: POLYGON_API_KEY,
    }
  },
  gasReporter: {
    currency: 'USD',
    gasPriceApi:
      "https://api.etherscan.io/api?module=proxy&action=eth_gasPrice",
    coinmarketcap: process.env.COINMARKETCAP_API_KEY,
  },
  mocha: {
    timeout: 100000000
  },
};
