// function deployFunc() {
//     console.log("hi")
// }
// module.exports.default = deployFunc
const { networkConfig, developmentChains } = require("../helper-hardhat-config")
const { network } = require("hardhat")
const { verify } = require("../utils/verify")
module.exports = async (hre) => {
    const { getNamedAccounts, deployments } = hre
    //similar to
    //hre.getNamedAccounts
    //hre.deployments
    const { deploy, log } = deployments //pulling two functions deploy, log out of deployments
    const { deployer } = await getNamedAccounts()
    const chainId = network.config.chainId
    //when going for localhost or hardhat we want to use mocks
    //const ethUsdPriceFeedAddress = networkConfig[chainId]["ethUsdPriceFeed"]
    let ethUsdPriceFeedAddress

    if (developmentChains.includes(network.name)) {
        const ethUsdAggregator = await deployments.get("MockV3Aggregator")
        ethUsdPriceFeedAddress = ethUsdAggregator.address
    } else {
        ethUsdPriceFeedAddress = networkConfig[chainId]["ethUsdPriceFeed"]
    }
    const fundMe = await deploy("FundMe", {
        from: deployer,
        args: [ethUsdPriceFeedAddress],
        log: true, //so that we dont have to do console log
        waitConfirmations: network.config.blockConfirmations || 1,
    })
    if (
        !developmentChains.includes(network.name) &&
        process.env.ETHERSCAN_API_KEY
    ) {
        //verify
        await verify(fundMe.address, [ethUsdPriceFeedAddress])
    }
    log("----------------------------------------------")
    //log(ethUsdPriceFeedAddress)
}
//similar to module.exports = async ({ getNamedAccounts, deployments }) => {}
module.exports.tags = ["all", "fundme"]
