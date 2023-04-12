const { network } = require("hardhat")
const {
    developmentChains,
    DECIMALS,
    INITIAL_ANSWER,
} = require("../helper-hardhat-config")
module.exports = async (hre) => {
    const { getNamedAccounts, deployments } = hre
    const { deploy, log } = deployments //pulling two functions deploy, log out of deployments
    const { deployer } = await getNamedAccounts()
    const chainId = network.config.chainId

    if (developmentChains.includes(network.name)) {
        log("Local network detected Deploying mocs.. ")
        await deploy("MockV3Aggregator", {
            contract: "MockV3Aggregator",
            from: deployer,
            log: true,
            args: [
                DECIMALS,
                INITIAL_ANSWER,
            ] /*Constructor parameters for Mockv3aggregator*/,
        })
        log("Mocks Deployed")
        log("---------------------------------------------")
    }
}
module.exports.tags = ["all", "mocks"]
