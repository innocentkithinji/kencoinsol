require("@nomiclabs/hardhat-waffle");

module.exports = {
  solidity: "0.5.0",
  paths: {
    artifacts: "./src/artifacts",
    sources: "./src/contracts",
    cache: "./src/cache",
    tests: "./src/tests"
  }
};
