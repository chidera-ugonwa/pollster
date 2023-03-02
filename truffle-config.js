module.exports = {
  networks: {
    development: {
      host: "127.0.0.1",
      port: 7545,
      network_id: "*", // Match any network id
      gas: 5000000
    }
  },
  contracts_build_directory: "./src/artifacts/",
  compilers: {
    solc: {
      version: "^0.8.14",
      settings: {
        optimizer: {
          enabled: false, // Default: false
          runs: 200      // Default: 200
        },
        evmVersion: "byzantium"
      }
    }
  }
};
