const {default: userEvent} = require("@testing-library/user-event")
const {ethers} = require("hardhat");
const {expect} = require("chai")

describe("KenCoin", function () {
  let deployer, addr1, addr2, kshc;

  beforeEach(async function(){
    const KencoinContract = await  ethers.getContractFactory("KenCoin");

    [deployer, addr1, addr2] = await ethers.getSigners()

    kshc = await KencoinContract.deploy()
  })

  describe("Deployed Successfully", function (){
    it("Should get the correct coin Name and Symbol", async function () {
      expect(await kshc.name()).to.equal("KenCoin")
      expect(await kshc.symbol()).to.equal("KSHC")
    })
  })

  describe("Deposit", function () {
    it("should not allow non owner to deposit", async function () {
      await expect(kshc.connect(addr1).deposit(0, addr2.address))
          .to.be.revertedWith( "Access denied for non owners")

    })

    it('should allow owner to deposit', async function () {
      let depositAmount = 100

      kshc.connect(deployer).deposit(depositAmount, addr1.address)

      expect(await kshc.totalSupply()).to.equal(depositAmount)
      expect(await kshc.balanceOf(addr1.address)).to.equal(depositAmount)
    });
  })


  describe ("Withdrawing", function () {
    let depositAmount = 10000;

    beforeEach( async function(){
      await kshc.connect(deployer).deposit(depositAmount, addr1.address)
    })

    it('should not withdraw more than you have', async function () {
      let amount = depositAmount + 1200
      await expect(kshc.connect(addr1).withdraw(amount))
          .to.be.revertedWith("Insufficient Balance")
    });

    it('should not withdraw zero value', async function () {
      await expect(kshc.connect(addr1).withdraw(0))
          .to.be.revertedWith("Cannot make an empty withdrawal")
    });


    it('should withdraw sucessfully', async function () {
      let remainder = 1000
      let amount = depositAmount - remainder
      kshc.connect(addr1).withdraw(amount)

      expect(await kshc.totalSupply()).to.equal(remainder)
      expect(await kshc.balanceOf(addr1.address)).to.equal(remainder)
    });

  })
})
