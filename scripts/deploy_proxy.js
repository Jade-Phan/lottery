const { ethers, upgrades } = require('hardhat')
    

async function main() {

  const LotteryFactory = await ethers.getContractFactory("LotteryUpgradeable");
  const lottery = await upgrades.deployProxy(LotteryFactory,[],{initializer:'initialize'});
  await lottery.deployed();
  console.log("Contract deployed to:", lottery.address);

   const implAddress = await upgrades.erc1967.getImplementationAddress(
    lottery.address,
  )
  console.log('implAddress deployed to:', implAddress)


}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error)
    process.exit(1)
  })
