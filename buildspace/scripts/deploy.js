const main = async () => {
  const nftPortalFactory = await hre.ethers.getContractFactory('NftPortal');
  const nftContract = await nftPortalFactory.deploy();

  await nftContract.deployed();

  console.log('Nft contract address: ', nftContract.address);
};

const runMain = async () => {
  try {
    await main();
    process.exit(0);
  } catch (error) {
    console.error(error);
    process.exit(1);
  }
};

runMain();