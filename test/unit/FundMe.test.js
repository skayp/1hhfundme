const { deployments, ethers, getNamedAccounts } = require("hardhat")
const { assert } = require("chai")

describe("FundMe", function () {
    let fundMe
    let deployer
    let mockV3Aggregator
    beforeEach(async function () {
        //deploy fundme contract using hardhat deploy
        // const accounts =await ethers.getSigners()
        // const accountZero = accounts[0]
        deployer = (await getNamedAccounts()).deployer // get accounts from hardhat.config
        await deployments.fixture("all") //deploys from deploy folder with all the files havin all tags
        fundMe = await ethers.getContract("FundMe", deployer) //Gets the fundme deployed contract
        mockV3Aggregator = await ethers.getContract(
            "MockV3Aggregator",
            deployer
        )
    })
    describe("constructor testing", function () {
        it("sets the aggregator address correctly", async function () {
            const response = await fundMe.priceFeed()
            assert.equal(response, mockV3Aggregator.address)
        })
    })
})
