const { ethers, artifacts} = require("hardhat");

async function main() {

    const [deployer] = await ethers.getSigners();

    console.log("Deploying contracts with the account:", deployer.address);
    console.log("Balance: ", (await deployer.getBalance()).toString());

    // Contracts definition and deployment
    const KencoinContract = await  ethers.getContractFactory("KenCoin");
    const kencoin = await KencoinContract.deploy();

    console.log("KenCoin contract addr: "+ kencoin.address)

    saveDetails(kencoin, "KenCoin")
}

function saveDetails(contract, name) {
    const fs = require("fs")
    const contractDir = __dirname + "/src/contractData";

    if (!fs.existsSync(contractDir)){
        fs.mkdirSync(contractDir)
    }

    fs.writeFileSync(
        contractDir + `/${name}-addr.json`,
        JSON.stringify({address: contract.address}, undefined, 2)
    )

    const contractArtifact = artifacts.readArtifactSync(name)

    fs.writeFileSync(
        contractDir+`/${name}.json`,
        JSON.stringify(contractArtifact, null, 2)
    )
}

main()
    .then(() => process.exit(0))
    .catch(err => {
        console.error(err)
        process.exit(1)
    })
