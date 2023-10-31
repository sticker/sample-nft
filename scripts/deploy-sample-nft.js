const hre = require("hardhat");

const _tokenURI = "https://bafybeidobccv4jeoivgkd2slnm2jclyqtkl27qdtb36wnu34mpfsjnaxwq.ipfs.nftstorage.link/SampleNft-metadata.json"

async function main() {
  const SampleNft = await hre.ethers.getContractFactory("SampleNft")
  const sampleNft = await hre.upgrades.deployProxy(SampleNft, [_tokenURI])
  await sampleNft.deployed()
  console.log("SampleNft deployed to:", sampleNft.address)

}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
