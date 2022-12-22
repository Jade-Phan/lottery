const { ethers, upgrades } = require('hardhat')
    

async function main() {

    const contractProxy ="0x6E136337dF7E662767cb846fd1E842b181725Ff6";

  const LotteryFactoryV2 = await ethers.getContractFactory("LotteryUpgradeable");
  const lotteryV2 = await upgrades.upgradeProxy(contractProxy,LotteryFactoryV2);

  console.log("Contract deployed to:", lotteryV2.address);

   const implAddress = await upgrades.erc1967.getImplementationAddress(
    contractProxy.address,
  )
  console.log('implAddress deployed to:', implAddress)


}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error)
    process.exit(1)
  })
