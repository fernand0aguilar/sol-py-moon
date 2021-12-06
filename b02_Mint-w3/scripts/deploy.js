const main = async () => {
  const nftContractFactory = await hre.ethers.getContractFactory("GenerateCombatKangaroosNFT");
  const nftContract = await nftContractFactory.deploy();
  await nftContract.deployed();
  
};

const runMain = async () => {
  try {
    await main();
    process.exit(0);
  } catch (error) {
    console.log(error);
    process.exit(1);
  }
};

runMain();
