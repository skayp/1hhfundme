# Sample Hardhat Project

This project demonstrates a basic Hardhat use case. It comes with a sample contract, a test for that contract, and a script that deploys that contract.

Try running some of the following tasks:

```shell
npx hardhat help
npx hardhat test
REPORT_GAS=true npx hardhat test
npx hardhat node
npx hardhat run scripts/deploy.js
```

yarn add --dev solhint
changed compiler version to 0.8.8
yarn add dotenv
yarn add --dev hardhat-deploy //this replaces using deploy scripts
yarn add --dev @nomiclabs/hardhat-ethers@npm:hardhat-deploy-ethers ethers //hardhat-ethers overwrites ethers and hardhat-deploy-ethers overwrite hardhat-ethers

